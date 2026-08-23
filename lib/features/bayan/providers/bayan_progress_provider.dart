import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/core/providers/shared_preferences.dart';

class BayanProgress {
  const BayanProgress({
    required this.id,
    required this.title,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final DateTime updatedAt;

  factory BayanProgress.fromJson(Map<String, dynamic> json) => BayanProgress(
        id: json['id'] as String,
        title: json['title'] as String? ?? '',
        updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'updatedAt': updatedAt.toUtc().toIso8601String(),
      };
}

final bayanProgressProvider =
    NotifierProvider<BayanProgressNotifier, BayanProgress?>(
  BayanProgressNotifier.new,
);

class BayanProgressNotifier extends Notifier<BayanProgress?> {
  static const _key = 'bayan_reading_progress';
  Timer? _debounce;

  @override
  BayanProgress? build() {
    ref.onDispose(() => _debounce?.cancel());
    final prefs = ref.read(sharedPreferencesProvider);
    final saved = prefs.getString(_key);
    if (saved != null) {
      try {
        return BayanProgress.fromJson(
          Map<String, dynamic>.from(jsonDecode(saved) as Map),
        );
      } catch (_) {}
    }
    final legacyId = prefs.getString('lastBayan');
    if (legacyId == null) return null;
    final migrated = BayanProgress(
      id: legacyId,
      title: '',
      updatedAt: DateTime.now(),
    );
    _write(migrated);
    unawaited(prefs.remove('lastBayan'));
    return migrated;
  }

  void opened(String id, String title) {
    if (state?.id == id && state?.title == title) return;
    state = BayanProgress(id: id, title: title, updatedAt: DateTime.now());
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () => _write(state));
  }

  void clear(String id) {
    if (state?.id != id) return;
    _debounce?.cancel();
    state = null;
    unawaited(ref.read(sharedPreferencesProvider).remove(_key));
  }

  void _write(BayanProgress? value) {
    if (value == null) return;
    unawaited(
      ref.read(sharedPreferencesProvider).setString(_key, jsonEncode(value)),
    );
  }
}
