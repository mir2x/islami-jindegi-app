import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/single_model.dart';
import 'package:native_app/objects/single_model_query.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'ayah_list.dart';

class Surah extends ConsumerWidget {
  const Surah({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var query = SingleModelQuery(
      repository: ref.surahs,
      id: QR.params['id'].toString(),
    );

    var modelQuery = ref.watch(singleModelProvider(query));

    return modelQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (surah) {
        return AyahList(
          chapter: surah,
          filterParams: {
            'surah_id': surah.id,
          },
        );
      },
    );
  }
}
