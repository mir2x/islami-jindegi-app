/// Pure Dart model for MasailAuthor.
class MasailAuthor {
  final String id;
  final String name;
  final String? info;
  final int? position;

  MasailAuthor({
    required this.id,
    required this.name,
    this.info,
    this.position,
  });

  factory MasailAuthor.fromJsonApi(Map<String, dynamic> resource) {
    final attrs = resource['attributes'] as Map<String, dynamic>? ?? {};
    return MasailAuthor(
      id: resource['id']?.toString() ?? '',
      name: attrs['name'] ?? '',
      info: attrs['info'],
      position: attrs['position'] is int ? attrs['position'] : null,
    );
  }

  factory MasailAuthor.fromDb(Map<String, dynamic> row) {
    return MasailAuthor(
      id: row['id'].toString(),
      name: row['name'] ?? '',
      info: row['info'],
      position: row['position'] is int ? row['position'] : null,
    );
  }
}
