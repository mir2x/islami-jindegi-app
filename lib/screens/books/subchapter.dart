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
import 'package:native_app/widgets/buttons/previous.dart';
import 'package:native_app/widgets/buttons/next.dart';

class Subchapter extends ConsumerWidget {
  const Subchapter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var fontSizeRatio = FontSizeRatio();

    var query = SingleModelQuery(
      repository: ref.subchapters,
      id: QR.params['subchapter_id'].toString(),
      params: const {'include': 'chapter'},
    );

    var bookId = QR.params['id'];

    var modelQuery = ref.watch(singleModelProvider(query));

    return modelQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resource) {
        var chapterId = resource.chapter.value.id;

        return AppScaffold(
          onBackPressed: () async => await QR.to('books/$bookId'),
          title: Text(locales.book),
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
              Previous(
                onPrevious: () async {
                  var previousResources = await ref.subchapters.findAll(
                        params: {
                          'quantity': 1,
                          'chapterId': chapterId,
                          'position': resource.position - 1,
                        },
                      ) ??
                      [];

                  if (previousResources.isNotEmpty) {
                    await QR.to(
                      'books/$bookId/subchapters/${previousResources.first.id}',
                    );
                  } else {
                    var currentChapter = await ref.chapters.findOne(chapterId);

                    if (currentChapter != null) {
                      var previousChapters = await ref.chapters.findAll(
                            params: {
                              'quantity': 1,
                              'include': 'subchapters',
                              'bookId': bookId,
                              'position': currentChapter.position! - 1,
                            },
                          ) ??
                          [];

                      if (previousChapters.isNotEmpty) {
                        var subchapters = previousChapters.first.subchapters;

                        if (subchapters != null && subchapters.isNotEmpty) {
                          var lastSubchapter = subchapters.map((a) => a).last;

                          await QR.to(
                            'books/$bookId/subchapters/${lastSubchapter.id}',
                          );
                        } else {
                          await QR.to(
                            'books/$bookId/chapters/${previousChapters.first.id}',
                          );
                        }
                      }
                    }
                  }
                },
              ),
              Row(
                children: [
                  SocialShare(
                    title: resource.title,
                    body: resource.body,
                    link: 'books/$bookId/subchapters/${resource.id}',
                  ),
                  BookmarkButton(
                    type: 'Book Subchapter',
                    title: resource.title,
                    link: 'books/$bookId/subchapters/${resource.id}',
                  ),
                ],
              ),
              FontResizer(fontSizeRatio: fontSizeRatio),
              Next(
                onNext: () async {
                  var nextResources = await ref.subchapters.findAll(
                        params: {
                          'quantity': 1,
                          'chapterId': chapterId,
                          'position': resource.position + 1,
                        },
                      ) ??
                      [];

                  if (nextResources.isNotEmpty) {
                    await QR.to(
                      'books/$bookId/subchapters/${nextResources.first.id}',
                    );
                  } else {
                    var currentChapter = await ref.chapters.findOne(chapterId);

                    if (currentChapter != null) {
                      var nextChapters = await ref.chapters.findAll(
                            params: {
                              'quantity': 1,
                              'include': 'subchapters',
                              'bookId': bookId,
                              'position': currentChapter.position! + 1,
                            },
                          ) ??
                          [];

                      if (nextChapters.isNotEmpty) {
                        var subchapters = nextChapters.first.subchapters;

                        if (subchapters != null && subchapters.isNotEmpty) {
                          await QR.to(
                            'books/$bookId/subchapters/${subchapters.first.id}',
                          );
                        } else {
                          await QR.to(
                            'books/$bookId/chapters/${nextChapters.first.id}',
                          );
                        }
                      }
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
