import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bookmark.dart';

const String _bookmarksKey = 'ayah_bookmarks';

class BookmarkNotifier extends Notifier<List<Bookmark>> {
  @override
  List<Bookmark> build() {
    _loadBookmarks();
    return [];
  }

  Future<void> _loadBookmarks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_bookmarksKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        state = Bookmark.decodeList(jsonString);
      }
    } catch (e) {
      print('Error loading bookmarks: $e');
    }
  }

  Future<void> _saveBookmarks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_bookmarksKey, Bookmark.encodeList(state));
    } catch (e) {
      print('Error saving bookmarks: $e');
    }
  }

  Future<void> addBookmark(Bookmark bookmark) async {
    // Don't add duplicate
    if (state.any((b) => b.id == bookmark.id)) return;

    state = [bookmark, ...state]; // Add to beginning
    await _saveBookmarks();
  }

  Future<void> removeBookmark(int suraNumber, int ayahNumber) async {
    state = state
        .where(
            (b) => !(b.suraNumber == suraNumber && b.ayahNumber == ayahNumber))
        .toList();
    await _saveBookmarks();
  }

  Future<void> toggleBookmark({
    required int suraNumber,
    required int ayahNumber,
    required String suraName,
    required String arabicText,
  }) async {
    final isBookmarked = state
        .any((b) => b.suraNumber == suraNumber && b.ayahNumber == ayahNumber);

    if (isBookmarked) {
      await removeBookmark(suraNumber, ayahNumber);
    } else {
      await addBookmark(Bookmark(
        suraNumber: suraNumber,
        ayahNumber: ayahNumber,
        suraName: suraName,
        arabicText: arabicText,
        createdAt: DateTime.now(),
      ));
    }
  }

  bool isBookmarked(int suraNumber, int ayahNumber) {
    return state
        .any((b) => b.suraNumber == suraNumber && b.ayahNumber == ayahNumber);
  }
}

final bookmarkProvider =
    NotifierProvider<BookmarkNotifier, List<Bookmark>>(
        BookmarkNotifier.new);

/// Provider to check if a specific ayah is bookmarked
final isAyahBookmarkedProvider =
    Provider.family<bool, ({int sura, int ayah})>((ref, params) {
  final bookmarks = ref.watch(bookmarkProvider);
  return bookmarks
      .any((b) => b.suraNumber == params.sura && b.ayahNumber == params.ayah);
});
