// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'downloaded_bayan.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDownloadedBayanCollection on Isar {
  IsarCollection<DownloadedBayan> get downloadedBayans => this.collection();
}

const DownloadedBayanSchema = CollectionSchema(
  name: r'DownloadedBayan',
  id: 8432117747208889997,
  properties: {
    r'audioFile': PropertySchema(
      id: 0,
      name: r'audioFile',
      type: IsarType.string,
    ),
    r'bayanId': PropertySchema(
      id: 1,
      name: r'bayanId',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'link': PropertySchema(
      id: 3,
      name: r'link',
      type: IsarType.string,
    ),
    r'publishedAt': PropertySchema(
      id: 4,
      name: r'publishedAt',
      type: IsarType.string,
    ),
    r'speaker': PropertySchema(
      id: 5,
      name: r'speaker',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 6,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _downloadedBayanEstimateSize,
  serialize: _downloadedBayanSerialize,
  deserialize: _downloadedBayanDeserialize,
  deserializeProp: _downloadedBayanDeserializeProp,
  idName: r'id',
  indexes: {
    r'bayanId': IndexSchema(
      id: 5775596693195700395,
      name: r'bayanId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'bayanId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'link': IndexSchema(
      id: 1895339948848804316,
      name: r'link',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'link',
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
  getId: _downloadedBayanGetId,
  getLinks: _downloadedBayanGetLinks,
  attach: _downloadedBayanAttach,
  version: '3.1.0+1',
);

int _downloadedBayanEstimateSize(
  DownloadedBayan object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.audioFile;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.bayanId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.link;
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
    final value = object.speaker;
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

void _downloadedBayanSerialize(
  DownloadedBayan object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.audioFile);
  writer.writeString(offsets[1], object.bayanId);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeString(offsets[3], object.link);
  writer.writeString(offsets[4], object.publishedAt);
  writer.writeString(offsets[5], object.speaker);
  writer.writeString(offsets[6], object.title);
}

DownloadedBayan _downloadedBayanDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DownloadedBayan();
  object.audioFile = reader.readStringOrNull(offsets[0]);
  object.bayanId = reader.readStringOrNull(offsets[1]);
  object.createdAt = reader.readDateTimeOrNull(offsets[2]);
  object.id = id;
  object.link = reader.readStringOrNull(offsets[3]);
  object.publishedAt = reader.readStringOrNull(offsets[4]);
  object.speaker = reader.readStringOrNull(offsets[5]);
  object.title = reader.readStringOrNull(offsets[6]);
  return object;
}

P _downloadedBayanDeserializeProp<P>(
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
      return (reader.readDateTimeOrNull(offset)) as P;
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

Id _downloadedBayanGetId(DownloadedBayan object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _downloadedBayanGetLinks(DownloadedBayan object) {
  return [];
}

void _downloadedBayanAttach(
    IsarCollection<dynamic> col, Id id, DownloadedBayan object) {
  object.id = id;
}

extension DownloadedBayanByIndex on IsarCollection<DownloadedBayan> {
  Future<DownloadedBayan?> getByBayanId(String? bayanId) {
    return getByIndex(r'bayanId', [bayanId]);
  }

  DownloadedBayan? getByBayanIdSync(String? bayanId) {
    return getByIndexSync(r'bayanId', [bayanId]);
  }

  Future<bool> deleteByBayanId(String? bayanId) {
    return deleteByIndex(r'bayanId', [bayanId]);
  }

  bool deleteByBayanIdSync(String? bayanId) {
    return deleteByIndexSync(r'bayanId', [bayanId]);
  }

  Future<List<DownloadedBayan?>> getAllByBayanId(List<String?> bayanIdValues) {
    final values = bayanIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'bayanId', values);
  }

  List<DownloadedBayan?> getAllByBayanIdSync(List<String?> bayanIdValues) {
    final values = bayanIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'bayanId', values);
  }

  Future<int> deleteAllByBayanId(List<String?> bayanIdValues) {
    final values = bayanIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'bayanId', values);
  }

  int deleteAllByBayanIdSync(List<String?> bayanIdValues) {
    final values = bayanIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'bayanId', values);
  }

  Future<Id> putByBayanId(DownloadedBayan object) {
    return putByIndex(r'bayanId', object);
  }

  Id putByBayanIdSync(DownloadedBayan object, {bool saveLinks = true}) {
    return putByIndexSync(r'bayanId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByBayanId(List<DownloadedBayan> objects) {
    return putAllByIndex(r'bayanId', objects);
  }

  List<Id> putAllByBayanIdSync(List<DownloadedBayan> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'bayanId', objects, saveLinks: saveLinks);
  }

  Future<DownloadedBayan?> getByLink(String? link) {
    return getByIndex(r'link', [link]);
  }

  DownloadedBayan? getByLinkSync(String? link) {
    return getByIndexSync(r'link', [link]);
  }

  Future<bool> deleteByLink(String? link) {
    return deleteByIndex(r'link', [link]);
  }

  bool deleteByLinkSync(String? link) {
    return deleteByIndexSync(r'link', [link]);
  }

  Future<List<DownloadedBayan?>> getAllByLink(List<String?> linkValues) {
    final values = linkValues.map((e) => [e]).toList();
    return getAllByIndex(r'link', values);
  }

  List<DownloadedBayan?> getAllByLinkSync(List<String?> linkValues) {
    final values = linkValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'link', values);
  }

  Future<int> deleteAllByLink(List<String?> linkValues) {
    final values = linkValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'link', values);
  }

  int deleteAllByLinkSync(List<String?> linkValues) {
    final values = linkValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'link', values);
  }

  Future<Id> putByLink(DownloadedBayan object) {
    return putByIndex(r'link', object);
  }

  Id putByLinkSync(DownloadedBayan object, {bool saveLinks = true}) {
    return putByIndexSync(r'link', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByLink(List<DownloadedBayan> objects) {
    return putAllByIndex(r'link', objects);
  }

  List<Id> putAllByLinkSync(List<DownloadedBayan> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'link', objects, saveLinks: saveLinks);
  }
}

extension DownloadedBayanQueryWhereSort
    on QueryBuilder<DownloadedBayan, DownloadedBayan, QWhere> {
  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterWhere> anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }
}

extension DownloadedBayanQueryWhere
    on QueryBuilder<DownloadedBayan, DownloadedBayan, QWhereClause> {
  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterWhereClause>
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

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterWhereClause> idBetween(
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

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterWhereClause>
      bayanIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'bayanId',
        value: [null],
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterWhereClause>
      bayanIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'bayanId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterWhereClause>
      bayanIdEqualTo(String? bayanId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'bayanId',
        value: [bayanId],
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterWhereClause>
      bayanIdNotEqualTo(String? bayanId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bayanId',
              lower: [],
              upper: [bayanId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bayanId',
              lower: [bayanId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bayanId',
              lower: [bayanId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bayanId',
              lower: [],
              upper: [bayanId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterWhereClause>
      linkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'link',
        value: [null],
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterWhereClause>
      linkIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'link',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterWhereClause> linkEqualTo(
      String? link) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'link',
        value: [link],
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterWhereClause>
      linkNotEqualTo(String? link) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'link',
              lower: [],
              upper: [link],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'link',
              lower: [link],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'link',
              lower: [link],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'link',
              lower: [],
              upper: [link],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterWhereClause>
      createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [null],
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterWhereClause>
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

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterWhereClause>
      createdAtEqualTo(DateTime? createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [createdAt],
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterWhereClause>
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

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterWhereClause>
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

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterWhereClause>
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

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterWhereClause>
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

extension DownloadedBayanQueryFilter
    on QueryBuilder<DownloadedBayan, DownloadedBayan, QFilterCondition> {
  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      audioFileIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'audioFile',
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      audioFileIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'audioFile',
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      audioFileEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'audioFile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      audioFileGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'audioFile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      audioFileLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'audioFile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      audioFileBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'audioFile',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      audioFileStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'audioFile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      audioFileEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'audioFile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      audioFileContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'audioFile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      audioFileMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'audioFile',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      audioFileIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'audioFile',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      audioFileIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'audioFile',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      bayanIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bayanId',
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      bayanIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'bayanId',
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      bayanIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bayanId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      bayanIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bayanId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      bayanIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bayanId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      bayanIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bayanId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      bayanIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bayanId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      bayanIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bayanId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      bayanIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bayanId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      bayanIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bayanId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      bayanIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bayanId',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      bayanIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bayanId',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      linkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'link',
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      linkIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'link',
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      linkEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'link',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      linkGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'link',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      linkLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'link',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      linkBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'link',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      linkStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'link',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      linkEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'link',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      linkContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'link',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      linkMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'link',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      linkIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'link',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      linkIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'link',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      publishedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'publishedAt',
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      publishedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'publishedAt',
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      publishedAtContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'publishedAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      publishedAtMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'publishedAt',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      publishedAtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'publishedAt',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      publishedAtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'publishedAt',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      speakerIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'speaker',
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      speakerIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'speaker',
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      speakerEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'speaker',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      speakerGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'speaker',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      speakerLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'speaker',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      speakerBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'speaker',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      speakerStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'speaker',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      speakerEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'speaker',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      speakerContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'speaker',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      speakerMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'speaker',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      speakerIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'speaker',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      speakerIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'speaker',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      titleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      titleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension DownloadedBayanQueryObject
    on QueryBuilder<DownloadedBayan, DownloadedBayan, QFilterCondition> {}

extension DownloadedBayanQueryLinks
    on QueryBuilder<DownloadedBayan, DownloadedBayan, QFilterCondition> {}

extension DownloadedBayanQuerySortBy
    on QueryBuilder<DownloadedBayan, DownloadedBayan, QSortBy> {
  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterSortBy>
      sortByAudioFile() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioFile', Sort.asc);
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterSortBy>
      sortByAudioFileDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioFile', Sort.desc);
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterSortBy> sortByBayanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bayanId', Sort.asc);
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterSortBy>
      sortByBayanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bayanId', Sort.desc);
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterSortBy> sortByLink() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'link', Sort.asc);
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterSortBy>
      sortByLinkDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'link', Sort.desc);
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterSortBy>
      sortByPublishedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publishedAt', Sort.asc);
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterSortBy>
      sortByPublishedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publishedAt', Sort.desc);
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterSortBy> sortBySpeaker() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speaker', Sort.asc);
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterSortBy>
      sortBySpeakerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speaker', Sort.desc);
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterSortBy>
      sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension DownloadedBayanQuerySortThenBy
    on QueryBuilder<DownloadedBayan, DownloadedBayan, QSortThenBy> {
  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterSortBy>
      thenByAudioFile() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioFile', Sort.asc);
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterSortBy>
      thenByAudioFileDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioFile', Sort.desc);
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterSortBy> thenByBayanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bayanId', Sort.asc);
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterSortBy>
      thenByBayanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bayanId', Sort.desc);
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterSortBy> thenByLink() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'link', Sort.asc);
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterSortBy>
      thenByLinkDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'link', Sort.desc);
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterSortBy>
      thenByPublishedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publishedAt', Sort.asc);
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterSortBy>
      thenByPublishedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publishedAt', Sort.desc);
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterSortBy> thenBySpeaker() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speaker', Sort.asc);
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterSortBy>
      thenBySpeakerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speaker', Sort.desc);
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QAfterSortBy>
      thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension DownloadedBayanQueryWhereDistinct
    on QueryBuilder<DownloadedBayan, DownloadedBayan, QDistinct> {
  QueryBuilder<DownloadedBayan, DownloadedBayan, QDistinct> distinctByAudioFile(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'audioFile', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QDistinct> distinctByBayanId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bayanId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QDistinct> distinctByLink(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'link', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QDistinct>
      distinctByPublishedAt({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'publishedAt', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QDistinct> distinctBySpeaker(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'speaker', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedBayan, DownloadedBayan, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension DownloadedBayanQueryProperty
    on QueryBuilder<DownloadedBayan, DownloadedBayan, QQueryProperty> {
  QueryBuilder<DownloadedBayan, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DownloadedBayan, String?, QQueryOperations> audioFileProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'audioFile');
    });
  }

  QueryBuilder<DownloadedBayan, String?, QQueryOperations> bayanIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bayanId');
    });
  }

  QueryBuilder<DownloadedBayan, DateTime?, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<DownloadedBayan, String?, QQueryOperations> linkProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'link');
    });
  }

  QueryBuilder<DownloadedBayan, String?, QQueryOperations>
      publishedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'publishedAt');
    });
  }

  QueryBuilder<DownloadedBayan, String?, QQueryOperations> speakerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'speaker');
    });
  }

  QueryBuilder<DownloadedBayan, String?, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }
}
