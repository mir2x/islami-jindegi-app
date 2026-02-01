import 'dart:convert';

class Bookmark {
  final int suraNumber;
  final int ayahNumber;
  final String suraName;
  final String arabicText;
  final DateTime createdAt;

  Bookmark({
    required this.suraNumber,
    required this.ayahNumber,
    required this.suraName,
    required this.arabicText,
    required this.createdAt,
  });

  /// Unique identifier for the bookmark
  String get id => '$suraNumber:$ayahNumber';

  Map<String, dynamic> toJson() => {
        'suraNumber': suraNumber,
        'ayahNumber': ayahNumber,
        'suraName': suraName,
        'arabicText': arabicText,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Bookmark.fromJson(Map<String, dynamic> json) => Bookmark(
        suraNumber: json['suraNumber'] as int,
        ayahNumber: json['ayahNumber'] as int,
        suraName: json['suraName'] as String,
        arabicText: json['arabicText'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  static String encodeList(List<Bookmark> bookmarks) =>
      jsonEncode(bookmarks.map((b) => b.toJson()).toList());

  static List<Bookmark> decodeList(String jsonString) {
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList
        .map((json) => Bookmark.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Bookmark &&
          runtimeType == other.runtimeType &&
          suraNumber == other.suraNumber &&
          ayahNumber == other.ayahNumber;

  @override
  int get hashCode => suraNumber.hashCode ^ ayahNumber.hashCode;
}
