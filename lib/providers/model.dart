import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/main.data.dart';

final modelProvider = FutureProvider.family((ref, id) async {
  await ref.watch(repositoryInitializerProvider.future);

  return await ref.news.findOne(id!);
});
