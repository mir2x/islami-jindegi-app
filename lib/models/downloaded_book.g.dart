// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'downloaded_book.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDownloadedBookCollection on Isar {
  IsarCollection<DownloadedBook> get downloadedBooks => this.collection();
}

const DownloadedBookSchema = CollectionSchema(
  name: r'DownloadedBook',
  id: -5105974177019457657,
  properties: {
    r'author': PropertySchema(
      id: 0,
      name: r'author',
      type: IsarType.string,
    ),
    r'bookId': PropertySchema(
      id: 1,
      name: r'bookId',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'documentFile': PropertySchema(
      id: 3,
      name: r'documentFile',
      type: IsarType.string,
    ),
    r'link': PropertySchema(
      id: 4,
      name: r'link',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 5,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _downloadedBookEstimateSize,
  serialize: _downloadedBookSerialize,
  deserialize: _downloadedBookDeserialize,
  deserializeProp: _downloadedBookDeserializeProp,
  idName: r'id',
  indexes: {
    r'bookId': IndexSchema(
      id: 3567540928881766442,
      name: r'bookId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'bookId',
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
  getId: _downloadedBookGetId,
  getLinks: _downloadedBookGetLinks,
  attach: _downloadedBookAttach,
  version: '3.1.0+1',
);

int _downloadedBookEstimateSize(
  DownloadedBook object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.author;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.bookId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.documentFile;
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
    final value = object.title;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _downloadedBookSerialize(
  DownloadedBook object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.author);
  writer.writeString(offsets[1], object.bookId);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeString(offsets[3], object.documentFile);
  writer.writeString(offsets[4], object.link);
  writer.writeString(offsets[5], object.title);
}

DownloadedBook _downloadedBookDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DownloadedBook();
  object.author = reader.readStringOrNull(offsets[0]);
  object.bookId = reader.readStringOrNull(offsets[1]);
  object.createdAt = reader.readDateTimeOrNull(offsets[2]);
  object.documentFile = reader.readStringOrNull(offsets[3]);
  object.id = id;
  object.link = reader.readStringOrNull(offsets[4]);
  object.title = reader.readStringOrNull(offsets[5]);
  return object;
}

P _downloadedBookDeserializeProp<P>(
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
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _downloadedBookGetId(DownloadedBook object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _downloadedBookGetLinks(DownloadedBook object) {
  return [];
}

void _downloadedBookAttach(
    IsarCollection<dynamic> col, Id id, DownloadedBook object) {
  object.id = id;
}

extension DownloadedBookByIndex on IsarCollection<DownloadedBook> {
  Future<DownloadedBook?> getByBookId(String? bookId) {
    return getByIndex(r'bookId', [bookId]);
  }

  DownloadedBook? getByBookIdSync(String? bookId) {
    return getByIndexSync(r'bookId', [bookId]);
  }

  Future<bool> deleteByBookId(String? bookId) {
    return deleteByIndex(r'bookId', [bookId]);
  }

  bool deleteByBookIdSync(String? bookId) {
    return deleteByIndexSync(r'bookId', [bookId]);
  }

  Future<List<DownloadedBook?>> getAllByBookId(List<String?> bookIdValues) {
    final values = bookIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'bookId', values);
  }

  List<DownloadedBook?> getAllByBookIdSync(List<String?> bookIdValues) {
    final values = bookIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'bookId', values);
  }

  Future<int> deleteAllByBookId(List<String?> bookIdValues) {
    final values = bookIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'bookId', values);
  }

  int deleteAllByBookIdSync(List<String?> bookIdValues) {
    final values = bookIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'bookId', values);
  }

  Future<Id> putByBookId(DownloadedBook object) {
    return putByIndex(r'bookId', object);
  }

  Id putByBookIdSync(DownloadedBook object, {bool saveLinks = true}) {
    return putByIndexSync(r'bookId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByBookId(List<DownloadedBook> objects) {
    return putAllByIndex(r'bookId', objects);
  }

  List<Id> putAllByBookIdSync(List<DownloadedBook> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'bookId', objects, saveLinks: saveLinks);
  }

  Future<DownloadedBook?> getByLink(String? link) {
    return getByIndex(r'link', [link]);
  }

  DownloadedBook? getByLinkSync(String? link) {
    return getByIndexSync(r'link', [link]);
  }

  Future<bool> deleteByLink(String? link) {
    return deleteByIndex(r'link', [link]);
  }

  bool deleteByLinkSync(String? link) {
    return deleteByIndexSync(r'link', [link]);
  }

  Future<List<DownloadedBook?>> getAllByLink(List<String?> linkValues) {
    final values = linkValues.map((e) => [e]).toList();
    return getAllByIndex(r'link', values);
  }

  List<DownloadedBook?> getAllByLinkSync(List<String?> linkValues) {
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

  Future<Id> putByLink(DownloadedBook object) {
    return putByIndex(r'link', object);
  }

  Id putByLinkSync(DownloadedBook object, {bool saveLinks = true}) {
    return putByIndexSync(r'link', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByLink(List<DownloadedBook> objects) {
    return putAllByIndex(r'link', objects);
  }

  List<Id> putAllByLinkSync(List<DownloadedBook> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'link', objects, saveLinks: saveLinks);
  }
}

extension DownloadedBookQueryWhereSort
    on QueryBuilder<DownloadedBook, DownloadedBook, QWhere> {
  QueryBuilder<DownloadedBook, DownloadedBook, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterWhere> anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }
}

extension DownloadedBookQueryWhere
    on QueryBuilder<DownloadedBook, DownloadedBook, QWhereClause> {
  QueryBuilder<DownloadedBook, DownloadedBook, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterWhereClause> idBetween(
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

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterWhereClause>
      bookIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'bookId',
        value: [null],
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterWhereClause>
      bookIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'bookId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterWhereClause> bookIdEqualTo(
      String? bookId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'bookId',
        value: [bookId],
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterWhereClause>
      bookIdNotEqualTo(String? bookId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookId',
              lower: [],
              upper: [bookId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookId',
              lower: [bookId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookId',
              lower: [bookId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookId',
              lower: [],
              upper: [bookId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterWhereClause> linkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'link',
        value: [null],
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterWhereClause>
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

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterWhereClause> linkEqualTo(
      String? link) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'link',
        value: [link],
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterWhereClause>
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

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterWhereClause>
      createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [null],
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterWhereClause>
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

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterWhereClause>
      createdAtEqualTo(DateTime? createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [createdAt],
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterWhereClause>
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

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterWhereClause>
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

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterWhereClause>
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

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterWhereClause>
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

extension DownloadedBookQueryFilter
    on QueryBuilder<DownloadedBook, DownloadedBook, QFilterCondition> {
  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      authorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'author',
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      authorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'author',
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      authorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      authorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'author',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      authorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'author',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      authorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'author',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      bookIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bookId',
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      bookIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'bookId',
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      bookIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bookId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      bookIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bookId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      bookIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bookId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      bookIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bookId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      bookIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bookId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      bookIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bookId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      bookIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bookId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      bookIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bookId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      bookIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bookId',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      bookIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bookId',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      documentFileIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'documentFile',
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      documentFileIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'documentFile',
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      documentFileEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'documentFile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      documentFileGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'documentFile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      documentFileLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'documentFile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      documentFileBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'documentFile',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      documentFileStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'documentFile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      documentFileEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'documentFile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      documentFileContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'documentFile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      documentFileMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'documentFile',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      documentFileIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'documentFile',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      documentFileIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'documentFile',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition> idBetween(
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

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      linkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'link',
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      linkIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'link',
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      linkContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'link',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      linkMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'link',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      linkIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'link',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      linkIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'link',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      titleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      titleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
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

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension DownloadedBookQueryObject
    on QueryBuilder<DownloadedBook, DownloadedBook, QFilterCondition> {}

extension DownloadedBookQueryLinks
    on QueryBuilder<DownloadedBook, DownloadedBook, QFilterCondition> {}

extension DownloadedBookQuerySortBy
    on QueryBuilder<DownloadedBook, DownloadedBook, QSortBy> {
  QueryBuilder<DownloadedBook, DownloadedBook, QAfterSortBy> sortByAuthor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.asc);
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterSortBy>
      sortByAuthorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.desc);
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterSortBy> sortByBookId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookId', Sort.asc);
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterSortBy>
      sortByBookIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookId', Sort.desc);
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterSortBy>
      sortByDocumentFile() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'documentFile', Sort.asc);
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterSortBy>
      sortByDocumentFileDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'documentFile', Sort.desc);
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterSortBy> sortByLink() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'link', Sort.asc);
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterSortBy> sortByLinkDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'link', Sort.desc);
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension DownloadedBookQuerySortThenBy
    on QueryBuilder<DownloadedBook, DownloadedBook, QSortThenBy> {
  QueryBuilder<DownloadedBook, DownloadedBook, QAfterSortBy> thenByAuthor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.asc);
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterSortBy>
      thenByAuthorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.desc);
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterSortBy> thenByBookId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookId', Sort.asc);
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterSortBy>
      thenByBookIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookId', Sort.desc);
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterSortBy>
      thenByDocumentFile() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'documentFile', Sort.asc);
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterSortBy>
      thenByDocumentFileDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'documentFile', Sort.desc);
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterSortBy> thenByLink() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'link', Sort.asc);
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterSortBy> thenByLinkDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'link', Sort.desc);
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension DownloadedBookQueryWhereDistinct
    on QueryBuilder<DownloadedBook, DownloadedBook, QDistinct> {
  QueryBuilder<DownloadedBook, DownloadedBook, QDistinct> distinctByAuthor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'author', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QDistinct> distinctByBookId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bookId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QDistinct>
      distinctByDocumentFile({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'documentFile', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QDistinct> distinctByLink(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'link', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedBook, DownloadedBook, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension DownloadedBookQueryProperty
    on QueryBuilder<DownloadedBook, DownloadedBook, QQueryProperty> {
  QueryBuilder<DownloadedBook, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DownloadedBook, String?, QQueryOperations> authorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'author');
    });
  }

  QueryBuilder<DownloadedBook, String?, QQueryOperations> bookIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bookId');
    });
  }

  QueryBuilder<DownloadedBook, DateTime?, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<DownloadedBook, String?, QQueryOperations>
      documentFileProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'documentFile');
    });
  }

  QueryBuilder<DownloadedBook, String?, QQueryOperations> linkProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'link');
    });
  }

  QueryBuilder<DownloadedBook, String?, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }
}
