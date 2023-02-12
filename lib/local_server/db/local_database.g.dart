// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// **************************************************************************
// DriftDatabaseGenerator
// **************************************************************************

// ignore_for_file: type=lint
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
  final DateTime? publishedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
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
      map['published_at'] = Variable<DateTime>(publishedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
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
      publishedAt: serializer.fromJson<DateTime?>(json['publishedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
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
      'publishedAt': serializer.toJson<DateTime?>(publishedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
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
          Value<DateTime?> publishedAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
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
  final Value<DateTime?> publishedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
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
    required DateTime createdAt,
    required DateTime updatedAt,
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
    Expression<DateTime>? publishedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
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
      Value<DateTime?>? publishedAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
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
      map['published_at'] = Variable<DateTime>(publishedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
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
  late final GeneratedColumn<DateTime> publishedAt = GeneratedColumn<DateTime>(
      'published_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
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
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
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
          .read(DriftSqlType.dateTime, data['${effectivePrefix}published_at']),
      createdAt: attachedDatabase.options.types
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.options.types
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $MasailsTable createAlias(String alias) {
    return $MasailsTable(attachedDatabase, alias);
  }
}

abstract class _$LocalDatabase extends GeneratedDatabase {
  _$LocalDatabase(QueryExecutor e) : super(e);
  late final $MasailsTable masails = $MasailsTable(this);
  @override
  Iterable<TableInfo<Table, dynamic>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [masails];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}
