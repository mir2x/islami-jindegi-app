import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/main.data.dart';

final allModelsProvider = FutureProvider.family((ref, AllModelsQuery query) async {
  await ref.watch(repositoryInitializerProvider.future);

  Map repositories = {
    'news': ref.news,
    'articles': ref.articles,
  };

  var resources = await repositories[query.repository].findAll(
    params: query.params,
    syncLocal: query.syncLocal,
  );

  return resources ?? [];
});
