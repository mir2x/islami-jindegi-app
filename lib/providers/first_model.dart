import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/providers/all_models.dart';

final firstModelProvider = FutureProvider.autoDispose
    .family<dynamic, AllModelsQuery>((ref, AllModelsQuery query) async {
  var resources = await ref.watch(allModelsProvider(query).future);

  if (resources.isEmpty) {
    throw Exception('Record not found');
  }

  return resources.first;
});
