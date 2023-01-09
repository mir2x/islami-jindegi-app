// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: directives_ordering, top_level_function_literal_block, depend_on_referenced_packages

import 'package:flutter_data/flutter_data.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:native_app/models/article.dart';
import 'package:native_app/models/author.dart';
import 'package:native_app/models/ayah.dart';
import 'package:native_app/models/bayan_category.dart';
import 'package:native_app/models/bayan.dart';
import 'package:native_app/models/book_category.dart';
import 'package:native_app/models/book_subcategory.dart';
import 'package:native_app/models/book.dart';
import 'package:native_app/models/chapter.dart';
import 'package:native_app/models/dua_category.dart';
import 'package:native_app/models/dua.dart';
import 'package:native_app/models/madrasah.dart';
import 'package:native_app/models/malfuzat.dart';
import 'package:native_app/models/masail.dart';
import 'package:native_app/models/news.dart';
import 'package:native_app/models/para.dart';
import 'package:native_app/models/speaker.dart';
import 'package:native_app/models/subchapter.dart';
import 'package:native_app/models/surah.dart';

// ignore: prefer_function_declarations_over_variables
ConfigureRepositoryLocalStorage configureRepositoryLocalStorage = ({
  FutureFn<String>? baseDirFn,
  List<int>? encryptionKey,
  LocalStorageClearStrategy? clear,
}) {
  if (!kIsWeb) {
    baseDirFn ??=
        () => getApplicationDocumentsDirectory().then((dir) => dir.path);
  } else {
    baseDirFn ??= () => '';
  }

  return hiveLocalStorageProvider.overrideWith(
    (ref) => HiveLocalStorage(
      hive: ref.read(hiveProvider),
      baseDirFn: baseDirFn,
      encryptionKey: encryptionKey,
      clear: clear,
    ),
  );
};

final repositoryProviders = <String, Provider<Repository<DataModel>>>{
  'articles': articlesRepositoryProvider,
  'authors': authorsRepositoryProvider,
  'ayahs': ayahsRepositoryProvider,
  'bayanCategories': bayanCategoriesRepositoryProvider,
  'bayans': bayansRepositoryProvider,
  'bookCategories': bookCategoriesRepositoryProvider,
  'bookSubcategories': bookSubcategoriesRepositoryProvider,
  'books': booksRepositoryProvider,
  'chapters': chaptersRepositoryProvider,
  'duaCategories': duaCategoriesRepositoryProvider,
  'duas': duasRepositoryProvider,
  'madrasahs': madrasahsRepositoryProvider,
  'malfuzats': malfuzatsRepositoryProvider,
  'masails': masailsRepositoryProvider,
  'news': newsRepositoryProvider,
  'paras': parasRepositoryProvider,
  'speakers': speakersRepositoryProvider,
  'subchapters': subchaptersRepositoryProvider,
  'surahs': surahsRepositoryProvider
};

final repositoryInitializerProvider =
    FutureProvider<RepositoryInitializer>((ref) async {
  DataHelpers.setInternalType<Article>('articles');
  DataHelpers.setInternalType<Author>('authors');
  DataHelpers.setInternalType<Ayah>('ayahs');
  DataHelpers.setInternalType<BayanCategory>('bayanCategories');
  DataHelpers.setInternalType<Bayan>('bayans');
  DataHelpers.setInternalType<BookCategory>('bookCategories');
  DataHelpers.setInternalType<BookSubcategory>('bookSubcategories');
  DataHelpers.setInternalType<Book>('books');
  DataHelpers.setInternalType<Chapter>('chapters');
  DataHelpers.setInternalType<DuaCategory>('duaCategories');
  DataHelpers.setInternalType<Dua>('duas');
  DataHelpers.setInternalType<Madrasah>('madrasahs');
  DataHelpers.setInternalType<Malfuzat>('malfuzats');
  DataHelpers.setInternalType<Masail>('masails');
  DataHelpers.setInternalType<News>('news');
  DataHelpers.setInternalType<Para>('paras');
  DataHelpers.setInternalType<Speaker>('speakers');
  DataHelpers.setInternalType<Subchapter>('subchapters');
  DataHelpers.setInternalType<Surah>('surahs');
  final adapters = <String, RemoteAdapter>{
    'articles': ref.watch(internalArticlesRemoteAdapterProvider),
    'authors': ref.watch(internalAuthorsRemoteAdapterProvider),
    'ayahs': ref.watch(internalAyahsRemoteAdapterProvider),
    'bayanCategories': ref.watch(internalBayanCategoriesRemoteAdapterProvider),
    'bayans': ref.watch(internalBayansRemoteAdapterProvider),
    'bookCategories': ref.watch(internalBookCategoriesRemoteAdapterProvider),
    'bookSubcategories':
        ref.watch(internalBookSubcategoriesRemoteAdapterProvider),
    'books': ref.watch(internalBooksRemoteAdapterProvider),
    'chapters': ref.watch(internalChaptersRemoteAdapterProvider),
    'duaCategories': ref.watch(internalDuaCategoriesRemoteAdapterProvider),
    'duas': ref.watch(internalDuasRemoteAdapterProvider),
    'madrasahs': ref.watch(internalMadrasahsRemoteAdapterProvider),
    'malfuzats': ref.watch(internalMalfuzatsRemoteAdapterProvider),
    'masails': ref.watch(internalMasailsRemoteAdapterProvider),
    'news': ref.watch(internalNewsRemoteAdapterProvider),
    'paras': ref.watch(internalParasRemoteAdapterProvider),
    'speakers': ref.watch(internalSpeakersRemoteAdapterProvider),
    'subchapters': ref.watch(internalSubchaptersRemoteAdapterProvider),
    'surahs': ref.watch(internalSurahsRemoteAdapterProvider)
  };
  final remotes = <String, bool>{
    'articles': true,
    'authors': true,
    'ayahs': true,
    'bayanCategories': true,
    'bayans': true,
    'bookCategories': true,
    'bookSubcategories': true,
    'books': true,
    'chapters': true,
    'duaCategories': true,
    'duas': true,
    'madrasahs': true,
    'malfuzats': true,
    'masails': true,
    'news': true,
    'paras': true,
    'speakers': true,
    'subchapters': true,
    'surahs': true
  };

  await ref.watch(graphNotifierProvider).initialize();

  // initialize and register
  for (final type in repositoryProviders.keys) {
    final repository = ref.read(repositoryProviders[type]!);
    repository.dispose();
    await repository.initialize(
      remote: remotes[type],
      adapters: adapters,
    );
    internalRepositories[type] = repository;
  }

  return RepositoryInitializer();
});

extension RepositoryWidgetRefX on WidgetRef {
  Repository<Article> get articles =>
      watch(articlesRepositoryProvider)..remoteAdapter.internalWatch = watch;
  Repository<Author> get authors =>
      watch(authorsRepositoryProvider)..remoteAdapter.internalWatch = watch;
  Repository<Ayah> get ayahs =>
      watch(ayahsRepositoryProvider)..remoteAdapter.internalWatch = watch;
  Repository<BayanCategory> get bayanCategories =>
      watch(bayanCategoriesRepositoryProvider)
        ..remoteAdapter.internalWatch = watch;
  Repository<Bayan> get bayans =>
      watch(bayansRepositoryProvider)..remoteAdapter.internalWatch = watch;
  Repository<BookCategory> get bookCategories =>
      watch(bookCategoriesRepositoryProvider)
        ..remoteAdapter.internalWatch = watch;
  Repository<BookSubcategory> get bookSubcategories =>
      watch(bookSubcategoriesRepositoryProvider)
        ..remoteAdapter.internalWatch = watch;
  Repository<Book> get books =>
      watch(booksRepositoryProvider)..remoteAdapter.internalWatch = watch;
  Repository<Chapter> get chapters =>
      watch(chaptersRepositoryProvider)..remoteAdapter.internalWatch = watch;
  Repository<DuaCategory> get duaCategories =>
      watch(duaCategoriesRepositoryProvider)
        ..remoteAdapter.internalWatch = watch;
  Repository<Dua> get duas =>
      watch(duasRepositoryProvider)..remoteAdapter.internalWatch = watch;
  Repository<Madrasah> get madrasahs =>
      watch(madrasahsRepositoryProvider)..remoteAdapter.internalWatch = watch;
  Repository<Malfuzat> get malfuzats =>
      watch(malfuzatsRepositoryProvider)..remoteAdapter.internalWatch = watch;
  Repository<Masail> get masails =>
      watch(masailsRepositoryProvider)..remoteAdapter.internalWatch = watch;
  Repository<News> get news =>
      watch(newsRepositoryProvider)..remoteAdapter.internalWatch = watch;
  Repository<Para> get paras =>
      watch(parasRepositoryProvider)..remoteAdapter.internalWatch = watch;
  Repository<Speaker> get speakers =>
      watch(speakersRepositoryProvider)..remoteAdapter.internalWatch = watch;
  Repository<Subchapter> get subchapters =>
      watch(subchaptersRepositoryProvider)..remoteAdapter.internalWatch = watch;
  Repository<Surah> get surahs =>
      watch(surahsRepositoryProvider)..remoteAdapter.internalWatch = watch;
}

extension RepositoryRefX on Ref {
  Repository<Article> get articles => watch(articlesRepositoryProvider)
    ..remoteAdapter.internalWatch = watch as Watcher;
  Repository<Author> get authors => watch(authorsRepositoryProvider)
    ..remoteAdapter.internalWatch = watch as Watcher;
  Repository<Ayah> get ayahs => watch(ayahsRepositoryProvider)
    ..remoteAdapter.internalWatch = watch as Watcher;
  Repository<BayanCategory> get bayanCategories =>
      watch(bayanCategoriesRepositoryProvider)
        ..remoteAdapter.internalWatch = watch as Watcher;
  Repository<Bayan> get bayans => watch(bayansRepositoryProvider)
    ..remoteAdapter.internalWatch = watch as Watcher;
  Repository<BookCategory> get bookCategories =>
      watch(bookCategoriesRepositoryProvider)
        ..remoteAdapter.internalWatch = watch as Watcher;
  Repository<BookSubcategory> get bookSubcategories =>
      watch(bookSubcategoriesRepositoryProvider)
        ..remoteAdapter.internalWatch = watch as Watcher;
  Repository<Book> get books => watch(booksRepositoryProvider)
    ..remoteAdapter.internalWatch = watch as Watcher;
  Repository<Chapter> get chapters => watch(chaptersRepositoryProvider)
    ..remoteAdapter.internalWatch = watch as Watcher;
  Repository<DuaCategory> get duaCategories =>
      watch(duaCategoriesRepositoryProvider)
        ..remoteAdapter.internalWatch = watch as Watcher;
  Repository<Dua> get duas => watch(duasRepositoryProvider)
    ..remoteAdapter.internalWatch = watch as Watcher;
  Repository<Madrasah> get madrasahs => watch(madrasahsRepositoryProvider)
    ..remoteAdapter.internalWatch = watch as Watcher;
  Repository<Malfuzat> get malfuzats => watch(malfuzatsRepositoryProvider)
    ..remoteAdapter.internalWatch = watch as Watcher;
  Repository<Masail> get masails => watch(masailsRepositoryProvider)
    ..remoteAdapter.internalWatch = watch as Watcher;
  Repository<News> get news => watch(newsRepositoryProvider)
    ..remoteAdapter.internalWatch = watch as Watcher;
  Repository<Para> get paras => watch(parasRepositoryProvider)
    ..remoteAdapter.internalWatch = watch as Watcher;
  Repository<Speaker> get speakers => watch(speakersRepositoryProvider)
    ..remoteAdapter.internalWatch = watch as Watcher;
  Repository<Subchapter> get subchapters => watch(subchaptersRepositoryProvider)
    ..remoteAdapter.internalWatch = watch as Watcher;
  Repository<Surah> get surahs => watch(surahsRepositoryProvider)
    ..remoteAdapter.internalWatch = watch as Watcher;
}
