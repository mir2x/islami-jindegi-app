String getLocationName(Map location) {
  return [
    location['city'],
    location['country'],
  ].where((v) => v is String && v.isNotEmpty).join(', ');
}
