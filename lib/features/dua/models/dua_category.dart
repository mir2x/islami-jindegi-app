/// Pure Dart model for DuaCategory.
class DuaCategory {
  final String id;
  final String title;
  final int? position;

  DuaCategory({
    required this.id,
    required this.title,
    this.position,
  });

  factory DuaCategory.fromJsonApi(Map<String, dynamic> resource) {
    final attrs = resource['attributes'] as Map<String, dynamic>? ?? {};
    return DuaCategory(
      id: resource['id']?.toString() ?? '',
      title: attrs['title'] ?? '',
      position: attrs['position'] is int ? attrs['position'] : null,
    );
  }
}
