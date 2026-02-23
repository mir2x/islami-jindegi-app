import 'malfuzat_subcategory.dart';

/// Pure Dart model for MalfuzatCategory with resolved subcategories.
class MalfuzatCategory {
  final String id;
  final String title;
  final int? position;
  final List<MalfuzatSubcategory> malfuzatSubcategories;

  MalfuzatCategory({
    required this.id,
    required this.title,
    this.position,
    this.malfuzatSubcategories = const [],
  });

  factory MalfuzatCategory.fromJsonApi(
    Map<String, dynamic> resource, {
    List<MalfuzatSubcategory> resolvedSubcategories = const [],
  }) {
    final attrs = resource['attributes'] as Map<String, dynamic>? ?? {};
    return MalfuzatCategory(
      id: resource['id']?.toString() ?? '',
      title: attrs['title'] ?? '',
      position: attrs['position'] is int ? attrs['position'] : null,
      malfuzatSubcategories: resolvedSubcategories,
    );
  }
}
