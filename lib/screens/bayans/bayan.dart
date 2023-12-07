import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/single_model.dart';
import 'package:native_app/providers/last_visited.dart';
import 'package:native_app/providers/downloaded_bayans.dart';
import 'package:native_app/objects/single_model_query.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/widgets/gestures/next_page_swipe.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/presentation/download_item.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/helpers/file_utils.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/buttons/social_share.dart';
import 'package:native_app/widgets/buttons/bookmark.dart';
import 'package:native_app/widgets/buttons/previous.dart';
import 'package:native_app/widgets/buttons/next.dart';
import 'display.dart';

class Bayan extends ConsumerWidget {
  const Bayan({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;

    var query = SingleModelQuery(
      repository: ref.bayans,
      id: QR.params['id'].toString(),
      params: const {'include': 'speaker'},
    );

    var modelQuery = ref.watch(singleModelProvider(query));

    return modelQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resource) {
        Future? previousPage() async {
          var previousResources = await ref.bayans.findAll(
            params: {
              'quantity': 1,
              'include': 'speaker',
              'position': resource.position + 1,
            },
          );

          if (previousResources.isEmpty) {
            await QR.to('bayans');
          } else {
            await QR.to('bayans/${previousResources.first.id}');
          }
        }

        Future? nextPage() async {
          var nextResources = await ref.bayans.findAll(
            params: {
              'quantity': 1,
              'include': 'speaker',
              'position': resource.position - 1,
            },
          );

          if (nextResources.isNotEmpty) {
            await QR.to('bayans/${nextResources.first.id}');
          }
        }

        ref.read(lastVisitedProvider.notifier).updateLastBayan(resource.id);

        return AppScaffold(
          onBackPressed: () async => await QR.to('bayans'),
          showPattern: false,
          title: Text(locales.bayan),
          body: NextPageSwipe(
            onPrevious: previousPage,
            onNext: nextPage,
            child: ItemContent(
              children: [
                BayanDisplay(
                  title: resource.title,
                  excerpt: resource.excerpt,
                  location: resource.location,
                  audio: resource.audio,
                  speaker: resource.speaker.value.name,
                  publishedAt: resource.publishedAt,
                ),
                if (resource.audio != null) ...[
                  DownloadItem(
                    filePath: resource.audio['id'],
                    fileUrl: fileSrcUrl(resource.audio),
                    downloadCallback: () async {
                      await ref.watch(
                        createDownloadedBayanProvider({
                          'bayanId': resource.id,
                          'title': resource.title,
                          'excerpt': resource.excerpt,
                          'location': resource.location,
                          'audio': json.encode(resource.audio),
                          'speaker': resource.speaker.value.name,
                          'publishedAt': resource.publishedAt,
                        }).future,
                      );
                    },
                    deleteCallback: () async {
                      await ref.watch(
                        deleteDownloadedBayanProvider(resource.id).future,
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
          bottomBar: BottomBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: [
              Previous(onPrevious: previousPage),
              Row(
                children: [
                  SocialShare(
                    title: resource.title,
                    subtitle: resource.speaker.value?.name,
                    link: 'bayans/${resource.id}',
                  ),
                  BookmarkButton(
                    type: 'Bayan',
                    title: resource.title,
                    link: 'bayans/${resource.id}',
                  ),
                ],
              ),
              Next(onNext: nextPage),
            ],
          ),
        );
      },
    );
  }
}
