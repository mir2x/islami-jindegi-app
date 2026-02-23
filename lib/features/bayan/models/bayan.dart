/// Pure Dart model for Bayan — no Flutter Data dependency.
class Bayan {
  final String id;
  final String title;
  final String? excerpt;
  final String language;
  final String? location;
  final Map<dynamic, dynamic>? audio;
  final bool? published;
  final String publishedAt;
  final int? position;
  final String? createdAt;
  final String? updatedAt;

  /// Resolved from the included speaker relationship
  final String? speakerName;

  Bayan({
    required this.id,
    required this.title,
    this.excerpt,
    required this.language,
    this.location,
    this.audio,
    this.published,
    required this.publishedAt,
    this.position,
    this.createdAt,
    this.updatedAt,
    this.speakerName,
  });

  factory Bayan.fromJsonApi(
    Map<String, dynamic> resource, {
    String? resolvedSpeakerName,
  }) {
    final attrs = resource['attributes'] as Map<String, dynamic>? ?? {};
    return Bayan(
      id: resource['id']?.toString() ?? '',
      title: attrs['title'] ?? '',
      excerpt: attrs['excerpt'],
      language: attrs['language'] ?? 'bn',
      location: attrs['location'],
      audio: attrs['audio'] is Map ? attrs['audio'] : null,
      published: attrs['published'],
      publishedAt: attrs['published-at'] ?? '',
      position: attrs['position'] is int ? attrs['position'] : null,
      createdAt: attrs['created-at'],
      updatedAt: attrs['updated-at'],
      speakerName: resolvedSpeakerName,
    );
  }
}
