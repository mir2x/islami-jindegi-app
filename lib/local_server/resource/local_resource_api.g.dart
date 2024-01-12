// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_resource_api.dart';

// ignore_for_file: type=lint
class $SurahsTable extends Surahs with TableInfo<$SurahsTable, Surah> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SurahsTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> titleBn = GeneratedColumn<String>(
      'title_bn', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
      'slug', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> introduction = GeneratedColumn<String>(
      'introduction', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> excerpt = GeneratedColumn<String>(
      'excerpt', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<int> totalAyat = GeneratedColumn<int>(
      'total_ayat', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<int> totalRuku = GeneratedColumn<int>(
      'total_ruku', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
      'location', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        titleBn,
        slug,
        introduction,
        excerpt,
        totalAyat,
        totalRuku,
        location,
        position,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? 'surahs';
  @override
  String get actualTableName => 'surahs';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Surah map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Surah(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      titleBn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title_bn'])!,
      slug: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}slug'])!,
      introduction: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}introduction']),
      excerpt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}excerpt']),
      totalAyat: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_ayat'])!,
      totalRuku: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_ruku'])!,
      location: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location']),
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SurahsTable createAlias(String alias) {
    return $SurahsTable(attachedDatabase, alias);
  }
}

class Surah extends DataClass implements Insertable<Surah> {
  final String id;
  final String title;
  final String titleBn;
  final String slug;
  final String? introduction;
  final String? excerpt;
  final int totalAyat;
  final int totalRuku;
  final String? location;
  final int position;
  final String createdAt;
  final String updatedAt;
  const Surah(
      {required this.id,
      required this.title,
      required this.titleBn,
      required this.slug,
      this.introduction,
      this.excerpt,
      required this.totalAyat,
      required this.totalRuku,
      this.location,
      required this.position,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['title_bn'] = Variable<String>(titleBn);
    map['slug'] = Variable<String>(slug);
    if (!nullToAbsent || introduction != null) {
      map['introduction'] = Variable<String>(introduction);
    }
    if (!nullToAbsent || excerpt != null) {
      map['excerpt'] = Variable<String>(excerpt);
    }
    map['total_ayat'] = Variable<int>(totalAyat);
    map['total_ruku'] = Variable<int>(totalRuku);
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    map['position'] = Variable<int>(position);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  factory Surah.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Surah(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      titleBn: serializer.fromJson<String>(json['titleBn']),
      slug: serializer.fromJson<String>(json['slug']),
      introduction: serializer.fromJson<String?>(json['introduction']),
      excerpt: serializer.fromJson<String?>(json['excerpt']),
      totalAyat: serializer.fromJson<int>(json['totalAyat']),
      totalRuku: serializer.fromJson<int>(json['totalRuku']),
      location: serializer.fromJson<String?>(json['location']),
      position: serializer.fromJson<int>(json['position']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'titleBn': serializer.toJson<String>(titleBn),
      'slug': serializer.toJson<String>(slug),
      'introduction': serializer.toJson<String?>(introduction),
      'excerpt': serializer.toJson<String?>(excerpt),
      'totalAyat': serializer.toJson<int>(totalAyat),
      'totalRuku': serializer.toJson<int>(totalRuku),
      'location': serializer.toJson<String?>(location),
      'position': serializer.toJson<int>(position),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  Surah copyWith(
          {String? id,
          String? title,
          String? titleBn,
          String? slug,
          Value<String?> introduction = const Value.absent(),
          Value<String?> excerpt = const Value.absent(),
          int? totalAyat,
          int? totalRuku,
          Value<String?> location = const Value.absent(),
          int? position,
          String? createdAt,
          String? updatedAt}) =>
      Surah(
        id: id ?? this.id,
        title: title ?? this.title,
        titleBn: titleBn ?? this.titleBn,
        slug: slug ?? this.slug,
        introduction:
            introduction.present ? introduction.value : this.introduction,
        excerpt: excerpt.present ? excerpt.value : this.excerpt,
        totalAyat: totalAyat ?? this.totalAyat,
        totalRuku: totalRuku ?? this.totalRuku,
        location: location.present ? location.value : this.location,
        position: position ?? this.position,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('Surah(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('titleBn: $titleBn, ')
          ..write('slug: $slug, ')
          ..write('introduction: $introduction, ')
          ..write('excerpt: $excerpt, ')
          ..write('totalAyat: $totalAyat, ')
          ..write('totalRuku: $totalRuku, ')
          ..write('location: $location, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, titleBn, slug, introduction,
      excerpt, totalAyat, totalRuku, location, position, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Surah &&
          other.id == this.id &&
          other.title == this.title &&
          other.titleBn == this.titleBn &&
          other.slug == this.slug &&
          other.introduction == this.introduction &&
          other.excerpt == this.excerpt &&
          other.totalAyat == this.totalAyat &&
          other.totalRuku == this.totalRuku &&
          other.location == this.location &&
          other.position == this.position &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SurahsCompanion extends UpdateCompanion<Surah> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> titleBn;
  final Value<String> slug;
  final Value<String?> introduction;
  final Value<String?> excerpt;
  final Value<int> totalAyat;
  final Value<int> totalRuku;
  final Value<String?> location;
  final Value<int> position;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const SurahsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.titleBn = const Value.absent(),
    this.slug = const Value.absent(),
    this.introduction = const Value.absent(),
    this.excerpt = const Value.absent(),
    this.totalAyat = const Value.absent(),
    this.totalRuku = const Value.absent(),
    this.location = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SurahsCompanion.insert({
    required String id,
    required String title,
    required String titleBn,
    required String slug,
    this.introduction = const Value.absent(),
    this.excerpt = const Value.absent(),
    required int totalAyat,
    required int totalRuku,
    this.location = const Value.absent(),
    required int position,
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        titleBn = Value(titleBn),
        slug = Value(slug),
        totalAyat = Value(totalAyat),
        totalRuku = Value(totalRuku),
        position = Value(position),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Surah> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? titleBn,
    Expression<String>? slug,
    Expression<String>? introduction,
    Expression<String>? excerpt,
    Expression<int>? totalAyat,
    Expression<int>? totalRuku,
    Expression<String>? location,
    Expression<int>? position,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (titleBn != null) 'title_bn': titleBn,
      if (slug != null) 'slug': slug,
      if (introduction != null) 'introduction': introduction,
      if (excerpt != null) 'excerpt': excerpt,
      if (totalAyat != null) 'total_ayat': totalAyat,
      if (totalRuku != null) 'total_ruku': totalRuku,
      if (location != null) 'location': location,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SurahsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? titleBn,
      Value<String>? slug,
      Value<String?>? introduction,
      Value<String?>? excerpt,
      Value<int>? totalAyat,
      Value<int>? totalRuku,
      Value<String?>? location,
      Value<int>? position,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<int>? rowid}) {
    return SurahsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      titleBn: titleBn ?? this.titleBn,
      slug: slug ?? this.slug,
      introduction: introduction ?? this.introduction,
      excerpt: excerpt ?? this.excerpt,
      totalAyat: totalAyat ?? this.totalAyat,
      totalRuku: totalRuku ?? this.totalRuku,
      location: location ?? this.location,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (titleBn.present) {
      map['title_bn'] = Variable<String>(titleBn.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (introduction.present) {
      map['introduction'] = Variable<String>(introduction.value);
    }
    if (excerpt.present) {
      map['excerpt'] = Variable<String>(excerpt.value);
    }
    if (totalAyat.present) {
      map['total_ayat'] = Variable<int>(totalAyat.value);
    }
    if (totalRuku.present) {
      map['total_ruku'] = Variable<int>(totalRuku.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SurahsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('titleBn: $titleBn, ')
          ..write('slug: $slug, ')
          ..write('introduction: $introduction, ')
          ..write('excerpt: $excerpt, ')
          ..write('totalAyat: $totalAyat, ')
          ..write('totalRuku: $totalRuku, ')
          ..write('location: $location, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ParasTable extends Paras with TableInfo<$ParasTable, Para> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ParasTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> titleBn = GeneratedColumn<String>(
      'title_bn', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
      'slug', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<int> totalAyat = GeneratedColumn<int>(
      'total_ayat', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<int> totalRuku = GeneratedColumn<int>(
      'total_ruku', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        titleBn,
        slug,
        totalAyat,
        totalRuku,
        position,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? 'paras';
  @override
  String get actualTableName => 'paras';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Para map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Para(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      titleBn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title_bn'])!,
      slug: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}slug'])!,
      totalAyat: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_ayat'])!,
      totalRuku: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_ruku'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ParasTable createAlias(String alias) {
    return $ParasTable(attachedDatabase, alias);
  }
}

class Para extends DataClass implements Insertable<Para> {
  final String id;
  final String title;
  final String titleBn;
  final String slug;
  final int totalAyat;
  final int totalRuku;
  final int position;
  final String createdAt;
  final String updatedAt;
  const Para(
      {required this.id,
      required this.title,
      required this.titleBn,
      required this.slug,
      required this.totalAyat,
      required this.totalRuku,
      required this.position,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['title_bn'] = Variable<String>(titleBn);
    map['slug'] = Variable<String>(slug);
    map['total_ayat'] = Variable<int>(totalAyat);
    map['total_ruku'] = Variable<int>(totalRuku);
    map['position'] = Variable<int>(position);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  factory Para.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Para(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      titleBn: serializer.fromJson<String>(json['titleBn']),
      slug: serializer.fromJson<String>(json['slug']),
      totalAyat: serializer.fromJson<int>(json['totalAyat']),
      totalRuku: serializer.fromJson<int>(json['totalRuku']),
      position: serializer.fromJson<int>(json['position']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'titleBn': serializer.toJson<String>(titleBn),
      'slug': serializer.toJson<String>(slug),
      'totalAyat': serializer.toJson<int>(totalAyat),
      'totalRuku': serializer.toJson<int>(totalRuku),
      'position': serializer.toJson<int>(position),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  Para copyWith(
          {String? id,
          String? title,
          String? titleBn,
          String? slug,
          int? totalAyat,
          int? totalRuku,
          int? position,
          String? createdAt,
          String? updatedAt}) =>
      Para(
        id: id ?? this.id,
        title: title ?? this.title,
        titleBn: titleBn ?? this.titleBn,
        slug: slug ?? this.slug,
        totalAyat: totalAyat ?? this.totalAyat,
        totalRuku: totalRuku ?? this.totalRuku,
        position: position ?? this.position,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('Para(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('titleBn: $titleBn, ')
          ..write('slug: $slug, ')
          ..write('totalAyat: $totalAyat, ')
          ..write('totalRuku: $totalRuku, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, titleBn, slug, totalAyat,
      totalRuku, position, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Para &&
          other.id == this.id &&
          other.title == this.title &&
          other.titleBn == this.titleBn &&
          other.slug == this.slug &&
          other.totalAyat == this.totalAyat &&
          other.totalRuku == this.totalRuku &&
          other.position == this.position &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ParasCompanion extends UpdateCompanion<Para> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> titleBn;
  final Value<String> slug;
  final Value<int> totalAyat;
  final Value<int> totalRuku;
  final Value<int> position;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const ParasCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.titleBn = const Value.absent(),
    this.slug = const Value.absent(),
    this.totalAyat = const Value.absent(),
    this.totalRuku = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ParasCompanion.insert({
    required String id,
    required String title,
    required String titleBn,
    required String slug,
    required int totalAyat,
    required int totalRuku,
    required int position,
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        titleBn = Value(titleBn),
        slug = Value(slug),
        totalAyat = Value(totalAyat),
        totalRuku = Value(totalRuku),
        position = Value(position),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Para> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? titleBn,
    Expression<String>? slug,
    Expression<int>? totalAyat,
    Expression<int>? totalRuku,
    Expression<int>? position,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (titleBn != null) 'title_bn': titleBn,
      if (slug != null) 'slug': slug,
      if (totalAyat != null) 'total_ayat': totalAyat,
      if (totalRuku != null) 'total_ruku': totalRuku,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ParasCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? titleBn,
      Value<String>? slug,
      Value<int>? totalAyat,
      Value<int>? totalRuku,
      Value<int>? position,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<int>? rowid}) {
    return ParasCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      titleBn: titleBn ?? this.titleBn,
      slug: slug ?? this.slug,
      totalAyat: totalAyat ?? this.totalAyat,
      totalRuku: totalRuku ?? this.totalRuku,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (titleBn.present) {
      map['title_bn'] = Variable<String>(titleBn.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (totalAyat.present) {
      map['total_ayat'] = Variable<int>(totalAyat.value);
    }
    if (totalRuku.present) {
      map['total_ruku'] = Variable<int>(totalRuku.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ParasCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('titleBn: $titleBn, ')
          ..write('slug: $slug, ')
          ..write('totalAyat: $totalAyat, ')
          ..write('totalRuku: $totalRuku, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AyahsTable extends Ayahs with TableInfo<$AyahsTable, Ayah> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AyahsTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<int> surahPosition = GeneratedColumn<int>(
      'surah_position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<int> paraPosition = GeneratedColumn<int>(
      'para_position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<int> ruku = GeneratedColumn<int>(
      'ruku', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> surahId = GeneratedColumn<String>(
      'surah_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES surahs (id)'));
  @override
  late final GeneratedColumn<String> paraId = GeneratedColumn<String>(
      'para_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES paras (id)'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        surahPosition,
        paraPosition,
        ruku,
        createdAt,
        updatedAt,
        surahId,
        paraId
      ];
  @override
  String get aliasedName => _alias ?? 'ayahs';
  @override
  String get actualTableName => 'ayahs';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Ayah map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ayah(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      surahPosition: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}surah_position'])!,
      paraPosition: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}para_position'])!,
      ruku: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ruku']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
      surahId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}surah_id'])!,
      paraId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}para_id'])!,
    );
  }

  @override
  $AyahsTable createAlias(String alias) {
    return $AyahsTable(attachedDatabase, alias);
  }
}

class Ayah extends DataClass implements Insertable<Ayah> {
  final String id;
  final String title;
  final int surahPosition;
  final int paraPosition;
  final int? ruku;
  final String createdAt;
  final String updatedAt;
  final String surahId;
  final String paraId;
  const Ayah(
      {required this.id,
      required this.title,
      required this.surahPosition,
      required this.paraPosition,
      this.ruku,
      required this.createdAt,
      required this.updatedAt,
      required this.surahId,
      required this.paraId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['surah_position'] = Variable<int>(surahPosition);
    map['para_position'] = Variable<int>(paraPosition);
    if (!nullToAbsent || ruku != null) {
      map['ruku'] = Variable<int>(ruku);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    map['surah_id'] = Variable<String>(surahId);
    map['para_id'] = Variable<String>(paraId);
    return map;
  }

  factory Ayah.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ayah(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      surahPosition: serializer.fromJson<int>(json['surahPosition']),
      paraPosition: serializer.fromJson<int>(json['paraPosition']),
      ruku: serializer.fromJson<int?>(json['ruku']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      surahId: serializer.fromJson<String>(json['surahId']),
      paraId: serializer.fromJson<String>(json['paraId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'surahPosition': serializer.toJson<int>(surahPosition),
      'paraPosition': serializer.toJson<int>(paraPosition),
      'ruku': serializer.toJson<int?>(ruku),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'surahId': serializer.toJson<String>(surahId),
      'paraId': serializer.toJson<String>(paraId),
    };
  }

  Ayah copyWith(
          {String? id,
          String? title,
          int? surahPosition,
          int? paraPosition,
          Value<int?> ruku = const Value.absent(),
          String? createdAt,
          String? updatedAt,
          String? surahId,
          String? paraId}) =>
      Ayah(
        id: id ?? this.id,
        title: title ?? this.title,
        surahPosition: surahPosition ?? this.surahPosition,
        paraPosition: paraPosition ?? this.paraPosition,
        ruku: ruku.present ? ruku.value : this.ruku,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        surahId: surahId ?? this.surahId,
        paraId: paraId ?? this.paraId,
      );
  @override
  String toString() {
    return (StringBuffer('Ayah(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('surahPosition: $surahPosition, ')
          ..write('paraPosition: $paraPosition, ')
          ..write('ruku: $ruku, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('surahId: $surahId, ')
          ..write('paraId: $paraId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, surahPosition, paraPosition, ruku,
      createdAt, updatedAt, surahId, paraId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ayah &&
          other.id == this.id &&
          other.title == this.title &&
          other.surahPosition == this.surahPosition &&
          other.paraPosition == this.paraPosition &&
          other.ruku == this.ruku &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.surahId == this.surahId &&
          other.paraId == this.paraId);
}

class AyahsCompanion extends UpdateCompanion<Ayah> {
  final Value<String> id;
  final Value<String> title;
  final Value<int> surahPosition;
  final Value<int> paraPosition;
  final Value<int?> ruku;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String> surahId;
  final Value<String> paraId;
  final Value<int> rowid;
  const AyahsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.surahPosition = const Value.absent(),
    this.paraPosition = const Value.absent(),
    this.ruku = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.surahId = const Value.absent(),
    this.paraId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AyahsCompanion.insert({
    required String id,
    required String title,
    required int surahPosition,
    required int paraPosition,
    this.ruku = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    required String surahId,
    required String paraId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        surahPosition = Value(surahPosition),
        paraPosition = Value(paraPosition),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        surahId = Value(surahId),
        paraId = Value(paraId);
  static Insertable<Ayah> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<int>? surahPosition,
    Expression<int>? paraPosition,
    Expression<int>? ruku,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? surahId,
    Expression<String>? paraId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (surahPosition != null) 'surah_position': surahPosition,
      if (paraPosition != null) 'para_position': paraPosition,
      if (ruku != null) 'ruku': ruku,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (surahId != null) 'surah_id': surahId,
      if (paraId != null) 'para_id': paraId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AyahsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<int>? surahPosition,
      Value<int>? paraPosition,
      Value<int?>? ruku,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<String>? surahId,
      Value<String>? paraId,
      Value<int>? rowid}) {
    return AyahsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      surahPosition: surahPosition ?? this.surahPosition,
      paraPosition: paraPosition ?? this.paraPosition,
      ruku: ruku ?? this.ruku,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      surahId: surahId ?? this.surahId,
      paraId: paraId ?? this.paraId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (surahPosition.present) {
      map['surah_position'] = Variable<int>(surahPosition.value);
    }
    if (paraPosition.present) {
      map['para_position'] = Variable<int>(paraPosition.value);
    }
    if (ruku.present) {
      map['ruku'] = Variable<int>(ruku.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (surahId.present) {
      map['surah_id'] = Variable<String>(surahId.value);
    }
    if (paraId.present) {
      map['para_id'] = Variable<String>(paraId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AyahsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('surahPosition: $surahPosition, ')
          ..write('paraPosition: $paraPosition, ')
          ..write('ruku: $ruku, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('surahId: $surahId, ')
          ..write('paraId: $paraId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AyahTranslationsTable extends AyahTranslations
    with TableInfo<$AyahTranslationsTable, AyahTranslation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AyahTranslationsTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> ayahId = GeneratedColumn<String>(
      'ayah_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES ayahs (id)'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, body, createdAt, updatedAt, ayahId];
  @override
  String get aliasedName => _alias ?? 'ayah_translations';
  @override
  String get actualTableName => 'ayah_translations';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AyahTranslation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AyahTranslation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
      ayahId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ayah_id'])!,
    );
  }

  @override
  $AyahTranslationsTable createAlias(String alias) {
    return $AyahTranslationsTable(attachedDatabase, alias);
  }
}

class AyahTranslation extends DataClass implements Insertable<AyahTranslation> {
  final String id;
  final String title;
  final String body;
  final String createdAt;
  final String updatedAt;
  final String ayahId;
  const AyahTranslation(
      {required this.id,
      required this.title,
      required this.body,
      required this.createdAt,
      required this.updatedAt,
      required this.ayahId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    map['ayah_id'] = Variable<String>(ayahId);
    return map;
  }

  factory AyahTranslation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AyahTranslation(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      ayahId: serializer.fromJson<String>(json['ayahId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'ayahId': serializer.toJson<String>(ayahId),
    };
  }

  AyahTranslation copyWith(
          {String? id,
          String? title,
          String? body,
          String? createdAt,
          String? updatedAt,
          String? ayahId}) =>
      AyahTranslation(
        id: id ?? this.id,
        title: title ?? this.title,
        body: body ?? this.body,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        ayahId: ayahId ?? this.ayahId,
      );
  @override
  String toString() {
    return (StringBuffer('AyahTranslation(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('ayahId: $ayahId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, body, createdAt, updatedAt, ayahId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AyahTranslation &&
          other.id == this.id &&
          other.title == this.title &&
          other.body == this.body &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.ayahId == this.ayahId);
}

class AyahTranslationsCompanion extends UpdateCompanion<AyahTranslation> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> body;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String> ayahId;
  final Value<int> rowid;
  const AyahTranslationsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.ayahId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AyahTranslationsCompanion.insert({
    required String id,
    required String title,
    required String body,
    required String createdAt,
    required String updatedAt,
    required String ayahId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        body = Value(body),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        ayahId = Value(ayahId);
  static Insertable<AyahTranslation> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? ayahId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (ayahId != null) 'ayah_id': ayahId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AyahTranslationsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? body,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<String>? ayahId,
      Value<int>? rowid}) {
    return AyahTranslationsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      ayahId: ayahId ?? this.ayahId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (ayahId.present) {
      map['ayah_id'] = Variable<String>(ayahId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AyahTranslationsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('ayahId: $ayahId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QarisTable extends Qaris with TableInfo<$QarisTable, Qari> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QarisTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> nameBn = GeneratedColumn<String>(
      'name_bn', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
      'slug', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, nameBn, slug, position, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? 'qaris';
  @override
  String get actualTableName => 'qaris';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Qari map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Qari(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      nameBn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_bn']),
      slug: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}slug'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $QarisTable createAlias(String alias) {
    return $QarisTable(attachedDatabase, alias);
  }
}

class Qari extends DataClass implements Insertable<Qari> {
  final String id;
  final String name;
  final String? nameBn;
  final String slug;
  final int position;
  final String createdAt;
  final String updatedAt;
  const Qari(
      {required this.id,
      required this.name,
      this.nameBn,
      required this.slug,
      required this.position,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameBn != null) {
      map['name_bn'] = Variable<String>(nameBn);
    }
    map['slug'] = Variable<String>(slug);
    map['position'] = Variable<int>(position);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  factory Qari.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Qari(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nameBn: serializer.fromJson<String?>(json['nameBn']),
      slug: serializer.fromJson<String>(json['slug']),
      position: serializer.fromJson<int>(json['position']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'nameBn': serializer.toJson<String?>(nameBn),
      'slug': serializer.toJson<String>(slug),
      'position': serializer.toJson<int>(position),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  Qari copyWith(
          {String? id,
          String? name,
          Value<String?> nameBn = const Value.absent(),
          String? slug,
          int? position,
          String? createdAt,
          String? updatedAt}) =>
      Qari(
        id: id ?? this.id,
        name: name ?? this.name,
        nameBn: nameBn.present ? nameBn.value : this.nameBn,
        slug: slug ?? this.slug,
        position: position ?? this.position,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('Qari(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameBn: $nameBn, ')
          ..write('slug: $slug, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, nameBn, slug, position, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Qari &&
          other.id == this.id &&
          other.name == this.name &&
          other.nameBn == this.nameBn &&
          other.slug == this.slug &&
          other.position == this.position &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class QarisCompanion extends UpdateCompanion<Qari> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> nameBn;
  final Value<String> slug;
  final Value<int> position;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const QarisCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nameBn = const Value.absent(),
    this.slug = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QarisCompanion.insert({
    required String id,
    required String name,
    this.nameBn = const Value.absent(),
    required String slug,
    required int position,
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        slug = Value(slug),
        position = Value(position),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Qari> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? nameBn,
    Expression<String>? slug,
    Expression<int>? position,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nameBn != null) 'name_bn': nameBn,
      if (slug != null) 'slug': slug,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QarisCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? nameBn,
      Value<String>? slug,
      Value<int>? position,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<int>? rowid}) {
    return QarisCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nameBn: nameBn ?? this.nameBn,
      slug: slug ?? this.slug,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameBn.present) {
      map['name_bn'] = Variable<String>(nameBn.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QarisCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameBn: $nameBn, ')
          ..write('slug: $slug, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TafseerQitabsTable extends TafseerQitabs
    with TableInfo<$TafseerQitabsTable, TafseerQitab> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TafseerQitabsTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
      'author', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, author, position, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? 'tafseer_qitabs';
  @override
  String get actualTableName => 'tafseer_qitabs';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TafseerQitab map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TafseerQitab(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      author: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}author'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $TafseerQitabsTable createAlias(String alias) {
    return $TafseerQitabsTable(attachedDatabase, alias);
  }
}

class TafseerQitab extends DataClass implements Insertable<TafseerQitab> {
  final String id;
  final String title;
  final String author;
  final int position;
  final String createdAt;
  final String updatedAt;
  const TafseerQitab(
      {required this.id,
      required this.title,
      required this.author,
      required this.position,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['author'] = Variable<String>(author);
    map['position'] = Variable<int>(position);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  factory TafseerQitab.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TafseerQitab(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      author: serializer.fromJson<String>(json['author']),
      position: serializer.fromJson<int>(json['position']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'author': serializer.toJson<String>(author),
      'position': serializer.toJson<int>(position),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  TafseerQitab copyWith(
          {String? id,
          String? title,
          String? author,
          int? position,
          String? createdAt,
          String? updatedAt}) =>
      TafseerQitab(
        id: id ?? this.id,
        title: title ?? this.title,
        author: author ?? this.author,
        position: position ?? this.position,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('TafseerQitab(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, author, position, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TafseerQitab &&
          other.id == this.id &&
          other.title == this.title &&
          other.author == this.author &&
          other.position == this.position &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TafseerQitabsCompanion extends UpdateCompanion<TafseerQitab> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> author;
  final Value<int> position;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const TafseerQitabsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.author = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TafseerQitabsCompanion.insert({
    required String id,
    required String title,
    required String author,
    required int position,
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        author = Value(author),
        position = Value(position),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<TafseerQitab> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? author,
    Expression<int>? position,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (author != null) 'author': author,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TafseerQitabsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? author,
      Value<int>? position,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<int>? rowid}) {
    return TafseerQitabsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TafseerQitabsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TafseersTable extends Tafseers with TableInfo<$TafseersTable, Tafseer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TafseersTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> tafseerQitabId = GeneratedColumn<String>(
      'tafseer_qitab_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES tafseer_qitabs (id)'));
  @override
  late final GeneratedColumn<String> ayahId = GeneratedColumn<String>(
      'ayah_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES ayahs (id)'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, body, createdAt, updatedAt, tafseerQitabId, ayahId];
  @override
  String get aliasedName => _alias ?? 'tafseers';
  @override
  String get actualTableName => 'tafseers';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tafseer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tafseer(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
      tafseerQitabId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}tafseer_qitab_id'])!,
      ayahId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ayah_id'])!,
    );
  }

  @override
  $TafseersTable createAlias(String alias) {
    return $TafseersTable(attachedDatabase, alias);
  }
}

class Tafseer extends DataClass implements Insertable<Tafseer> {
  final String id;
  final String body;
  final String createdAt;
  final String updatedAt;
  final String tafseerQitabId;
  final String ayahId;
  const Tafseer(
      {required this.id,
      required this.body,
      required this.createdAt,
      required this.updatedAt,
      required this.tafseerQitabId,
      required this.ayahId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['body'] = Variable<String>(body);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    map['tafseer_qitab_id'] = Variable<String>(tafseerQitabId);
    map['ayah_id'] = Variable<String>(ayahId);
    return map;
  }

  factory Tafseer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tafseer(
      id: serializer.fromJson<String>(json['id']),
      body: serializer.fromJson<String>(json['body']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      tafseerQitabId: serializer.fromJson<String>(json['tafseerQitabId']),
      ayahId: serializer.fromJson<String>(json['ayahId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'body': serializer.toJson<String>(body),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'tafseerQitabId': serializer.toJson<String>(tafseerQitabId),
      'ayahId': serializer.toJson<String>(ayahId),
    };
  }

  Tafseer copyWith(
          {String? id,
          String? body,
          String? createdAt,
          String? updatedAt,
          String? tafseerQitabId,
          String? ayahId}) =>
      Tafseer(
        id: id ?? this.id,
        body: body ?? this.body,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        tafseerQitabId: tafseerQitabId ?? this.tafseerQitabId,
        ayahId: ayahId ?? this.ayahId,
      );
  @override
  String toString() {
    return (StringBuffer('Tafseer(')
          ..write('id: $id, ')
          ..write('body: $body, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('tafseerQitabId: $tafseerQitabId, ')
          ..write('ayahId: $ayahId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, body, createdAt, updatedAt, tafseerQitabId, ayahId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tafseer &&
          other.id == this.id &&
          other.body == this.body &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.tafseerQitabId == this.tafseerQitabId &&
          other.ayahId == this.ayahId);
}

class TafseersCompanion extends UpdateCompanion<Tafseer> {
  final Value<String> id;
  final Value<String> body;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String> tafseerQitabId;
  final Value<String> ayahId;
  final Value<int> rowid;
  const TafseersCompanion({
    this.id = const Value.absent(),
    this.body = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.tafseerQitabId = const Value.absent(),
    this.ayahId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TafseersCompanion.insert({
    required String id,
    required String body,
    required String createdAt,
    required String updatedAt,
    required String tafseerQitabId,
    required String ayahId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        body = Value(body),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        tafseerQitabId = Value(tafseerQitabId),
        ayahId = Value(ayahId);
  static Insertable<Tafseer> custom({
    Expression<String>? id,
    Expression<String>? body,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? tafseerQitabId,
    Expression<String>? ayahId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (body != null) 'body': body,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (tafseerQitabId != null) 'tafseer_qitab_id': tafseerQitabId,
      if (ayahId != null) 'ayah_id': ayahId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TafseersCompanion copyWith(
      {Value<String>? id,
      Value<String>? body,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<String>? tafseerQitabId,
      Value<String>? ayahId,
      Value<int>? rowid}) {
    return TafseersCompanion(
      id: id ?? this.id,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tafseerQitabId: tafseerQitabId ?? this.tafseerQitabId,
      ayahId: ayahId ?? this.ayahId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (tafseerQitabId.present) {
      map['tafseer_qitab_id'] = Variable<String>(tafseerQitabId.value);
    }
    if (ayahId.present) {
      map['ayah_id'] = Variable<String>(ayahId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TafseersCompanion(')
          ..write('id: $id, ')
          ..write('body: $body, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('tafseerQitabId: $tafseerQitabId, ')
          ..write('ayahId: $ayahId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BooksTable extends Books with TableInfo<$BooksTable, Book> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BooksTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> excerpt = GeneratedColumn<String>(
      'excerpt', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> publisher = GeneratedColumn<String>(
      'publisher', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> price = GeneratedColumn<String>(
      'price', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<Map<dynamic, dynamic>?, String>
      imageData = GeneratedColumn<String>('image_data', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Map<dynamic, dynamic>?>(
              $BooksTable.$converterimageDatan);
  @override
  late final GeneratedColumnWithTypeConverter<Map<dynamic, dynamic>?, String>
      documentData = GeneratedColumn<String>('document_data', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Map<dynamic, dynamic>?>(
              $BooksTable.$converterdocumentDatan);
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> publishedAt = GeneratedColumn<String>(
      'published_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        excerpt,
        publisher,
        price,
        language,
        imageData,
        documentData,
        position,
        publishedAt,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? 'books';
  @override
  String get actualTableName => 'books';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Book map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Book(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      excerpt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}excerpt']),
      publisher: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}publisher']),
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}price']),
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
      imageData: $BooksTable.$converterimageDatan.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_data'])),
      documentData: $BooksTable.$converterdocumentDatan.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}document_data'])),
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      publishedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}published_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $BooksTable createAlias(String alias) {
    return $BooksTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<dynamic, dynamic>, String> $converterimageData =
      const FileData();
  static TypeConverter<Map<dynamic, dynamic>?, String?> $converterimageDatan =
      NullAwareTypeConverter.wrap($converterimageData);
  static TypeConverter<Map<dynamic, dynamic>, String> $converterdocumentData =
      const FileData();
  static TypeConverter<Map<dynamic, dynamic>?, String?>
      $converterdocumentDatan =
      NullAwareTypeConverter.wrap($converterdocumentData);
}

class Book extends DataClass implements Insertable<Book> {
  final String id;
  final String title;
  final String? excerpt;
  final String? publisher;
  final String? price;
  final String language;
  final Map<dynamic, dynamic>? imageData;
  final Map<dynamic, dynamic>? documentData;
  final int position;
  final String? publishedAt;
  final String createdAt;
  final String updatedAt;
  const Book(
      {required this.id,
      required this.title,
      this.excerpt,
      this.publisher,
      this.price,
      required this.language,
      this.imageData,
      this.documentData,
      required this.position,
      this.publishedAt,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || excerpt != null) {
      map['excerpt'] = Variable<String>(excerpt);
    }
    if (!nullToAbsent || publisher != null) {
      map['publisher'] = Variable<String>(publisher);
    }
    if (!nullToAbsent || price != null) {
      map['price'] = Variable<String>(price);
    }
    map['language'] = Variable<String>(language);
    if (!nullToAbsent || imageData != null) {
      final converter = $BooksTable.$converterimageDatan;
      map['image_data'] = Variable<String>(converter.toSql(imageData));
    }
    if (!nullToAbsent || documentData != null) {
      final converter = $BooksTable.$converterdocumentDatan;
      map['document_data'] = Variable<String>(converter.toSql(documentData));
    }
    map['position'] = Variable<int>(position);
    if (!nullToAbsent || publishedAt != null) {
      map['published_at'] = Variable<String>(publishedAt);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  factory Book.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Book(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      excerpt: serializer.fromJson<String?>(json['excerpt']),
      publisher: serializer.fromJson<String?>(json['publisher']),
      price: serializer.fromJson<String?>(json['price']),
      language: serializer.fromJson<String>(json['language']),
      imageData: serializer.fromJson<Map<dynamic, dynamic>?>(json['image']),
      documentData:
          serializer.fromJson<Map<dynamic, dynamic>?>(json['document']),
      position: serializer.fromJson<int>(json['position']),
      publishedAt: serializer.fromJson<String?>(json['publishedAt']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'excerpt': serializer.toJson<String?>(excerpt),
      'publisher': serializer.toJson<String?>(publisher),
      'price': serializer.toJson<String?>(price),
      'language': serializer.toJson<String>(language),
      'image': serializer.toJson<Map<dynamic, dynamic>?>(imageData),
      'document': serializer.toJson<Map<dynamic, dynamic>?>(documentData),
      'position': serializer.toJson<int>(position),
      'publishedAt': serializer.toJson<String?>(publishedAt),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  Book copyWith(
          {String? id,
          String? title,
          Value<String?> excerpt = const Value.absent(),
          Value<String?> publisher = const Value.absent(),
          Value<String?> price = const Value.absent(),
          String? language,
          Value<Map<dynamic, dynamic>?> imageData = const Value.absent(),
          Value<Map<dynamic, dynamic>?> documentData = const Value.absent(),
          int? position,
          Value<String?> publishedAt = const Value.absent(),
          String? createdAt,
          String? updatedAt}) =>
      Book(
        id: id ?? this.id,
        title: title ?? this.title,
        excerpt: excerpt.present ? excerpt.value : this.excerpt,
        publisher: publisher.present ? publisher.value : this.publisher,
        price: price.present ? price.value : this.price,
        language: language ?? this.language,
        imageData: imageData.present ? imageData.value : this.imageData,
        documentData:
            documentData.present ? documentData.value : this.documentData,
        position: position ?? this.position,
        publishedAt: publishedAt.present ? publishedAt.value : this.publishedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('Book(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('excerpt: $excerpt, ')
          ..write('publisher: $publisher, ')
          ..write('price: $price, ')
          ..write('language: $language, ')
          ..write('imageData: $imageData, ')
          ..write('documentData: $documentData, ')
          ..write('position: $position, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      excerpt,
      publisher,
      price,
      language,
      imageData,
      documentData,
      position,
      publishedAt,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Book &&
          other.id == this.id &&
          other.title == this.title &&
          other.excerpt == this.excerpt &&
          other.publisher == this.publisher &&
          other.price == this.price &&
          other.language == this.language &&
          other.imageData == this.imageData &&
          other.documentData == this.documentData &&
          other.position == this.position &&
          other.publishedAt == this.publishedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BooksCompanion extends UpdateCompanion<Book> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> excerpt;
  final Value<String?> publisher;
  final Value<String?> price;
  final Value<String> language;
  final Value<Map<dynamic, dynamic>?> imageData;
  final Value<Map<dynamic, dynamic>?> documentData;
  final Value<int> position;
  final Value<String?> publishedAt;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const BooksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.excerpt = const Value.absent(),
    this.publisher = const Value.absent(),
    this.price = const Value.absent(),
    this.language = const Value.absent(),
    this.imageData = const Value.absent(),
    this.documentData = const Value.absent(),
    this.position = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BooksCompanion.insert({
    required String id,
    required String title,
    this.excerpt = const Value.absent(),
    this.publisher = const Value.absent(),
    this.price = const Value.absent(),
    required String language,
    this.imageData = const Value.absent(),
    this.documentData = const Value.absent(),
    required int position,
    this.publishedAt = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        language = Value(language),
        position = Value(position),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Book> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? excerpt,
    Expression<String>? publisher,
    Expression<String>? price,
    Expression<String>? language,
    Expression<String>? imageData,
    Expression<String>? documentData,
    Expression<int>? position,
    Expression<String>? publishedAt,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (excerpt != null) 'excerpt': excerpt,
      if (publisher != null) 'publisher': publisher,
      if (price != null) 'price': price,
      if (language != null) 'language': language,
      if (imageData != null) 'image_data': imageData,
      if (documentData != null) 'document_data': documentData,
      if (position != null) 'position': position,
      if (publishedAt != null) 'published_at': publishedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BooksCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String?>? excerpt,
      Value<String?>? publisher,
      Value<String?>? price,
      Value<String>? language,
      Value<Map<dynamic, dynamic>?>? imageData,
      Value<Map<dynamic, dynamic>?>? documentData,
      Value<int>? position,
      Value<String?>? publishedAt,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<int>? rowid}) {
    return BooksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      excerpt: excerpt ?? this.excerpt,
      publisher: publisher ?? this.publisher,
      price: price ?? this.price,
      language: language ?? this.language,
      imageData: imageData ?? this.imageData,
      documentData: documentData ?? this.documentData,
      position: position ?? this.position,
      publishedAt: publishedAt ?? this.publishedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (excerpt.present) {
      map['excerpt'] = Variable<String>(excerpt.value);
    }
    if (publisher.present) {
      map['publisher'] = Variable<String>(publisher.value);
    }
    if (price.present) {
      map['price'] = Variable<String>(price.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (imageData.present) {
      final converter = $BooksTable.$converterimageDatan;
      map['image_data'] = Variable<String>(converter.toSql(imageData.value));
    }
    if (documentData.present) {
      final converter = $BooksTable.$converterdocumentDatan;
      map['document_data'] =
          Variable<String>(converter.toSql(documentData.value));
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<String>(publishedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BooksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('excerpt: $excerpt, ')
          ..write('publisher: $publisher, ')
          ..write('price: $price, ')
          ..write('language: $language, ')
          ..write('imageData: $imageData, ')
          ..write('documentData: $documentData, ')
          ..write('position: $position, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChaptersTable extends Chapters with TableInfo<$ChaptersTable, Chapter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChaptersTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> bookId = GeneratedColumn<String>(
      'book_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES books (id)'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, body, position, createdAt, updatedAt, bookId];
  @override
  String get aliasedName => _alias ?? 'chapters';
  @override
  String get actualTableName => 'chapters';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Chapter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Chapter(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body']),
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
      bookId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}book_id'])!,
    );
  }

  @override
  $ChaptersTable createAlias(String alias) {
    return $ChaptersTable(attachedDatabase, alias);
  }
}

class Chapter extends DataClass implements Insertable<Chapter> {
  final String id;
  final String title;
  final String? body;
  final int position;
  final String createdAt;
  final String updatedAt;
  final String bookId;
  const Chapter(
      {required this.id,
      required this.title,
      this.body,
      required this.position,
      required this.createdAt,
      required this.updatedAt,
      required this.bookId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || body != null) {
      map['body'] = Variable<String>(body);
    }
    map['position'] = Variable<int>(position);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    map['book_id'] = Variable<String>(bookId);
    return map;
  }

  factory Chapter.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Chapter(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String?>(json['body']),
      position: serializer.fromJson<int>(json['position']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      bookId: serializer.fromJson<String>(json['bookId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String?>(body),
      'position': serializer.toJson<int>(position),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'bookId': serializer.toJson<String>(bookId),
    };
  }

  Chapter copyWith(
          {String? id,
          String? title,
          Value<String?> body = const Value.absent(),
          int? position,
          String? createdAt,
          String? updatedAt,
          String? bookId}) =>
      Chapter(
        id: id ?? this.id,
        title: title ?? this.title,
        body: body.present ? body.value : this.body,
        position: position ?? this.position,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        bookId: bookId ?? this.bookId,
      );
  @override
  String toString() {
    return (StringBuffer('Chapter(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('bookId: $bookId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, body, position, createdAt, updatedAt, bookId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Chapter &&
          other.id == this.id &&
          other.title == this.title &&
          other.body == this.body &&
          other.position == this.position &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.bookId == this.bookId);
}

class ChaptersCompanion extends UpdateCompanion<Chapter> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> body;
  final Value<int> position;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String> bookId;
  final Value<int> rowid;
  const ChaptersCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.bookId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChaptersCompanion.insert({
    required String id,
    required String title,
    this.body = const Value.absent(),
    required int position,
    required String createdAt,
    required String updatedAt,
    required String bookId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        position = Value(position),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        bookId = Value(bookId);
  static Insertable<Chapter> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? body,
    Expression<int>? position,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? bookId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (bookId != null) 'book_id': bookId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChaptersCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String?>? body,
      Value<int>? position,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<String>? bookId,
      Value<int>? rowid}) {
    return ChaptersCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      bookId: bookId ?? this.bookId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<String>(bookId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChaptersCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('bookId: $bookId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubchaptersTable extends Subchapters
    with TableInfo<$SubchaptersTable, Subchapter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubchaptersTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> chapterId = GeneratedColumn<String>(
      'chapter_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES chapters (id)'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, body, position, createdAt, updatedAt, chapterId];
  @override
  String get aliasedName => _alias ?? 'subchapters';
  @override
  String get actualTableName => 'subchapters';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Subchapter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Subchapter(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
      chapterId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chapter_id'])!,
    );
  }

  @override
  $SubchaptersTable createAlias(String alias) {
    return $SubchaptersTable(attachedDatabase, alias);
  }
}

class Subchapter extends DataClass implements Insertable<Subchapter> {
  final String id;
  final String title;
  final String body;
  final int position;
  final String createdAt;
  final String updatedAt;
  final String chapterId;
  const Subchapter(
      {required this.id,
      required this.title,
      required this.body,
      required this.position,
      required this.createdAt,
      required this.updatedAt,
      required this.chapterId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    map['position'] = Variable<int>(position);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    map['chapter_id'] = Variable<String>(chapterId);
    return map;
  }

  factory Subchapter.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Subchapter(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      position: serializer.fromJson<int>(json['position']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      chapterId: serializer.fromJson<String>(json['chapterId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'position': serializer.toJson<int>(position),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'chapterId': serializer.toJson<String>(chapterId),
    };
  }

  Subchapter copyWith(
          {String? id,
          String? title,
          String? body,
          int? position,
          String? createdAt,
          String? updatedAt,
          String? chapterId}) =>
      Subchapter(
        id: id ?? this.id,
        title: title ?? this.title,
        body: body ?? this.body,
        position: position ?? this.position,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        chapterId: chapterId ?? this.chapterId,
      );
  @override
  String toString() {
    return (StringBuffer('Subchapter(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('chapterId: $chapterId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, body, position, createdAt, updatedAt, chapterId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Subchapter &&
          other.id == this.id &&
          other.title == this.title &&
          other.body == this.body &&
          other.position == this.position &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.chapterId == this.chapterId);
}

class SubchaptersCompanion extends UpdateCompanion<Subchapter> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> body;
  final Value<int> position;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String> chapterId;
  final Value<int> rowid;
  const SubchaptersCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubchaptersCompanion.insert({
    required String id,
    required String title,
    required String body,
    required int position,
    required String createdAt,
    required String updatedAt,
    required String chapterId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        body = Value(body),
        position = Value(position),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        chapterId = Value(chapterId);
  static Insertable<Subchapter> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? body,
    Expression<int>? position,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? chapterId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (chapterId != null) 'chapter_id': chapterId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubchaptersCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? body,
      Value<int>? position,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<String>? chapterId,
      Value<int>? rowid}) {
    return SubchaptersCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      chapterId: chapterId ?? this.chapterId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<String>(chapterId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubchaptersCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('chapterId: $chapterId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuthorsTable extends Authors with TableInfo<$AuthorsTable, Author> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuthorsTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> info = GeneratedColumn<String>(
      'info', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, info, position, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? 'authors';
  @override
  String get actualTableName => 'authors';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Author map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Author(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      info: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}info']),
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $AuthorsTable createAlias(String alias) {
    return $AuthorsTable(attachedDatabase, alias);
  }
}

class Author extends DataClass implements Insertable<Author> {
  final String id;
  final String name;
  final String? info;
  final int position;
  final String createdAt;
  final String updatedAt;
  const Author(
      {required this.id,
      required this.name,
      this.info,
      required this.position,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || info != null) {
      map['info'] = Variable<String>(info);
    }
    map['position'] = Variable<int>(position);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  factory Author.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Author(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      info: serializer.fromJson<String?>(json['info']),
      position: serializer.fromJson<int>(json['position']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'info': serializer.toJson<String?>(info),
      'position': serializer.toJson<int>(position),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  Author copyWith(
          {String? id,
          String? name,
          Value<String?> info = const Value.absent(),
          int? position,
          String? createdAt,
          String? updatedAt}) =>
      Author(
        id: id ?? this.id,
        name: name ?? this.name,
        info: info.present ? info.value : this.info,
        position: position ?? this.position,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('Author(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('info: $info, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, info, position, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Author &&
          other.id == this.id &&
          other.name == this.name &&
          other.info == this.info &&
          other.position == this.position &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AuthorsCompanion extends UpdateCompanion<Author> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> info;
  final Value<int> position;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const AuthorsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.info = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuthorsCompanion.insert({
    required String id,
    required String name,
    this.info = const Value.absent(),
    required int position,
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        position = Value(position),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Author> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? info,
    Expression<int>? position,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (info != null) 'info': info,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuthorsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? info,
      Value<int>? position,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<int>? rowid}) {
    return AuthorsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      info: info ?? this.info,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (info.present) {
      map['info'] = Variable<String>(info.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuthorsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('info: $info, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BooksAuthorsTable extends BooksAuthors
    with TableInfo<$BooksAuthorsTable, BooksAuthor> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BooksAuthorsTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> bookId = GeneratedColumn<String>(
      'book_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES books (id)'));
  @override
  late final GeneratedColumn<String> authorId = GeneratedColumn<String>(
      'author_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES authors (id)'));
  @override
  List<GeneratedColumn> get $columns => [id, bookId, authorId];
  @override
  String get aliasedName => _alias ?? 'books_authors';
  @override
  String get actualTableName => 'books_authors';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BooksAuthor map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BooksAuthor(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      bookId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}book_id'])!,
      authorId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}author_id'])!,
    );
  }

  @override
  $BooksAuthorsTable createAlias(String alias) {
    return $BooksAuthorsTable(attachedDatabase, alias);
  }
}

class BooksAuthor extends DataClass implements Insertable<BooksAuthor> {
  final String id;
  final String bookId;
  final String authorId;
  const BooksAuthor(
      {required this.id, required this.bookId, required this.authorId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['book_id'] = Variable<String>(bookId);
    map['author_id'] = Variable<String>(authorId);
    return map;
  }

  factory BooksAuthor.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BooksAuthor(
      id: serializer.fromJson<String>(json['id']),
      bookId: serializer.fromJson<String>(json['bookId']),
      authorId: serializer.fromJson<String>(json['authorId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'bookId': serializer.toJson<String>(bookId),
      'authorId': serializer.toJson<String>(authorId),
    };
  }

  BooksAuthor copyWith({String? id, String? bookId, String? authorId}) =>
      BooksAuthor(
        id: id ?? this.id,
        bookId: bookId ?? this.bookId,
        authorId: authorId ?? this.authorId,
      );
  @override
  String toString() {
    return (StringBuffer('BooksAuthor(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('authorId: $authorId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, bookId, authorId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BooksAuthor &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.authorId == this.authorId);
}

class BooksAuthorsCompanion extends UpdateCompanion<BooksAuthor> {
  final Value<String> id;
  final Value<String> bookId;
  final Value<String> authorId;
  final Value<int> rowid;
  const BooksAuthorsCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.authorId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BooksAuthorsCompanion.insert({
    required String id,
    required String bookId,
    required String authorId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        bookId = Value(bookId),
        authorId = Value(authorId);
  static Insertable<BooksAuthor> custom({
    Expression<String>? id,
    Expression<String>? bookId,
    Expression<String>? authorId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (authorId != null) 'author_id': authorId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BooksAuthorsCompanion copyWith(
      {Value<String>? id,
      Value<String>? bookId,
      Value<String>? authorId,
      Value<int>? rowid}) {
    return BooksAuthorsCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      authorId: authorId ?? this.authorId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<String>(bookId.value);
    }
    if (authorId.present) {
      map['author_id'] = Variable<String>(authorId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BooksAuthorsCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('authorId: $authorId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SpeakersTable extends Speakers with TableInfo<$SpeakersTable, Speaker> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpeakersTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> info = GeneratedColumn<String>(
      'info', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, info, position, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? 'speakers';
  @override
  String get actualTableName => 'speakers';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Speaker map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Speaker(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      info: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}info']),
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SpeakersTable createAlias(String alias) {
    return $SpeakersTable(attachedDatabase, alias);
  }
}

class Speaker extends DataClass implements Insertable<Speaker> {
  final String id;
  final String name;
  final String? info;
  final int position;
  final String createdAt;
  final String updatedAt;
  const Speaker(
      {required this.id,
      required this.name,
      this.info,
      required this.position,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || info != null) {
      map['info'] = Variable<String>(info);
    }
    map['position'] = Variable<int>(position);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  factory Speaker.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Speaker(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      info: serializer.fromJson<String?>(json['info']),
      position: serializer.fromJson<int>(json['position']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'info': serializer.toJson<String?>(info),
      'position': serializer.toJson<int>(position),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  Speaker copyWith(
          {String? id,
          String? name,
          Value<String?> info = const Value.absent(),
          int? position,
          String? createdAt,
          String? updatedAt}) =>
      Speaker(
        id: id ?? this.id,
        name: name ?? this.name,
        info: info.present ? info.value : this.info,
        position: position ?? this.position,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('Speaker(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('info: $info, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, info, position, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Speaker &&
          other.id == this.id &&
          other.name == this.name &&
          other.info == this.info &&
          other.position == this.position &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SpeakersCompanion extends UpdateCompanion<Speaker> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> info;
  final Value<int> position;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const SpeakersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.info = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SpeakersCompanion.insert({
    required String id,
    required String name,
    this.info = const Value.absent(),
    required int position,
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        position = Value(position),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Speaker> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? info,
    Expression<int>? position,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (info != null) 'info': info,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SpeakersCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? info,
      Value<int>? position,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<int>? rowid}) {
    return SpeakersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      info: info ?? this.info,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (info.present) {
      map['info'] = Variable<String>(info.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpeakersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('info: $info, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BayansTable extends Bayans with TableInfo<$BayansTable, Bayan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BayansTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> excerpt = GeneratedColumn<String>(
      'excerpt', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
      'location', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<Map<dynamic, dynamic>?, String>
      audioData = GeneratedColumn<String>('audio_data', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Map<dynamic, dynamic>?>(
              $BayansTable.$converteraudioDatan);
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> publishedAt = GeneratedColumn<String>(
      'published_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> speakerId = GeneratedColumn<String>(
      'speaker_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES speakers (id)'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        excerpt,
        language,
        location,
        audioData,
        position,
        publishedAt,
        createdAt,
        updatedAt,
        speakerId
      ];
  @override
  String get aliasedName => _alias ?? 'bayans';
  @override
  String get actualTableName => 'bayans';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Bayan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Bayan(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      excerpt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}excerpt']),
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
      location: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location']),
      audioData: $BayansTable.$converteraudioDatan.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}audio_data'])),
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      publishedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}published_at'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
      speakerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}speaker_id'])!,
    );
  }

  @override
  $BayansTable createAlias(String alias) {
    return $BayansTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<dynamic, dynamic>, String> $converteraudioData =
      const FileData();
  static TypeConverter<Map<dynamic, dynamic>?, String?> $converteraudioDatan =
      NullAwareTypeConverter.wrap($converteraudioData);
}

class Bayan extends DataClass implements Insertable<Bayan> {
  final String id;
  final String title;
  final String? excerpt;
  final String language;
  final String? location;
  final Map<dynamic, dynamic>? audioData;
  final int position;
  final String publishedAt;
  final String createdAt;
  final String updatedAt;
  final String speakerId;
  const Bayan(
      {required this.id,
      required this.title,
      this.excerpt,
      required this.language,
      this.location,
      this.audioData,
      required this.position,
      required this.publishedAt,
      required this.createdAt,
      required this.updatedAt,
      required this.speakerId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || excerpt != null) {
      map['excerpt'] = Variable<String>(excerpt);
    }
    map['language'] = Variable<String>(language);
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    if (!nullToAbsent || audioData != null) {
      final converter = $BayansTable.$converteraudioDatan;
      map['audio_data'] = Variable<String>(converter.toSql(audioData));
    }
    map['position'] = Variable<int>(position);
    map['published_at'] = Variable<String>(publishedAt);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    map['speaker_id'] = Variable<String>(speakerId);
    return map;
  }

  factory Bayan.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Bayan(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      excerpt: serializer.fromJson<String?>(json['excerpt']),
      language: serializer.fromJson<String>(json['language']),
      location: serializer.fromJson<String?>(json['location']),
      audioData: serializer.fromJson<Map<dynamic, dynamic>?>(json['audio']),
      position: serializer.fromJson<int>(json['position']),
      publishedAt: serializer.fromJson<String>(json['publishedAt']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      speakerId: serializer.fromJson<String>(json['speakerId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'excerpt': serializer.toJson<String?>(excerpt),
      'language': serializer.toJson<String>(language),
      'location': serializer.toJson<String?>(location),
      'audio': serializer.toJson<Map<dynamic, dynamic>?>(audioData),
      'position': serializer.toJson<int>(position),
      'publishedAt': serializer.toJson<String>(publishedAt),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'speakerId': serializer.toJson<String>(speakerId),
    };
  }

  Bayan copyWith(
          {String? id,
          String? title,
          Value<String?> excerpt = const Value.absent(),
          String? language,
          Value<String?> location = const Value.absent(),
          Value<Map<dynamic, dynamic>?> audioData = const Value.absent(),
          int? position,
          String? publishedAt,
          String? createdAt,
          String? updatedAt,
          String? speakerId}) =>
      Bayan(
        id: id ?? this.id,
        title: title ?? this.title,
        excerpt: excerpt.present ? excerpt.value : this.excerpt,
        language: language ?? this.language,
        location: location.present ? location.value : this.location,
        audioData: audioData.present ? audioData.value : this.audioData,
        position: position ?? this.position,
        publishedAt: publishedAt ?? this.publishedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        speakerId: speakerId ?? this.speakerId,
      );
  @override
  String toString() {
    return (StringBuffer('Bayan(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('excerpt: $excerpt, ')
          ..write('language: $language, ')
          ..write('location: $location, ')
          ..write('audioData: $audioData, ')
          ..write('position: $position, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('speakerId: $speakerId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, excerpt, language, location,
      audioData, position, publishedAt, createdAt, updatedAt, speakerId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bayan &&
          other.id == this.id &&
          other.title == this.title &&
          other.excerpt == this.excerpt &&
          other.language == this.language &&
          other.location == this.location &&
          other.audioData == this.audioData &&
          other.position == this.position &&
          other.publishedAt == this.publishedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.speakerId == this.speakerId);
}

class BayansCompanion extends UpdateCompanion<Bayan> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> excerpt;
  final Value<String> language;
  final Value<String?> location;
  final Value<Map<dynamic, dynamic>?> audioData;
  final Value<int> position;
  final Value<String> publishedAt;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String> speakerId;
  final Value<int> rowid;
  const BayansCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.excerpt = const Value.absent(),
    this.language = const Value.absent(),
    this.location = const Value.absent(),
    this.audioData = const Value.absent(),
    this.position = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.speakerId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BayansCompanion.insert({
    required String id,
    required String title,
    this.excerpt = const Value.absent(),
    required String language,
    this.location = const Value.absent(),
    this.audioData = const Value.absent(),
    required int position,
    required String publishedAt,
    required String createdAt,
    required String updatedAt,
    required String speakerId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        language = Value(language),
        position = Value(position),
        publishedAt = Value(publishedAt),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        speakerId = Value(speakerId);
  static Insertable<Bayan> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? excerpt,
    Expression<String>? language,
    Expression<String>? location,
    Expression<String>? audioData,
    Expression<int>? position,
    Expression<String>? publishedAt,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? speakerId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (excerpt != null) 'excerpt': excerpt,
      if (language != null) 'language': language,
      if (location != null) 'location': location,
      if (audioData != null) 'audio_data': audioData,
      if (position != null) 'position': position,
      if (publishedAt != null) 'published_at': publishedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (speakerId != null) 'speaker_id': speakerId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BayansCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String?>? excerpt,
      Value<String>? language,
      Value<String?>? location,
      Value<Map<dynamic, dynamic>?>? audioData,
      Value<int>? position,
      Value<String>? publishedAt,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<String>? speakerId,
      Value<int>? rowid}) {
    return BayansCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      excerpt: excerpt ?? this.excerpt,
      language: language ?? this.language,
      location: location ?? this.location,
      audioData: audioData ?? this.audioData,
      position: position ?? this.position,
      publishedAt: publishedAt ?? this.publishedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      speakerId: speakerId ?? this.speakerId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (excerpt.present) {
      map['excerpt'] = Variable<String>(excerpt.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (audioData.present) {
      final converter = $BayansTable.$converteraudioDatan;
      map['audio_data'] = Variable<String>(converter.toSql(audioData.value));
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<String>(publishedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (speakerId.present) {
      map['speaker_id'] = Variable<String>(speakerId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BayansCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('excerpt: $excerpt, ')
          ..write('language: $language, ')
          ..write('location: $location, ')
          ..write('audioData: $audioData, ')
          ..write('position: $position, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('speakerId: $speakerId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MalfuzatAuthorsTable extends MalfuzatAuthors
    with TableInfo<$MalfuzatAuthorsTable, MalfuzatAuthor> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MalfuzatAuthorsTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> info = GeneratedColumn<String>(
      'info', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, info, position, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? 'malfuzat_authors';
  @override
  String get actualTableName => 'malfuzat_authors';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MalfuzatAuthor map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MalfuzatAuthor(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      info: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}info']),
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $MalfuzatAuthorsTable createAlias(String alias) {
    return $MalfuzatAuthorsTable(attachedDatabase, alias);
  }
}

class MalfuzatAuthor extends DataClass implements Insertable<MalfuzatAuthor> {
  final String id;
  final String name;
  final String? info;
  final int position;
  final String createdAt;
  final String updatedAt;
  const MalfuzatAuthor(
      {required this.id,
      required this.name,
      this.info,
      required this.position,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || info != null) {
      map['info'] = Variable<String>(info);
    }
    map['position'] = Variable<int>(position);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  factory MalfuzatAuthor.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MalfuzatAuthor(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      info: serializer.fromJson<String?>(json['info']),
      position: serializer.fromJson<int>(json['position']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'info': serializer.toJson<String?>(info),
      'position': serializer.toJson<int>(position),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  MalfuzatAuthor copyWith(
          {String? id,
          String? name,
          Value<String?> info = const Value.absent(),
          int? position,
          String? createdAt,
          String? updatedAt}) =>
      MalfuzatAuthor(
        id: id ?? this.id,
        name: name ?? this.name,
        info: info.present ? info.value : this.info,
        position: position ?? this.position,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('MalfuzatAuthor(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('info: $info, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, info, position, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MalfuzatAuthor &&
          other.id == this.id &&
          other.name == this.name &&
          other.info == this.info &&
          other.position == this.position &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MalfuzatAuthorsCompanion extends UpdateCompanion<MalfuzatAuthor> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> info;
  final Value<int> position;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const MalfuzatAuthorsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.info = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MalfuzatAuthorsCompanion.insert({
    required String id,
    required String name,
    this.info = const Value.absent(),
    required int position,
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        position = Value(position),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<MalfuzatAuthor> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? info,
    Expression<int>? position,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (info != null) 'info': info,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MalfuzatAuthorsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? info,
      Value<int>? position,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<int>? rowid}) {
    return MalfuzatAuthorsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      info: info ?? this.info,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (info.present) {
      map['info'] = Variable<String>(info.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MalfuzatAuthorsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('info: $info, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MalfuzatsTable extends Malfuzats
    with TableInfo<$MalfuzatsTable, Malfuzat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MalfuzatsTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> excerpt = GeneratedColumn<String>(
      'excerpt', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<bool> hasAudio =
      GeneratedColumn<bool>('has_audio', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("has_audio" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(false));
  @override
  late final GeneratedColumnWithTypeConverter<Map<dynamic, dynamic>?, String>
      audioData = GeneratedColumn<String>('audio_data', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Map<dynamic, dynamic>?>(
              $MalfuzatsTable.$converteraudioDatan);
  @override
  late final GeneratedColumnWithTypeConverter<Map<dynamic, dynamic>?, String>
      documentData = GeneratedColumn<String>('document_data', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Map<dynamic, dynamic>?>(
              $MalfuzatsTable.$converterdocumentDatan);
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> publishedAt = GeneratedColumn<String>(
      'published_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> malfuzatAuthorId = GeneratedColumn<String>(
      'malfuzat_author_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES malfuzat_authors (id)'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        body,
        excerpt,
        language,
        hasAudio,
        audioData,
        documentData,
        position,
        publishedAt,
        createdAt,
        updatedAt,
        malfuzatAuthorId
      ];
  @override
  String get aliasedName => _alias ?? 'malfuzats';
  @override
  String get actualTableName => 'malfuzats';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Malfuzat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Malfuzat(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body']),
      excerpt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}excerpt']),
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
      hasAudio: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}has_audio'])!,
      audioData: $MalfuzatsTable.$converteraudioDatan.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}audio_data'])),
      documentData: $MalfuzatsTable.$converterdocumentDatan.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}document_data'])),
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      publishedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}published_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
      malfuzatAuthorId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}malfuzat_author_id'])!,
    );
  }

  @override
  $MalfuzatsTable createAlias(String alias) {
    return $MalfuzatsTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<dynamic, dynamic>, String> $converteraudioData =
      const FileData();
  static TypeConverter<Map<dynamic, dynamic>?, String?> $converteraudioDatan =
      NullAwareTypeConverter.wrap($converteraudioData);
  static TypeConverter<Map<dynamic, dynamic>, String> $converterdocumentData =
      const FileData();
  static TypeConverter<Map<dynamic, dynamic>?, String?>
      $converterdocumentDatan =
      NullAwareTypeConverter.wrap($converterdocumentData);
}

class Malfuzat extends DataClass implements Insertable<Malfuzat> {
  final String id;
  final String title;
  final String? body;
  final String? excerpt;
  final String language;
  final bool hasAudio;
  final Map<dynamic, dynamic>? audioData;
  final Map<dynamic, dynamic>? documentData;
  final int position;
  final String? publishedAt;
  final String createdAt;
  final String updatedAt;
  final String malfuzatAuthorId;
  const Malfuzat(
      {required this.id,
      required this.title,
      this.body,
      this.excerpt,
      required this.language,
      required this.hasAudio,
      this.audioData,
      this.documentData,
      required this.position,
      this.publishedAt,
      required this.createdAt,
      required this.updatedAt,
      required this.malfuzatAuthorId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || body != null) {
      map['body'] = Variable<String>(body);
    }
    if (!nullToAbsent || excerpt != null) {
      map['excerpt'] = Variable<String>(excerpt);
    }
    map['language'] = Variable<String>(language);
    map['has_audio'] = Variable<bool>(hasAudio);
    if (!nullToAbsent || audioData != null) {
      final converter = $MalfuzatsTable.$converteraudioDatan;
      map['audio_data'] = Variable<String>(converter.toSql(audioData));
    }
    if (!nullToAbsent || documentData != null) {
      final converter = $MalfuzatsTable.$converterdocumentDatan;
      map['document_data'] = Variable<String>(converter.toSql(documentData));
    }
    map['position'] = Variable<int>(position);
    if (!nullToAbsent || publishedAt != null) {
      map['published_at'] = Variable<String>(publishedAt);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    map['malfuzat_author_id'] = Variable<String>(malfuzatAuthorId);
    return map;
  }

  factory Malfuzat.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Malfuzat(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String?>(json['body']),
      excerpt: serializer.fromJson<String?>(json['excerpt']),
      language: serializer.fromJson<String>(json['language']),
      hasAudio: serializer.fromJson<bool>(json['hasAudio']),
      audioData: serializer.fromJson<Map<dynamic, dynamic>?>(json['audio']),
      documentData:
          serializer.fromJson<Map<dynamic, dynamic>?>(json['document']),
      position: serializer.fromJson<int>(json['position']),
      publishedAt: serializer.fromJson<String?>(json['publishedAt']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      malfuzatAuthorId: serializer.fromJson<String>(json['malfuzatAuthorId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String?>(body),
      'excerpt': serializer.toJson<String?>(excerpt),
      'language': serializer.toJson<String>(language),
      'hasAudio': serializer.toJson<bool>(hasAudio),
      'audio': serializer.toJson<Map<dynamic, dynamic>?>(audioData),
      'document': serializer.toJson<Map<dynamic, dynamic>?>(documentData),
      'position': serializer.toJson<int>(position),
      'publishedAt': serializer.toJson<String?>(publishedAt),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'malfuzatAuthorId': serializer.toJson<String>(malfuzatAuthorId),
    };
  }

  Malfuzat copyWith(
          {String? id,
          String? title,
          Value<String?> body = const Value.absent(),
          Value<String?> excerpt = const Value.absent(),
          String? language,
          bool? hasAudio,
          Value<Map<dynamic, dynamic>?> audioData = const Value.absent(),
          Value<Map<dynamic, dynamic>?> documentData = const Value.absent(),
          int? position,
          Value<String?> publishedAt = const Value.absent(),
          String? createdAt,
          String? updatedAt,
          String? malfuzatAuthorId}) =>
      Malfuzat(
        id: id ?? this.id,
        title: title ?? this.title,
        body: body.present ? body.value : this.body,
        excerpt: excerpt.present ? excerpt.value : this.excerpt,
        language: language ?? this.language,
        hasAudio: hasAudio ?? this.hasAudio,
        audioData: audioData.present ? audioData.value : this.audioData,
        documentData:
            documentData.present ? documentData.value : this.documentData,
        position: position ?? this.position,
        publishedAt: publishedAt.present ? publishedAt.value : this.publishedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        malfuzatAuthorId: malfuzatAuthorId ?? this.malfuzatAuthorId,
      );
  @override
  String toString() {
    return (StringBuffer('Malfuzat(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('excerpt: $excerpt, ')
          ..write('language: $language, ')
          ..write('hasAudio: $hasAudio, ')
          ..write('audioData: $audioData, ')
          ..write('documentData: $documentData, ')
          ..write('position: $position, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('malfuzatAuthorId: $malfuzatAuthorId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      body,
      excerpt,
      language,
      hasAudio,
      audioData,
      documentData,
      position,
      publishedAt,
      createdAt,
      updatedAt,
      malfuzatAuthorId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Malfuzat &&
          other.id == this.id &&
          other.title == this.title &&
          other.body == this.body &&
          other.excerpt == this.excerpt &&
          other.language == this.language &&
          other.hasAudio == this.hasAudio &&
          other.audioData == this.audioData &&
          other.documentData == this.documentData &&
          other.position == this.position &&
          other.publishedAt == this.publishedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.malfuzatAuthorId == this.malfuzatAuthorId);
}

class MalfuzatsCompanion extends UpdateCompanion<Malfuzat> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> body;
  final Value<String?> excerpt;
  final Value<String> language;
  final Value<bool> hasAudio;
  final Value<Map<dynamic, dynamic>?> audioData;
  final Value<Map<dynamic, dynamic>?> documentData;
  final Value<int> position;
  final Value<String?> publishedAt;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String> malfuzatAuthorId;
  final Value<int> rowid;
  const MalfuzatsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.excerpt = const Value.absent(),
    this.language = const Value.absent(),
    this.hasAudio = const Value.absent(),
    this.audioData = const Value.absent(),
    this.documentData = const Value.absent(),
    this.position = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.malfuzatAuthorId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MalfuzatsCompanion.insert({
    required String id,
    required String title,
    this.body = const Value.absent(),
    this.excerpt = const Value.absent(),
    required String language,
    this.hasAudio = const Value.absent(),
    this.audioData = const Value.absent(),
    this.documentData = const Value.absent(),
    required int position,
    this.publishedAt = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    required String malfuzatAuthorId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        language = Value(language),
        position = Value(position),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        malfuzatAuthorId = Value(malfuzatAuthorId);
  static Insertable<Malfuzat> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? excerpt,
    Expression<String>? language,
    Expression<bool>? hasAudio,
    Expression<String>? audioData,
    Expression<String>? documentData,
    Expression<int>? position,
    Expression<String>? publishedAt,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? malfuzatAuthorId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (excerpt != null) 'excerpt': excerpt,
      if (language != null) 'language': language,
      if (hasAudio != null) 'has_audio': hasAudio,
      if (audioData != null) 'audio_data': audioData,
      if (documentData != null) 'document_data': documentData,
      if (position != null) 'position': position,
      if (publishedAt != null) 'published_at': publishedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (malfuzatAuthorId != null) 'malfuzat_author_id': malfuzatAuthorId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MalfuzatsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String?>? body,
      Value<String?>? excerpt,
      Value<String>? language,
      Value<bool>? hasAudio,
      Value<Map<dynamic, dynamic>?>? audioData,
      Value<Map<dynamic, dynamic>?>? documentData,
      Value<int>? position,
      Value<String?>? publishedAt,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<String>? malfuzatAuthorId,
      Value<int>? rowid}) {
    return MalfuzatsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      excerpt: excerpt ?? this.excerpt,
      language: language ?? this.language,
      hasAudio: hasAudio ?? this.hasAudio,
      audioData: audioData ?? this.audioData,
      documentData: documentData ?? this.documentData,
      position: position ?? this.position,
      publishedAt: publishedAt ?? this.publishedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      malfuzatAuthorId: malfuzatAuthorId ?? this.malfuzatAuthorId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (excerpt.present) {
      map['excerpt'] = Variable<String>(excerpt.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (hasAudio.present) {
      map['has_audio'] = Variable<bool>(hasAudio.value);
    }
    if (audioData.present) {
      final converter = $MalfuzatsTable.$converteraudioDatan;
      map['audio_data'] = Variable<String>(converter.toSql(audioData.value));
    }
    if (documentData.present) {
      final converter = $MalfuzatsTable.$converterdocumentDatan;
      map['document_data'] =
          Variable<String>(converter.toSql(documentData.value));
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<String>(publishedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (malfuzatAuthorId.present) {
      map['malfuzat_author_id'] = Variable<String>(malfuzatAuthorId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MalfuzatsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('excerpt: $excerpt, ')
          ..write('language: $language, ')
          ..write('hasAudio: $hasAudio, ')
          ..write('audioData: $audioData, ')
          ..write('documentData: $documentData, ')
          ..write('position: $position, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('malfuzatAuthorId: $malfuzatAuthorId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MasailAuthorsTable extends MasailAuthors
    with TableInfo<$MasailAuthorsTable, MasailAuthor> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MasailAuthorsTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> info = GeneratedColumn<String>(
      'info', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, info, position, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? 'masail_authors';
  @override
  String get actualTableName => 'masail_authors';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MasailAuthor map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MasailAuthor(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      info: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}info']),
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $MasailAuthorsTable createAlias(String alias) {
    return $MasailAuthorsTable(attachedDatabase, alias);
  }
}

class MasailAuthor extends DataClass implements Insertable<MasailAuthor> {
  final String id;
  final String name;
  final String? info;
  final int position;
  final String createdAt;
  final String updatedAt;
  const MasailAuthor(
      {required this.id,
      required this.name,
      this.info,
      required this.position,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || info != null) {
      map['info'] = Variable<String>(info);
    }
    map['position'] = Variable<int>(position);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  factory MasailAuthor.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MasailAuthor(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      info: serializer.fromJson<String?>(json['info']),
      position: serializer.fromJson<int>(json['position']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'info': serializer.toJson<String?>(info),
      'position': serializer.toJson<int>(position),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  MasailAuthor copyWith(
          {String? id,
          String? name,
          Value<String?> info = const Value.absent(),
          int? position,
          String? createdAt,
          String? updatedAt}) =>
      MasailAuthor(
        id: id ?? this.id,
        name: name ?? this.name,
        info: info.present ? info.value : this.info,
        position: position ?? this.position,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('MasailAuthor(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('info: $info, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, info, position, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MasailAuthor &&
          other.id == this.id &&
          other.name == this.name &&
          other.info == this.info &&
          other.position == this.position &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MasailAuthorsCompanion extends UpdateCompanion<MasailAuthor> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> info;
  final Value<int> position;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const MasailAuthorsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.info = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MasailAuthorsCompanion.insert({
    required String id,
    required String name,
    this.info = const Value.absent(),
    required int position,
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        position = Value(position),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<MasailAuthor> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? info,
    Expression<int>? position,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (info != null) 'info': info,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MasailAuthorsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? info,
      Value<int>? position,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<int>? rowid}) {
    return MasailAuthorsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      info: info ?? this.info,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (info.present) {
      map['info'] = Variable<String>(info.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MasailAuthorsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('info: $info, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MasailsTable extends Masails with TableInfo<$MasailsTable, Masail> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MasailsTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> question = GeneratedColumn<String>(
      'question', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> answer = GeneratedColumn<String>(
      'answer', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<bool> hasAudio =
      GeneratedColumn<bool>('has_audio', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("has_audio" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(false));
  @override
  late final GeneratedColumnWithTypeConverter<Map<dynamic, dynamic>?, String>
      audioData = GeneratedColumn<String>('audio_data', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Map<dynamic, dynamic>?>(
              $MasailsTable.$converteraudioDatan);
  @override
  late final GeneratedColumnWithTypeConverter<Map<dynamic, dynamic>?, String>
      documentData = GeneratedColumn<String>('document_data', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Map<dynamic, dynamic>?>(
              $MasailsTable.$converterdocumentDatan);
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> publishedAt = GeneratedColumn<String>(
      'published_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> masailAuthorId = GeneratedColumn<String>(
      'masail_author_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES masail_authors (id)'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        question,
        answer,
        language,
        hasAudio,
        audioData,
        documentData,
        position,
        publishedAt,
        createdAt,
        updatedAt,
        masailAuthorId
      ];
  @override
  String get aliasedName => _alias ?? 'masails';
  @override
  String get actualTableName => 'masails';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Masail map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Masail(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      question: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}question'])!,
      answer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}answer']),
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
      hasAudio: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}has_audio'])!,
      audioData: $MasailsTable.$converteraudioDatan.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}audio_data'])),
      documentData: $MasailsTable.$converterdocumentDatan.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}document_data'])),
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      publishedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}published_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
      masailAuthorId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}masail_author_id']),
    );
  }

  @override
  $MasailsTable createAlias(String alias) {
    return $MasailsTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<dynamic, dynamic>, String> $converteraudioData =
      const FileData();
  static TypeConverter<Map<dynamic, dynamic>?, String?> $converteraudioDatan =
      NullAwareTypeConverter.wrap($converteraudioData);
  static TypeConverter<Map<dynamic, dynamic>, String> $converterdocumentData =
      const FileData();
  static TypeConverter<Map<dynamic, dynamic>?, String?>
      $converterdocumentDatan =
      NullAwareTypeConverter.wrap($converterdocumentData);
}

class Masail extends DataClass implements Insertable<Masail> {
  final String id;
  final String title;
  final String question;
  final String? answer;
  final String language;
  final bool hasAudio;
  final Map<dynamic, dynamic>? audioData;
  final Map<dynamic, dynamic>? documentData;
  final int position;
  final String? publishedAt;
  final String createdAt;
  final String updatedAt;
  final String? masailAuthorId;
  const Masail(
      {required this.id,
      required this.title,
      required this.question,
      this.answer,
      required this.language,
      required this.hasAudio,
      this.audioData,
      this.documentData,
      required this.position,
      this.publishedAt,
      required this.createdAt,
      required this.updatedAt,
      this.masailAuthorId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['question'] = Variable<String>(question);
    if (!nullToAbsent || answer != null) {
      map['answer'] = Variable<String>(answer);
    }
    map['language'] = Variable<String>(language);
    map['has_audio'] = Variable<bool>(hasAudio);
    if (!nullToAbsent || audioData != null) {
      final converter = $MasailsTable.$converteraudioDatan;
      map['audio_data'] = Variable<String>(converter.toSql(audioData));
    }
    if (!nullToAbsent || documentData != null) {
      final converter = $MasailsTable.$converterdocumentDatan;
      map['document_data'] = Variable<String>(converter.toSql(documentData));
    }
    map['position'] = Variable<int>(position);
    if (!nullToAbsent || publishedAt != null) {
      map['published_at'] = Variable<String>(publishedAt);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    if (!nullToAbsent || masailAuthorId != null) {
      map['masail_author_id'] = Variable<String>(masailAuthorId);
    }
    return map;
  }

  factory Masail.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Masail(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      question: serializer.fromJson<String>(json['question']),
      answer: serializer.fromJson<String?>(json['answer']),
      language: serializer.fromJson<String>(json['language']),
      hasAudio: serializer.fromJson<bool>(json['hasAudio']),
      audioData: serializer.fromJson<Map<dynamic, dynamic>?>(json['audio']),
      documentData:
          serializer.fromJson<Map<dynamic, dynamic>?>(json['document']),
      position: serializer.fromJson<int>(json['position']),
      publishedAt: serializer.fromJson<String?>(json['publishedAt']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      masailAuthorId: serializer.fromJson<String?>(json['masailAuthorId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'question': serializer.toJson<String>(question),
      'answer': serializer.toJson<String?>(answer),
      'language': serializer.toJson<String>(language),
      'hasAudio': serializer.toJson<bool>(hasAudio),
      'audio': serializer.toJson<Map<dynamic, dynamic>?>(audioData),
      'document': serializer.toJson<Map<dynamic, dynamic>?>(documentData),
      'position': serializer.toJson<int>(position),
      'publishedAt': serializer.toJson<String?>(publishedAt),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'masailAuthorId': serializer.toJson<String?>(masailAuthorId),
    };
  }

  Masail copyWith(
          {String? id,
          String? title,
          String? question,
          Value<String?> answer = const Value.absent(),
          String? language,
          bool? hasAudio,
          Value<Map<dynamic, dynamic>?> audioData = const Value.absent(),
          Value<Map<dynamic, dynamic>?> documentData = const Value.absent(),
          int? position,
          Value<String?> publishedAt = const Value.absent(),
          String? createdAt,
          String? updatedAt,
          Value<String?> masailAuthorId = const Value.absent()}) =>
      Masail(
        id: id ?? this.id,
        title: title ?? this.title,
        question: question ?? this.question,
        answer: answer.present ? answer.value : this.answer,
        language: language ?? this.language,
        hasAudio: hasAudio ?? this.hasAudio,
        audioData: audioData.present ? audioData.value : this.audioData,
        documentData:
            documentData.present ? documentData.value : this.documentData,
        position: position ?? this.position,
        publishedAt: publishedAt.present ? publishedAt.value : this.publishedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        masailAuthorId:
            masailAuthorId.present ? masailAuthorId.value : this.masailAuthorId,
      );
  @override
  String toString() {
    return (StringBuffer('Masail(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('question: $question, ')
          ..write('answer: $answer, ')
          ..write('language: $language, ')
          ..write('hasAudio: $hasAudio, ')
          ..write('audioData: $audioData, ')
          ..write('documentData: $documentData, ')
          ..write('position: $position, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('masailAuthorId: $masailAuthorId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      question,
      answer,
      language,
      hasAudio,
      audioData,
      documentData,
      position,
      publishedAt,
      createdAt,
      updatedAt,
      masailAuthorId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Masail &&
          other.id == this.id &&
          other.title == this.title &&
          other.question == this.question &&
          other.answer == this.answer &&
          other.language == this.language &&
          other.hasAudio == this.hasAudio &&
          other.audioData == this.audioData &&
          other.documentData == this.documentData &&
          other.position == this.position &&
          other.publishedAt == this.publishedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.masailAuthorId == this.masailAuthorId);
}

class MasailsCompanion extends UpdateCompanion<Masail> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> question;
  final Value<String?> answer;
  final Value<String> language;
  final Value<bool> hasAudio;
  final Value<Map<dynamic, dynamic>?> audioData;
  final Value<Map<dynamic, dynamic>?> documentData;
  final Value<int> position;
  final Value<String?> publishedAt;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String?> masailAuthorId;
  final Value<int> rowid;
  const MasailsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.question = const Value.absent(),
    this.answer = const Value.absent(),
    this.language = const Value.absent(),
    this.hasAudio = const Value.absent(),
    this.audioData = const Value.absent(),
    this.documentData = const Value.absent(),
    this.position = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.masailAuthorId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MasailsCompanion.insert({
    required String id,
    required String title,
    required String question,
    this.answer = const Value.absent(),
    required String language,
    this.hasAudio = const Value.absent(),
    this.audioData = const Value.absent(),
    this.documentData = const Value.absent(),
    required int position,
    this.publishedAt = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.masailAuthorId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        question = Value(question),
        language = Value(language),
        position = Value(position),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Masail> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? question,
    Expression<String>? answer,
    Expression<String>? language,
    Expression<bool>? hasAudio,
    Expression<String>? audioData,
    Expression<String>? documentData,
    Expression<int>? position,
    Expression<String>? publishedAt,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? masailAuthorId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (question != null) 'question': question,
      if (answer != null) 'answer': answer,
      if (language != null) 'language': language,
      if (hasAudio != null) 'has_audio': hasAudio,
      if (audioData != null) 'audio_data': audioData,
      if (documentData != null) 'document_data': documentData,
      if (position != null) 'position': position,
      if (publishedAt != null) 'published_at': publishedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (masailAuthorId != null) 'masail_author_id': masailAuthorId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MasailsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? question,
      Value<String?>? answer,
      Value<String>? language,
      Value<bool>? hasAudio,
      Value<Map<dynamic, dynamic>?>? audioData,
      Value<Map<dynamic, dynamic>?>? documentData,
      Value<int>? position,
      Value<String?>? publishedAt,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<String?>? masailAuthorId,
      Value<int>? rowid}) {
    return MasailsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      language: language ?? this.language,
      hasAudio: hasAudio ?? this.hasAudio,
      audioData: audioData ?? this.audioData,
      documentData: documentData ?? this.documentData,
      position: position ?? this.position,
      publishedAt: publishedAt ?? this.publishedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      masailAuthorId: masailAuthorId ?? this.masailAuthorId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (question.present) {
      map['question'] = Variable<String>(question.value);
    }
    if (answer.present) {
      map['answer'] = Variable<String>(answer.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (hasAudio.present) {
      map['has_audio'] = Variable<bool>(hasAudio.value);
    }
    if (audioData.present) {
      final converter = $MasailsTable.$converteraudioDatan;
      map['audio_data'] = Variable<String>(converter.toSql(audioData.value));
    }
    if (documentData.present) {
      final converter = $MasailsTable.$converterdocumentDatan;
      map['document_data'] =
          Variable<String>(converter.toSql(documentData.value));
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<String>(publishedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (masailAuthorId.present) {
      map['masail_author_id'] = Variable<String>(masailAuthorId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MasailsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('question: $question, ')
          ..write('answer: $answer, ')
          ..write('language: $language, ')
          ..write('hasAudio: $hasAudio, ')
          ..write('audioData: $audioData, ')
          ..write('documentData: $documentData, ')
          ..write('position: $position, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('masailAuthorId: $masailAuthorId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DuaCategoriesTable extends DuaCategories
    with TableInfo<$DuaCategoriesTable, DuaCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DuaCategoriesTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, position, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? 'dua_categories';
  @override
  String get actualTableName => 'dua_categories';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DuaCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DuaCategory(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $DuaCategoriesTable createAlias(String alias) {
    return $DuaCategoriesTable(attachedDatabase, alias);
  }
}

class DuaCategory extends DataClass implements Insertable<DuaCategory> {
  final String id;
  final String title;
  final int position;
  final String createdAt;
  final String updatedAt;
  const DuaCategory(
      {required this.id,
      required this.title,
      required this.position,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['position'] = Variable<int>(position);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  factory DuaCategory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DuaCategory(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      position: serializer.fromJson<int>(json['position']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'position': serializer.toJson<int>(position),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  DuaCategory copyWith(
          {String? id,
          String? title,
          int? position,
          String? createdAt,
          String? updatedAt}) =>
      DuaCategory(
        id: id ?? this.id,
        title: title ?? this.title,
        position: position ?? this.position,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('DuaCategory(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, position, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DuaCategory &&
          other.id == this.id &&
          other.title == this.title &&
          other.position == this.position &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DuaCategoriesCompanion extends UpdateCompanion<DuaCategory> {
  final Value<String> id;
  final Value<String> title;
  final Value<int> position;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const DuaCategoriesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DuaCategoriesCompanion.insert({
    required String id,
    required String title,
    required int position,
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        position = Value(position),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<DuaCategory> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<int>? position,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DuaCategoriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<int>? position,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<int>? rowid}) {
    return DuaCategoriesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DuaCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DuasTable extends Duas with TableInfo<$DuasTable, Dua> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DuasTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> excerpt = GeneratedColumn<String>(
      'excerpt', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<Map<dynamic, dynamic>?, String>
      audioData = GeneratedColumn<String>('audio_data', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Map<dynamic, dynamic>?>(
              $DuasTable.$converteraudioDatan);
  @override
  late final GeneratedColumnWithTypeConverter<Map<dynamic, dynamic>?, String>
      documentData = GeneratedColumn<String>('document_data', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Map<dynamic, dynamic>?>(
              $DuasTable.$converterdocumentDatan);
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        body,
        excerpt,
        language,
        audioData,
        documentData,
        position,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? 'duas';
  @override
  String get actualTableName => 'duas';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Dua map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Dua(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      excerpt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}excerpt']),
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
      audioData: $DuasTable.$converteraudioDatan.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}audio_data'])),
      documentData: $DuasTable.$converterdocumentDatan.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}document_data'])),
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $DuasTable createAlias(String alias) {
    return $DuasTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<dynamic, dynamic>, String> $converteraudioData =
      const FileData();
  static TypeConverter<Map<dynamic, dynamic>?, String?> $converteraudioDatan =
      NullAwareTypeConverter.wrap($converteraudioData);
  static TypeConverter<Map<dynamic, dynamic>, String> $converterdocumentData =
      const FileData();
  static TypeConverter<Map<dynamic, dynamic>?, String?>
      $converterdocumentDatan =
      NullAwareTypeConverter.wrap($converterdocumentData);
}

class Dua extends DataClass implements Insertable<Dua> {
  final String id;
  final String title;
  final String body;
  final String? excerpt;
  final String language;
  final Map<dynamic, dynamic>? audioData;
  final Map<dynamic, dynamic>? documentData;
  final int position;
  final String createdAt;
  final String updatedAt;
  const Dua(
      {required this.id,
      required this.title,
      required this.body,
      this.excerpt,
      required this.language,
      this.audioData,
      this.documentData,
      required this.position,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    if (!nullToAbsent || excerpt != null) {
      map['excerpt'] = Variable<String>(excerpt);
    }
    map['language'] = Variable<String>(language);
    if (!nullToAbsent || audioData != null) {
      final converter = $DuasTable.$converteraudioDatan;
      map['audio_data'] = Variable<String>(converter.toSql(audioData));
    }
    if (!nullToAbsent || documentData != null) {
      final converter = $DuasTable.$converterdocumentDatan;
      map['document_data'] = Variable<String>(converter.toSql(documentData));
    }
    map['position'] = Variable<int>(position);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  factory Dua.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Dua(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      excerpt: serializer.fromJson<String?>(json['excerpt']),
      language: serializer.fromJson<String>(json['language']),
      audioData: serializer.fromJson<Map<dynamic, dynamic>?>(json['audio']),
      documentData:
          serializer.fromJson<Map<dynamic, dynamic>?>(json['document']),
      position: serializer.fromJson<int>(json['position']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'excerpt': serializer.toJson<String?>(excerpt),
      'language': serializer.toJson<String>(language),
      'audio': serializer.toJson<Map<dynamic, dynamic>?>(audioData),
      'document': serializer.toJson<Map<dynamic, dynamic>?>(documentData),
      'position': serializer.toJson<int>(position),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  Dua copyWith(
          {String? id,
          String? title,
          String? body,
          Value<String?> excerpt = const Value.absent(),
          String? language,
          Value<Map<dynamic, dynamic>?> audioData = const Value.absent(),
          Value<Map<dynamic, dynamic>?> documentData = const Value.absent(),
          int? position,
          String? createdAt,
          String? updatedAt}) =>
      Dua(
        id: id ?? this.id,
        title: title ?? this.title,
        body: body ?? this.body,
        excerpt: excerpt.present ? excerpt.value : this.excerpt,
        language: language ?? this.language,
        audioData: audioData.present ? audioData.value : this.audioData,
        documentData:
            documentData.present ? documentData.value : this.documentData,
        position: position ?? this.position,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('Dua(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('excerpt: $excerpt, ')
          ..write('language: $language, ')
          ..write('audioData: $audioData, ')
          ..write('documentData: $documentData, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, body, excerpt, language, audioData,
      documentData, position, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Dua &&
          other.id == this.id &&
          other.title == this.title &&
          other.body == this.body &&
          other.excerpt == this.excerpt &&
          other.language == this.language &&
          other.audioData == this.audioData &&
          other.documentData == this.documentData &&
          other.position == this.position &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DuasCompanion extends UpdateCompanion<Dua> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> body;
  final Value<String?> excerpt;
  final Value<String> language;
  final Value<Map<dynamic, dynamic>?> audioData;
  final Value<Map<dynamic, dynamic>?> documentData;
  final Value<int> position;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const DuasCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.excerpt = const Value.absent(),
    this.language = const Value.absent(),
    this.audioData = const Value.absent(),
    this.documentData = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DuasCompanion.insert({
    required String id,
    required String title,
    required String body,
    this.excerpt = const Value.absent(),
    required String language,
    this.audioData = const Value.absent(),
    this.documentData = const Value.absent(),
    required int position,
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        body = Value(body),
        language = Value(language),
        position = Value(position),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Dua> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? excerpt,
    Expression<String>? language,
    Expression<String>? audioData,
    Expression<String>? documentData,
    Expression<int>? position,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (excerpt != null) 'excerpt': excerpt,
      if (language != null) 'language': language,
      if (audioData != null) 'audio_data': audioData,
      if (documentData != null) 'document_data': documentData,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DuasCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? body,
      Value<String?>? excerpt,
      Value<String>? language,
      Value<Map<dynamic, dynamic>?>? audioData,
      Value<Map<dynamic, dynamic>?>? documentData,
      Value<int>? position,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<int>? rowid}) {
    return DuasCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      excerpt: excerpt ?? this.excerpt,
      language: language ?? this.language,
      audioData: audioData ?? this.audioData,
      documentData: documentData ?? this.documentData,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (excerpt.present) {
      map['excerpt'] = Variable<String>(excerpt.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (audioData.present) {
      final converter = $DuasTable.$converteraudioDatan;
      map['audio_data'] = Variable<String>(converter.toSql(audioData.value));
    }
    if (documentData.present) {
      final converter = $DuasTable.$converterdocumentDatan;
      map['document_data'] =
          Variable<String>(converter.toSql(documentData.value));
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DuasCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('excerpt: $excerpt, ')
          ..write('language: $language, ')
          ..write('audioData: $audioData, ')
          ..write('documentData: $documentData, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DuaCategorizationsTable extends DuaCategorizations
    with TableInfo<$DuaCategorizationsTable, DuaCategorization> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DuaCategorizationsTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> duaId = GeneratedColumn<String>(
      'dua_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES duas (id)'));
  @override
  late final GeneratedColumn<String> duaCategoryId = GeneratedColumn<String>(
      'dua_category_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES dua_categories (id)'));
  @override
  List<GeneratedColumn> get $columns => [id, duaId, duaCategoryId];
  @override
  String get aliasedName => _alias ?? 'dua_categorizations';
  @override
  String get actualTableName => 'dua_categorizations';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DuaCategorization map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DuaCategorization(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      duaId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dua_id'])!,
      duaCategoryId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}dua_category_id'])!,
    );
  }

  @override
  $DuaCategorizationsTable createAlias(String alias) {
    return $DuaCategorizationsTable(attachedDatabase, alias);
  }
}

class DuaCategorization extends DataClass
    implements Insertable<DuaCategorization> {
  final String id;
  final String duaId;
  final String duaCategoryId;
  const DuaCategorization(
      {required this.id, required this.duaId, required this.duaCategoryId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['dua_id'] = Variable<String>(duaId);
    map['dua_category_id'] = Variable<String>(duaCategoryId);
    return map;
  }

  factory DuaCategorization.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DuaCategorization(
      id: serializer.fromJson<String>(json['id']),
      duaId: serializer.fromJson<String>(json['duaId']),
      duaCategoryId: serializer.fromJson<String>(json['duaCategoryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'duaId': serializer.toJson<String>(duaId),
      'duaCategoryId': serializer.toJson<String>(duaCategoryId),
    };
  }

  DuaCategorization copyWith(
          {String? id, String? duaId, String? duaCategoryId}) =>
      DuaCategorization(
        id: id ?? this.id,
        duaId: duaId ?? this.duaId,
        duaCategoryId: duaCategoryId ?? this.duaCategoryId,
      );
  @override
  String toString() {
    return (StringBuffer('DuaCategorization(')
          ..write('id: $id, ')
          ..write('duaId: $duaId, ')
          ..write('duaCategoryId: $duaCategoryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, duaId, duaCategoryId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DuaCategorization &&
          other.id == this.id &&
          other.duaId == this.duaId &&
          other.duaCategoryId == this.duaCategoryId);
}

class DuaCategorizationsCompanion extends UpdateCompanion<DuaCategorization> {
  final Value<String> id;
  final Value<String> duaId;
  final Value<String> duaCategoryId;
  final Value<int> rowid;
  const DuaCategorizationsCompanion({
    this.id = const Value.absent(),
    this.duaId = const Value.absent(),
    this.duaCategoryId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DuaCategorizationsCompanion.insert({
    required String id,
    required String duaId,
    required String duaCategoryId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        duaId = Value(duaId),
        duaCategoryId = Value(duaCategoryId);
  static Insertable<DuaCategorization> custom({
    Expression<String>? id,
    Expression<String>? duaId,
    Expression<String>? duaCategoryId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (duaId != null) 'dua_id': duaId,
      if (duaCategoryId != null) 'dua_category_id': duaCategoryId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DuaCategorizationsCompanion copyWith(
      {Value<String>? id,
      Value<String>? duaId,
      Value<String>? duaCategoryId,
      Value<int>? rowid}) {
    return DuaCategorizationsCompanion(
      id: id ?? this.id,
      duaId: duaId ?? this.duaId,
      duaCategoryId: duaCategoryId ?? this.duaCategoryId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (duaId.present) {
      map['dua_id'] = Variable<String>(duaId.value);
    }
    if (duaCategoryId.present) {
      map['dua_category_id'] = Variable<String>(duaCategoryId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DuaCategorizationsCompanion(')
          ..write('id: $id, ')
          ..write('duaId: $duaId, ')
          ..write('duaCategoryId: $duaCategoryId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ArticleAuthorsTable extends ArticleAuthors
    with TableInfo<$ArticleAuthorsTable, ArticleAuthor> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArticleAuthorsTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> info = GeneratedColumn<String>(
      'info', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, info, position, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? 'article_authors';
  @override
  String get actualTableName => 'article_authors';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ArticleAuthor map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ArticleAuthor(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      info: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}info']),
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ArticleAuthorsTable createAlias(String alias) {
    return $ArticleAuthorsTable(attachedDatabase, alias);
  }
}

class ArticleAuthor extends DataClass implements Insertable<ArticleAuthor> {
  final String id;
  final String name;
  final String? info;
  final int position;
  final String createdAt;
  final String updatedAt;
  const ArticleAuthor(
      {required this.id,
      required this.name,
      this.info,
      required this.position,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || info != null) {
      map['info'] = Variable<String>(info);
    }
    map['position'] = Variable<int>(position);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  factory ArticleAuthor.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ArticleAuthor(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      info: serializer.fromJson<String?>(json['info']),
      position: serializer.fromJson<int>(json['position']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'info': serializer.toJson<String?>(info),
      'position': serializer.toJson<int>(position),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  ArticleAuthor copyWith(
          {String? id,
          String? name,
          Value<String?> info = const Value.absent(),
          int? position,
          String? createdAt,
          String? updatedAt}) =>
      ArticleAuthor(
        id: id ?? this.id,
        name: name ?? this.name,
        info: info.present ? info.value : this.info,
        position: position ?? this.position,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('ArticleAuthor(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('info: $info, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, info, position, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ArticleAuthor &&
          other.id == this.id &&
          other.name == this.name &&
          other.info == this.info &&
          other.position == this.position &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ArticleAuthorsCompanion extends UpdateCompanion<ArticleAuthor> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> info;
  final Value<int> position;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const ArticleAuthorsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.info = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ArticleAuthorsCompanion.insert({
    required String id,
    required String name,
    this.info = const Value.absent(),
    required int position,
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        position = Value(position),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<ArticleAuthor> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? info,
    Expression<int>? position,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (info != null) 'info': info,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ArticleAuthorsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? info,
      Value<int>? position,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<int>? rowid}) {
    return ArticleAuthorsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      info: info ?? this.info,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (info.present) {
      map['info'] = Variable<String>(info.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArticleAuthorsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('info: $info, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ArticlesTable extends Articles with TableInfo<$ArticlesTable, Article> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArticlesTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> excerpt = GeneratedColumn<String>(
      'excerpt', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<Map<dynamic, dynamic>?, String>
      documentData = GeneratedColumn<String>('document_data', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Map<dynamic, dynamic>?>(
              $ArticlesTable.$converterdocumentDatan);
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> publishedAt = GeneratedColumn<String>(
      'published_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> articleAuthorId = GeneratedColumn<String>(
      'article_author_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES article_authors (id)'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        body,
        excerpt,
        language,
        documentData,
        position,
        publishedAt,
        createdAt,
        updatedAt,
        articleAuthorId
      ];
  @override
  String get aliasedName => _alias ?? 'articles';
  @override
  String get actualTableName => 'articles';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Article map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Article(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      excerpt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}excerpt']),
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
      documentData: $ArticlesTable.$converterdocumentDatan.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}document_data'])),
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      publishedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}published_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
      articleAuthorId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}article_author_id'])!,
    );
  }

  @override
  $ArticlesTable createAlias(String alias) {
    return $ArticlesTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<dynamic, dynamic>, String> $converterdocumentData =
      const FileData();
  static TypeConverter<Map<dynamic, dynamic>?, String?>
      $converterdocumentDatan =
      NullAwareTypeConverter.wrap($converterdocumentData);
}

class Article extends DataClass implements Insertable<Article> {
  final String id;
  final String title;
  final String body;
  final String? excerpt;
  final String language;
  final Map<dynamic, dynamic>? documentData;
  final int position;
  final String? publishedAt;
  final String createdAt;
  final String updatedAt;
  final String articleAuthorId;
  const Article(
      {required this.id,
      required this.title,
      required this.body,
      this.excerpt,
      required this.language,
      this.documentData,
      required this.position,
      this.publishedAt,
      required this.createdAt,
      required this.updatedAt,
      required this.articleAuthorId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    if (!nullToAbsent || excerpt != null) {
      map['excerpt'] = Variable<String>(excerpt);
    }
    map['language'] = Variable<String>(language);
    if (!nullToAbsent || documentData != null) {
      final converter = $ArticlesTable.$converterdocumentDatan;
      map['document_data'] = Variable<String>(converter.toSql(documentData));
    }
    map['position'] = Variable<int>(position);
    if (!nullToAbsent || publishedAt != null) {
      map['published_at'] = Variable<String>(publishedAt);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    map['article_author_id'] = Variable<String>(articleAuthorId);
    return map;
  }

  factory Article.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Article(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      excerpt: serializer.fromJson<String?>(json['excerpt']),
      language: serializer.fromJson<String>(json['language']),
      documentData:
          serializer.fromJson<Map<dynamic, dynamic>?>(json['document']),
      position: serializer.fromJson<int>(json['position']),
      publishedAt: serializer.fromJson<String?>(json['publishedAt']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      articleAuthorId: serializer.fromJson<String>(json['articleAuthorId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'excerpt': serializer.toJson<String?>(excerpt),
      'language': serializer.toJson<String>(language),
      'document': serializer.toJson<Map<dynamic, dynamic>?>(documentData),
      'position': serializer.toJson<int>(position),
      'publishedAt': serializer.toJson<String?>(publishedAt),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'articleAuthorId': serializer.toJson<String>(articleAuthorId),
    };
  }

  Article copyWith(
          {String? id,
          String? title,
          String? body,
          Value<String?> excerpt = const Value.absent(),
          String? language,
          Value<Map<dynamic, dynamic>?> documentData = const Value.absent(),
          int? position,
          Value<String?> publishedAt = const Value.absent(),
          String? createdAt,
          String? updatedAt,
          String? articleAuthorId}) =>
      Article(
        id: id ?? this.id,
        title: title ?? this.title,
        body: body ?? this.body,
        excerpt: excerpt.present ? excerpt.value : this.excerpt,
        language: language ?? this.language,
        documentData:
            documentData.present ? documentData.value : this.documentData,
        position: position ?? this.position,
        publishedAt: publishedAt.present ? publishedAt.value : this.publishedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        articleAuthorId: articleAuthorId ?? this.articleAuthorId,
      );
  @override
  String toString() {
    return (StringBuffer('Article(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('excerpt: $excerpt, ')
          ..write('language: $language, ')
          ..write('documentData: $documentData, ')
          ..write('position: $position, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('articleAuthorId: $articleAuthorId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      body,
      excerpt,
      language,
      documentData,
      position,
      publishedAt,
      createdAt,
      updatedAt,
      articleAuthorId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Article &&
          other.id == this.id &&
          other.title == this.title &&
          other.body == this.body &&
          other.excerpt == this.excerpt &&
          other.language == this.language &&
          other.documentData == this.documentData &&
          other.position == this.position &&
          other.publishedAt == this.publishedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.articleAuthorId == this.articleAuthorId);
}

class ArticlesCompanion extends UpdateCompanion<Article> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> body;
  final Value<String?> excerpt;
  final Value<String> language;
  final Value<Map<dynamic, dynamic>?> documentData;
  final Value<int> position;
  final Value<String?> publishedAt;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String> articleAuthorId;
  final Value<int> rowid;
  const ArticlesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.excerpt = const Value.absent(),
    this.language = const Value.absent(),
    this.documentData = const Value.absent(),
    this.position = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.articleAuthorId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ArticlesCompanion.insert({
    required String id,
    required String title,
    required String body,
    this.excerpt = const Value.absent(),
    required String language,
    this.documentData = const Value.absent(),
    required int position,
    this.publishedAt = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    required String articleAuthorId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        body = Value(body),
        language = Value(language),
        position = Value(position),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        articleAuthorId = Value(articleAuthorId);
  static Insertable<Article> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? excerpt,
    Expression<String>? language,
    Expression<String>? documentData,
    Expression<int>? position,
    Expression<String>? publishedAt,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? articleAuthorId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (excerpt != null) 'excerpt': excerpt,
      if (language != null) 'language': language,
      if (documentData != null) 'document_data': documentData,
      if (position != null) 'position': position,
      if (publishedAt != null) 'published_at': publishedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (articleAuthorId != null) 'article_author_id': articleAuthorId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ArticlesCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? body,
      Value<String?>? excerpt,
      Value<String>? language,
      Value<Map<dynamic, dynamic>?>? documentData,
      Value<int>? position,
      Value<String?>? publishedAt,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<String>? articleAuthorId,
      Value<int>? rowid}) {
    return ArticlesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      excerpt: excerpt ?? this.excerpt,
      language: language ?? this.language,
      documentData: documentData ?? this.documentData,
      position: position ?? this.position,
      publishedAt: publishedAt ?? this.publishedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      articleAuthorId: articleAuthorId ?? this.articleAuthorId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (excerpt.present) {
      map['excerpt'] = Variable<String>(excerpt.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (documentData.present) {
      final converter = $ArticlesTable.$converterdocumentDatan;
      map['document_data'] =
          Variable<String>(converter.toSql(documentData.value));
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<String>(publishedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (articleAuthorId.present) {
      map['article_author_id'] = Variable<String>(articleAuthorId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArticlesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('excerpt: $excerpt, ')
          ..write('language: $language, ')
          ..write('documentData: $documentData, ')
          ..write('position: $position, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('articleAuthorId: $articleAuthorId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MadrasahsTable extends Madrasahs
    with TableInfo<$MadrasahsTable, Madrasah> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MadrasahsTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> introduction = GeneratedColumn<String>(
      'introduction', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> excerpt = GeneratedColumn<String>(
      'excerpt', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<Map<dynamic, dynamic>?, String>
      documentData = GeneratedColumn<String>('document_data', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Map<dynamic, dynamic>?>(
              $MadrasahsTable.$converterdocumentDatan);
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        introduction,
        excerpt,
        documentData,
        position,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? 'madrasahs';
  @override
  String get actualTableName => 'madrasahs';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Madrasah map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Madrasah(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      introduction: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}introduction'])!,
      excerpt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}excerpt']),
      documentData: $MadrasahsTable.$converterdocumentDatan.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}document_data'])),
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $MadrasahsTable createAlias(String alias) {
    return $MadrasahsTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<dynamic, dynamic>, String> $converterdocumentData =
      const FileData();
  static TypeConverter<Map<dynamic, dynamic>?, String?>
      $converterdocumentDatan =
      NullAwareTypeConverter.wrap($converterdocumentData);
}

class Madrasah extends DataClass implements Insertable<Madrasah> {
  final String id;
  final String title;
  final String introduction;
  final String? excerpt;
  final Map<dynamic, dynamic>? documentData;
  final int position;
  final String createdAt;
  final String updatedAt;
  const Madrasah(
      {required this.id,
      required this.title,
      required this.introduction,
      this.excerpt,
      this.documentData,
      required this.position,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['introduction'] = Variable<String>(introduction);
    if (!nullToAbsent || excerpt != null) {
      map['excerpt'] = Variable<String>(excerpt);
    }
    if (!nullToAbsent || documentData != null) {
      final converter = $MadrasahsTable.$converterdocumentDatan;
      map['document_data'] = Variable<String>(converter.toSql(documentData));
    }
    map['position'] = Variable<int>(position);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  factory Madrasah.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Madrasah(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      introduction: serializer.fromJson<String>(json['introduction']),
      excerpt: serializer.fromJson<String?>(json['excerpt']),
      documentData:
          serializer.fromJson<Map<dynamic, dynamic>?>(json['document']),
      position: serializer.fromJson<int>(json['position']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'introduction': serializer.toJson<String>(introduction),
      'excerpt': serializer.toJson<String?>(excerpt),
      'document': serializer.toJson<Map<dynamic, dynamic>?>(documentData),
      'position': serializer.toJson<int>(position),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  Madrasah copyWith(
          {String? id,
          String? title,
          String? introduction,
          Value<String?> excerpt = const Value.absent(),
          Value<Map<dynamic, dynamic>?> documentData = const Value.absent(),
          int? position,
          String? createdAt,
          String? updatedAt}) =>
      Madrasah(
        id: id ?? this.id,
        title: title ?? this.title,
        introduction: introduction ?? this.introduction,
        excerpt: excerpt.present ? excerpt.value : this.excerpt,
        documentData:
            documentData.present ? documentData.value : this.documentData,
        position: position ?? this.position,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('Madrasah(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('introduction: $introduction, ')
          ..write('excerpt: $excerpt, ')
          ..write('documentData: $documentData, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, introduction, excerpt,
      documentData, position, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Madrasah &&
          other.id == this.id &&
          other.title == this.title &&
          other.introduction == this.introduction &&
          other.excerpt == this.excerpt &&
          other.documentData == this.documentData &&
          other.position == this.position &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MadrasahsCompanion extends UpdateCompanion<Madrasah> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> introduction;
  final Value<String?> excerpt;
  final Value<Map<dynamic, dynamic>?> documentData;
  final Value<int> position;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const MadrasahsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.introduction = const Value.absent(),
    this.excerpt = const Value.absent(),
    this.documentData = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MadrasahsCompanion.insert({
    required String id,
    required String title,
    required String introduction,
    this.excerpt = const Value.absent(),
    this.documentData = const Value.absent(),
    required int position,
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        introduction = Value(introduction),
        position = Value(position),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Madrasah> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? introduction,
    Expression<String>? excerpt,
    Expression<String>? documentData,
    Expression<int>? position,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (introduction != null) 'introduction': introduction,
      if (excerpt != null) 'excerpt': excerpt,
      if (documentData != null) 'document_data': documentData,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MadrasahsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? introduction,
      Value<String?>? excerpt,
      Value<Map<dynamic, dynamic>?>? documentData,
      Value<int>? position,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<int>? rowid}) {
    return MadrasahsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      introduction: introduction ?? this.introduction,
      excerpt: excerpt ?? this.excerpt,
      documentData: documentData ?? this.documentData,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (introduction.present) {
      map['introduction'] = Variable<String>(introduction.value);
    }
    if (excerpt.present) {
      map['excerpt'] = Variable<String>(excerpt.value);
    }
    if (documentData.present) {
      final converter = $MadrasahsTable.$converterdocumentDatan;
      map['document_data'] =
          Variable<String>(converter.toSql(documentData.value));
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MadrasahsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('introduction: $introduction, ')
          ..write('excerpt: $excerpt, ')
          ..write('documentData: $documentData, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MadrasahInfosTable extends MadrasahInfos
    with TableInfo<$MadrasahInfosTable, MadrasahInfo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MadrasahInfosTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
      'label', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> info = GeneratedColumn<String>(
      'info', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> madrasahId = GeneratedColumn<String>(
      'madrasah_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES madrasahs (id)'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, label, info, position, createdAt, updatedAt, madrasahId];
  @override
  String get aliasedName => _alias ?? 'madrasah_infos';
  @override
  String get actualTableName => 'madrasah_infos';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MadrasahInfo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MadrasahInfo(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      label: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label'])!,
      info: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}info'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
      madrasahId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}madrasah_id'])!,
    );
  }

  @override
  $MadrasahInfosTable createAlias(String alias) {
    return $MadrasahInfosTable(attachedDatabase, alias);
  }
}

class MadrasahInfo extends DataClass implements Insertable<MadrasahInfo> {
  final String id;
  final String label;
  final String info;
  final int position;
  final String createdAt;
  final String updatedAt;
  final String madrasahId;
  const MadrasahInfo(
      {required this.id,
      required this.label,
      required this.info,
      required this.position,
      required this.createdAt,
      required this.updatedAt,
      required this.madrasahId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['label'] = Variable<String>(label);
    map['info'] = Variable<String>(info);
    map['position'] = Variable<int>(position);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    map['madrasah_id'] = Variable<String>(madrasahId);
    return map;
  }

  factory MadrasahInfo.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MadrasahInfo(
      id: serializer.fromJson<String>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      info: serializer.fromJson<String>(json['info']),
      position: serializer.fromJson<int>(json['position']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      madrasahId: serializer.fromJson<String>(json['madrasahId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'label': serializer.toJson<String>(label),
      'info': serializer.toJson<String>(info),
      'position': serializer.toJson<int>(position),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'madrasahId': serializer.toJson<String>(madrasahId),
    };
  }

  MadrasahInfo copyWith(
          {String? id,
          String? label,
          String? info,
          int? position,
          String? createdAt,
          String? updatedAt,
          String? madrasahId}) =>
      MadrasahInfo(
        id: id ?? this.id,
        label: label ?? this.label,
        info: info ?? this.info,
        position: position ?? this.position,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        madrasahId: madrasahId ?? this.madrasahId,
      );
  @override
  String toString() {
    return (StringBuffer('MadrasahInfo(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('info: $info, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('madrasahId: $madrasahId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, label, info, position, createdAt, updatedAt, madrasahId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MadrasahInfo &&
          other.id == this.id &&
          other.label == this.label &&
          other.info == this.info &&
          other.position == this.position &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.madrasahId == this.madrasahId);
}

class MadrasahInfosCompanion extends UpdateCompanion<MadrasahInfo> {
  final Value<String> id;
  final Value<String> label;
  final Value<String> info;
  final Value<int> position;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String> madrasahId;
  final Value<int> rowid;
  const MadrasahInfosCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.info = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.madrasahId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MadrasahInfosCompanion.insert({
    required String id,
    required String label,
    required String info,
    required int position,
    required String createdAt,
    required String updatedAt,
    required String madrasahId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        label = Value(label),
        info = Value(info),
        position = Value(position),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        madrasahId = Value(madrasahId);
  static Insertable<MadrasahInfo> custom({
    Expression<String>? id,
    Expression<String>? label,
    Expression<String>? info,
    Expression<int>? position,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? madrasahId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (info != null) 'info': info,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (madrasahId != null) 'madrasah_id': madrasahId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MadrasahInfosCompanion copyWith(
      {Value<String>? id,
      Value<String>? label,
      Value<String>? info,
      Value<int>? position,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<String>? madrasahId,
      Value<int>? rowid}) {
    return MadrasahInfosCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      info: info ?? this.info,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      madrasahId: madrasahId ?? this.madrasahId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (info.present) {
      map['info'] = Variable<String>(info.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (madrasahId.present) {
      map['madrasah_id'] = Variable<String>(madrasahId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MadrasahInfosCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('info: $info, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('madrasahId: $madrasahId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NamazTimesTable extends NamazTimes
    with TableInfo<$NamazTimesTable, NamazTime> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NamazTimesTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> titleBn = GeneratedColumn<String>(
      'title_bn', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
      'slug', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> masail = GeneratedColumn<String>(
      'masail', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> fazail = GeneratedColumn<String>(
      'fazail', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        titleBn,
        slug,
        masail,
        fazail,
        position,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? 'namaz_times';
  @override
  String get actualTableName => 'namaz_times';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NamazTime map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NamazTime(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      titleBn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title_bn']),
      slug: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}slug'])!,
      masail: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}masail'])!,
      fazail: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fazail']),
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $NamazTimesTable createAlias(String alias) {
    return $NamazTimesTable(attachedDatabase, alias);
  }
}

class NamazTime extends DataClass implements Insertable<NamazTime> {
  final String id;
  final String title;
  final String? titleBn;
  final String slug;
  final String masail;
  final String? fazail;
  final int position;
  final String createdAt;
  final String updatedAt;
  const NamazTime(
      {required this.id,
      required this.title,
      this.titleBn,
      required this.slug,
      required this.masail,
      this.fazail,
      required this.position,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || titleBn != null) {
      map['title_bn'] = Variable<String>(titleBn);
    }
    map['slug'] = Variable<String>(slug);
    map['masail'] = Variable<String>(masail);
    if (!nullToAbsent || fazail != null) {
      map['fazail'] = Variable<String>(fazail);
    }
    map['position'] = Variable<int>(position);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  factory NamazTime.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NamazTime(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      titleBn: serializer.fromJson<String?>(json['titleBn']),
      slug: serializer.fromJson<String>(json['slug']),
      masail: serializer.fromJson<String>(json['masail']),
      fazail: serializer.fromJson<String?>(json['fazail']),
      position: serializer.fromJson<int>(json['position']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'titleBn': serializer.toJson<String?>(titleBn),
      'slug': serializer.toJson<String>(slug),
      'masail': serializer.toJson<String>(masail),
      'fazail': serializer.toJson<String?>(fazail),
      'position': serializer.toJson<int>(position),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  NamazTime copyWith(
          {String? id,
          String? title,
          Value<String?> titleBn = const Value.absent(),
          String? slug,
          String? masail,
          Value<String?> fazail = const Value.absent(),
          int? position,
          String? createdAt,
          String? updatedAt}) =>
      NamazTime(
        id: id ?? this.id,
        title: title ?? this.title,
        titleBn: titleBn.present ? titleBn.value : this.titleBn,
        slug: slug ?? this.slug,
        masail: masail ?? this.masail,
        fazail: fazail.present ? fazail.value : this.fazail,
        position: position ?? this.position,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('NamazTime(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('titleBn: $titleBn, ')
          ..write('slug: $slug, ')
          ..write('masail: $masail, ')
          ..write('fazail: $fazail, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, title, titleBn, slug, masail, fazail, position, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NamazTime &&
          other.id == this.id &&
          other.title == this.title &&
          other.titleBn == this.titleBn &&
          other.slug == this.slug &&
          other.masail == this.masail &&
          other.fazail == this.fazail &&
          other.position == this.position &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class NamazTimesCompanion extends UpdateCompanion<NamazTime> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> titleBn;
  final Value<String> slug;
  final Value<String> masail;
  final Value<String?> fazail;
  final Value<int> position;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const NamazTimesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.titleBn = const Value.absent(),
    this.slug = const Value.absent(),
    this.masail = const Value.absent(),
    this.fazail = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NamazTimesCompanion.insert({
    required String id,
    required String title,
    this.titleBn = const Value.absent(),
    required String slug,
    required String masail,
    this.fazail = const Value.absent(),
    required int position,
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        slug = Value(slug),
        masail = Value(masail),
        position = Value(position),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<NamazTime> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? titleBn,
    Expression<String>? slug,
    Expression<String>? masail,
    Expression<String>? fazail,
    Expression<int>? position,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (titleBn != null) 'title_bn': titleBn,
      if (slug != null) 'slug': slug,
      if (masail != null) 'masail': masail,
      if (fazail != null) 'fazail': fazail,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NamazTimesCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String?>? titleBn,
      Value<String>? slug,
      Value<String>? masail,
      Value<String?>? fazail,
      Value<int>? position,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<int>? rowid}) {
    return NamazTimesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      titleBn: titleBn ?? this.titleBn,
      slug: slug ?? this.slug,
      masail: masail ?? this.masail,
      fazail: fazail ?? this.fazail,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (titleBn.present) {
      map['title_bn'] = Variable<String>(titleBn.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (masail.present) {
      map['masail'] = Variable<String>(masail.value);
    }
    if (fazail.present) {
      map['fazail'] = Variable<String>(fazail.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NamazTimesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('titleBn: $titleBn, ')
          ..write('slug: $slug, ')
          ..write('masail: $masail, ')
          ..write('fazail: $fazail, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NewsTable extends News with TableInfo<$NewsTable, New> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NewsTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> excerpt = GeneratedColumn<String>(
      'excerpt', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> publishedAt = GeneratedColumn<String>(
      'published_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, body, excerpt, language, publishedAt, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? 'news';
  @override
  String get actualTableName => 'news';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  New map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return New(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      excerpt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}excerpt']),
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
      publishedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}published_at'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $NewsTable createAlias(String alias) {
    return $NewsTable(attachedDatabase, alias);
  }
}

class New extends DataClass implements Insertable<New> {
  final String id;
  final String title;
  final String body;
  final String? excerpt;
  final String language;
  final String publishedAt;
  final String createdAt;
  final String updatedAt;
  const New(
      {required this.id,
      required this.title,
      required this.body,
      this.excerpt,
      required this.language,
      required this.publishedAt,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    if (!nullToAbsent || excerpt != null) {
      map['excerpt'] = Variable<String>(excerpt);
    }
    map['language'] = Variable<String>(language);
    map['published_at'] = Variable<String>(publishedAt);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  factory New.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return New(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      excerpt: serializer.fromJson<String?>(json['excerpt']),
      language: serializer.fromJson<String>(json['language']),
      publishedAt: serializer.fromJson<String>(json['publishedAt']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'excerpt': serializer.toJson<String?>(excerpt),
      'language': serializer.toJson<String>(language),
      'publishedAt': serializer.toJson<String>(publishedAt),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  New copyWith(
          {String? id,
          String? title,
          String? body,
          Value<String?> excerpt = const Value.absent(),
          String? language,
          String? publishedAt,
          String? createdAt,
          String? updatedAt}) =>
      New(
        id: id ?? this.id,
        title: title ?? this.title,
        body: body ?? this.body,
        excerpt: excerpt.present ? excerpt.value : this.excerpt,
        language: language ?? this.language,
        publishedAt: publishedAt ?? this.publishedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('New(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('excerpt: $excerpt, ')
          ..write('language: $language, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, title, body, excerpt, language, publishedAt, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is New &&
          other.id == this.id &&
          other.title == this.title &&
          other.body == this.body &&
          other.excerpt == this.excerpt &&
          other.language == this.language &&
          other.publishedAt == this.publishedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class NewsCompanion extends UpdateCompanion<New> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> body;
  final Value<String?> excerpt;
  final Value<String> language;
  final Value<String> publishedAt;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const NewsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.excerpt = const Value.absent(),
    this.language = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NewsCompanion.insert({
    required String id,
    required String title,
    required String body,
    this.excerpt = const Value.absent(),
    required String language,
    required String publishedAt,
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        body = Value(body),
        language = Value(language),
        publishedAt = Value(publishedAt),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<New> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? excerpt,
    Expression<String>? language,
    Expression<String>? publishedAt,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (excerpt != null) 'excerpt': excerpt,
      if (language != null) 'language': language,
      if (publishedAt != null) 'published_at': publishedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NewsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? body,
      Value<String?>? excerpt,
      Value<String>? language,
      Value<String>? publishedAt,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<int>? rowid}) {
    return NewsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      excerpt: excerpt ?? this.excerpt,
      language: language ?? this.language,
      publishedAt: publishedAt ?? this.publishedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (excerpt.present) {
      map['excerpt'] = Variable<String>(excerpt.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<String>(publishedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NewsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('excerpt: $excerpt, ')
          ..write('language: $language, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PagesTable extends Pages with TableInfo<$PagesTable, Page> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PagesTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
      'slug', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<Map<dynamic, dynamic>?, String>
      imageData = GeneratedColumn<String>('image_data', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Map<dynamic, dynamic>?>(
              $PagesTable.$converterimageDatan);
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, slug, body, imageData, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? 'pages';
  @override
  String get actualTableName => 'pages';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Page map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Page(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      slug: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}slug'])!,
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      imageData: $PagesTable.$converterimageDatan.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_data'])),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $PagesTable createAlias(String alias) {
    return $PagesTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<dynamic, dynamic>, String> $converterimageData =
      const FileData();
  static TypeConverter<Map<dynamic, dynamic>?, String?> $converterimageDatan =
      NullAwareTypeConverter.wrap($converterimageData);
}

class Page extends DataClass implements Insertable<Page> {
  final String id;
  final String title;
  final String slug;
  final String body;
  final Map<dynamic, dynamic>? imageData;
  final String createdAt;
  final String updatedAt;
  const Page(
      {required this.id,
      required this.title,
      required this.slug,
      required this.body,
      this.imageData,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['slug'] = Variable<String>(slug);
    map['body'] = Variable<String>(body);
    if (!nullToAbsent || imageData != null) {
      final converter = $PagesTable.$converterimageDatan;
      map['image_data'] = Variable<String>(converter.toSql(imageData));
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  factory Page.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Page(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      slug: serializer.fromJson<String>(json['slug']),
      body: serializer.fromJson<String>(json['body']),
      imageData: serializer.fromJson<Map<dynamic, dynamic>?>(json['image']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'slug': serializer.toJson<String>(slug),
      'body': serializer.toJson<String>(body),
      'image': serializer.toJson<Map<dynamic, dynamic>?>(imageData),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  Page copyWith(
          {String? id,
          String? title,
          String? slug,
          String? body,
          Value<Map<dynamic, dynamic>?> imageData = const Value.absent(),
          String? createdAt,
          String? updatedAt}) =>
      Page(
        id: id ?? this.id,
        title: title ?? this.title,
        slug: slug ?? this.slug,
        body: body ?? this.body,
        imageData: imageData.present ? imageData.value : this.imageData,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('Page(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('slug: $slug, ')
          ..write('body: $body, ')
          ..write('imageData: $imageData, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, slug, body, imageData, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Page &&
          other.id == this.id &&
          other.title == this.title &&
          other.slug == this.slug &&
          other.body == this.body &&
          other.imageData == this.imageData &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PagesCompanion extends UpdateCompanion<Page> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> slug;
  final Value<String> body;
  final Value<Map<dynamic, dynamic>?> imageData;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const PagesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.slug = const Value.absent(),
    this.body = const Value.absent(),
    this.imageData = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PagesCompanion.insert({
    required String id,
    required String title,
    required String slug,
    required String body,
    this.imageData = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        slug = Value(slug),
        body = Value(body),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Page> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? slug,
    Expression<String>? body,
    Expression<String>? imageData,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (slug != null) 'slug': slug,
      if (body != null) 'body': body,
      if (imageData != null) 'image_data': imageData,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PagesCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? slug,
      Value<String>? body,
      Value<Map<dynamic, dynamic>?>? imageData,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<int>? rowid}) {
    return PagesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      body: body ?? this.body,
      imageData: imageData ?? this.imageData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (imageData.present) {
      final converter = $PagesTable.$converterimageDatan;
      map['image_data'] = Variable<String>(converter.toSql(imageData.value));
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PagesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('slug: $slug, ')
          ..write('body: $body, ')
          ..write('imageData: $imageData, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuranBooksTable extends QuranBooks
    with TableInfo<$QuranBooksTable, QuranBook> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuranBooksTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, position, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? 'quran_books';
  @override
  String get actualTableName => 'quran_books';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuranBook map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuranBook(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $QuranBooksTable createAlias(String alias) {
    return $QuranBooksTable(attachedDatabase, alias);
  }
}

class QuranBook extends DataClass implements Insertable<QuranBook> {
  final String id;
  final String title;
  final int position;
  final String createdAt;
  final String updatedAt;
  const QuranBook(
      {required this.id,
      required this.title,
      required this.position,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['position'] = Variable<int>(position);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  factory QuranBook.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuranBook(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      position: serializer.fromJson<int>(json['position']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'position': serializer.toJson<int>(position),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  QuranBook copyWith(
          {String? id,
          String? title,
          int? position,
          String? createdAt,
          String? updatedAt}) =>
      QuranBook(
        id: id ?? this.id,
        title: title ?? this.title,
        position: position ?? this.position,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('QuranBook(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, position, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuranBook &&
          other.id == this.id &&
          other.title == this.title &&
          other.position == this.position &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class QuranBooksCompanion extends UpdateCompanion<QuranBook> {
  final Value<String> id;
  final Value<String> title;
  final Value<int> position;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const QuranBooksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuranBooksCompanion.insert({
    required String id,
    required String title,
    required int position,
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        position = Value(position),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<QuranBook> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<int>? position,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuranBooksCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<int>? position,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<int>? rowid}) {
    return QuranBooksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuranBooksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuranBookQitabsTable extends QuranBookQitabs
    with TableInfo<$QuranBookQitabsTable, QuranBookQitab> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuranBookQitabsTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> titleBn = GeneratedColumn<String>(
      'title_bn', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<Map<dynamic, dynamic>?, String>
      imageData = GeneratedColumn<String>('image_data', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Map<dynamic, dynamic>?>(
              $QuranBookQitabsTable.$converterimageDatan);
  @override
  late final GeneratedColumnWithTypeConverter<Map<dynamic, dynamic>?, String>
      documentData = GeneratedColumn<String>('document_data', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Map<dynamic, dynamic>?>(
              $QuranBookQitabsTable.$converterdocumentDatan);
  @override
  late final GeneratedColumn<bool> published =
      GeneratedColumn<bool>('published', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("published" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(false));
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> quranBookId = GeneratedColumn<String>(
      'quran_book_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES quran_books (id)'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        titleBn,
        imageData,
        documentData,
        published,
        position,
        createdAt,
        updatedAt,
        quranBookId
      ];
  @override
  String get aliasedName => _alias ?? 'quran_book_qitabs';
  @override
  String get actualTableName => 'quran_book_qitabs';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuranBookQitab map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuranBookQitab(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      titleBn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title_bn']),
      imageData: $QuranBookQitabsTable.$converterimageDatan.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.string, data['${effectivePrefix}image_data'])),
      documentData: $QuranBookQitabsTable.$converterdocumentDatan.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}document_data'])),
      published: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}published'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
      quranBookId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}quran_book_id'])!,
    );
  }

  @override
  $QuranBookQitabsTable createAlias(String alias) {
    return $QuranBookQitabsTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<dynamic, dynamic>, String> $converterimageData =
      const FileData();
  static TypeConverter<Map<dynamic, dynamic>?, String?> $converterimageDatan =
      NullAwareTypeConverter.wrap($converterimageData);
  static TypeConverter<Map<dynamic, dynamic>, String> $converterdocumentData =
      const FileData();
  static TypeConverter<Map<dynamic, dynamic>?, String?>
      $converterdocumentDatan =
      NullAwareTypeConverter.wrap($converterdocumentData);
}

class QuranBookQitab extends DataClass implements Insertable<QuranBookQitab> {
  final String id;
  final String title;
  final String? titleBn;
  final Map<dynamic, dynamic>? imageData;
  final Map<dynamic, dynamic>? documentData;
  final bool published;
  final int position;
  final String createdAt;
  final String updatedAt;
  final String quranBookId;
  const QuranBookQitab(
      {required this.id,
      required this.title,
      this.titleBn,
      this.imageData,
      this.documentData,
      required this.published,
      required this.position,
      required this.createdAt,
      required this.updatedAt,
      required this.quranBookId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || titleBn != null) {
      map['title_bn'] = Variable<String>(titleBn);
    }
    if (!nullToAbsent || imageData != null) {
      final converter = $QuranBookQitabsTable.$converterimageDatan;
      map['image_data'] = Variable<String>(converter.toSql(imageData));
    }
    if (!nullToAbsent || documentData != null) {
      final converter = $QuranBookQitabsTable.$converterdocumentDatan;
      map['document_data'] = Variable<String>(converter.toSql(documentData));
    }
    map['published'] = Variable<bool>(published);
    map['position'] = Variable<int>(position);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    map['quran_book_id'] = Variable<String>(quranBookId);
    return map;
  }

  factory QuranBookQitab.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuranBookQitab(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      titleBn: serializer.fromJson<String?>(json['titleBn']),
      imageData: serializer.fromJson<Map<dynamic, dynamic>?>(json['image']),
      documentData:
          serializer.fromJson<Map<dynamic, dynamic>?>(json['document']),
      published: serializer.fromJson<bool>(json['published']),
      position: serializer.fromJson<int>(json['position']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      quranBookId: serializer.fromJson<String>(json['quranBookId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'titleBn': serializer.toJson<String?>(titleBn),
      'image': serializer.toJson<Map<dynamic, dynamic>?>(imageData),
      'document': serializer.toJson<Map<dynamic, dynamic>?>(documentData),
      'published': serializer.toJson<bool>(published),
      'position': serializer.toJson<int>(position),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'quranBookId': serializer.toJson<String>(quranBookId),
    };
  }

  QuranBookQitab copyWith(
          {String? id,
          String? title,
          Value<String?> titleBn = const Value.absent(),
          Value<Map<dynamic, dynamic>?> imageData = const Value.absent(),
          Value<Map<dynamic, dynamic>?> documentData = const Value.absent(),
          bool? published,
          int? position,
          String? createdAt,
          String? updatedAt,
          String? quranBookId}) =>
      QuranBookQitab(
        id: id ?? this.id,
        title: title ?? this.title,
        titleBn: titleBn.present ? titleBn.value : this.titleBn,
        imageData: imageData.present ? imageData.value : this.imageData,
        documentData:
            documentData.present ? documentData.value : this.documentData,
        published: published ?? this.published,
        position: position ?? this.position,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        quranBookId: quranBookId ?? this.quranBookId,
      );
  @override
  String toString() {
    return (StringBuffer('QuranBookQitab(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('titleBn: $titleBn, ')
          ..write('imageData: $imageData, ')
          ..write('documentData: $documentData, ')
          ..write('published: $published, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('quranBookId: $quranBookId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, titleBn, imageData, documentData,
      published, position, createdAt, updatedAt, quranBookId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuranBookQitab &&
          other.id == this.id &&
          other.title == this.title &&
          other.titleBn == this.titleBn &&
          other.imageData == this.imageData &&
          other.documentData == this.documentData &&
          other.published == this.published &&
          other.position == this.position &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.quranBookId == this.quranBookId);
}

class QuranBookQitabsCompanion extends UpdateCompanion<QuranBookQitab> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> titleBn;
  final Value<Map<dynamic, dynamic>?> imageData;
  final Value<Map<dynamic, dynamic>?> documentData;
  final Value<bool> published;
  final Value<int> position;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String> quranBookId;
  final Value<int> rowid;
  const QuranBookQitabsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.titleBn = const Value.absent(),
    this.imageData = const Value.absent(),
    this.documentData = const Value.absent(),
    this.published = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.quranBookId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuranBookQitabsCompanion.insert({
    required String id,
    required String title,
    this.titleBn = const Value.absent(),
    this.imageData = const Value.absent(),
    this.documentData = const Value.absent(),
    this.published = const Value.absent(),
    required int position,
    required String createdAt,
    required String updatedAt,
    required String quranBookId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        position = Value(position),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        quranBookId = Value(quranBookId);
  static Insertable<QuranBookQitab> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? titleBn,
    Expression<String>? imageData,
    Expression<String>? documentData,
    Expression<bool>? published,
    Expression<int>? position,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? quranBookId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (titleBn != null) 'title_bn': titleBn,
      if (imageData != null) 'image_data': imageData,
      if (documentData != null) 'document_data': documentData,
      if (published != null) 'published': published,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (quranBookId != null) 'quran_book_id': quranBookId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuranBookQitabsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String?>? titleBn,
      Value<Map<dynamic, dynamic>?>? imageData,
      Value<Map<dynamic, dynamic>?>? documentData,
      Value<bool>? published,
      Value<int>? position,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<String>? quranBookId,
      Value<int>? rowid}) {
    return QuranBookQitabsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      titleBn: titleBn ?? this.titleBn,
      imageData: imageData ?? this.imageData,
      documentData: documentData ?? this.documentData,
      published: published ?? this.published,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      quranBookId: quranBookId ?? this.quranBookId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (titleBn.present) {
      map['title_bn'] = Variable<String>(titleBn.value);
    }
    if (imageData.present) {
      final converter = $QuranBookQitabsTable.$converterimageDatan;
      map['image_data'] = Variable<String>(converter.toSql(imageData.value));
    }
    if (documentData.present) {
      final converter = $QuranBookQitabsTable.$converterdocumentDatan;
      map['document_data'] =
          Variable<String>(converter.toSql(documentData.value));
    }
    if (published.present) {
      map['published'] = Variable<bool>(published.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (quranBookId.present) {
      map['quran_book_id'] = Variable<String>(quranBookId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuranBookQitabsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('titleBn: $titleBn, ')
          ..write('imageData: $imageData, ')
          ..write('documentData: $documentData, ')
          ..write('published: $published, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('quranBookId: $quranBookId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuranBookPagesTable extends QuranBookPages
    with TableInfo<$QuranBookPagesTable, QuranBookPage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuranBookPagesTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<int> paraPage = GeneratedColumn<int>(
      'para_page', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> quranBookId = GeneratedColumn<String>(
      'quran_book_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES quran_books (id)'));
  @override
  late final GeneratedColumn<String> paraId = GeneratedColumn<String>(
      'para_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES paras (id)'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        paraPage,
        position,
        createdAt,
        updatedAt,
        quranBookId,
        paraId
      ];
  @override
  String get aliasedName => _alias ?? 'quran_book_pages';
  @override
  String get actualTableName => 'quran_book_pages';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuranBookPage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuranBookPage(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      paraPage: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}para_page'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
      quranBookId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}quran_book_id'])!,
      paraId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}para_id'])!,
    );
  }

  @override
  $QuranBookPagesTable createAlias(String alias) {
    return $QuranBookPagesTable(attachedDatabase, alias);
  }
}

class QuranBookPage extends DataClass implements Insertable<QuranBookPage> {
  final String id;
  final String title;
  final int paraPage;
  final int position;
  final String createdAt;
  final String updatedAt;
  final String quranBookId;
  final String paraId;
  const QuranBookPage(
      {required this.id,
      required this.title,
      required this.paraPage,
      required this.position,
      required this.createdAt,
      required this.updatedAt,
      required this.quranBookId,
      required this.paraId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['para_page'] = Variable<int>(paraPage);
    map['position'] = Variable<int>(position);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    map['quran_book_id'] = Variable<String>(quranBookId);
    map['para_id'] = Variable<String>(paraId);
    return map;
  }

  factory QuranBookPage.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuranBookPage(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      paraPage: serializer.fromJson<int>(json['paraPage']),
      position: serializer.fromJson<int>(json['position']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      quranBookId: serializer.fromJson<String>(json['quranBookId']),
      paraId: serializer.fromJson<String>(json['paraId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'paraPage': serializer.toJson<int>(paraPage),
      'position': serializer.toJson<int>(position),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'quranBookId': serializer.toJson<String>(quranBookId),
      'paraId': serializer.toJson<String>(paraId),
    };
  }

  QuranBookPage copyWith(
          {String? id,
          String? title,
          int? paraPage,
          int? position,
          String? createdAt,
          String? updatedAt,
          String? quranBookId,
          String? paraId}) =>
      QuranBookPage(
        id: id ?? this.id,
        title: title ?? this.title,
        paraPage: paraPage ?? this.paraPage,
        position: position ?? this.position,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        quranBookId: quranBookId ?? this.quranBookId,
        paraId: paraId ?? this.paraId,
      );
  @override
  String toString() {
    return (StringBuffer('QuranBookPage(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('paraPage: $paraPage, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('quranBookId: $quranBookId, ')
          ..write('paraId: $paraId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, title, paraPage, position, createdAt, updatedAt, quranBookId, paraId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuranBookPage &&
          other.id == this.id &&
          other.title == this.title &&
          other.paraPage == this.paraPage &&
          other.position == this.position &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.quranBookId == this.quranBookId &&
          other.paraId == this.paraId);
}

class QuranBookPagesCompanion extends UpdateCompanion<QuranBookPage> {
  final Value<String> id;
  final Value<String> title;
  final Value<int> paraPage;
  final Value<int> position;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String> quranBookId;
  final Value<String> paraId;
  final Value<int> rowid;
  const QuranBookPagesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.paraPage = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.quranBookId = const Value.absent(),
    this.paraId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuranBookPagesCompanion.insert({
    required String id,
    required String title,
    required int paraPage,
    required int position,
    required String createdAt,
    required String updatedAt,
    required String quranBookId,
    required String paraId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        paraPage = Value(paraPage),
        position = Value(position),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        quranBookId = Value(quranBookId),
        paraId = Value(paraId);
  static Insertable<QuranBookPage> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<int>? paraPage,
    Expression<int>? position,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? quranBookId,
    Expression<String>? paraId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (paraPage != null) 'para_page': paraPage,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (quranBookId != null) 'quran_book_id': quranBookId,
      if (paraId != null) 'para_id': paraId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuranBookPagesCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<int>? paraPage,
      Value<int>? position,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<String>? quranBookId,
      Value<String>? paraId,
      Value<int>? rowid}) {
    return QuranBookPagesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      paraPage: paraPage ?? this.paraPage,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      quranBookId: quranBookId ?? this.quranBookId,
      paraId: paraId ?? this.paraId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (paraPage.present) {
      map['para_page'] = Variable<int>(paraPage.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (quranBookId.present) {
      map['quran_book_id'] = Variable<String>(quranBookId.value);
    }
    if (paraId.present) {
      map['para_id'] = Variable<String>(paraId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuranBookPagesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('paraPage: $paraPage, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('quranBookId: $quranBookId, ')
          ..write('paraId: $paraId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuranBookSurahsTable extends QuranBookSurahs
    with TableInfo<$QuranBookSurahsTable, QuranBookSurah> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuranBookSurahsTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<int> startAyah = GeneratedColumn<int>(
      'start_ayah', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<int> endAyah = GeneratedColumn<int>(
      'end_ayah', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> quranBookPageId = GeneratedColumn<String>(
      'quran_book_page_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES quran_book_pages (id)'));
  @override
  late final GeneratedColumn<String> surahId = GeneratedColumn<String>(
      'surah_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES surahs (id)'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        startAyah,
        endAyah,
        position,
        createdAt,
        updatedAt,
        quranBookPageId,
        surahId
      ];
  @override
  String get aliasedName => _alias ?? 'quran_book_surahs';
  @override
  String get actualTableName => 'quran_book_surahs';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuranBookSurah map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuranBookSurah(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      startAyah: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}start_ayah'])!,
      endAyah: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}end_ayah'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
      quranBookPageId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}quran_book_page_id'])!,
      surahId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}surah_id'])!,
    );
  }

  @override
  $QuranBookSurahsTable createAlias(String alias) {
    return $QuranBookSurahsTable(attachedDatabase, alias);
  }
}

class QuranBookSurah extends DataClass implements Insertable<QuranBookSurah> {
  final String id;
  final int startAyah;
  final int endAyah;
  final int position;
  final String createdAt;
  final String updatedAt;
  final String quranBookPageId;
  final String surahId;
  const QuranBookSurah(
      {required this.id,
      required this.startAyah,
      required this.endAyah,
      required this.position,
      required this.createdAt,
      required this.updatedAt,
      required this.quranBookPageId,
      required this.surahId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['start_ayah'] = Variable<int>(startAyah);
    map['end_ayah'] = Variable<int>(endAyah);
    map['position'] = Variable<int>(position);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    map['quran_book_page_id'] = Variable<String>(quranBookPageId);
    map['surah_id'] = Variable<String>(surahId);
    return map;
  }

  factory QuranBookSurah.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuranBookSurah(
      id: serializer.fromJson<String>(json['id']),
      startAyah: serializer.fromJson<int>(json['startAyah']),
      endAyah: serializer.fromJson<int>(json['endAyah']),
      position: serializer.fromJson<int>(json['position']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      quranBookPageId: serializer.fromJson<String>(json['quranBookPageId']),
      surahId: serializer.fromJson<String>(json['surahId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'startAyah': serializer.toJson<int>(startAyah),
      'endAyah': serializer.toJson<int>(endAyah),
      'position': serializer.toJson<int>(position),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'quranBookPageId': serializer.toJson<String>(quranBookPageId),
      'surahId': serializer.toJson<String>(surahId),
    };
  }

  QuranBookSurah copyWith(
          {String? id,
          int? startAyah,
          int? endAyah,
          int? position,
          String? createdAt,
          String? updatedAt,
          String? quranBookPageId,
          String? surahId}) =>
      QuranBookSurah(
        id: id ?? this.id,
        startAyah: startAyah ?? this.startAyah,
        endAyah: endAyah ?? this.endAyah,
        position: position ?? this.position,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        quranBookPageId: quranBookPageId ?? this.quranBookPageId,
        surahId: surahId ?? this.surahId,
      );
  @override
  String toString() {
    return (StringBuffer('QuranBookSurah(')
          ..write('id: $id, ')
          ..write('startAyah: $startAyah, ')
          ..write('endAyah: $endAyah, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('quranBookPageId: $quranBookPageId, ')
          ..write('surahId: $surahId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, startAyah, endAyah, position, createdAt,
      updatedAt, quranBookPageId, surahId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuranBookSurah &&
          other.id == this.id &&
          other.startAyah == this.startAyah &&
          other.endAyah == this.endAyah &&
          other.position == this.position &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.quranBookPageId == this.quranBookPageId &&
          other.surahId == this.surahId);
}

class QuranBookSurahsCompanion extends UpdateCompanion<QuranBookSurah> {
  final Value<String> id;
  final Value<int> startAyah;
  final Value<int> endAyah;
  final Value<int> position;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String> quranBookPageId;
  final Value<String> surahId;
  final Value<int> rowid;
  const QuranBookSurahsCompanion({
    this.id = const Value.absent(),
    this.startAyah = const Value.absent(),
    this.endAyah = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.quranBookPageId = const Value.absent(),
    this.surahId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuranBookSurahsCompanion.insert({
    required String id,
    required int startAyah,
    required int endAyah,
    required int position,
    required String createdAt,
    required String updatedAt,
    required String quranBookPageId,
    required String surahId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        startAyah = Value(startAyah),
        endAyah = Value(endAyah),
        position = Value(position),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        quranBookPageId = Value(quranBookPageId),
        surahId = Value(surahId);
  static Insertable<QuranBookSurah> custom({
    Expression<String>? id,
    Expression<int>? startAyah,
    Expression<int>? endAyah,
    Expression<int>? position,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? quranBookPageId,
    Expression<String>? surahId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startAyah != null) 'start_ayah': startAyah,
      if (endAyah != null) 'end_ayah': endAyah,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (quranBookPageId != null) 'quran_book_page_id': quranBookPageId,
      if (surahId != null) 'surah_id': surahId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuranBookSurahsCompanion copyWith(
      {Value<String>? id,
      Value<int>? startAyah,
      Value<int>? endAyah,
      Value<int>? position,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<String>? quranBookPageId,
      Value<String>? surahId,
      Value<int>? rowid}) {
    return QuranBookSurahsCompanion(
      id: id ?? this.id,
      startAyah: startAyah ?? this.startAyah,
      endAyah: endAyah ?? this.endAyah,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      quranBookPageId: quranBookPageId ?? this.quranBookPageId,
      surahId: surahId ?? this.surahId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (startAyah.present) {
      map['start_ayah'] = Variable<int>(startAyah.value);
    }
    if (endAyah.present) {
      map['end_ayah'] = Variable<int>(endAyah.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (quranBookPageId.present) {
      map['quran_book_page_id'] = Variable<String>(quranBookPageId.value);
    }
    if (surahId.present) {
      map['surah_id'] = Variable<String>(surahId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuranBookSurahsCompanion(')
          ..write('id: $id, ')
          ..write('startAyah: $startAyah, ')
          ..write('endAyah: $endAyah, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('quranBookPageId: $quranBookPageId, ')
          ..write('surahId: $surahId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuranBookParasTable extends QuranBookParas
    with TableInfo<$QuranBookParasTable, QuranBookPara> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuranBookParasTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<int> totalPage = GeneratedColumn<int>(
      'total_page', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> quranBookId = GeneratedColumn<String>(
      'quran_book_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES quran_books (id)'));
  @override
  late final GeneratedColumn<String> paraId = GeneratedColumn<String>(
      'para_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES paras (id)'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, totalPage, position, createdAt, updatedAt, quranBookId, paraId];
  @override
  String get aliasedName => _alias ?? 'quran_book_paras';
  @override
  String get actualTableName => 'quran_book_paras';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuranBookPara map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuranBookPara(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      totalPage: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_page'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
      quranBookId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}quran_book_id'])!,
      paraId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}para_id'])!,
    );
  }

  @override
  $QuranBookParasTable createAlias(String alias) {
    return $QuranBookParasTable(attachedDatabase, alias);
  }
}

class QuranBookPara extends DataClass implements Insertable<QuranBookPara> {
  final String id;
  final int totalPage;
  final int position;
  final String createdAt;
  final String updatedAt;
  final String quranBookId;
  final String paraId;
  const QuranBookPara(
      {required this.id,
      required this.totalPage,
      required this.position,
      required this.createdAt,
      required this.updatedAt,
      required this.quranBookId,
      required this.paraId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['total_page'] = Variable<int>(totalPage);
    map['position'] = Variable<int>(position);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    map['quran_book_id'] = Variable<String>(quranBookId);
    map['para_id'] = Variable<String>(paraId);
    return map;
  }

  factory QuranBookPara.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuranBookPara(
      id: serializer.fromJson<String>(json['id']),
      totalPage: serializer.fromJson<int>(json['totalPage']),
      position: serializer.fromJson<int>(json['position']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      quranBookId: serializer.fromJson<String>(json['quranBookId']),
      paraId: serializer.fromJson<String>(json['paraId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'totalPage': serializer.toJson<int>(totalPage),
      'position': serializer.toJson<int>(position),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'quranBookId': serializer.toJson<String>(quranBookId),
      'paraId': serializer.toJson<String>(paraId),
    };
  }

  QuranBookPara copyWith(
          {String? id,
          int? totalPage,
          int? position,
          String? createdAt,
          String? updatedAt,
          String? quranBookId,
          String? paraId}) =>
      QuranBookPara(
        id: id ?? this.id,
        totalPage: totalPage ?? this.totalPage,
        position: position ?? this.position,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        quranBookId: quranBookId ?? this.quranBookId,
        paraId: paraId ?? this.paraId,
      );
  @override
  String toString() {
    return (StringBuffer('QuranBookPara(')
          ..write('id: $id, ')
          ..write('totalPage: $totalPage, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('quranBookId: $quranBookId, ')
          ..write('paraId: $paraId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, totalPage, position, createdAt, updatedAt, quranBookId, paraId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuranBookPara &&
          other.id == this.id &&
          other.totalPage == this.totalPage &&
          other.position == this.position &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.quranBookId == this.quranBookId &&
          other.paraId == this.paraId);
}

class QuranBookParasCompanion extends UpdateCompanion<QuranBookPara> {
  final Value<String> id;
  final Value<int> totalPage;
  final Value<int> position;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String> quranBookId;
  final Value<String> paraId;
  final Value<int> rowid;
  const QuranBookParasCompanion({
    this.id = const Value.absent(),
    this.totalPage = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.quranBookId = const Value.absent(),
    this.paraId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuranBookParasCompanion.insert({
    required String id,
    required int totalPage,
    required int position,
    required String createdAt,
    required String updatedAt,
    required String quranBookId,
    required String paraId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        totalPage = Value(totalPage),
        position = Value(position),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        quranBookId = Value(quranBookId),
        paraId = Value(paraId);
  static Insertable<QuranBookPara> custom({
    Expression<String>? id,
    Expression<int>? totalPage,
    Expression<int>? position,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? quranBookId,
    Expression<String>? paraId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (totalPage != null) 'total_page': totalPage,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (quranBookId != null) 'quran_book_id': quranBookId,
      if (paraId != null) 'para_id': paraId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuranBookParasCompanion copyWith(
      {Value<String>? id,
      Value<int>? totalPage,
      Value<int>? position,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<String>? quranBookId,
      Value<String>? paraId,
      Value<int>? rowid}) {
    return QuranBookParasCompanion(
      id: id ?? this.id,
      totalPage: totalPage ?? this.totalPage,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      quranBookId: quranBookId ?? this.quranBookId,
      paraId: paraId ?? this.paraId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (totalPage.present) {
      map['total_page'] = Variable<int>(totalPage.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (quranBookId.present) {
      map['quran_book_id'] = Variable<String>(quranBookId.value);
    }
    if (paraId.present) {
      map['para_id'] = Variable<String>(paraId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuranBookParasCompanion(')
          ..write('id: $id, ')
          ..write('totalPage: $totalPage, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('quranBookId: $quranBookId, ')
          ..write('paraId: $paraId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$LocalResourceAPI extends GeneratedDatabase {
  _$LocalResourceAPI(QueryExecutor e) : super(e);
  late final $SurahsTable surahs = $SurahsTable(this);
  late final $ParasTable paras = $ParasTable(this);
  late final $AyahsTable ayahs = $AyahsTable(this);
  late final $AyahTranslationsTable ayahTranslations =
      $AyahTranslationsTable(this);
  late final $QarisTable qaris = $QarisTable(this);
  late final $TafseerQitabsTable tafseerQitabs = $TafseerQitabsTable(this);
  late final $TafseersTable tafseers = $TafseersTable(this);
  late final $BooksTable books = $BooksTable(this);
  late final $ChaptersTable chapters = $ChaptersTable(this);
  late final $SubchaptersTable subchapters = $SubchaptersTable(this);
  late final $AuthorsTable authors = $AuthorsTable(this);
  late final $BooksAuthorsTable booksAuthors = $BooksAuthorsTable(this);
  late final $SpeakersTable speakers = $SpeakersTable(this);
  late final $BayansTable bayans = $BayansTable(this);
  late final $MalfuzatAuthorsTable malfuzatAuthors =
      $MalfuzatAuthorsTable(this);
  late final $MalfuzatsTable malfuzats = $MalfuzatsTable(this);
  late final $MasailAuthorsTable masailAuthors = $MasailAuthorsTable(this);
  late final $MasailsTable masails = $MasailsTable(this);
  late final $DuaCategoriesTable duaCategories = $DuaCategoriesTable(this);
  late final $DuasTable duas = $DuasTable(this);
  late final $DuaCategorizationsTable duaCategorizations =
      $DuaCategorizationsTable(this);
  late final $ArticleAuthorsTable articleAuthors = $ArticleAuthorsTable(this);
  late final $ArticlesTable articles = $ArticlesTable(this);
  late final $MadrasahsTable madrasahs = $MadrasahsTable(this);
  late final $MadrasahInfosTable madrasahInfos = $MadrasahInfosTable(this);
  late final $NamazTimesTable namazTimes = $NamazTimesTable(this);
  late final $NewsTable news = $NewsTable(this);
  late final $PagesTable pages = $PagesTable(this);
  late final $QuranBooksTable quranBooks = $QuranBooksTable(this);
  late final $QuranBookQitabsTable quranBookQitabs =
      $QuranBookQitabsTable(this);
  late final $QuranBookPagesTable quranBookPages = $QuranBookPagesTable(this);
  late final $QuranBookSurahsTable quranBookSurahs =
      $QuranBookSurahsTable(this);
  late final $QuranBookParasTable quranBookParas = $QuranBookParasTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        surahs,
        paras,
        ayahs,
        ayahTranslations,
        qaris,
        tafseerQitabs,
        tafseers,
        books,
        chapters,
        subchapters,
        authors,
        booksAuthors,
        speakers,
        bayans,
        malfuzatAuthors,
        malfuzats,
        masailAuthors,
        masails,
        duaCategories,
        duas,
        duaCategorizations,
        articleAuthors,
        articles,
        madrasahs,
        madrasahInfos,
        namazTimes,
        news,
        pages,
        quranBooks,
        quranBookQitabs,
        quranBookPages,
        quranBookSurahs,
        quranBookParas
      ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}
