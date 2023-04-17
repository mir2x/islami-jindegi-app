import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/single_model.dart';
import 'package:native_app/objects/single_model_query.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/objects/font_size_ratio.dart';
import 'package:native_app/widgets/page/title.dart';
import 'package:native_app/widgets/page/html_body.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/buttons/social_share.dart';
import 'package:native_app/widgets/buttons/bookmark.dart';
import 'package:native_app/widgets/buttons/font_resizer.dart';
import 'package:native_app/widgets/buttons/previous_next.dart';

class Chapter extends ConsumerWidget {
  const Chapter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var fontSizeRatio = FontSizeRatio();

    var query = SingleModelQuery(
      repository: ref.chapters,
      id: QR.params['chapter_id'].toString(),
    );

    var bookId = QR.params['id'];

    var modelQuery = ref.watch(singleModelProvider(query));

    return modelQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resource) {
        return AppScaffold(
          title: Text(locales.chapter),
          body: ItemContent(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: PageTitle(
                  text: resource.title,
                  fontSizeRatio: fontSizeRatio,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: PageHtmlBody(
                  text: resource.body,
                  fontSizeRatio: fontSizeRatio,
                ),
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
                    body: resource.body,
                    link: 'books/$bookId/chapters/${resource.id}',
                  ),
                  BookmarkButton(
                    type: 'Book Chapter',
                    title: resource.title,
                    link: 'books/$bookId/chapters/${resource.id}',
                  ),
                ],
              ),
              FontResizer(fontSizeRatio: fontSizeRatio),
              PreviousNext(
                onPrevious: () async {
                  var previousResources = await ref.chapters.findAll(
                        params: {
                          'quantity': 1,
                          'include': 'subchapters',
                          'bookId': bookId,
                          'position': resource.position - 1,
                        },
                      ) ??
                      [];

                  if (previousResources.isNotEmpty) {
                    var subchapters = previousResources.first.subchapters;

                    if (subchapters != null && subchapters.isNotEmpty) {
                      var lastSubchapter = subchapters.map((a) => a).last;

                      await QR.to(
                        'books/$bookId/subchapters/${lastSubchapter.id}',
                      );
                    } else {
                      await QR.to(
                        'books/$bookId/chapters/${previousResources.first.id}',
                      );
                    }
                  }
                },
                onNext: () async {
                  var nextResources = await ref.chapters.findAll(
                        params: {
                          'quantity': 1,
                          'include': 'subchapters',
                          'bookId': bookId,
                          'position': resource.position + 1,
                        },
                      ) ??
                      [];

                  if (nextResources.isNotEmpty) {
                    var subchapters = nextResources.first.subchapters;

                    if (subchapters != null && subchapters.isNotEmpty) {
                      await QR.to(
                        'books/$bookId/subchapters/${subchapters.first.id}',
                      );
                    } else {
                      await QR.to(
                        'books/$bookId/chapters/${nextResources.first.id}',
                      );
                    }
                  }
                },
                previousDisabled: resource.position == 1,
              ),
            ],
          ),
        );
      },
    );
  }
}
