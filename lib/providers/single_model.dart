import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/objects/single_model_query.dart';
import 'package:native_app/main.data.dart';

final singleModelProvider =
    FutureProvider.family((ref, SingleModelQuery query) async {
  await ref.watch(repositoryInitializerProvider.future);

  Map repositories = {
    'surahs': ref.surahs,
    'paras': ref.paras,
    'ayahs': ref.ayahs,
    'books': ref.books,
    'chapters': ref.chapters,
    'subchapters': ref.subchapters,
    'bayans': ref.bayans,
    'bayanCategories': ref.bayanCategories,
    'speakers': ref.speakers,
    'malfuzats': ref.malfuzats,
    'masails': ref.masails,
    'duas': ref.duas,
    'articles': ref.articles,
    'news': ref.news,
    'madrasahs': ref.madrasahs,
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
