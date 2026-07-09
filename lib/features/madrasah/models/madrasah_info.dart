/// Pure Dart model for a madrasah's info entry (label/value pair).
///
/// Always embedded within `MadrasahDetail.infos` — the .NET API has no
/// standalone `/madrasah_infos/:id` endpoint (unlike the old JSON:API
/// backend's `madrasah_infos` resource), so this is parsed straight off the
/// nested JSON rather than fetched separately.
class MadrasahInfoItem {
  final String id;
  final String label;
  final String info;
  final int? position;

  MadrasahInfoItem({
    required this.id,
    required this.label,
    required this.info,
    this.position,
  });

  factory MadrasahInfoItem.fromJson(Map<String, dynamic> json) {
    return MadrasahInfoItem(
      id: json['id']?.toString() ?? '',
      label: json['label'] ?? '',
      info: json['info'] ?? '',
      position: json['position'] is int ? json['position'] : null,
    );
  }

  factory MadrasahInfoItem.fromDb(Map<String, dynamic> row) {
    return MadrasahInfoItem(
      id: row['id'].toString(),
      label: row['label'] ?? '',
      info: row['info'] ?? '',
      position: row['position'] is int ? row['position'] : null,
    );
  }
}
