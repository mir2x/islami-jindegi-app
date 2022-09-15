import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/objects/models_query.dart';
import 'package:native_app/main.data.dart';

final modelsProvider = FutureProvider.family((ref, ModelsQuery query) async {
  await ref.watch(repositoryInitializerProvider.future);

  Map models = {
    'news': ref.news,
    'articles': ref.articles,
  };

  var resources = await models[query.model].findAll(
    params: query.params,
    syncLocal: query.syncLocal,
  );

  return resources ?? [];
});
