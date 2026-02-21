import 'dart:convert';

/// A downloaded book stored in SharedPreferences.
/// Replaces the old Isar-based DownloadedBook model.
class DownloadedBookEntry {
  final String bookId;
  final String? title;
  final String? excerpt;
  final String? publisher;
  final String? price;
  final String? image;
  final String? document;
  final String? authors;
  final String? publishedAt;
  final DateTime createdAt;

  DownloadedBookEntry({
    required this.bookId,
    this.title,
    this.excerpt,
    this.publisher,
    this.price,
    this.image,
    this.document,
    this.authors,
    this.publishedAt,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'bookId': bookId,
        'title': title,
        'excerpt': excerpt,
        'publisher': publisher,
        'price': price,
        'image': image,
        'document': document,
        'authors': authors,
        'publishedAt': publishedAt,
        'createdAt': createdAt.toIso8601String(),
      };

  factory DownloadedBookEntry.fromJson(Map<String, dynamic> json) {
    return DownloadedBookEntry(
      bookId: json['bookId'] ?? '',
      title: json['title'],
      excerpt: json['excerpt'],
      publisher: json['publisher'],
      price: json['price'],
      image: json['image'],
      document: json['document'],
      authors: json['authors'],
      publishedAt: json['publishedAt'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  /// Encode a list of entries to a JSON string for SharedPreferences storage
  static String encodeList(List<DownloadedBookEntry> entries) {
    return json.encode(entries.map((e) => e.toJson()).toList());
  }

  /// Decode a list of entries from a JSON string
  static List<DownloadedBookEntry> decodeList(String jsonString) {
    final List<dynamic> list = json.decode(jsonString);
    return list
        .map((e) => DownloadedBookEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
