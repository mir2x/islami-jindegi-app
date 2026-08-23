class SiblingRef {
  final String id;
  final String title;
  final int? position;

  const SiblingRef({
    required this.id,
    required this.title,
    this.position,
  });

  static SiblingRef? fromJson(Map<String, dynamic>? json) => json == null
      ? null
      : SiblingRef(
          id: json['id'].toString(),
          title: json['title']?.toString() ?? '',
          position: json['position'] is int ? json['position'] as int : null,
        );
}
