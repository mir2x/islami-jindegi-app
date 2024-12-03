// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ayah_bookmark.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAyahBookmarkCollection on Isar {
  IsarCollection<AyahBookmark> get ayahBookmarks => this.collection();
}

const AyahBookmarkSchema = CollectionSchema(
  name: r'AyahBookmark',
  id: -3350418778030092224,
  properties: {
    r'ayahId': PropertySchema(
      id: 0,
      name: r'ayahId',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'position': PropertySchema(
      id: 2,
      name: r'position',
      type: IsarType.long,
    ),
    r'surahTitle': PropertySchema(
      id: 3,
      name: r'surahTitle',
      type: IsarType.string,
    ),
    r'surahTitleBn': PropertySchema(
      id: 4,
      name: r'surahTitleBn',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 5,
      name: r'title',
      type: IsarType.string,
    ),
    r'translation': PropertySchema(
      id: 6,
      name: r'translation',
      type: IsarType.string,
    )
  },
  estimateSize: _ayahBookmarkEstimateSize,
  serialize: _ayahBookmarkSerialize,
  deserialize: _ayahBookmarkDeserialize,
  deserializeProp: _ayahBookmarkDeserializeProp,
  idName: r'id',
  indexes: {
    r'ayahId': IndexSchema(
      id: -5377454751934077591,
      name: r'ayahId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'ayahId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'createdAt': IndexSchema(
      id: -3433535483987302584,
      name: r'createdAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'createdAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _ayahBookmarkGetId,
  getLinks: _ayahBookmarkGetLinks,
  attach: _ayahBookmarkAttach,
  version: '3.1.8',
);

int _ayahBookmarkEstimateSize(
  AyahBookmark object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.ayahId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.surahTitle;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.surahTitleBn;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.title;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.translation;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _ayahBookmarkSerialize(
  AyahBookmark object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.ayahId);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeLong(offsets[2], object.position);
  writer.writeString(offsets[3], object.surahTitle);
  writer.writeString(offsets[4], object.surahTitleBn);
  writer.writeString(offsets[5], object.title);
  writer.writeString(offsets[6], object.translation);
}

AyahBookmark _ayahBookmarkDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AyahBookmark();
  object.ayahId = reader.readStringOrNull(offsets[0]);
  object.createdAt = reader.readDateTimeOrNull(offsets[1]);
  object.id = id;
  object.position = reader.readLongOrNull(offsets[2]);
  object.surahTitle = reader.readStringOrNull(offsets[3]);
  object.surahTitleBn = reader.readStringOrNull(offsets[4]);
  object.title = reader.readStringOrNull(offsets[5]);
  object.translation = reader.readStringOrNull(offsets[6]);
  return object;
}

P _ayahBookmarkDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _ayahBookmarkGetId(AyahBookmark object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _ayahBookmarkGetLinks(AyahBookmark object) {
  return [];
}

void _ayahBookmarkAttach(
    IsarCollection<dynamic> col, Id id, AyahBookmark object) {
  object.id = id;
}

extension AyahBookmarkByIndex on IsarCollection<AyahBookmark> {
  Future<AyahBookmark?> getByAyahId(String? ayahId) {
    return getByIndex(r'ayahId', [ayahId]);
  }

  AyahBookmark? getByAyahIdSync(String? ayahId) {
    return getByIndexSync(r'ayahId', [ayahId]);
  }

  Future<bool> deleteByAyahId(String? ayahId) {
    return deleteByIndex(r'ayahId', [ayahId]);
  }

  bool deleteByAyahIdSync(String? ayahId) {
    return deleteByIndexSync(r'ayahId', [ayahId]);
  }

  Future<List<AyahBookmark?>> getAllByAyahId(List<String?> ayahIdValues) {
    final values = ayahIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'ayahId', values);
  }

  List<AyahBookmark?> getAllByAyahIdSync(List<String?> ayahIdValues) {
    final values = ayahIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'ayahId', values);
  }

  Future<int> deleteAllByAyahId(List<String?> ayahIdValues) {
    final values = ayahIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'ayahId', values);
  }

  int deleteAllByAyahIdSync(List<String?> ayahIdValues) {
    final values = ayahIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'ayahId', values);
  }

  Future<Id> putByAyahId(AyahBookmark object) {
    return putByIndex(r'ayahId', object);
  }

  Id putByAyahIdSync(AyahBookmark object, {bool saveLinks = true}) {
    return putByIndexSync(r'ayahId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByAyahId(List<AyahBookmark> objects) {
    return putAllByIndex(r'ayahId', objects);
  }

  List<Id> putAllByAyahIdSync(List<AyahBookmark> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'ayahId', objects, saveLinks: saveLinks);
  }
}

extension AyahBookmarkQueryWhereSort
    on QueryBuilder<AyahBookmark, AyahBookmark, QWhere> {
  QueryBuilder<AyahBookmark, AyahBookmark, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterWhere> anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }
}

extension AyahBookmarkQueryWhere
    on QueryBuilder<AyahBookmark, AyahBookmark, QWhereClause> {
  QueryBuilder<AyahBookmark, AyahBookmark, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterWhereClause> ayahIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'ayahId',
        value: [null],
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterWhereClause>
      ayahIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'ayahId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterWhereClause> ayahIdEqualTo(
      String? ayahId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'ayahId',
        value: [ayahId],
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterWhereClause> ayahIdNotEqualTo(
      String? ayahId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ayahId',
              lower: [],
              upper: [ayahId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ayahId',
              lower: [ayahId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ayahId',
              lower: [ayahId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ayahId',
              lower: [],
              upper: [ayahId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterWhereClause>
      createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [null],
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterWhereClause>
      createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterWhereClause> createdAtEqualTo(
      DateTime? createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [createdAt],
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterWhereClause>
      createdAtNotEqualTo(DateTime? createdAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [],
              upper: [createdAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [createdAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [createdAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [],
              upper: [createdAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterWhereClause>
      createdAtGreaterThan(
    DateTime? createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [createdAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterWhereClause> createdAtLessThan(
    DateTime? createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [],
        upper: [createdAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterWhereClause> createdAtBetween(
    DateTime? lowerCreatedAt,
    DateTime? upperCreatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [lowerCreatedAt],
        includeLower: includeLower,
        upper: [upperCreatedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AyahBookmarkQueryFilter
    on QueryBuilder<AyahBookmark, AyahBookmark, QFilterCondition> {
  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      ayahIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'ayahId',
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      ayahIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'ayahId',
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition> ayahIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ayahId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      ayahIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ayahId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      ayahIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ayahId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition> ayahIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ayahId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      ayahIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ayahId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      ayahIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ayahId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      ayahIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ayahId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition> ayahIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ayahId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      ayahIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ayahId',
        value: '',
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      ayahIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ayahId',
        value: '',
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      createdAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      createdAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      positionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'position',
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      positionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'position',
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      positionEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'position',
        value: value,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      positionGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'position',
        value: value,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      positionLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'position',
        value: value,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      positionBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'position',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      surahTitleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'surahTitle',
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      surahTitleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'surahTitle',
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      surahTitleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'surahTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      surahTitleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'surahTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      surahTitleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'surahTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      surahTitleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'surahTitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      surahTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'surahTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      surahTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'surahTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      surahTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'surahTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      surahTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'surahTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      surahTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'surahTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      surahTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'surahTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      surahTitleBnIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'surahTitleBn',
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      surahTitleBnIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'surahTitleBn',
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      surahTitleBnEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'surahTitleBn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      surahTitleBnGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'surahTitleBn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      surahTitleBnLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'surahTitleBn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      surahTitleBnBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'surahTitleBn',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      surahTitleBnStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'surahTitleBn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      surahTitleBnEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'surahTitleBn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      surahTitleBnContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'surahTitleBn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      surahTitleBnMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'surahTitleBn',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      surahTitleBnIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'surahTitleBn',
        value: '',
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      surahTitleBnIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'surahTitleBn',
        value: '',
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      titleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      titleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition> titleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      titleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition> titleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition> titleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      translationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'translation',
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      translationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'translation',
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      translationEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'translation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      translationGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'translation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      translationLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'translation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      translationBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'translation',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      translationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'translation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      translationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'translation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      translationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'translation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      translationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'translation',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      translationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'translation',
        value: '',
      ));
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterFilterCondition>
      translationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'translation',
        value: '',
      ));
    });
  }
}

extension AyahBookmarkQueryObject
    on QueryBuilder<AyahBookmark, AyahBookmark, QFilterCondition> {}

extension AyahBookmarkQueryLinks
    on QueryBuilder<AyahBookmark, AyahBookmark, QFilterCondition> {}

extension AyahBookmarkQuerySortBy
    on QueryBuilder<AyahBookmark, AyahBookmark, QSortBy> {
  QueryBuilder<AyahBookmark, AyahBookmark, QAfterSortBy> sortByAyahId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayahId', Sort.asc);
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterSortBy> sortByAyahIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayahId', Sort.desc);
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterSortBy> sortByPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'position', Sort.asc);
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterSortBy> sortByPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'position', Sort.desc);
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterSortBy> sortBySurahTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahTitle', Sort.asc);
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterSortBy>
      sortBySurahTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahTitle', Sort.desc);
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterSortBy> sortBySurahTitleBn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahTitleBn', Sort.asc);
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterSortBy>
      sortBySurahTitleBnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahTitleBn', Sort.desc);
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterSortBy> sortByTranslation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translation', Sort.asc);
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterSortBy>
      sortByTranslationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translation', Sort.desc);
    });
  }
}

extension AyahBookmarkQuerySortThenBy
    on QueryBuilder<AyahBookmark, AyahBookmark, QSortThenBy> {
  QueryBuilder<AyahBookmark, AyahBookmark, QAfterSortBy> thenByAyahId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayahId', Sort.asc);
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterSortBy> thenByAyahIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayahId', Sort.desc);
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterSortBy> thenByPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'position', Sort.asc);
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterSortBy> thenByPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'position', Sort.desc);
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterSortBy> thenBySurahTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahTitle', Sort.asc);
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterSortBy>
      thenBySurahTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahTitle', Sort.desc);
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterSortBy> thenBySurahTitleBn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahTitleBn', Sort.asc);
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterSortBy>
      thenBySurahTitleBnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahTitleBn', Sort.desc);
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterSortBy> thenByTranslation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translation', Sort.asc);
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QAfterSortBy>
      thenByTranslationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translation', Sort.desc);
    });
  }
}

extension AyahBookmarkQueryWhereDistinct
    on QueryBuilder<AyahBookmark, AyahBookmark, QDistinct> {
  QueryBuilder<AyahBookmark, AyahBookmark, QDistinct> distinctByAyahId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ayahId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QDistinct> distinctByPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'position');
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QDistinct> distinctBySurahTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'surahTitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QDistinct> distinctBySurahTitleBn(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'surahTitleBn', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AyahBookmark, AyahBookmark, QDistinct> distinctByTranslation(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'translation', caseSensitive: caseSensitive);
    });
  }
}

extension AyahBookmarkQueryProperty
    on QueryBuilder<AyahBookmark, AyahBookmark, QQueryProperty> {
  QueryBuilder<AyahBookmark, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AyahBookmark, String?, QQueryOperations> ayahIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ayahId');
    });
  }

  QueryBuilder<AyahBookmark, DateTime?, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<AyahBookmark, int?, QQueryOperations> positionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'position');
    });
  }

  QueryBuilder<AyahBookmark, String?, QQueryOperations> surahTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'surahTitle');
    });
  }

  QueryBuilder<AyahBookmark, String?, QQueryOperations> surahTitleBnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'surahTitleBn');
    });
  }

  QueryBuilder<AyahBookmark, String?, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<AyahBookmark, String?, QQueryOperations> translationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'translation');
    });
  }
}
