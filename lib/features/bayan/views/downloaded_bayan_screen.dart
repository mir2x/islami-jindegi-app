import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/providers/downloaded_bayans.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/widgets/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/presentation/download_item.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/helpers/file_title_path.dart';
import 'package:native_app/widgets/buttons/social_share.dart';
import 'package:native_app/widgets/buttons/bookmark.dart';
import 'bayan_display.dart';

class DownloadedBayanScreen extends ConsumerWidget {
  const DownloadedBayanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    int id = int.parse(GoRouterState.of(context).pathParameters['id'].toString());
    var modelQuery = ref.watch(getDownloadedBayanProvider(id));

    return modelQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resource) {
        final bayanId = resource.bayanId ?? '';
        final audioUrl = resource.audio;

        return AppScaffold(
          showPattern: false,
          title: Text('${locales.downloaded} ${locales.bayans}'),
          body: ItemContent(
            children: [
              BayanDisplay(
                bayanId: bayanId,
                title: resource.title ?? '',
                excerpt: resource.excerpt,
                location: resource.location,
                audioUrl: audioUrl,
                speaker: resource.speaker,
                publishedAt: resource.publishedAt ?? '',
                downloadItem: (audioUrl != null && audioUrl.isNotEmpty)
                    ? DownloadItem(
                        filePath: fileTitlePath(
                          resource.title ?? '',
                          'bayans/$bayanId',
                        ),
                        fileUrl: audioUrl,
                        deleteCallback: () async {
                          await ref
                              .watch(downloadedBayansProvider.notifier)
                              .deleteItem(resource.bayanId);

                          await context.push('/bayans/downloads');
                        },
                      )
                    : null,
              ),
            ],
          ),
          bottomBar: BottomBar(
            alignment: MainAxisAlignment.center,
            children: [
              SocialShare(
                title: resource.title,
                subtitle: resource.speaker,
                link: 'bayans/${resource.bayanId}',
                fileLink: audioUrl,
              ),
              BookmarkButton(
                type: 'Bayan',
                title: resource.title,
                link: 'bayans/${resource.bayanId}',
              ),
            ],
          ),
        );
      },
    );
  }
}
