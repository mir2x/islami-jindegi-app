import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/core/providers/shared_preferences.dart';

class MadrasahProgress {
  const MadrasahProgress(this.id, this.title);
  final String id;
  final String title;
}

final madrasahProgressProvider =
    NotifierProvider<MadrasahProgressNotifier, MadrasahProgress?>(
        MadrasahProgressNotifier.new);

class MadrasahProgressNotifier extends Notifier<MadrasahProgress?> {
  Timer? _timer;
  @override
  MadrasahProgress? build() {
    ref.onDispose(() => _timer?.cancel());
    final prefs = ref.read(sharedPreferencesProvider);
    final raw = prefs.getString('madrasah_reading_progress');
    if (raw != null) {
      try {
        final json = Map<String, dynamic>.from(jsonDecode(raw) as Map);
        return MadrasahProgress(
            json['id'] as String, json['title'] as String? ?? '');
      } catch (_) {}
    }
    final legacyId = prefs.getString('lastMadrasah');
    if (legacyId == null) return null;
    final migrated = MadrasahProgress(legacyId, '');
    _writeValue(migrated);
    unawaited(prefs.remove('lastMadrasah'));
    return migrated;
  }

  void opened(String id, String title) {
    if (state?.id == id && state?.title == title) return;
    state = MadrasahProgress(id, title);
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 350), _write);
  }

  void clear(String id) {
    if (state?.id != id) return;
    _timer?.cancel();
    state = null;
    unawaited(ref
        .read(sharedPreferencesProvider)
        .remove('madrasah_reading_progress'));
  }

  void _write() {
    final v = state;
    if (v != null) _writeValue(v);
  }

  void _writeValue(MadrasahProgress value) => unawaited(
        ref.read(sharedPreferencesProvider).setString(
              'madrasah_reading_progress',
              jsonEncode({'id': value.id, 'title': value.title}),
            ),
      );
}
