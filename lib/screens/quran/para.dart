import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/first_model.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/widgets/layouts/placeholder_scaffold.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'ayah_list.dart';

class Para extends ConsumerWidget {
  const Para({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var query = AllModelsQuery(
      repository: ref.paras,
      params: {
        'slug': QR.params['slug'],
        'quantity': 1,
      },
    );

    var modelQuery = ref.watch(firstModelProvider(query));

    return modelQuery.when(
      loading: () {
        return const PlaceholderScaffold(
          body: SizedBox.shrink(),
        );
      },
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (para) {
        return WithPreferences(
          builder: (context, preferences) {
            preferences.setString('lastPara', para.id);

            return AyahList(
              key: PageStorageKey<String>(para.id),
              chapter: para,
              filterParams: {
                'para_id': para.id,
                'sort': 'para-position',
              },
            );
          },
        );
      },
    );
  }
}
