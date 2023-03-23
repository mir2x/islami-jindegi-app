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
import 'package:native_app/widgets/page/title.dart';
import 'package:native_app/widgets/page/subtitle.dart';
import 'package:native_app/widgets/page/html_body.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/buttons/social_share.dart';
import 'package:native_app/widgets/buttons/bookmark.dart';
import 'package:native_app/widgets/buttons/font_resizer.dart';

class Article extends ConsumerWidget {
  const Article({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var fontSizeRatio = FontSizeRatio();

    var query = SingleModelQuery(
      repository: ref.articles,
      id: QR.params['id'].toString(),
      params: const {'include': 'article-author'},
      remote: true,
    );

    var modelQuery = ref.watch(singleModelProvider(query));

    return modelQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resource) {
        return MyScaffold(
          title: Text(resource.title),
          body: ItemContent(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: PageTitle(
                  text: resource.title,
                  fontSizeRatio: fontSizeRatio,
                ),
              ),
              if (resource.articleAuthor.value != null) ...[
                Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: PageSubtitle(
                    text: resource.articleAuthor.value.name,
                    fontSizeRatio: fontSizeRatio,
                  ),
                ),
              ],
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
                    subtitle: resource.articleAuthor.value.name,
                    body: resource.body,
                  ),
                  BookmarkButton(
                    type: 'Article',
                    title: resource.title,
                    link: 'articles/${resource.id}',
                  ),
                ],
              ),
              FontResizer(fontSizeRatio: fontSizeRatio),
            ],
          ),
        );
      },
    );
  }
}
