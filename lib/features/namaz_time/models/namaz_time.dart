// Pure Dart models for NamazTime — flat REST JSON from the .NET API
// (no JSON:API envelope, no `slug` field; ordering is by `position`).

/// Lightweight list-item shape, matching .NET's `NamazTimeListItem` DTO
/// (`Id, Title, TitleBn, Position, ...`).
class NamazTimeListItem {
  final String id;
  final String title;
  final String? titleBn;
  /// Stable route key; null only from an API build that predates it.
  final String? slug;
  final int position;

  NamazTimeListItem({
    required this.id,
    required this.title,
    this.titleBn,
    this.slug,
    required this.position,
  });

  factory NamazTimeListItem.fromJson(Map<String, dynamic> json) {
    return NamazTimeListItem(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      titleBn: json['titleBn'],
      slug: json['slug'],
      position: json['position'] is int ? json['position'] : 0,
    );
  }
}

/// Full detail shape (adds the masail/fazail text), matching .NET's
/// `NamazTimeDetail` DTO (`Id, Title, TitleBn, Masail, Fazail, Position, ...`).
class NamazTimeItem {
  final String id;
  final String title;
  final String? titleBn;
  final String? slug;
  final String masail;
  final String? fazail;
  final int? position;
  final String? createdAt;
  final String? updatedAt;

  NamazTimeItem({
    required this.id,
    required this.title,
    this.titleBn,
    this.slug,
    required this.masail,
    this.fazail,
    this.position,
    this.createdAt,
    this.updatedAt,
  });

  factory NamazTimeItem.fromJson(Map<String, dynamic> json) {
    return NamazTimeItem(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      titleBn: json['titleBn'],
      slug: json['slug'],
      masail: json['masail'] ?? '',
      fazail: json['fazail'],
      position: json['position'] is int ? json['position'] : null,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
