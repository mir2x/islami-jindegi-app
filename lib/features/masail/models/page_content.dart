/// Simple model for page content (used by ask-question screen).
class PageContent {
  final String id;
  final String? body;
  final String? slug;

  PageContent({
    required this.id,
    this.body,
    this.slug,
  });

  factory PageContent.fromJsonApi(Map<String, dynamic> resource) {
    final attrs = resource['attributes'] as Map<String, dynamic>? ?? {};
    return PageContent(
      id: resource['id']?.toString() ?? '',
      body: attrs['body'],
      slug: attrs['slug'],
    );
  }

  factory PageContent.fromDb(Map<String, dynamic> row) {
    return PageContent(
      id: row['id'].toString(),
      body: row['body'],
      slug: row['slug'],
    );
  }
}
