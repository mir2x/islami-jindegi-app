import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/single_model.dart';
import 'package:native_app/objects/single_model_query.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/objects/font_size_ratio.dart';
import 'package:native_app/widgets/page/html_body.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/buttons/social_share.dart';
import 'package:native_app/widgets/buttons/bookmark.dart';
import 'package:native_app/widgets/buttons/font_resizer.dart';
import 'package:native_app/widgets/buttons/previous_next.dart';

class Subchapter extends ConsumerWidget {
  const Subchapter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

        return MyScaffold(
          title: Text(resource.title),
          body: ItemContent(
            children: [
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
              PreviousNext(
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
                  }
                },
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
