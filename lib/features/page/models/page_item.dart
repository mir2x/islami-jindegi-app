/// Pure Dart model for Page — fetched by slug for static content screens.
class PageItem {
  final String id;
  final String title;
  final String slug;
  final String body;
  final String? imageUrl;
  final String? createdAt;
  final String? updatedAt;

  PageItem({
    required this.id,
    required this.title,
    required this.slug,
    required this.body,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  /// From the .NET API's flat PageDetail JSON
  factory PageItem.fromJson(Map<String, dynamic> json) {
    return PageItem(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      body: json['body'] ?? '',
      imageUrl: json['imageUrl'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
