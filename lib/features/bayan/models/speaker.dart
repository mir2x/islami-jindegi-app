/// Pure Dart model for Speaker — no Flutter Data dependency.
class Speaker {
  final String id;
  final String name;
  final String? info;
  final int? position;
  final String? createdAt;
  final String? updatedAt;

  Speaker({
    required this.id,
    required this.name,
    this.info,
    this.position,
    this.createdAt,
    this.updatedAt,
  });

  factory Speaker.fromJsonApi(Map<String, dynamic> resource) {
    final attrs = resource['attributes'] as Map<String, dynamic>? ?? {};
    return Speaker(
      id: resource['id']?.toString() ?? '',
      name: attrs['name'] ?? '',
      info: attrs['info'],
      position: attrs['position'] is int ? attrs['position'] : null,
      createdAt: attrs['created-at'],
      updatedAt: attrs['updated-at'],
    );
  }

  factory Speaker.fromDb(Map<String, dynamic> row) {
    return Speaker(
      id: row['id'].toString(),
      name: row['name'] ?? '',
      info: row['info'],
      position: row['position'] is int ? row['position'] : null,
      createdAt: row['created_at'],
      updatedAt: row['updated_at'],
    );
  }
}
