import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/core/providers/shared_preferences.dart';

class ArticleProgress {
  const ArticleProgress(this.id, this.title);
  final String id;
  final String title;
}

final articleProgressProvider =
    NotifierProvider<ArticleProgressNotifier, ArticleProgress?>(
        ArticleProgressNotifier.new);

class ArticleProgressNotifier extends Notifier<ArticleProgress?> {
  Timer? _timer;
  @override
  ArticleProgress? build() {
    ref.onDispose(() => _timer?.cancel());
    final prefs = ref.read(sharedPreferencesProvider);
    final raw = prefs.getString('article_reading_progress');
    if (raw != null) {
      try {
        final j = Map<String, dynamic>.from(jsonDecode(raw) as Map);
        return ArticleProgress(j['id'] as String, j['title'] as String? ?? '');
      } catch (_) {}
    }
    final legacy = prefs.getString('lastArticle');
    if (legacy == null) return null;
    final value = ArticleProgress(legacy, '');
    _persist(value);
    unawaited(prefs.remove('lastArticle'));
    return value;
  }

  void opened(String id, String title) {
    if (state?.id == id && state?.title == title) return;
    state = ArticleProgress(id, title);
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 350), () => _persist(state));
  }

  void clear(String id) {
    if (state?.id != id) return;
    _timer?.cancel();
    state = null;
    unawaited(
        ref.read(sharedPreferencesProvider).remove('article_reading_progress'));
  }

  void _persist(ArticleProgress? value) {
    if (value != null)
      unawaited(ref.read(sharedPreferencesProvider).setString(
          'article_reading_progress',
          jsonEncode({'id': value.id, 'title': value.title})));
  }
}
