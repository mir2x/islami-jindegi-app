class BookCategory {
  final String id;
  final String title;
  final int? position;
  final List<BookSubcategory> subcategories;

  BookCategory({
    required this.id,
    required this.title,
    this.position,
    this.subcategories = const [],
  });

  /// From JSON:API resource + resolved included subcategories
  factory BookCategory.fromJsonApi(
    Map<String, dynamic> resource, {
    List<BookSubcategory> resolvedSubcategories = const [],
  }) {
    final attrs = resource['attributes'] as Map<String, dynamic>? ?? {};
    return BookCategory(
      id: resource['id'].toString(),
      title: attrs['title'] ?? '',
      position: attrs['position'] is int ? attrs['position'] : null,
      subcategories: resolvedSubcategories,
    );
  }
}

class BookSubcategory {
  final String id;
  final String title;
  final int? position;

  BookSubcategory({
    required this.id,
    required this.title,
    this.position,
  });

  /// From JSON:API resource
  factory BookSubcategory.fromJsonApi(Map<String, dynamic> resource) {
    final attrs = resource['attributes'] as Map<String, dynamic>? ?? {};
    return BookSubcategory(
      id: resource['id'].toString(),
      title: attrs['title'] ?? '',
      position: attrs['position'] is int ? attrs['position'] : null,
    );
  }
}
