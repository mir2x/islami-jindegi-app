/// Pure Dart model for City.
class CityItem {
  final String id;
  final String name;
  final String? nameBn;
  final String countryCode;
  final double latitude;
  final double longitude;
  final String? timezone;

  CityItem({
    required this.id,
    required this.name,
    this.nameBn,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
    this.timezone,
  });

  factory CityItem.fromJsonApi(Map<String, dynamic> resource) {
    final attrs = resource['attributes'] as Map<String, dynamic>? ?? {};
    return CityItem(
      id: resource['id']?.toString() ?? '',
      name: attrs['name'] ?? '',
      nameBn: attrs['name-bn'],
      countryCode: attrs['country-code'] ?? '',
      latitude: (attrs['latitude'] is num)
          ? (attrs['latitude'] as num).toDouble()
          : 0.0,
      longitude: (attrs['longitude'] is num)
          ? (attrs['longitude'] as num).toDouble()
          : 0.0,
      timezone: attrs['timezone'],
    );
  }
}
