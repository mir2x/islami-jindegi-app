import 'dart:convert';

/// Pure Dart model for MadrasahPhoto.
class MadrasahPhotoItem {
  final String id;
  final String? title;
  final Map<dynamic, dynamic>? image;
  final int? position;

  MadrasahPhotoItem({
    required this.id,
    this.title,
    this.image,
    this.position,
  });

  factory MadrasahPhotoItem.fromDb(Map<String, dynamic> row) {
    Map<dynamic, dynamic>? image;
    final raw = row['image_data'];
    if (raw != null) {
      try {
        final decoded = json.decode(raw as String);
        image = decoded is Map ? decoded : null;
      } catch (_) {}
    }
    return MadrasahPhotoItem(
      id: row['id'].toString(),
      title: row['title']?.toString(),
      image: image,
      position: row['position'] is int ? row['position'] : null,
    );
  }

  factory MadrasahPhotoItem.fromJsonApi(Map<String, dynamic> resource) {
    final attrs = resource['attributes'] as Map<String, dynamic>? ?? {};
    return MadrasahPhotoItem(
      id: resource['id']?.toString() ?? '',
      title: attrs['title'],
      image: attrs['image'] is Map ? attrs['image'] : null,
      position: attrs['position'] is int ? attrs['position'] : null,
    );
  }
}
