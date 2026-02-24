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
