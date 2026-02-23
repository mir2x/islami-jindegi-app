/// Pure Dart model for MalfuzatAuthor.
class MalfuzatAuthor {
  final String id;
  final String name;
  final String? info;
  final int? position;

  MalfuzatAuthor({
    required this.id,
    required this.name,
    this.info,
    this.position,
  });

  factory MalfuzatAuthor.fromJsonApi(Map<String, dynamic> resource) {
    final attrs = resource['attributes'] as Map<String, dynamic>? ?? {};
    return MalfuzatAuthor(
      id: resource['id']?.toString() ?? '',
      name: attrs['name'] ?? '',
      info: attrs['info'],
      position: attrs['position'] is int ? attrs['position'] : null,
    );
  }
}
