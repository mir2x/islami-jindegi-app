import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/objects/single_model_query.dart';
import 'package:native_app/main.data.dart';

final singleModelProvider = FutureProvider.autoDispose
    .family<dynamic, SingleModelQuery>((ref, SingleModelQuery query) async {
  // Keep the provider alive to prevent auto-dispose during widget tree changes
  ref.keepAlive();

  // Use ref.read instead of ref.watch to avoid continuous dependency on the initializer
  // We only need to wait for initialization once, not continuously watch it
  await ref.read(repositoryInitializerProvider.future);

  var resource = await query.repository.findOne(
    query.id,
    params: query.params,
    remote: query.remote,
  );

  if (resource == null) {
    throw Exception('Record not found');
  }

  return resource;
});
