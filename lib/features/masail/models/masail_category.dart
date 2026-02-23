import 'masail_subcategory.dart';

/// Pure Dart model for MasailCategory with resolved subcategories.
class MasailCategory {
  final String id;
  final String title;
  final int? position;
  final List<MasailSubcategory> masailSubcategories;

  MasailCategory({
    required this.id,
    required this.title,
    this.position,
    this.masailSubcategories = const [],
  });

  factory MasailCategory.fromJsonApi(
    Map<String, dynamic> resource, {
    List<MasailSubcategory> resolvedSubcategories = const [],
  }) {
    final attrs = resource['attributes'] as Map<String, dynamic>? ?? {};
    return MasailCategory(
      id: resource['id']?.toString() ?? '',
      title: attrs['title'] ?? '',
      position: attrs['position'] is int ? attrs['position'] : null,
      masailSubcategories: resolvedSubcategories,
    );
  }
}
