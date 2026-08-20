import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'offline_reset_service.dart';

import '../../features/article/providers/article_sync_service.dart';
import '../../features/bayan/providers/bayan_sync_service.dart';
import '../../features/book/providers/book_sync_service.dart';
import '../../features/dua/providers/dua_sync_service.dart';
import '../../features/madrasah/providers/madrasah_sync_service.dart';
import '../../features/malfuzat/providers/malfuzat_sync_service.dart';
import '../../features/masail/providers/masail_sync_service.dart';

/// Domains synced on every cycle. Note `misc` (the shared Pages bucket used
/// by the "ask a question" screen) isn't listed separately — it's synced
/// together with `masails` by `MasailSyncService`.
const offlineDbFeatures = <String>[
  'books',
  'duas',
  'malfuzats',
  'articles',
  'madrasahs',
  'masails',
  'bayans',
];

/// Skip a sync pass if the last successful one finished more recently than
/// this. Now a pure fallback safety net for missed/undelivered pushes (see
/// `push_notifications.dart`'s "content-sync" topic handling, which triggers
/// an immediate single-feature sync on admin changes) rather than the
/// primary propagation path — stretched well past 30 minutes since it's no
/// longer carrying the "reach the device soon" requirement on its own.
const _throttle = Duration(hours: 6);

/// Retry window after a pass where at least one domain failed. The long
/// [_throttle] assumes the last sweep actually landed; when it didn't, waiting
/// six hours to try again leaves the device with a knowingly incomplete
/// offline store for the rest of the day.
const _failedRetryThrottle = Duration(minutes: 15);

const _lastSyncPrefKey = 'last_offline_sync_at';
const _lastSyncFailedPrefKey = 'last_offline_sync_had_failures';

enum OfflineDbPrefetchStatus {
  idle,
  checking,
  downloading,
  completed,
  failed,
}

class OfflineDbPrefetchState {
  const OfflineDbPrefetchState({
    this.status = OfflineDbPrefetchStatus.idle,
    this.currentFeature,
    this.completed = 0,
    this.total = 0,
    this.currentProgress = 0,
    this.failedFeatures = const [],
  });

  final OfflineDbPrefetchStatus status;
  final String? currentFeature;
  final int completed;
  final int total;
  final double currentProgress;
  final List<String> failedFeatures;

  bool get isVisible =>
      status == OfflineDbPrefetchStatus.downloading ||
      status == OfflineDbPrefetchStatus.completed ||
      status == OfflineDbPrefetchStatus.failed;

  double get overallProgress {
    if (total == 0) return 0;
    return (completed + currentProgress) / total;
  }

  OfflineDbPrefetchState copyWith({
    OfflineDbPrefetchStatus? status,
    String? currentFeature,
    bool clearCurrentFeature = false,
    int? completed,
    int? total,
    double? currentProgress,
    List<String>? failedFeatures,
  }) {
    return OfflineDbPrefetchState(
      status: status ?? this.status,
      currentFeature:
          clearCurrentFeature ? null : currentFeature ?? this.currentFeature,
      completed: completed ?? this.completed,
      total: total ?? this.total,
      currentProgress: currentProgress ?? this.currentProgress,
      failedFeatures: failedFeatures ?? this.failedFeatures,
    );
  }
}

/// Drives the admin-curated offline content sync: for each domain in
/// [offlineDbFeatures], fetches the currently offline-marked set from the
/// `.NET` API and applies it to that domain's local SQLite tables (see the
/// per-feature `X_sync_service.dart` files).
///
/// Unlike the old bulk-download flow this replaced (one prebuilt `.sqlite3`
/// file per feature, downloaded once at first launch), this runs on cold
/// start *and* every time the app resumes from background (see
/// `OfflineDbPrefetchBanner`'s lifecycle observer), throttled by
/// [_throttle] — content curated in the admin panel needs to reach devices
/// that already have the app installed, not just fresh installs.
class OfflineDbPrefetchNotifier extends Notifier<OfflineDbPrefetchState> {
  @override
  OfflineDbPrefetchState build() => const OfflineDbPrefetchState();

  bool _running = false;

  Future<void> start() async {
    if (_running) return;

    // Before anything reads or writes the local store, in case this build
    // has to discard what a previous one left behind.
    await OfflineResetService.ensureApplied();

    final prefs = await SharedPreferences.getInstance();
    final lastSync = prefs.getInt(_lastSyncPrefKey);
    if (lastSync != null) {
      final hadFailures = prefs.getBool(_lastSyncFailedPrefKey) ?? false;
      final window = hadFailures ? _failedRetryThrottle : _throttle;
      final elapsed = DateTime.now().millisecondsSinceEpoch - lastSync;
      if (elapsed < window.inMilliseconds) return;
    }

    _running = true;
    state = state.copyWith(status: OfflineDbPrefetchStatus.checking);

    try {
      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity.contains(ConnectivityResult.none)) {
        state = const OfflineDbPrefetchState();
        return;
      }

      final failed = <String>[];
      var completed = 0;
      state = OfflineDbPrefetchState(
        status: OfflineDbPrefetchStatus.downloading,
        total: offlineDbFeatures.length,
      );

      for (final feature in offlineDbFeatures) {
        state = state.copyWith(
          status: OfflineDbPrefetchStatus.downloading,
          currentFeature: feature,
          completed: completed,
          currentProgress: 0,
          failedFeatures: failed,
        );

        try {
          await _syncFeature(feature);
        } catch (error, stackTrace) {
          debugPrint('Offline sync failed for $feature: $error\n$stackTrace');
          failed.add(feature);
        }

        completed++;
        state = state.copyWith(
          completed: completed,
          currentProgress: 0,
          failedFeatures: List.unmodifiable(failed),
        );
      }

      state = state.copyWith(
        status: failed.isEmpty
            ? OfflineDbPrefetchStatus.completed
            : OfflineDbPrefetchStatus.failed,
        clearCurrentFeature: true,
        completed: completed,
        currentProgress: 0,
        failedFeatures: List.unmodifiable(failed),
      );

      // Record the sweep as done regardless, so a handful of flaky domains
      // don't force a full re-run on every app resume — but remember whether
      // anything failed, which shortens the next wait to
      // [_failedRetryThrottle] instead of the full [_throttle].
      await prefs.setInt(
          _lastSyncPrefKey, DateTime.now().millisecondsSinceEpoch);
      await prefs.setBool(_lastSyncFailedPrefKey, failed.isNotEmpty);

      await Future.delayed(const Duration(seconds: 4));
      state = const OfflineDbPrefetchState();
    } finally {
      _running = false;
    }
  }

  Future<void> _syncFeature(String feature) {
    return switch (feature) {
      'books' => BookSyncService().sync(),
      'duas' => DuaSyncService().sync(),
      'malfuzats' => MalfuzatSyncService().sync(),
      'articles' => ArticleSyncService().sync(),
      'madrasahs' => MadrasahSyncService().sync(),
      'masails' => MasailSyncService().sync(),
      'bayans' => BayanSyncService().sync(),
      _ => throw ArgumentError('Unknown offline feature "$feature"'),
    };
  }
}

final offlineDbPrefetchProvider =
    NotifierProvider<OfflineDbPrefetchNotifier, OfflineDbPrefetchState>(
        OfflineDbPrefetchNotifier.new);
