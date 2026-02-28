class BayanCategory {
  final String id;
  final String title;
  final int? position;
  final String? createdAt;
  final String? updatedAt;

  BayanCategory({
    required this.id,
    required this.title,
    this.position,
    this.createdAt,
    this.updatedAt,
  });

  factory BayanCategory.fromJsonApi(Map<String, dynamic> resource) {
    final attrs = resource['attributes'] as Map<String, dynamic>? ?? {};
    return BayanCategory(
      id: resource['id']?.toString() ?? '',
      title: attrs['title'] ?? '',
      position: attrs['position'] is int ? attrs['position'] : null,
      createdAt: attrs['created-at'],
      updatedAt: attrs['updated-at'],
    );
  }

  factory BayanCategory.fromDb(Map<String, dynamic> row) {
    return BayanCategory(
      id: row['id'].toString(),
      title: row['title'] ?? '',
      position: row['position'] is int ? row['position'] : null,
      createdAt: row['created_at'],
      updatedAt: row['updated_at'],
    );
  }
}
