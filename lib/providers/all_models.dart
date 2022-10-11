import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/main.data.dart';

final allModelsProvider =
    FutureProvider.family((ref, AllModelsQuery query) async {
  await ref.watch(repositoryInitializerProvider.future);

  Map repositories = {
    /* 'books': ref.books, */
    'bayans': ref.bayans,
    'malfuzats': ref.malfuzats,
    'masails': ref.masails,
    'duas': ref.duas,
    'articles': ref.articles,
    'news': ref.news,
    'madrasahs': ref.madrasahs,
  };

  var resources = await repositories[query.repository].findAll(
    params: query.params,
    syncLocal: query.syncLocal,
  );

  return resources ?? [];
});
