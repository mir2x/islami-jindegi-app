// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'downloaded_malfuzat.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDownloadedMalfuzatCollection on Isar {
  IsarCollection<DownloadedMalfuzat> get downloadedMalfuzats =>
      this.collection();
}

const DownloadedMalfuzatSchema = CollectionSchema(
  name: r'DownloadedMalfuzat',
  id: -2666365813993290457,
  properties: {
    r'audio': PropertySchema(
      id: 0,
      name: r'audio',
      type: IsarType.string,
    ),
    r'author': PropertySchema(
      id: 1,
      name: r'author',
      type: IsarType.string,
    ),
    r'body': PropertySchema(
      id: 2,
      name: r'body',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 3,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'document': PropertySchema(
      id: 4,
      name: r'document',
      type: IsarType.string,
    ),
    r'excerpt': PropertySchema(
      id: 5,
      name: r'excerpt',
      type: IsarType.string,
    ),
    r'malfuzatId': PropertySchema(
      id: 6,
      name: r'malfuzatId',
      type: IsarType.string,
    ),
    r'publishedAt': PropertySchema(
      id: 7,
      name: r'publishedAt',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 8,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _downloadedMalfuzatEstimateSize,
  serialize: _downloadedMalfuzatSerialize,
  deserialize: _downloadedMalfuzatDeserialize,
  deserializeProp: _downloadedMalfuzatDeserializeProp,
  idName: r'id',
  indexes: {
    r'malfuzatId': IndexSchema(
      id: -4394880600353586429,
      name: r'malfuzatId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'malfuzatId',
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
  getId: _downloadedMalfuzatGetId,
  getLinks: _downloadedMalfuzatGetLinks,
  attach: _downloadedMalfuzatAttach,
  version: '3.1.0+1',
);

int _downloadedMalfuzatEstimateSize(
  DownloadedMalfuzat object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.audio;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.author;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.body;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.document;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.excerpt;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.malfuzatId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.publishedAt;
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
  return bytesCount;
}

void _downloadedMalfuzatSerialize(
  DownloadedMalfuzat object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.audio);
  writer.writeString(offsets[1], object.author);
  writer.writeString(offsets[2], object.body);
  writer.writeDateTime(offsets[3], object.createdAt);
  writer.writeString(offsets[4], object.document);
  writer.writeString(offsets[5], object.excerpt);
  writer.writeString(offsets[6], object.malfuzatId);
  writer.writeString(offsets[7], object.publishedAt);
  writer.writeString(offsets[8], object.title);
}

DownloadedMalfuzat _downloadedMalfuzatDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DownloadedMalfuzat();
  object.audio = reader.readStringOrNull(offsets[0]);
  object.author = reader.readStringOrNull(offsets[1]);
  object.body = reader.readStringOrNull(offsets[2]);
  object.createdAt = reader.readDateTimeOrNull(offsets[3]);
  object.document = reader.readStringOrNull(offsets[4]);
  object.excerpt = reader.readStringOrNull(offsets[5]);
  object.id = id;
  object.malfuzatId = reader.readStringOrNull(offsets[6]);
  object.publishedAt = reader.readStringOrNull(offsets[7]);
  object.title = reader.readStringOrNull(offsets[8]);
  return object;
}

P _downloadedMalfuzatDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _downloadedMalfuzatGetId(DownloadedMalfuzat object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _downloadedMalfuzatGetLinks(
    DownloadedMalfuzat object) {
  return [];
}

void _downloadedMalfuzatAttach(
    IsarCollection<dynamic> col, Id id, DownloadedMalfuzat object) {
  object.id = id;
}

extension DownloadedMalfuzatByIndex on IsarCollection<DownloadedMalfuzat> {
  Future<DownloadedMalfuzat?> getByMalfuzatId(String? malfuzatId) {
    return getByIndex(r'malfuzatId', [malfuzatId]);
  }

  DownloadedMalfuzat? getByMalfuzatIdSync(String? malfuzatId) {
    return getByIndexSync(r'malfuzatId', [malfuzatId]);
  }

  Future<bool> deleteByMalfuzatId(String? malfuzatId) {
    return deleteByIndex(r'malfuzatId', [malfuzatId]);
  }

  bool deleteByMalfuzatIdSync(String? malfuzatId) {
    return deleteByIndexSync(r'malfuzatId', [malfuzatId]);
  }

  Future<List<DownloadedMalfuzat?>> getAllByMalfuzatId(
      List<String?> malfuzatIdValues) {
    final values = malfuzatIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'malfuzatId', values);
  }

  List<DownloadedMalfuzat?> getAllByMalfuzatIdSync(
      List<String?> malfuzatIdValues) {
    final values = malfuzatIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'malfuzatId', values);
  }

  Future<int> deleteAllByMalfuzatId(List<String?> malfuzatIdValues) {
    final values = malfuzatIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'malfuzatId', values);
  }

  int deleteAllByMalfuzatIdSync(List<String?> malfuzatIdValues) {
    final values = malfuzatIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'malfuzatId', values);
  }

  Future<Id> putByMalfuzatId(DownloadedMalfuzat object) {
    return putByIndex(r'malfuzatId', object);
  }

  Id putByMalfuzatIdSync(DownloadedMalfuzat object, {bool saveLinks = true}) {
    return putByIndexSync(r'malfuzatId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByMalfuzatId(List<DownloadedMalfuzat> objects) {
    return putAllByIndex(r'malfuzatId', objects);
  }

  List<Id> putAllByMalfuzatIdSync(List<DownloadedMalfuzat> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'malfuzatId', objects, saveLinks: saveLinks);
  }
}

extension DownloadedMalfuzatQueryWhereSort
    on QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QWhere> {
  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterWhere>
      anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }
}

extension DownloadedMalfuzatQueryWhere
    on QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QWhereClause> {
  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterWhereClause>
      malfuzatIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'malfuzatId',
        value: [null],
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterWhereClause>
      malfuzatIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'malfuzatId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterWhereClause>
      malfuzatIdEqualTo(String? malfuzatId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'malfuzatId',
        value: [malfuzatId],
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterWhereClause>
      malfuzatIdNotEqualTo(String? malfuzatId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'malfuzatId',
              lower: [],
              upper: [malfuzatId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'malfuzatId',
              lower: [malfuzatId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'malfuzatId',
              lower: [malfuzatId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'malfuzatId',
              lower: [],
              upper: [malfuzatId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterWhereClause>
      createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [null],
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterWhereClause>
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

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterWhereClause>
      createdAtEqualTo(DateTime? createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [createdAt],
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterWhereClause>
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

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterWhereClause>
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

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterWhereClause>
      createdAtLessThan(
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

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterWhereClause>
      createdAtBetween(
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

extension DownloadedMalfuzatQueryFilter
    on QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QFilterCondition> {
  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      audioIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'audio',
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      audioIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'audio',
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      audioEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'audio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      audioGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'audio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      audioLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'audio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      audioBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'audio',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      audioStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'audio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      audioEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'audio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      audioContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'audio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      audioMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'audio',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      audioIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'audio',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      audioIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'audio',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      authorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'author',
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      authorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'author',
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      authorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      authorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      authorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      authorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'author',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      authorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      authorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      authorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      authorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'author',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      authorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'author',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      authorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'author',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      bodyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'body',
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      bodyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'body',
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      bodyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      bodyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      bodyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      bodyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'body',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      bodyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      bodyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      bodyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      bodyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'body',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      bodyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'body',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      bodyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'body',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
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

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
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

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
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

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      documentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'document',
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      documentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'document',
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      documentEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'document',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      documentGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'document',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      documentLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'document',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      documentBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'document',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      documentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'document',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      documentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'document',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      documentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'document',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      documentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'document',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      documentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'document',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      documentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'document',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      excerptIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'excerpt',
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      excerptIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'excerpt',
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      excerptEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'excerpt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      excerptGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'excerpt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      excerptLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'excerpt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      excerptBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'excerpt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      excerptStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'excerpt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      excerptEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'excerpt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      excerptContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'excerpt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      excerptMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'excerpt',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      excerptIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'excerpt',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      excerptIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'excerpt',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      malfuzatIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'malfuzatId',
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      malfuzatIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'malfuzatId',
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      malfuzatIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'malfuzatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      malfuzatIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'malfuzatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      malfuzatIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'malfuzatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      malfuzatIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'malfuzatId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      malfuzatIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'malfuzatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      malfuzatIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'malfuzatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      malfuzatIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'malfuzatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      malfuzatIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'malfuzatId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      malfuzatIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'malfuzatId',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      malfuzatIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'malfuzatId',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      publishedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'publishedAt',
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      publishedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'publishedAt',
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      publishedAtEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'publishedAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      publishedAtGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'publishedAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      publishedAtLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'publishedAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      publishedAtBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'publishedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      publishedAtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'publishedAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      publishedAtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'publishedAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      publishedAtContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'publishedAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      publishedAtMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'publishedAt',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      publishedAtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'publishedAt',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      publishedAtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'publishedAt',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      titleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      titleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      titleEqualTo(
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

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
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

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      titleLessThan(
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

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      titleBetween(
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

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
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

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      titleEndsWith(
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

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension DownloadedMalfuzatQueryObject
    on QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QFilterCondition> {}

extension DownloadedMalfuzatQueryLinks
    on QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QFilterCondition> {}

extension DownloadedMalfuzatQuerySortBy
    on QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QSortBy> {
  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterSortBy>
      sortByAudio() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audio', Sort.asc);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterSortBy>
      sortByAudioDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audio', Sort.desc);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterSortBy>
      sortByAuthor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.asc);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterSortBy>
      sortByAuthorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.desc);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterSortBy>
      sortByBody() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'body', Sort.asc);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterSortBy>
      sortByBodyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'body', Sort.desc);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterSortBy>
      sortByDocument() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'document', Sort.asc);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterSortBy>
      sortByDocumentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'document', Sort.desc);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterSortBy>
      sortByExcerpt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'excerpt', Sort.asc);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterSortBy>
      sortByExcerptDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'excerpt', Sort.desc);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterSortBy>
      sortByMalfuzatId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'malfuzatId', Sort.asc);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterSortBy>
      sortByMalfuzatIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'malfuzatId', Sort.desc);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterSortBy>
      sortByPublishedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publishedAt', Sort.asc);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterSortBy>
      sortByPublishedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publishedAt', Sort.desc);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterSortBy>
      sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterSortBy>
      sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension DownloadedMalfuzatQuerySortThenBy
    on QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QSortThenBy> {
  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterSortBy>
      thenByAudio() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audio', Sort.asc);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterSortBy>
      thenByAudioDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audio', Sort.desc);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterSortBy>
      thenByAuthor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.asc);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterSortBy>
      thenByAuthorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.desc);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterSortBy>
      thenByBody() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'body', Sort.asc);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterSortBy>
      thenByBodyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'body', Sort.desc);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterSortBy>
      thenByDocument() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'document', Sort.asc);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterSortBy>
      thenByDocumentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'document', Sort.desc);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterSortBy>
      thenByExcerpt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'excerpt', Sort.asc);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterSortBy>
      thenByExcerptDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'excerpt', Sort.desc);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterSortBy>
      thenByMalfuzatId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'malfuzatId', Sort.asc);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterSortBy>
      thenByMalfuzatIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'malfuzatId', Sort.desc);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterSortBy>
      thenByPublishedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publishedAt', Sort.asc);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterSortBy>
      thenByPublishedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publishedAt', Sort.desc);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterSortBy>
      thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QAfterSortBy>
      thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension DownloadedMalfuzatQueryWhereDistinct
    on QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QDistinct> {
  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QDistinct>
      distinctByAudio({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'audio', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QDistinct>
      distinctByAuthor({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'author', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QDistinct>
      distinctByBody({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'body', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QDistinct>
      distinctByDocument({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'document', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QDistinct>
      distinctByExcerpt({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'excerpt', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QDistinct>
      distinctByMalfuzatId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'malfuzatId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QDistinct>
      distinctByPublishedAt({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'publishedAt', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QDistinct>
      distinctByTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension DownloadedMalfuzatQueryProperty
    on QueryBuilder<DownloadedMalfuzat, DownloadedMalfuzat, QQueryProperty> {
  QueryBuilder<DownloadedMalfuzat, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DownloadedMalfuzat, String?, QQueryOperations> audioProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'audio');
    });
  }

  QueryBuilder<DownloadedMalfuzat, String?, QQueryOperations> authorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'author');
    });
  }

  QueryBuilder<DownloadedMalfuzat, String?, QQueryOperations> bodyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'body');
    });
  }

  QueryBuilder<DownloadedMalfuzat, DateTime?, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<DownloadedMalfuzat, String?, QQueryOperations>
      documentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'document');
    });
  }

  QueryBuilder<DownloadedMalfuzat, String?, QQueryOperations>
      excerptProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'excerpt');
    });
  }

  QueryBuilder<DownloadedMalfuzat, String?, QQueryOperations>
      malfuzatIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'malfuzatId');
    });
  }

  QueryBuilder<DownloadedMalfuzat, String?, QQueryOperations>
      publishedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'publishedAt');
    });
  }

  QueryBuilder<DownloadedMalfuzat, String?, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }
}
