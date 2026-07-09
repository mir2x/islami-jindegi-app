import 'madrasah_info.dart';
import 'madrasah_photo.dart';

/// Pure Dart model for Madrasah — no Flutter Data dependency.
///
/// Madrasah has no author/category/audio concept (unlike book/article/
/// malfuzat/masail/dua) and no `document`/`published` fields either — just a
/// title/excerpt/introduction plus embedded `infos` (label/value pairs) and
/// `photos` (gallery), both nested directly in `MadrasahDetail` by the .NET
/// API (no separate sub-resource fetch, unlike the old JSON:API backend).
class MadrasahItem {
  final String id;
  final String title;
  final String? excerpt;
  final String introduction;
  final int? position;
  final String? createdAt;
  final String? updatedAt;
  final List<MadrasahInfoItem> infos;
  final List<MadrasahPhotoItem> photos;

  MadrasahItem({
    required this.id,
    required this.title,
    this.excerpt,
    this.introduction = '',
    this.position,
    this.createdAt,
    this.updatedAt,
    this.infos = const [],
    this.photos = const [],
  });

  /// Parse from the .NET API's flat MadrasahListItem/MadrasahDetail JSON.
  /// MadrasahListItem omits `introduction`/`infos`/`photos` (detail-only
  /// fields, exposed there only as `infoCount`/`photoCount`), so those stay
  /// empty/default when parsing a list response.
  factory MadrasahItem.fromJson(Map<String, dynamic> json) {
    return MadrasahItem(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      excerpt: json['excerpt'],
      introduction: json['introduction'] ?? '',
      position: json['position'] is int ? json['position'] : null,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      infos: (json['infos'] as List? ?? [])
          .map((i) => MadrasahInfoItem.fromJson(i))
          .toList(),
      photos: (json['photos'] as List? ?? [])
          .map((p) => MadrasahPhotoItem.fromJson(p))
          .toList(),
    );
  }

  factory MadrasahItem.fromDb(
    Map<String, dynamic> row, {
    List<MadrasahInfoItem> infos = const [],
    List<MadrasahPhotoItem> photos = const [],
  }) {
    return MadrasahItem(
      id: row['id'].toString(),
      title: row['title'] ?? '',
      excerpt: row['excerpt']?.toString(),
      introduction: row['introduction'] ?? '',
      position: row['position'] is int ? row['position'] : null,
      createdAt: row['created_at']?.toString(),
      updatedAt: row['updated_at']?.toString(),
      infos: infos,
      photos: photos,
    );
  }
}
