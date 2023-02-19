// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// **************************************************************************
// DriftDatabaseGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Surah extends DataClass implements Insertable<Surah> {
  final String id;
  final String title;
  final String titleBn;
  final String slug;
  final String? excerpt;
  final int totalAyat;
  final int totalRuku;
  final String? introduction;
  final int position;
  final String createdAt;
  final String updatedAt;
  const Surah(
      {required this.id,
      required this.title,
      required this.titleBn,
      required this.slug,
      this.excerpt,
      required this.totalAyat,
      required this.totalRuku,
      this.introduction,
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
    if (!nullToAbsent || excerpt != null) {
      map['excerpt'] = Variable<String>(excerpt);
    }
    map['total_ayat'] = Variable<int>(totalAyat);
    map['total_ruku'] = Variable<int>(totalRuku);
    if (!nullToAbsent || introduction != null) {
      map['introduction'] = Variable<String>(introduction);
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
      excerpt: serializer.fromJson<String?>(json['excerpt']),
      totalAyat: serializer.fromJson<int>(json['totalAyat']),
      totalRuku: serializer.fromJson<int>(json['totalRuku']),
      introduction: serializer.fromJson<String?>(json['introduction']),
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
      'excerpt': serializer.toJson<String?>(excerpt),
      'totalAyat': serializer.toJson<int>(totalAyat),
      'totalRuku': serializer.toJson<int>(totalRuku),
      'introduction': serializer.toJson<String?>(introduction),
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
          Value<String?> excerpt = const Value.absent(),
          int? totalAyat,
          int? totalRuku,
          Value<String?> introduction = const Value.absent(),
          int? position,
          String? createdAt,
          String? updatedAt}) =>
      Surah(
        id: id ?? this.id,
        title: title ?? this.title,
        titleBn: titleBn ?? this.titleBn,
        slug: slug ?? this.slug,
        excerpt: excerpt.present ? excerpt.value : this.excerpt,
        totalAyat: totalAyat ?? this.totalAyat,
        totalRuku: totalRuku ?? this.totalRuku,
        introduction:
            introduction.present ? introduction.value : this.introduction,
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
          ..write('excerpt: $excerpt, ')
          ..write('totalAyat: $totalAyat, ')
          ..write('totalRuku: $totalRuku, ')
          ..write('introduction: $introduction, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, titleBn, slug, excerpt, totalAyat,
      totalRuku, introduction, position, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Surah &&
          other.id == this.id &&
          other.title == this.title &&
          other.titleBn == this.titleBn &&
          other.slug == this.slug &&
          other.excerpt == this.excerpt &&
          other.totalAyat == this.totalAyat &&
          other.totalRuku == this.totalRuku &&
          other.introduction == this.introduction &&
          other.position == this.position &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SurahsCompanion extends UpdateCompanion<Surah> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> titleBn;
  final Value<String> slug;
  final Value<String?> excerpt;
  final Value<int> totalAyat;
  final Value<int> totalRuku;
  final Value<String?> introduction;
  final Value<int> position;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  const SurahsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.titleBn = const Value.absent(),
    this.slug = const Value.absent(),
    this.excerpt = const Value.absent(),
    this.totalAyat = const Value.absent(),
    this.totalRuku = const Value.absent(),
    this.introduction = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  SurahsCompanion.insert({
    required String id,
    required String title,
    required String titleBn,
    required String slug,
    this.excerpt = const Value.absent(),
    required int totalAyat,
    required int totalRuku,
    this.introduction = const Value.absent(),
    required int position,
    required String createdAt,
    required String updatedAt,
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
    Expression<String>? excerpt,
    Expression<int>? totalAyat,
    Expression<int>? totalRuku,
    Expression<String>? introduction,
    Expression<int>? position,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (titleBn != null) 'title_bn': titleBn,
      if (slug != null) 'slug': slug,
      if (excerpt != null) 'excerpt': excerpt,
      if (totalAyat != null) 'total_ayat': totalAyat,
      if (totalRuku != null) 'total_ruku': totalRuku,
      if (introduction != null) 'introduction': introduction,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  SurahsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? titleBn,
      Value<String>? slug,
      Value<String?>? excerpt,
      Value<int>? totalAyat,
      Value<int>? totalRuku,
      Value<String?>? introduction,
      Value<int>? position,
      Value<String>? createdAt,
      Value<String>? updatedAt}) {
    return SurahsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      titleBn: titleBn ?? this.titleBn,
      slug: slug ?? this.slug,
      excerpt: excerpt ?? this.excerpt,
      totalAyat: totalAyat ?? this.totalAyat,
      totalRuku: totalRuku ?? this.totalRuku,
      introduction: introduction ?? this.introduction,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (excerpt.present) {
      map['excerpt'] = Variable<String>(excerpt.value);
    }
    if (totalAyat.present) {
      map['total_ayat'] = Variable<int>(totalAyat.value);
    }
    if (totalRuku.present) {
      map['total_ruku'] = Variable<int>(totalRuku.value);
    }
    if (introduction.present) {
      map['introduction'] = Variable<String>(introduction.value);
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SurahsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('titleBn: $titleBn, ')
          ..write('slug: $slug, ')
          ..write('excerpt: $excerpt, ')
          ..write('totalAyat: $totalAyat, ')
          ..write('totalRuku: $totalRuku, ')
          ..write('introduction: $introduction, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

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
  late final GeneratedColumn<String> introduction = GeneratedColumn<String>(
      'introduction', aliasedName, true,
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
        excerpt,
        totalAyat,
        totalRuku,
        introduction,
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
      id: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      titleBn: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}title_bn'])!,
      slug: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}slug'])!,
      excerpt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}excerpt']),
      totalAyat: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}total_ayat'])!,
      totalRuku: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}total_ruku'])!,
      introduction: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}introduction']),
      position: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      createdAt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SurahsTable createAlias(String alias) {
    return $SurahsTable(attachedDatabase, alias);
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
      Value<String>? updatedAt}) {
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
          ..write('updatedAt: $updatedAt')
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
      id: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      titleBn: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}title_bn'])!,
      slug: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}slug'])!,
      totalAyat: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}total_ayat'])!,
      totalRuku: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}total_ruku'])!,
      position: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      createdAt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ParasTable createAlias(String alias) {
    return $ParasTable(attachedDatabase, alias);
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
      Value<String>? paraId}) {
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
          ..write('paraId: $paraId')
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
      defaultConstraints: 'REFERENCES surahs (id)');
  @override
  late final GeneratedColumn<String> paraId = GeneratedColumn<String>(
      'para_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: 'REFERENCES paras (id)');
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
      id: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      surahPosition: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}surah_position'])!,
      paraPosition: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}para_position'])!,
      ruku: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}ruku']),
      createdAt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
      surahId: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}surah_id'])!,
      paraId: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}para_id'])!,
    );
  }

  @override
  $AyahsTable createAlias(String alias) {
    return $AyahsTable(attachedDatabase, alias);
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
  const AyahTranslationsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.ayahId = const Value.absent(),
  });
  AyahTranslationsCompanion.insert({
    required String id,
    required String title,
    required String body,
    required String createdAt,
    required String updatedAt,
    required String ayahId,
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
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (ayahId != null) 'ayah_id': ayahId,
    });
  }

  AyahTranslationsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? body,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<String>? ayahId}) {
    return AyahTranslationsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      ayahId: ayahId ?? this.ayahId,
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
          ..write('ayahId: $ayahId')
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
      defaultConstraints: 'REFERENCES ayahs (id)');
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
      id: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      body: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      createdAt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
      ayahId: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}ayah_id'])!,
    );
  }

  @override
  $AyahTranslationsTable createAlias(String alias) {
    return $AyahTranslationsTable(attachedDatabase, alias);
  }
}

class Book extends DataClass implements Insertable<Book> {
  final String id;
  final String title;
  final String slug;
  final String? excerpt;
  final String? publisher;
  final String? price;
  final String language;
  final String? imageData;
  final String? documentData;
  final int position;
  final String? publishedAt;
  final String createdAt;
  final String updatedAt;
  const Book(
      {required this.id,
      required this.title,
      required this.slug,
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
    map['slug'] = Variable<String>(slug);
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
      map['image_data'] = Variable<String>(imageData);
    }
    if (!nullToAbsent || documentData != null) {
      map['document_data'] = Variable<String>(documentData);
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
      slug: serializer.fromJson<String>(json['slug']),
      excerpt: serializer.fromJson<String?>(json['excerpt']),
      publisher: serializer.fromJson<String?>(json['publisher']),
      price: serializer.fromJson<String?>(json['price']),
      language: serializer.fromJson<String>(json['language']),
      imageData: serializer.fromJson<String?>(json['imageData']),
      documentData: serializer.fromJson<String?>(json['documentData']),
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
      'slug': serializer.toJson<String>(slug),
      'excerpt': serializer.toJson<String?>(excerpt),
      'publisher': serializer.toJson<String?>(publisher),
      'price': serializer.toJson<String?>(price),
      'language': serializer.toJson<String>(language),
      'imageData': serializer.toJson<String?>(imageData),
      'documentData': serializer.toJson<String?>(documentData),
      'position': serializer.toJson<int>(position),
      'publishedAt': serializer.toJson<String?>(publishedAt),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  Book copyWith(
          {String? id,
          String? title,
          String? slug,
          Value<String?> excerpt = const Value.absent(),
          Value<String?> publisher = const Value.absent(),
          Value<String?> price = const Value.absent(),
          String? language,
          Value<String?> imageData = const Value.absent(),
          Value<String?> documentData = const Value.absent(),
          int? position,
          Value<String?> publishedAt = const Value.absent(),
          String? createdAt,
          String? updatedAt}) =>
      Book(
        id: id ?? this.id,
        title: title ?? this.title,
        slug: slug ?? this.slug,
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
          ..write('slug: $slug, ')
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
      slug,
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
          other.slug == this.slug &&
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
  final Value<String> slug;
  final Value<String?> excerpt;
  final Value<String?> publisher;
  final Value<String?> price;
  final Value<String> language;
  final Value<String?> imageData;
  final Value<String?> documentData;
  final Value<int> position;
  final Value<String?> publishedAt;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  const BooksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.slug = const Value.absent(),
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
  });
  BooksCompanion.insert({
    required String id,
    required String title,
    required String slug,
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
  })  : id = Value(id),
        title = Value(title),
        slug = Value(slug),
        language = Value(language),
        position = Value(position),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Book> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? slug,
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
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (slug != null) 'slug': slug,
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
    });
  }

  BooksCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? slug,
      Value<String?>? excerpt,
      Value<String?>? publisher,
      Value<String?>? price,
      Value<String>? language,
      Value<String?>? imageData,
      Value<String?>? documentData,
      Value<int>? position,
      Value<String?>? publishedAt,
      Value<String>? createdAt,
      Value<String>? updatedAt}) {
    return BooksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      slug: slug ?? this.slug,
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
      map['image_data'] = Variable<String>(imageData.value);
    }
    if (documentData.present) {
      map['document_data'] = Variable<String>(documentData.value);
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BooksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('slug: $slug, ')
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
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
      'slug', aliasedName, false,
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
  late final GeneratedColumn<String> imageData = GeneratedColumn<String>(
      'image_data', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> documentData = GeneratedColumn<String>(
      'document_data', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
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
        slug,
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
      id: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      slug: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}slug'])!,
      excerpt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}excerpt']),
      publisher: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}publisher']),
      price: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}price']),
      language: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
      imageData: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}image_data']),
      documentData: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}document_data']),
      position: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      publishedAt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}published_at']),
      createdAt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $BooksTable createAlias(String alias) {
    return $BooksTable(attachedDatabase, alias);
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
  const ChaptersCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.bookId = const Value.absent(),
  });
  ChaptersCompanion.insert({
    required String id,
    required String title,
    this.body = const Value.absent(),
    required int position,
    required String createdAt,
    required String updatedAt,
    required String bookId,
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
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (bookId != null) 'book_id': bookId,
    });
  }

  ChaptersCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String?>? body,
      Value<int>? position,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<String>? bookId}) {
    return ChaptersCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      bookId: bookId ?? this.bookId,
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
          ..write('bookId: $bookId')
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
      defaultConstraints: 'REFERENCES books (id)');
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
      id: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      body: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}body']),
      position: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      createdAt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
      bookId: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}book_id'])!,
    );
  }

  @override
  $ChaptersTable createAlias(String alias) {
    return $ChaptersTable(attachedDatabase, alias);
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
  const SubchaptersCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.chapterId = const Value.absent(),
  });
  SubchaptersCompanion.insert({
    required String id,
    required String title,
    required String body,
    required int position,
    required String createdAt,
    required String updatedAt,
    required String chapterId,
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
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (chapterId != null) 'chapter_id': chapterId,
    });
  }

  SubchaptersCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? body,
      Value<int>? position,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<String>? chapterId}) {
    return SubchaptersCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      chapterId: chapterId ?? this.chapterId,
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
          ..write('chapterId: $chapterId')
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
      defaultConstraints: 'REFERENCES chapters (id)');
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
      id: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      body: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      position: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      createdAt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
      chapterId: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}chapter_id'])!,
    );
  }

  @override
  $SubchaptersTable createAlias(String alias) {
    return $SubchaptersTable(attachedDatabase, alias);
  }
}

class Bayan extends DataClass implements Insertable<Bayan> {
  final String id;
  final String title;
  final String? excerpt;
  final String language;
  final String? location;
  final String? audioData;
  final String publishedAt;
  final String createdAt;
  final String updatedAt;
  const Bayan(
      {required this.id,
      required this.title,
      this.excerpt,
      required this.language,
      this.location,
      this.audioData,
      required this.publishedAt,
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
    map['language'] = Variable<String>(language);
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    if (!nullToAbsent || audioData != null) {
      map['audio_data'] = Variable<String>(audioData);
    }
    map['published_at'] = Variable<String>(publishedAt);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
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
      audioData: serializer.fromJson<String?>(json['audioData']),
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
      'excerpt': serializer.toJson<String?>(excerpt),
      'language': serializer.toJson<String>(language),
      'location': serializer.toJson<String?>(location),
      'audioData': serializer.toJson<String?>(audioData),
      'publishedAt': serializer.toJson<String>(publishedAt),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  Bayan copyWith(
          {String? id,
          String? title,
          Value<String?> excerpt = const Value.absent(),
          String? language,
          Value<String?> location = const Value.absent(),
          Value<String?> audioData = const Value.absent(),
          String? publishedAt,
          String? createdAt,
          String? updatedAt}) =>
      Bayan(
        id: id ?? this.id,
        title: title ?? this.title,
        excerpt: excerpt.present ? excerpt.value : this.excerpt,
        language: language ?? this.language,
        location: location.present ? location.value : this.location,
        audioData: audioData.present ? audioData.value : this.audioData,
        publishedAt: publishedAt ?? this.publishedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
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
          ..write('publishedAt: $publishedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, excerpt, language, location,
      audioData, publishedAt, createdAt, updatedAt);
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
          other.publishedAt == this.publishedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BayansCompanion extends UpdateCompanion<Bayan> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> excerpt;
  final Value<String> language;
  final Value<String?> location;
  final Value<String?> audioData;
  final Value<String> publishedAt;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  const BayansCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.excerpt = const Value.absent(),
    this.language = const Value.absent(),
    this.location = const Value.absent(),
    this.audioData = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  BayansCompanion.insert({
    required String id,
    required String title,
    this.excerpt = const Value.absent(),
    required String language,
    this.location = const Value.absent(),
    this.audioData = const Value.absent(),
    required String publishedAt,
    required String createdAt,
    required String updatedAt,
  })  : id = Value(id),
        title = Value(title),
        language = Value(language),
        publishedAt = Value(publishedAt),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Bayan> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? excerpt,
    Expression<String>? language,
    Expression<String>? location,
    Expression<String>? audioData,
    Expression<String>? publishedAt,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (excerpt != null) 'excerpt': excerpt,
      if (language != null) 'language': language,
      if (location != null) 'location': location,
      if (audioData != null) 'audio_data': audioData,
      if (publishedAt != null) 'published_at': publishedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  BayansCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String?>? excerpt,
      Value<String>? language,
      Value<String?>? location,
      Value<String?>? audioData,
      Value<String>? publishedAt,
      Value<String>? createdAt,
      Value<String>? updatedAt}) {
    return BayansCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      excerpt: excerpt ?? this.excerpt,
      language: language ?? this.language,
      location: location ?? this.location,
      audioData: audioData ?? this.audioData,
      publishedAt: publishedAt ?? this.publishedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
      map['audio_data'] = Variable<String>(audioData.value);
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
          ..write('publishedAt: $publishedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
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
  late final GeneratedColumn<String> audioData = GeneratedColumn<String>(
      'audio_data', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
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
  List<GeneratedColumn> get $columns => [
        id,
        title,
        excerpt,
        language,
        location,
        audioData,
        publishedAt,
        createdAt,
        updatedAt
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
      id: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      excerpt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}excerpt']),
      language: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
      location: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}location']),
      audioData: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}audio_data']),
      publishedAt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}published_at'])!,
      createdAt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $BayansTable createAlias(String alias) {
    return $BayansTable(attachedDatabase, alias);
  }
}

class Malfuzat extends DataClass implements Insertable<Malfuzat> {
  final String id;
  final String title;
  final String? body;
  final String? excerpt;
  final String language;
  final bool hasAudio;
  final String? audioData;
  final String? documentData;
  final int position;
  final String? publishedAt;
  final String createdAt;
  final String updatedAt;
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
      required this.updatedAt});
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
      map['audio_data'] = Variable<String>(audioData);
    }
    if (!nullToAbsent || documentData != null) {
      map['document_data'] = Variable<String>(documentData);
    }
    map['position'] = Variable<int>(position);
    if (!nullToAbsent || publishedAt != null) {
      map['published_at'] = Variable<String>(publishedAt);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
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
      audioData: serializer.fromJson<String?>(json['audioData']),
      documentData: serializer.fromJson<String?>(json['documentData']),
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
      'body': serializer.toJson<String?>(body),
      'excerpt': serializer.toJson<String?>(excerpt),
      'language': serializer.toJson<String>(language),
      'hasAudio': serializer.toJson<bool>(hasAudio),
      'audioData': serializer.toJson<String?>(audioData),
      'documentData': serializer.toJson<String?>(documentData),
      'position': serializer.toJson<int>(position),
      'publishedAt': serializer.toJson<String?>(publishedAt),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  Malfuzat copyWith(
          {String? id,
          String? title,
          Value<String?> body = const Value.absent(),
          Value<String?> excerpt = const Value.absent(),
          String? language,
          bool? hasAudio,
          Value<String?> audioData = const Value.absent(),
          Value<String?> documentData = const Value.absent(),
          int? position,
          Value<String?> publishedAt = const Value.absent(),
          String? createdAt,
          String? updatedAt}) =>
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
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, body, excerpt, language, hasAudio,
      audioData, documentData, position, publishedAt, createdAt, updatedAt);
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
          other.updatedAt == this.updatedAt);
}

class MalfuzatsCompanion extends UpdateCompanion<Malfuzat> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> body;
  final Value<String?> excerpt;
  final Value<String> language;
  final Value<bool> hasAudio;
  final Value<String?> audioData;
  final Value<String?> documentData;
  final Value<int> position;
  final Value<String?> publishedAt;
  final Value<String> createdAt;
  final Value<String> updatedAt;
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
  })  : id = Value(id),
        title = Value(title),
        language = Value(language),
        position = Value(position),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
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
    });
  }

  MalfuzatsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String?>? body,
      Value<String?>? excerpt,
      Value<String>? language,
      Value<bool>? hasAudio,
      Value<String?>? audioData,
      Value<String?>? documentData,
      Value<int>? position,
      Value<String?>? publishedAt,
      Value<String>? createdAt,
      Value<String>? updatedAt}) {
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
      map['audio_data'] = Variable<String>(audioData.value);
    }
    if (documentData.present) {
      map['document_data'] = Variable<String>(documentData.value);
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
          ..write('updatedAt: $updatedAt')
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
  late final GeneratedColumn<bool> hasAudio = GeneratedColumn<bool>(
      'has_audio', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (has_audio IN (0, 1))',
      defaultValue: const Constant(false));
  @override
  late final GeneratedColumn<String> audioData = GeneratedColumn<String>(
      'audio_data', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> documentData = GeneratedColumn<String>(
      'document_data', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
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
        body,
        excerpt,
        language,
        hasAudio,
        audioData,
        documentData,
        position,
        publishedAt,
        createdAt,
        updatedAt
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
      id: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      body: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}body']),
      excerpt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}excerpt']),
      language: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
      hasAudio: attachedDatabase.options.types
          .read(DriftSqlType.bool, data['${effectivePrefix}has_audio'])!,
      audioData: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}audio_data']),
      documentData: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}document_data']),
      position: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      publishedAt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}published_at']),
      createdAt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $MalfuzatsTable createAlias(String alias) {
    return $MalfuzatsTable(attachedDatabase, alias);
  }
}

class Masail extends DataClass implements Insertable<Masail> {
  final String id;
  final String title;
  final String slug;
  final String question;
  final String? answer;
  final String language;
  final bool hasAudio;
  final String? audioData;
  final String? documentData;
  final int position;
  final String? publishedAt;
  final String createdAt;
  final String updatedAt;
  const Masail(
      {required this.id,
      required this.title,
      required this.slug,
      required this.question,
      this.answer,
      required this.language,
      required this.hasAudio,
      this.audioData,
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
    map['slug'] = Variable<String>(slug);
    map['question'] = Variable<String>(question);
    if (!nullToAbsent || answer != null) {
      map['answer'] = Variable<String>(answer);
    }
    map['language'] = Variable<String>(language);
    map['has_audio'] = Variable<bool>(hasAudio);
    if (!nullToAbsent || audioData != null) {
      map['audio_data'] = Variable<String>(audioData);
    }
    if (!nullToAbsent || documentData != null) {
      map['document_data'] = Variable<String>(documentData);
    }
    map['position'] = Variable<int>(position);
    if (!nullToAbsent || publishedAt != null) {
      map['published_at'] = Variable<String>(publishedAt);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  factory Masail.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Masail(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      slug: serializer.fromJson<String>(json['slug']),
      question: serializer.fromJson<String>(json['question']),
      answer: serializer.fromJson<String?>(json['answer']),
      language: serializer.fromJson<String>(json['language']),
      hasAudio: serializer.fromJson<bool>(json['hasAudio']),
      audioData: serializer.fromJson<String?>(json['audioData']),
      documentData: serializer.fromJson<String?>(json['documentData']),
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
      'slug': serializer.toJson<String>(slug),
      'question': serializer.toJson<String>(question),
      'answer': serializer.toJson<String?>(answer),
      'language': serializer.toJson<String>(language),
      'hasAudio': serializer.toJson<bool>(hasAudio),
      'audioData': serializer.toJson<String?>(audioData),
      'documentData': serializer.toJson<String?>(documentData),
      'position': serializer.toJson<int>(position),
      'publishedAt': serializer.toJson<String?>(publishedAt),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  Masail copyWith(
          {String? id,
          String? title,
          String? slug,
          String? question,
          Value<String?> answer = const Value.absent(),
          String? language,
          bool? hasAudio,
          Value<String?> audioData = const Value.absent(),
          Value<String?> documentData = const Value.absent(),
          int? position,
          Value<String?> publishedAt = const Value.absent(),
          String? createdAt,
          String? updatedAt}) =>
      Masail(
        id: id ?? this.id,
        title: title ?? this.title,
        slug: slug ?? this.slug,
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
      );
  @override
  String toString() {
    return (StringBuffer('Masail(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('slug: $slug, ')
          ..write('question: $question, ')
          ..write('answer: $answer, ')
          ..write('language: $language, ')
          ..write('hasAudio: $hasAudio, ')
          ..write('audioData: $audioData, ')
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
      slug,
      question,
      answer,
      language,
      hasAudio,
      audioData,
      documentData,
      position,
      publishedAt,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Masail &&
          other.id == this.id &&
          other.title == this.title &&
          other.slug == this.slug &&
          other.question == this.question &&
          other.answer == this.answer &&
          other.language == this.language &&
          other.hasAudio == this.hasAudio &&
          other.audioData == this.audioData &&
          other.documentData == this.documentData &&
          other.position == this.position &&
          other.publishedAt == this.publishedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MasailsCompanion extends UpdateCompanion<Masail> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> slug;
  final Value<String> question;
  final Value<String?> answer;
  final Value<String> language;
  final Value<bool> hasAudio;
  final Value<String?> audioData;
  final Value<String?> documentData;
  final Value<int> position;
  final Value<String?> publishedAt;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  const MasailsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.slug = const Value.absent(),
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
  });
  MasailsCompanion.insert({
    required String id,
    required String title,
    required String slug,
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
  })  : id = Value(id),
        title = Value(title),
        slug = Value(slug),
        question = Value(question),
        language = Value(language),
        position = Value(position),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Masail> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? slug,
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
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (slug != null) 'slug': slug,
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
    });
  }

  MasailsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? slug,
      Value<String>? question,
      Value<String?>? answer,
      Value<String>? language,
      Value<bool>? hasAudio,
      Value<String?>? audioData,
      Value<String?>? documentData,
      Value<int>? position,
      Value<String?>? publishedAt,
      Value<String>? createdAt,
      Value<String>? updatedAt}) {
    return MasailsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      slug: slug ?? this.slug,
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
      map['audio_data'] = Variable<String>(audioData.value);
    }
    if (documentData.present) {
      map['document_data'] = Variable<String>(documentData.value);
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MasailsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('slug: $slug, ')
          ..write('question: $question, ')
          ..write('answer: $answer, ')
          ..write('language: $language, ')
          ..write('hasAudio: $hasAudio, ')
          ..write('audioData: $audioData, ')
          ..write('documentData: $documentData, ')
          ..write('position: $position, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
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
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
      'slug', aliasedName, false,
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
  late final GeneratedColumn<bool> hasAudio = GeneratedColumn<bool>(
      'has_audio', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (has_audio IN (0, 1))',
      defaultValue: const Constant(false));
  @override
  late final GeneratedColumn<String> audioData = GeneratedColumn<String>(
      'audio_data', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> documentData = GeneratedColumn<String>(
      'document_data', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
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
        slug,
        question,
        answer,
        language,
        hasAudio,
        audioData,
        documentData,
        position,
        publishedAt,
        createdAt,
        updatedAt
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
      id: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      slug: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}slug'])!,
      question: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}question'])!,
      answer: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}answer']),
      language: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
      hasAudio: attachedDatabase.options.types
          .read(DriftSqlType.bool, data['${effectivePrefix}has_audio'])!,
      audioData: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}audio_data']),
      documentData: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}document_data']),
      position: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      publishedAt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}published_at']),
      createdAt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $MasailsTable createAlias(String alias) {
    return $MasailsTable(attachedDatabase, alias);
  }
}

class Dua extends DataClass implements Insertable<Dua> {
  final String id;
  final String title;
  final String body;
  final String? excerpt;
  final String language;
  final String? audioData;
  final String? documentData;
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
      map['audio_data'] = Variable<String>(audioData);
    }
    if (!nullToAbsent || documentData != null) {
      map['document_data'] = Variable<String>(documentData);
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
      audioData: serializer.fromJson<String?>(json['audioData']),
      documentData: serializer.fromJson<String?>(json['documentData']),
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
      'audioData': serializer.toJson<String?>(audioData),
      'documentData': serializer.toJson<String?>(documentData),
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
          Value<String?> audioData = const Value.absent(),
          Value<String?> documentData = const Value.absent(),
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
  final Value<String?> audioData;
  final Value<String?> documentData;
  final Value<int> position;
  final Value<String> createdAt;
  final Value<String> updatedAt;
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
    });
  }

  DuasCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? body,
      Value<String?>? excerpt,
      Value<String>? language,
      Value<String?>? audioData,
      Value<String?>? documentData,
      Value<int>? position,
      Value<String>? createdAt,
      Value<String>? updatedAt}) {
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
      map['audio_data'] = Variable<String>(audioData.value);
    }
    if (documentData.present) {
      map['document_data'] = Variable<String>(documentData.value);
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
          ..write('updatedAt: $updatedAt')
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
  late final GeneratedColumn<String> audioData = GeneratedColumn<String>(
      'audio_data', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> documentData = GeneratedColumn<String>(
      'document_data', aliasedName, true,
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
      id: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      body: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      excerpt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}excerpt']),
      language: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
      audioData: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}audio_data']),
      documentData: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}document_data']),
      position: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      createdAt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $DuasTable createAlias(String alias) {
    return $DuasTable(attachedDatabase, alias);
  }
}

class Article extends DataClass implements Insertable<Article> {
  final String id;
  final String title;
  final String slug;
  final String body;
  final String? excerpt;
  final String language;
  final String? documentData;
  final int position;
  final String? publishedAt;
  final String createdAt;
  final String updatedAt;
  const Article(
      {required this.id,
      required this.title,
      required this.slug,
      required this.body,
      this.excerpt,
      required this.language,
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
    map['slug'] = Variable<String>(slug);
    map['body'] = Variable<String>(body);
    if (!nullToAbsent || excerpt != null) {
      map['excerpt'] = Variable<String>(excerpt);
    }
    map['language'] = Variable<String>(language);
    if (!nullToAbsent || documentData != null) {
      map['document_data'] = Variable<String>(documentData);
    }
    map['position'] = Variable<int>(position);
    if (!nullToAbsent || publishedAt != null) {
      map['published_at'] = Variable<String>(publishedAt);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  factory Article.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Article(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      slug: serializer.fromJson<String>(json['slug']),
      body: serializer.fromJson<String>(json['body']),
      excerpt: serializer.fromJson<String?>(json['excerpt']),
      language: serializer.fromJson<String>(json['language']),
      documentData: serializer.fromJson<String?>(json['documentData']),
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
      'slug': serializer.toJson<String>(slug),
      'body': serializer.toJson<String>(body),
      'excerpt': serializer.toJson<String?>(excerpt),
      'language': serializer.toJson<String>(language),
      'documentData': serializer.toJson<String?>(documentData),
      'position': serializer.toJson<int>(position),
      'publishedAt': serializer.toJson<String?>(publishedAt),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  Article copyWith(
          {String? id,
          String? title,
          String? slug,
          String? body,
          Value<String?> excerpt = const Value.absent(),
          String? language,
          Value<String?> documentData = const Value.absent(),
          int? position,
          Value<String?> publishedAt = const Value.absent(),
          String? createdAt,
          String? updatedAt}) =>
      Article(
        id: id ?? this.id,
        title: title ?? this.title,
        slug: slug ?? this.slug,
        body: body ?? this.body,
        excerpt: excerpt.present ? excerpt.value : this.excerpt,
        language: language ?? this.language,
        documentData:
            documentData.present ? documentData.value : this.documentData,
        position: position ?? this.position,
        publishedAt: publishedAt.present ? publishedAt.value : this.publishedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('Article(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('slug: $slug, ')
          ..write('body: $body, ')
          ..write('excerpt: $excerpt, ')
          ..write('language: $language, ')
          ..write('documentData: $documentData, ')
          ..write('position: $position, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, slug, body, excerpt, language,
      documentData, position, publishedAt, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Article &&
          other.id == this.id &&
          other.title == this.title &&
          other.slug == this.slug &&
          other.body == this.body &&
          other.excerpt == this.excerpt &&
          other.language == this.language &&
          other.documentData == this.documentData &&
          other.position == this.position &&
          other.publishedAt == this.publishedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ArticlesCompanion extends UpdateCompanion<Article> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> slug;
  final Value<String> body;
  final Value<String?> excerpt;
  final Value<String> language;
  final Value<String?> documentData;
  final Value<int> position;
  final Value<String?> publishedAt;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  const ArticlesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.slug = const Value.absent(),
    this.body = const Value.absent(),
    this.excerpt = const Value.absent(),
    this.language = const Value.absent(),
    this.documentData = const Value.absent(),
    this.position = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ArticlesCompanion.insert({
    required String id,
    required String title,
    required String slug,
    required String body,
    this.excerpt = const Value.absent(),
    required String language,
    this.documentData = const Value.absent(),
    required int position,
    this.publishedAt = const Value.absent(),
    required String createdAt,
    required String updatedAt,
  })  : id = Value(id),
        title = Value(title),
        slug = Value(slug),
        body = Value(body),
        language = Value(language),
        position = Value(position),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Article> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? slug,
    Expression<String>? body,
    Expression<String>? excerpt,
    Expression<String>? language,
    Expression<String>? documentData,
    Expression<int>? position,
    Expression<String>? publishedAt,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (slug != null) 'slug': slug,
      if (body != null) 'body': body,
      if (excerpt != null) 'excerpt': excerpt,
      if (language != null) 'language': language,
      if (documentData != null) 'document_data': documentData,
      if (position != null) 'position': position,
      if (publishedAt != null) 'published_at': publishedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ArticlesCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? slug,
      Value<String>? body,
      Value<String?>? excerpt,
      Value<String>? language,
      Value<String?>? documentData,
      Value<int>? position,
      Value<String?>? publishedAt,
      Value<String>? createdAt,
      Value<String>? updatedAt}) {
    return ArticlesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      body: body ?? this.body,
      excerpt: excerpt ?? this.excerpt,
      language: language ?? this.language,
      documentData: documentData ?? this.documentData,
      position: position ?? this.position,
      publishedAt: publishedAt ?? this.publishedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (excerpt.present) {
      map['excerpt'] = Variable<String>(excerpt.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (documentData.present) {
      map['document_data'] = Variable<String>(documentData.value);
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArticlesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('slug: $slug, ')
          ..write('body: $body, ')
          ..write('excerpt: $excerpt, ')
          ..write('language: $language, ')
          ..write('documentData: $documentData, ')
          ..write('position: $position, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
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
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
      'slug', aliasedName, false,
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
  late final GeneratedColumn<String> documentData = GeneratedColumn<String>(
      'document_data', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
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
        slug,
        body,
        excerpt,
        language,
        documentData,
        position,
        publishedAt,
        createdAt,
        updatedAt
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
      id: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      slug: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}slug'])!,
      body: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      excerpt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}excerpt']),
      language: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
      documentData: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}document_data']),
      position: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      publishedAt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}published_at']),
      createdAt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ArticlesTable createAlias(String alias) {
    return $ArticlesTable(attachedDatabase, alias);
  }
}

class Madrasah extends DataClass implements Insertable<Madrasah> {
  final String id;
  final String title;
  final String introduction;
  final String? excerpt;
  final String? documentData;
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
      map['document_data'] = Variable<String>(documentData);
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
      documentData: serializer.fromJson<String?>(json['documentData']),
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
      'documentData': serializer.toJson<String?>(documentData),
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
          Value<String?> documentData = const Value.absent(),
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
  final Value<String?> documentData;
  final Value<int> position;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  const MadrasahsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.introduction = const Value.absent(),
    this.excerpt = const Value.absent(),
    this.documentData = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
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
    });
  }

  MadrasahsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? introduction,
      Value<String?>? excerpt,
      Value<String?>? documentData,
      Value<int>? position,
      Value<String>? createdAt,
      Value<String>? updatedAt}) {
    return MadrasahsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      introduction: introduction ?? this.introduction,
      excerpt: excerpt ?? this.excerpt,
      documentData: documentData ?? this.documentData,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
      map['document_data'] = Variable<String>(documentData.value);
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
          ..write('updatedAt: $updatedAt')
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
  late final GeneratedColumn<String> documentData = GeneratedColumn<String>(
      'document_data', aliasedName, true,
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
      id: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      introduction: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}introduction'])!,
      excerpt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}excerpt']),
      documentData: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}document_data']),
      position: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      createdAt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $MadrasahsTable createAlias(String alias) {
    return $MadrasahsTable(attachedDatabase, alias);
  }
}

class NamazTime extends DataClass implements Insertable<NamazTime> {
  final String id;
  final String title;
  final String slug;
  final String masail;
  final String? fazail;
  final String createdAt;
  final String updatedAt;
  const NamazTime(
      {required this.id,
      required this.title,
      required this.slug,
      required this.masail,
      this.fazail,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['slug'] = Variable<String>(slug);
    map['masail'] = Variable<String>(masail);
    if (!nullToAbsent || fazail != null) {
      map['fazail'] = Variable<String>(fazail);
    }
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
      slug: serializer.fromJson<String>(json['slug']),
      masail: serializer.fromJson<String>(json['masail']),
      fazail: serializer.fromJson<String?>(json['fazail']),
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
      'masail': serializer.toJson<String>(masail),
      'fazail': serializer.toJson<String?>(fazail),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  NamazTime copyWith(
          {String? id,
          String? title,
          String? slug,
          String? masail,
          Value<String?> fazail = const Value.absent(),
          String? createdAt,
          String? updatedAt}) =>
      NamazTime(
        id: id ?? this.id,
        title: title ?? this.title,
        slug: slug ?? this.slug,
        masail: masail ?? this.masail,
        fazail: fazail.present ? fazail.value : this.fazail,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('NamazTime(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('slug: $slug, ')
          ..write('masail: $masail, ')
          ..write('fazail: $fazail, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, slug, masail, fazail, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NamazTime &&
          other.id == this.id &&
          other.title == this.title &&
          other.slug == this.slug &&
          other.masail == this.masail &&
          other.fazail == this.fazail &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class NamazTimesCompanion extends UpdateCompanion<NamazTime> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> slug;
  final Value<String> masail;
  final Value<String?> fazail;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  const NamazTimesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.slug = const Value.absent(),
    this.masail = const Value.absent(),
    this.fazail = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  NamazTimesCompanion.insert({
    required String id,
    required String title,
    required String slug,
    required String masail,
    this.fazail = const Value.absent(),
    required String createdAt,
    required String updatedAt,
  })  : id = Value(id),
        title = Value(title),
        slug = Value(slug),
        masail = Value(masail),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<NamazTime> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? slug,
    Expression<String>? masail,
    Expression<String>? fazail,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (slug != null) 'slug': slug,
      if (masail != null) 'masail': masail,
      if (fazail != null) 'fazail': fazail,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  NamazTimesCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? slug,
      Value<String>? masail,
      Value<String?>? fazail,
      Value<String>? createdAt,
      Value<String>? updatedAt}) {
    return NamazTimesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      masail: masail ?? this.masail,
      fazail: fazail ?? this.fazail,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (masail.present) {
      map['masail'] = Variable<String>(masail.value);
    }
    if (fazail.present) {
      map['fazail'] = Variable<String>(fazail.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NamazTimesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('slug: $slug, ')
          ..write('masail: $masail, ')
          ..write('fazail: $fazail, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
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
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, slug, masail, fazail, createdAt, updatedAt];
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
      id: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      slug: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}slug'])!,
      masail: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}masail'])!,
      fazail: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}fazail']),
      createdAt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $NamazTimesTable createAlias(String alias) {
    return $NamazTimesTable(attachedDatabase, alias);
  }
}

class Page extends DataClass implements Insertable<Page> {
  final String id;
  final String title;
  final String slug;
  final String body;
  final String? imageData;
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
      map['image_data'] = Variable<String>(imageData);
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
      imageData: serializer.fromJson<String?>(json['imageData']),
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
      'imageData': serializer.toJson<String?>(imageData),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  Page copyWith(
          {String? id,
          String? title,
          String? slug,
          String? body,
          Value<String?> imageData = const Value.absent(),
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
  final Value<String?> imageData;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  const PagesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.slug = const Value.absent(),
    this.body = const Value.absent(),
    this.imageData = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PagesCompanion.insert({
    required String id,
    required String title,
    required String slug,
    required String body,
    this.imageData = const Value.absent(),
    required String createdAt,
    required String updatedAt,
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
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (slug != null) 'slug': slug,
      if (body != null) 'body': body,
      if (imageData != null) 'image_data': imageData,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PagesCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? slug,
      Value<String>? body,
      Value<String?>? imageData,
      Value<String>? createdAt,
      Value<String>? updatedAt}) {
    return PagesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      body: body ?? this.body,
      imageData: imageData ?? this.imageData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
      map['image_data'] = Variable<String>(imageData.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
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
          ..write('updatedAt: $updatedAt')
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
  late final GeneratedColumn<String> imageData = GeneratedColumn<String>(
      'image_data', aliasedName, true,
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
      id: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      slug: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}slug'])!,
      body: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      imageData: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}image_data']),
      createdAt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $PagesTable createAlias(String alias) {
    return $PagesTable(attachedDatabase, alias);
  }
}

abstract class _$LocalDatabase extends GeneratedDatabase {
  _$LocalDatabase(QueryExecutor e) : super(e);
  late final $SurahsTable surahs = $SurahsTable(this);
  late final $ParasTable paras = $ParasTable(this);
  late final $AyahsTable ayahs = $AyahsTable(this);
  late final $AyahTranslationsTable ayahTranslations =
      $AyahTranslationsTable(this);
  late final $BooksTable books = $BooksTable(this);
  late final $ChaptersTable chapters = $ChaptersTable(this);
  late final $SubchaptersTable subchapters = $SubchaptersTable(this);
  late final $BayansTable bayans = $BayansTable(this);
  late final $MalfuzatsTable malfuzats = $MalfuzatsTable(this);
  late final $MasailsTable masails = $MasailsTable(this);
  late final $DuasTable duas = $DuasTable(this);
  late final $ArticlesTable articles = $ArticlesTable(this);
  late final $MadrasahsTable madrasahs = $MadrasahsTable(this);
  late final $NamazTimesTable namazTimes = $NamazTimesTable(this);
  late final $PagesTable pages = $PagesTable(this);
  @override
  Iterable<TableInfo<Table, dynamic>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        surahs,
        paras,
        ayahs,
        ayahTranslations,
        books,
        chapters,
        subchapters,
        bayans,
        malfuzats,
        masails,
        duas,
        articles,
        madrasahs,
        namazTimes,
        pages
      ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}
