import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/objects/model_query.dart';
import 'package:native_app/main.data.dart';

final modelProvider = FutureProvider.family((ref, ModelQuery query) async {
  await ref.watch(repositoryInitializerProvider.future);

  Map models = {
    'news': ref.news,
    'articles': ref.articles,
  };

  var resource = await models[query.model].findOne(
    query.id,
    remote: query.remote,
  );

  if (resource == null) {
    throw Exception('Record not found');
  }

  return resource;
});
