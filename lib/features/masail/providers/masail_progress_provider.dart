import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/core/providers/shared_preferences.dart';

enum MasailTab { all, text, audio }

class MasailProgress {
  const MasailProgress(this.id, this.title);
  final String id;
  final String title;
  Map<String, String> toJson() => {'id': id, 'title': title};
}

final masailProgressProvider =
    NotifierProvider<MasailProgressNotifier, Map<MasailTab, MasailProgress>>(
        MasailProgressNotifier.new);

class MasailProgressNotifier extends Notifier<Map<MasailTab, MasailProgress>> {
  Timer? _timer;
  @override
  Map<MasailTab, MasailProgress> build() {
    ref.onDispose(() => _timer?.cancel());
    final prefs = ref.read(sharedPreferencesProvider);
    final raw = prefs.getString('masail_reading_progress');
    if (raw != null) {
      try {
        final entries = Map<String, dynamic>.from(jsonDecode(raw) as Map);
        return {
          for (final tab in MasailTab.values)
            if (entries[tab.name] is Map)
              tab: _from(Map<String, dynamic>.from(entries[tab.name] as Map))
        };
      } catch (_) {}
    }
    final old = prefs.getString('lastMasail');
    if (old == null) return {};
    final migrated = {MasailTab.all: MasailProgress(old, '')};
    _write(migrated);
    unawaited(prefs.remove('lastMasail'));
    return migrated;
  }

  MasailProgress? forTab(MasailTab tab) => state[tab];
  void opened(String id, String title, {required MasailTab tab}) {
    state = {...state, tab: MasailProgress(id, title)};
    _save();
  }

  void clear(String id) {
    state = {
      for (final e in state.entries)
        if (e.value.id != id) e.key: e.value
    };
    _save();
  }

  MasailProgress _from(Map<String, dynamic> json) =>
      MasailProgress(json['id'] as String, json['title'] as String? ?? '');
  void _save() {
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 350), () => _write(state));
  }

  void _write(Map<MasailTab, MasailProgress> value) =>
      unawaited(ref.read(sharedPreferencesProvider).setString(
          'masail_reading_progress',
          jsonEncode(
              {for (final e in value.entries) e.key.name: e.value.toJson()})));
}
