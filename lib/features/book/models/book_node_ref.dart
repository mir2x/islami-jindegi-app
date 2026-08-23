class BookNodeRef {
  final String id;
  final String title;
  final int readingOrder;
  final String kind;

  const BookNodeRef(
      {required this.id,
      required this.title,
      required this.readingOrder,
      required this.kind});

  static BookNodeRef? fromJson(Map<String, dynamic>? json) => json == null
      ? null
      : BookNodeRef(
          id: json['id'].toString(),
          title: json['title']?.toString() ?? '',
          readingOrder: json['readingOrder'] as int? ?? 0,
          kind: json['kind']?.toString() ?? 'subchapter');
}
