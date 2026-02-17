import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/main.data.dart';

final allModelsProvider = FutureProvider.autoDispose
    .family<List, AllModelsQuery>((ref, AllModelsQuery query) async {
  // Keep the provider alive to prevent auto-dispose during widget tree changes
  ref.keepAlive();

  debugPrint(
      '[allModelsProvider] Query: ${query.repository.runtimeType} params=${query.params}');

  // Use ref.read instead of ref.watch to avoid continuous dependency on the initializer
  await ref.read(repositoryInitializerProvider.future);

  try {
    return await query.repository.findAll(
      params: query.params,
      syncLocal: query.syncLocal,
    );
  } catch (error) {
    return [];
  }
});
