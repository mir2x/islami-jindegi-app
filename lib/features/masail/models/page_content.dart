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

  /// From the .NET API's flat PageDetail JSON
  factory PageContent.fromJson(Map<String, dynamic> json) {
    return PageContent(
      id: json['id'].toString(),
      body: json['body'],
      slug: json['slug'],
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
