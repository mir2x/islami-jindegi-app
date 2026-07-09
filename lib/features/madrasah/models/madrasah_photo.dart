/// Pure Dart model for a madrasah gallery photo.
///
/// The .NET API exposes a flat `imageUrl` string (unlike the old JSON:API
/// backend's derivative-map `image` attribute), so the gallery screen renders
/// it directly via `CachedNetworkImage` instead of the shared
/// `ResponsiveImage` widget, which still expects the old map shape and is
/// used elsewhere.
class MadrasahPhotoItem {
  final String id;
  final String? title;
  final String? imageUrl;
  final int? position;

  MadrasahPhotoItem({
    required this.id,
    this.title,
    this.imageUrl,
    this.position,
  });

  factory MadrasahPhotoItem.fromJson(Map<String, dynamic> json) {
    return MadrasahPhotoItem(
      id: json['id']?.toString() ?? '',
      title: json['title'],
      imageUrl: json['imageUrl'],
      position: json['position'] is int ? json['position'] : null,
    );
  }

  factory MadrasahPhotoItem.fromDb(Map<String, dynamic> row) {
    return MadrasahPhotoItem(
      id: row['id'].toString(),
      title: row['title']?.toString(),
      imageUrl: row['image_url'] ?? row['imageUrl'],
      position: row['position'] is int ? row['position'] : null,
    );
  }
}
