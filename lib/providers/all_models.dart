import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/main.data.dart';

final allModelsProvider = FutureProvider.family<List, AllModelsQuery>(
    (ref, AllModelsQuery query) async {
  await ref.watch(repositoryInitializerProvider.future);

  var resources = await query.repository.findAll(
    params: query.params,
    syncLocal: query.syncLocal,
  );

  return resources ?? [];
});
