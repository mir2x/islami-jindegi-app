import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/core/providers/shared_preferences.dart';

enum MalfuzatTab { all, text, audio }

class MalfuzatProgress {
  const MalfuzatProgress(this.id, this.title);
  final String id;
  final String title;
  Map<String, String> toJson() => {'id': id, 'title': title};
}

final malfuzatProgressProvider = NotifierProvider<MalfuzatProgressNotifier,
    Map<MalfuzatTab, MalfuzatProgress>>(MalfuzatProgressNotifier.new);

class MalfuzatProgressNotifier
    extends Notifier<Map<MalfuzatTab, MalfuzatProgress>> {
  Timer? _timer;
  @override
  Map<MalfuzatTab, MalfuzatProgress> build() {
    ref.onDispose(() => _timer?.cancel());
    final prefs = ref.read(sharedPreferencesProvider);
    final raw = prefs.getString('malfuzat_reading_progress');
    if (raw != null) {
      try {
        final entries = Map<String, dynamic>.from(jsonDecode(raw) as Map);
        return {
          for (final tab in MalfuzatTab.values)
            if (entries[tab.name] is Map)
              tab: _from(Map<String, dynamic>.from(entries[tab.name] as Map))
        };
      } catch (_) {}
    }
    final old = prefs.getString('lastMalfuzat');
    if (old == null) return {};
    final migrated = {MalfuzatTab.all: MalfuzatProgress(old, '')};
    _write(migrated);
    unawaited(prefs.remove('lastMalfuzat'));
    return migrated;
  }

  MalfuzatProgress? forTab(MalfuzatTab tab) => state[tab];
  void opened(String id, String title, {required MalfuzatTab tab}) {
    final p = MalfuzatProgress(id, title);
    state = {...state, tab: p};
    _save();
  }

  void clear(String id) {
    state = {
      for (final e in state.entries)
        if (e.value.id != id) e.key: e.value
    };
    _save();
  }

  MalfuzatProgress _from(Map<String, dynamic> json) =>
      MalfuzatProgress(json['id'] as String, json['title'] as String? ?? '');
  void _save() {
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 350), () => _write(state));
  }

  void _write(Map<MalfuzatTab, MalfuzatProgress> value) =>
      unawaited(ref.read(sharedPreferencesProvider).setString(
          'malfuzat_reading_progress',
          jsonEncode(
              {for (final e in value.entries) e.key.name: e.value.toJson()})));
}
