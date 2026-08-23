import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/core/providers/shared_preferences.dart';

class NewsProgress {
  const NewsProgress(this.id, this.title);
  final String id;
  final String title;
}

final newsProgressProvider =
    NotifierProvider<NewsProgressNotifier, NewsProgress?>(
        NewsProgressNotifier.new);

class NewsProgressNotifier extends Notifier<NewsProgress?> {
  Timer? _timer;
  @override
  NewsProgress? build() {
    ref.onDispose(() => _timer?.cancel());
    final prefs = ref.read(sharedPreferencesProvider);
    final raw = prefs.getString('news_reading_progress');
    if (raw != null) {
      try {
        final j = Map<String, dynamic>.from(jsonDecode(raw) as Map);
        return NewsProgress(j['id'] as String, j['title'] as String? ?? '');
      } catch (_) {}
    }
    final legacy = prefs.getString('lastNews');
    if (legacy == null) return null;
    final value = NewsProgress(legacy, '');
    _persist(value);
    unawaited(prefs.remove('lastNews'));
    return value;
  }

  void opened(String id, String title) {
    if (state?.id == id && state?.title == title) return;
    state = NewsProgress(id, title);
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 350), () => _persist(state));
  }

  void clear(String id) {
    if (state?.id != id) return;
    _timer?.cancel();
    state = null;
    unawaited(
        ref.read(sharedPreferencesProvider).remove('news_reading_progress'));
  }

  void _persist(NewsProgress? v) {
    if (v != null)
      unawaited(ref.read(sharedPreferencesProvider).setString(
          'news_reading_progress', jsonEncode({'id': v.id, 'title': v.title})));
  }
}
