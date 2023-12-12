import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LastVisitedNotifier extends AsyncNotifier<SharedPreferences> {
  @override
  Future<SharedPreferences> build() async {
    return await SharedPreferences.getInstance();
  }

  Future<dynamic> updateLastSurah(value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastSurah', value);
    state = AsyncValue.data(prefs);
  }

  Future<dynamic> updateLastPara(value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastPara', value);
    state = AsyncValue.data(prefs);
  }

  Future<dynamic> updateLastChapter(bookId, chapterId) async {
    var prefs = await SharedPreferences.getInstance();
    Map books = json.decode(prefs.getString('lastChapters') ?? '{}');
    books[bookId.toString()] = chapterId.toString();
    await prefs.setString('lastChapters', json.encode(books));
    state = AsyncValue.data(prefs);
  }

  Future<dynamic> updateLastBayan(value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastBayan', value);
    state = AsyncValue.data(prefs);
  }

  Future<dynamic> updateLastMalfuzat(value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastMalfuzat', value);
    state = AsyncValue.data(prefs);
  }

  Future<dynamic> updateLastMasail(value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastMasail', value);
    state = AsyncValue.data(prefs);
  }

  Future<dynamic> updateLastDuaDurud(value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastDuaDurud', value);
    state = AsyncValue.data(prefs);
  }

  Future<dynamic> updateLastArticle(value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastArticle', value);
    state = AsyncValue.data(prefs);
  }

  Future<dynamic> updateLastNews(value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastNews', value);
    state = AsyncValue.data(prefs);
  }

  Future<dynamic> updateLastMadrasah(value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastMadrasah', value);
    state = AsyncValue.data(prefs);
  }
}

final lastVisitedProvider =
    AsyncNotifierProvider<LastVisitedNotifier, SharedPreferences>(() {
  return LastVisitedNotifier();
});
