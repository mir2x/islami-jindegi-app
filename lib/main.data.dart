// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: directives_ordering, top_level_function_literal_block

import 'package:flutter_data/flutter_data.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:native_app/models/article.dart';
import 'package:native_app/models/bayan.dart';
import 'package:native_app/models/book.dart';
import 'package:native_app/models/dua.dart';
import 'package:native_app/models/madrasah.dart';
import 'package:native_app/models/malfuzat.dart';
import 'package:native_app/models/masail.dart';
import 'package:native_app/models/news.dart';
import 'package:native_app/models/speaker.dart';

// ignore: prefer_function_declarations_over_variables
ConfigureRepositoryLocalStorage configureRepositoryLocalStorage =
    ({FutureFn<String>? baseDirFn, List<int>? encryptionKey, bool? clear}) {
  if (!kIsWeb) {
    baseDirFn ??=
        () => getApplicationDocumentsDirectory().then((dir) => dir.path);
  } else {
    baseDirFn ??= () => '';
  }

  return hiveLocalStorageProvider.overrideWithProvider(
    Provider(
      (ref) => HiveLocalStorage(
        hive: ref.read(hiveProvider),
        baseDirFn: baseDirFn,
        encryptionKey: encryptionKey,
        clear: clear,
      ),
    ),
  );
};

final repositoryProviders = <String, Provider<Repository<DataModel>>>{
  'articles': articlesRepositoryProvider,
  'bayans': bayansRepositoryProvider,
  'books': booksRepositoryProvider,
  'duas': duasRepositoryProvider,
  'madrasahs': madrasahsRepositoryProvider,
  'malfuzats': malfuzatsRepositoryProvider,
  'masails': masailsRepositoryProvider,
  'news': newsRepositoryProvider,
  'speakers': speakersRepositoryProvider
};

final repositoryInitializerProvider =
    FutureProvider<RepositoryInitializer>((ref) async {
  DataHelpers.setInternalType<Article>('articles');
  DataHelpers.setInternalType<Bayan>('bayans');
  DataHelpers.setInternalType<Book>('books');
  DataHelpers.setInternalType<Dua>('duas');
  DataHelpers.setInternalType<Madrasah>('madrasahs');
  DataHelpers.setInternalType<Malfuzat>('malfuzats');
  DataHelpers.setInternalType<Masail>('masails');
  DataHelpers.setInternalType<News>('news');
  DataHelpers.setInternalType<Speaker>('speakers');
  final adapters = <String, RemoteAdapter>{
    'articles': ref.watch(internalArticlesRemoteAdapterProvider),
    'bayans': ref.watch(internalBayansRemoteAdapterProvider),
    'books': ref.watch(internalBooksRemoteAdapterProvider),
    'duas': ref.watch(internalDuasRemoteAdapterProvider),
    'madrasahs': ref.watch(internalMadrasahsRemoteAdapterProvider),
    'malfuzats': ref.watch(internalMalfuzatsRemoteAdapterProvider),
    'masails': ref.watch(internalMasailsRemoteAdapterProvider),
    'news': ref.watch(internalNewsRemoteAdapterProvider),
    'speakers': ref.watch(internalSpeakersRemoteAdapterProvider)
  };
  final remotes = <String, bool>{
    'articles': true,
    'bayans': true,
    'books': true,
    'duas': true,
    'madrasahs': true,
    'malfuzats': true,
    'masails': true,
    'news': true,
    'speakers': true
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
  Repository<Bayan> get bayans =>
      watch(bayansRepositoryProvider)..remoteAdapter.internalWatch = watch;
  Repository<Book> get books =>
      watch(booksRepositoryProvider)..remoteAdapter.internalWatch = watch;
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
  Repository<Speaker> get speakers =>
      watch(speakersRepositoryProvider)..remoteAdapter.internalWatch = watch;
}

extension RepositoryRefX on Ref {
  Repository<Article> get articles => watch(articlesRepositoryProvider)
    ..remoteAdapter.internalWatch = watch as Watcher;
  Repository<Bayan> get bayans => watch(bayansRepositoryProvider)
    ..remoteAdapter.internalWatch = watch as Watcher;
  Repository<Book> get books => watch(booksRepositoryProvider)
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
  Repository<Speaker> get speakers => watch(speakersRepositoryProvider)
    ..remoteAdapter.internalWatch = watch as Watcher;
}
