import 'package:sqflite/sqflite.dart';

import 'sibling_ref.dart';

/// Resolves a neighbour within the locally downloaded subsequence.
///
/// The comparison intentionally runs in SQLite: canonical UUID text ordering
/// matches PostgreSQL uuid byte ordering, while comparing ids in Dart/.NET
/// would not be a portable canonical ordering.
Future<SiblingRef?> findOfflineSibling({
  required Database db,
  required String table,
  required int position,
  required String id,
  required bool forward,
  required bool descending,
  bool filterPublished = true,
}) async {
  final up = descending ? !forward : forward;
  final comparison = up ? '>' : '<';
  final direction = up ? 'ASC' : 'DESC';
  final rows = await db.query(
    table,
    columns: const ['id', 'title', 'position'],
    where: [
      if (filterPublished) 'published = 1',
      '(position $comparison ? OR (position = ? AND id $comparison ?))',
    ].join(' AND '),
    whereArgs: [position, position, id],
    orderBy: 'position $direction, id $direction',
    limit: 1,
  );
  if (rows.isEmpty) return null;
  final row = rows.first;
  return SiblingRef(
    id: row['id'].toString(),
    title: row['title']?.toString() ?? '',
    position: row['position'] as int?,
  );
}
