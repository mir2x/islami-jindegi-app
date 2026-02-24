/// Pure Dart model for NamazTime — no Flutter Data dependency.
class NamazTimeItem {
  final String id;
  final String title;
  final String? titleBn;
  final String slug;
  final String masail;
  final String? fazail;
  final int? position;
  final String? createdAt;
  final String? updatedAt;

  NamazTimeItem({
    required this.id,
    required this.title,
    this.titleBn,
    required this.slug,
    required this.masail,
    this.fazail,
    this.position,
    this.createdAt,
    this.updatedAt,
  });

  factory NamazTimeItem.fromJsonApi(Map<String, dynamic> resource) {
    final attrs = resource['attributes'] as Map<String, dynamic>? ?? {};
    return NamazTimeItem(
      id: resource['id']?.toString() ?? '',
      title: attrs['title'] ?? '',
      titleBn: attrs['title-bn'],
      slug: attrs['slug'] ?? '',
      masail: attrs['masail'] ?? '',
      fazail: attrs['fazail'],
      position: attrs['position'] is int ? attrs['position'] : null,
      createdAt: attrs['created-at'],
      updatedAt: attrs['updated-at'],
    );
  }
}
