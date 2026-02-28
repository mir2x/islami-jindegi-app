/// Pure Dart model for MadrasahInfo.
class MadrasahInfoItem {
  final String id;
  final String label;
  final String info;
  final int? position;
  final String? createdAt;
  final String? updatedAt;

  /// Resolved from the included madrasah relationship
  final String? madrasahId;
  final String? madrasahTitle;

  MadrasahInfoItem({
    required this.id,
    required this.label,
    required this.info,
    this.position,
    this.createdAt,
    this.updatedAt,
    this.madrasahId,
    this.madrasahTitle,
  });

  factory MadrasahInfoItem.fromDb(Map<String, dynamic> row,
      {String? madrasahTitle}) {
    return MadrasahInfoItem(
      id: row['id'].toString(),
      label: row['label'] ?? '',
      info: row['info'] ?? '',
      position: row['position'] is int ? row['position'] : null,
      createdAt: row['created_at']?.toString(),
      updatedAt: row['updated_at']?.toString(),
      madrasahId: row['madrasah_id']?.toString(),
      madrasahTitle: madrasahTitle,
    );
  }

  factory MadrasahInfoItem.fromJsonApi(
    Map<String, dynamic> resource, {
    String? resolvedMadrasahId,
    String? resolvedMadrasahTitle,
  }) {
    final attrs = resource['attributes'] as Map<String, dynamic>? ?? {};
    return MadrasahInfoItem(
      id: resource['id']?.toString() ?? '',
      label: attrs['label'] ?? '',
      info: attrs['info'] ?? '',
      position: attrs['position'] is int ? attrs['position'] : null,
      createdAt: attrs['created-at'],
      updatedAt: attrs['updated-at'],
      madrasahId: resolvedMadrasahId,
      madrasahTitle: resolvedMadrasahTitle,
    );
  }
}
