import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/objects/single_model_query.dart';
import 'package:native_app/main.data.dart';

final singleModelProvider = FutureProvider.family((ref, SingleModelQuery query) async {
  await ref.watch(repositoryInitializerProvider.future);

  Map repositories = {
    'news': ref.news,
    'articles': ref.articles,
  };

  var resource = await repositories[query.repository].findOne(
    query.id,
    remote: query.remote,
  );

  if (resource == null) {
    throw Exception('Record not found');
  }

  return resource;
});
