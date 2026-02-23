/// Pure Dart model for MasailSubcategory.
class MasailSubcategory {
  final String id;
  final String title;
  final int? position;

  MasailSubcategory({
    required this.id,
    required this.title,
    this.position,
  });

  factory MasailSubcategory.fromJsonApi(Map<String, dynamic> resource) {
    final attrs = resource['attributes'] as Map<String, dynamic>? ?? {};
    return MasailSubcategory(
      id: resource['id']?.toString() ?? '',
      title: attrs['title'] ?? '',
      position: attrs['position'] is int ? attrs['position'] : null,
    );
  }
}
