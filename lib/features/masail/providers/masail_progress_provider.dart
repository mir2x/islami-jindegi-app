import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/core/providers/shared_preferences.dart';

class MasailProgress {
  const MasailProgress(this.id, this.title);
  final String id;
  final String title;
}

final masailProgressProvider =
    NotifierProvider<MasailProgressNotifier, MasailProgress?>(
        MasailProgressNotifier.new);

class MasailProgressNotifier extends Notifier<MasailProgress?> {
  Timer? _timer;
  @override
  MasailProgress? build() {
    ref.onDispose(() => _timer?.cancel());
    final prefs = ref.read(sharedPreferencesProvider);
    final raw = prefs.getString('masail_reading_progress');
    if (raw != null) {
      try {
        final json = Map<String, dynamic>.from(jsonDecode(raw) as Map);
        return MasailProgress(
            json['id'] as String, json['title'] as String? ?? '');
      } catch (_) {}
    }
    final old = prefs.getString('lastMasail');
    if (old == null) return null;
    final value = MasailProgress(old, '');
    _write(value);
    unawaited(prefs.remove('lastMasail'));
    return value;
  }

  void opened(String id, String title) {
    state = MasailProgress(id, title);
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 350), () => _write(state));
  }

  void clear(String id) {
    if (state?.id != id) return;
    state = null;
    unawaited(
        ref.read(sharedPreferencesProvider).remove('masail_reading_progress'));
  }

  void _write(MasailProgress? value) {
    if (value != null)
      unawaited(ref.read(sharedPreferencesProvider).setString(
          'masail_reading_progress',
          jsonEncode({'id': value.id, 'title': value.title})));
  }
}
