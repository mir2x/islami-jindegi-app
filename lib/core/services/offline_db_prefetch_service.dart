import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/offline_database_helper.dart';
import 'static_asset_api.dart';

const offlineDbFeatures = <String>[
  'books',
  'duas',
  'malfuzats',
  'articles',
  'madrasahs',
  'masails',
  'misc',
  'bayans',
];

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

class OfflineDbPrefetchNotifier extends Notifier<OfflineDbPrefetchState> {
  @override
  OfflineDbPrefetchState build() => const OfflineDbPrefetchState();

  final Dio _dio = Dio();
  bool _started = false;

  Future<void> start() async {
    if (_started) return;
    _started = true;

    state = state.copyWith(status: OfflineDbPrefetchStatus.checking);

    final missingFeatures = <String>[];
    for (final feature in offlineDbFeatures) {
      if (!await _isCurrent(feature)) {
        missingFeatures.add(feature);
      }
    }

    if (missingFeatures.isEmpty) {
      state = const OfflineDbPrefetchState();
      return;
    }

    final failed = <String>[];
    var completed = 0;
    state = OfflineDbPrefetchState(
      status: OfflineDbPrefetchStatus.downloading,
      total: missingFeatures.length,
    );

    for (final feature in missingFeatures) {
      state = state.copyWith(
        status: OfflineDbPrefetchStatus.downloading,
        currentFeature: feature,
        completed: completed,
        currentProgress: 0,
        failedFeatures: failed,
      );

      try {
        await _downloadFeature(feature);
      } catch (error, stackTrace) {
        debugPrint(
          'Offline DB prefetch failed for $feature: $error\n$stackTrace',
        );
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

    await Future.delayed(const Duration(seconds: 4));
    state = const OfflineDbPrefetchState();
  }

  Future<bool> _isCurrent(String feature) async {
    final isAvailable = await OfflineDatabaseHelper.isAvailable(feature);
    if (!isAvailable) return false;

    final prefs = await SharedPreferences.getInstance();
    final version = prefs.getInt('offline_db_version_$feature') ?? 0;
    return version >= 1;
  }

  Future<void> _downloadFeature(String feature) async {
    final assetResponse = await StaticAssetApi().getDbUrl(feature);
    if (assetResponse == null) {
      throw StateError('No download URL returned');
    }

    final dbPath = await OfflineDatabaseHelper.getDbPath(feature);
    final tempPath = '$dbPath.download';
    final tempFile = File(tempPath);
    final dbFile = File(dbPath);

    await Directory(p.dirname(dbPath)).create(recursive: true);
    if (await tempFile.exists()) {
      await tempFile.delete();
    }

    await _dio.download(
      assetResponse.url,
      tempPath,
      onReceiveProgress: (received, total) {
        if (total <= 0) return;
        state = state.copyWith(currentProgress: received / total);
      },
    );

    await OfflineDatabaseHelper.evict(feature);
    if (await dbFile.exists()) {
      await dbFile.delete();
    }
    await tempFile.rename(dbPath);
    await OfflineDatabaseHelper.markVersion(feature, 1);
  }
}

final offlineDbPrefetchProvider =
    NotifierProvider<OfflineDbPrefetchNotifier, OfflineDbPrefetchState>(
        OfflineDbPrefetchNotifier.new);
