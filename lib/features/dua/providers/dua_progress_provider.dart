import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/core/providers/shared_preferences.dart';

class DuaProgress {
  const DuaProgress(this.id, this.title);
  final String id;
  final String title;
}

final duaProgressProvider = NotifierProvider<DuaProgressNotifier, DuaProgress?>(
    DuaProgressNotifier.new);

class DuaProgressNotifier extends Notifier<DuaProgress?> {
  Timer? _timer;
  @override
  DuaProgress? build() {
    ref.onDispose(() => _timer?.cancel());
    final prefs = ref.read(sharedPreferencesProvider);
    final raw = prefs.getString('dua_reading_progress');
    if (raw != null) {
      try {
        final v = Map<String, dynamic>.from(jsonDecode(raw) as Map);
        return DuaProgress(v['id'] as String, v['title'] as String? ?? '');
      } catch (_) {}
    }
    final old = prefs.getString('lastDuaDurud');
    if (old == null) return null;
    final value = DuaProgress(old, '');
    _write(value);
    unawaited(prefs.remove('lastDuaDurud'));
    return value;
  }

  void opened(String id, String title) {
    if (state?.id == id && state?.title == title) return;
    state = DuaProgress(id, title);
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 350), () => _write(state));
  }

  void clear(String id) {
    if (state?.id != id) return;
    _timer?.cancel();
    state = null;
    unawaited(
        ref.read(sharedPreferencesProvider).remove('dua_reading_progress'));
  }

  void _write(DuaProgress? value) {
    if (value != null)
      unawaited(ref.read(sharedPreferencesProvider).setString(
          'dua_reading_progress',
          jsonEncode({'id': value.id, 'title': value.title})));
  }
}
