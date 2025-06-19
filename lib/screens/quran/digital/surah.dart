import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/first_model.dart';
import 'package:native_app/providers/last_visited.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'ayah_list.dart';

class Surah extends ConsumerWidget {
  const Surah({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var query = AllModelsQuery(
      repository: ref.surahs,
      params: {
        'slug': QR.params['slug'],
        'quantity': 1,
        'offline': true,
      },
    );

    var modelQuery = ref.watch(firstModelProvider(query));

    return modelQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (surah) {
        Future? previousPage() async {
          var previousResources = await ref.surahs.findAll(
            params: {
              'position': surah.position - 1,
              'quantity': 1,
              'offline': true,
            },
          );

          if (previousResources.isEmpty) {
            await QR.to('quran');
          } else {
            await QR.to('quran/surah/${previousResources.first.slug}');
          }
        }

        Future? nextPage() async {
          var nextResources = await ref.surahs.findAll(
            params: {
              'position': surah.position + 1,
              'quantity': 1,
              'offline': true,
            },
          );

          if (nextResources.isEmpty) {
            await QR.to('quran');
          } else {
            await QR.to('quran/surah/${nextResources.first.slug}');
          }
        }

        ref.read(lastVisitedProvider.notifier).updateLastSurah(surah.id);

        return AyahList(
          key: PageStorageKey<String>(surah.id),
          chapter: surah,
          filterParams: {
            'surah_id': surah.id,
          },
          previousPage: previousPage,
          nextPage: nextPage,
        );
      },
    );
  }
}
