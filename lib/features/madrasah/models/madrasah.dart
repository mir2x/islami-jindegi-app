import 'madrasah_info.dart';
import 'madrasah_photo.dart';

/// Pure Dart model for Madrasah — no Flutter Data dependency.
class MadrasahItem {
  final String id;
  final String title;
  final String introduction;
  final String? excerpt;
  final Map<dynamic, dynamic>? document;
  final int? position;
  final bool? published;
  final String? createdAt;
  final String? updatedAt;

  /// Resolved from included relationships
  final List<MadrasahInfoItem> madrasahInfos;
  final List<MadrasahPhotoItem> madrasahPhotos;

  MadrasahItem({
    required this.id,
    required this.title,
    required this.introduction,
    this.excerpt,
    this.document,
    this.position,
    this.published,
    this.createdAt,
    this.updatedAt,
    this.madrasahInfos = const [],
    this.madrasahPhotos = const [],
  });

  factory MadrasahItem.fromJsonApi(
    Map<String, dynamic> resource, {
    List<MadrasahInfoItem> resolvedInfos = const [],
    List<MadrasahPhotoItem> resolvedPhotos = const [],
  }) {
    final attrs = resource['attributes'] as Map<String, dynamic>? ?? {};
    return MadrasahItem(
      id: resource['id']?.toString() ?? '',
      title: attrs['title'] ?? '',
      introduction: attrs['introduction'] ?? '',
      excerpt: attrs['excerpt'],
      document: attrs['document'] is Map ? attrs['document'] : null,
      position: attrs['position'] is int ? attrs['position'] : null,
      published: attrs['published'],
      createdAt: attrs['created-at'],
      updatedAt: attrs['updated-at'],
      madrasahInfos: resolvedInfos,
      madrasahPhotos: resolvedPhotos,
    );
  }
}
