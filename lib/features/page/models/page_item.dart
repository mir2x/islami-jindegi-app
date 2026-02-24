/// Pure Dart model for Page — fetched by slug for static content screens.
class PageItem {
  final String id;
  final String title;
  final String slug;
  final String body;
  final Map<dynamic, dynamic>? image;
  final String? createdAt;
  final String? updatedAt;

  PageItem({
    required this.id,
    required this.title,
    required this.slug,
    required this.body,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory PageItem.fromJsonApi(Map<String, dynamic> resource) {
    final attrs = resource['attributes'] as Map<String, dynamic>? ?? {};
    return PageItem(
      id: resource['id']?.toString() ?? '',
      title: attrs['title'] ?? '',
      slug: attrs['slug'] ?? '',
      body: attrs['body'] ?? '',
      image: attrs['image'] is Map ? attrs['image'] : null,
      createdAt: attrs['created-at'],
      updatedAt: attrs['updated-at'],
    );
  }
}
