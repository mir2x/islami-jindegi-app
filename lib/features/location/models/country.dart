/// Pure Dart model for Country.
class CountryItem {
  final String id;
  final String name;
  final String? nameBn;
  final String code;

  CountryItem({
    required this.id,
    required this.name,
    this.nameBn,
    required this.code,
  });

  factory CountryItem.fromJsonApi(Map<String, dynamic> resource) {
    final attrs = resource['attributes'] as Map<String, dynamic>? ?? {};
    return CountryItem(
      id: resource['id']?.toString() ?? '',
      name: attrs['name'] ?? '',
      nameBn: attrs['name-bn'],
      code: attrs['code'] ?? '',
    );
  }
}
