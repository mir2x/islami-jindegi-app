import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/providers/downloaded_masail.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/widgets/presentation/resizable_font.dart';
import 'package:native_app/widgets/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/presentation/download_item.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/helpers/file_title_path.dart';
import 'package:native_app/helpers/file_utils.dart';
import 'package:native_app/widgets/buttons/social_share.dart';
import 'package:native_app/widgets/buttons/bookmark.dart';
import 'package:native_app/widgets/buttons/font_resizer.dart';
import 'masail_display.dart';

class DownloadedMasailScreen extends ConsumerWidget {
  const DownloadedMasailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    int id = int.parse(QR.params['id'].toString());
    var modelQuery = ref.watch(getDownloadedMasailProvider(id));

    return modelQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resource) {
        Map audio = json.decode(resource.audio);

        return ResizableFont(
          storeKey: 'masailFontRatio',
          builder: (context, fontSizeRatio) {
            return AppScaffold(
              showPattern: false,
              title: Text('${locales.downloaded} ${locales.masail}'),
              body: ItemContent(
                children: [
                  MasailDisplay(
                    title: resource.title,
                    question: resource.question,
                    answer: resource.answer,
                    audio: audio,
                    author: resource.author,
                    fontSizeRatio: fontSizeRatio,
                    downloadItem: (audio.isNotEmpty)
                        ? DownloadItem(
                            filePath: fileTitlePath(
                              resource.title,
                              audio['id'],
                            ),
                            fileUrl: fileSrcUrl(audio),
                            deleteCallback: () async {
                              await ref
                                  .watch(downloadedMasailProvider.notifier)
                                  .deleteItem(resource.masailId);

                              await QR.to('masail/downloads');
                            },
                          )
                        : null,
                  ),
                ],
              ),
              bottomBar: BottomBar(
                alignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SocialShare(
                        title: resource.title,
                        body: '${resource.question} \n\n${resource.answer}',
                        link: 'masail/${resource.masailId}',
                      ),
                      BookmarkButton(
                        type: 'Masail',
                        title: resource.title,
                        link: 'masail/${resource.masailId}',
                      ),
                    ],
                  ),
                  FontResizer(
                    fontSizeRatio: fontSizeRatio,
                    storeKey: 'masailFontRatio',
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
