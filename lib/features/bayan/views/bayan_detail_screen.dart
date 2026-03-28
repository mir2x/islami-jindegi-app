import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/providers/last_visited.dart';
import 'package:native_app/providers/downloaded_bayans.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/widgets/gestures/next_page_swipe.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/presentation/download_item.dart';
import 'package:native_app/widgets/error_pages/model_exception_handler.dart';
import 'package:native_app/helpers/file_utils.dart';
import 'package:native_app/helpers/file_title_path.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/buttons/social_share.dart';
import 'package:native_app/widgets/buttons/bookmark.dart';
import 'package:native_app/widgets/buttons/previous.dart';
import 'package:native_app/widgets/buttons/next.dart';
import '../providers/bayan_providers.dart';
import 'bayan_display.dart';

class BayanDetailScreen extends ConsumerWidget {
  const BayanDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var bayanId = GoRouterState.of(context).pathParameters['id'].toString();
    var bayanQuery = ref.watch(singleBayanProvider(bayanId));

    return bayanQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resource) {
        final api = ref.read(bayanApiServiceProvider);

        Future? previousPage() async {
          if (resource.position == null) {
            context.go('/bayans');
            return;
          }
          var previousResources = await api.fetchBayansByPosition(
            quantity: 1,
            position: resource.position! + 1,
          );

          if (previousResources.isEmpty) {
            context.go('/bayans');
          } else {
            context.go('/bayans/${previousResources.first.id}');
          }
        }

        Future? nextPage() async {
          if (resource.position == null) return;
          var nextResources = await api.fetchBayansByPosition(
            quantity: 1,
            position: resource.position! - 1,
          );

          if (nextResources.isNotEmpty) {
            context.go('/bayans/${nextResources.first.id}');
          }
        }

        Future(() {
          ref.read(lastVisitedProvider.notifier).updateLastBayan(resource.id);
        });

        return AppScaffold(
          onBackPressed: () async => context.canPop() ? context.pop() : context.go('/bayans'),
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
                  speaker: resource.speakerName,
                  publishedAt: resource.publishedAt,
                  downloadItem: (resource.audio != null)
                      ? DownloadItem(
                          filePath: fileTitlePath(
                            resource.title,
                            resource.audio!['id'],
                          ),
                          fileUrl: fileSrcUrl(resource.audio),
                          downloadCallback: () async {
                            await ref.watch(
                              createDownloadedBayanProvider({
                                'bayanId': resource.id,
                                'title': resource.title,
                                'excerpt': resource.excerpt,
                                'location': resource.location,
                                'audio': json.encode(resource.audio),
                                'speaker': resource.speakerName,
                                'publishedAt': resource.publishedAt,
                              }).future,
                            );
                          },
                          deleteCallback: () async {
                            await ref.watch(
                              deleteDownloadedBayanProvider(resource.id).future,
                            );
                          },
                        )
                      : null,
                ),
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
                    subtitle: resource.speakerName,
                    link: 'bayans/${resource.id}',
                    fileLink: fileSrcUrl(resource.audio),
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
