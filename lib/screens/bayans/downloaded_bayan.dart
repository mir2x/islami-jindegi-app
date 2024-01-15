import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/providers/downloaded_bayans.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/presentation/download_item.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/helpers/file_title_path.dart';
import 'package:native_app/helpers/file_utils.dart';
import 'package:native_app/widgets/buttons/social_share.dart';
import 'package:native_app/widgets/buttons/bookmark.dart';
import 'display.dart';

class DownloadedBayan extends ConsumerWidget {
  const DownloadedBayan({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    int id = int.parse(QR.params['id'].toString());
    var modelQuery = ref.watch(getDownloadedBayanProvider(id));

    return modelQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resource) {
        Map audio = json.decode(resource.audio);

        return AppScaffold(
          showPattern: false,
          title: Text('${locales.downloaded} ${locales.bayans}'),
          body: ItemContent(
            children: [
              BayanDisplay(
                title: resource.title,
                excerpt: resource.excerpt,
                location: resource.location,
                audio: audio,
                speaker: resource.speaker,
                publishedAt: resource.publishedAt,
                downloadItem: (audio.isNotEmpty)
                    ? DownloadItem(
                        filePath: fileTitlePath(resource.title, audio['id']),
                        fileUrl: fileSrcUrl(audio),
                        deleteCallback: () async {
                          await ref
                              .watch(downloadedBayansProvider.notifier)
                              .deleteItem(resource.bayanId);

                          await QR.to('bayans/downloads');
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
                fileLink: fileSrcUrl(audio),
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
