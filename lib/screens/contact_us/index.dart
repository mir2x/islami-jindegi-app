import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/objects/font_size_ratio.dart';
import 'package:native_app/widgets/page/title.dart';
import 'package:native_app/widgets/page/html_body.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/buttons/social_share.dart';
import 'package:native_app/widgets/buttons/font_resizer.dart';

class ContactUs extends ConsumerWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var fontSizeRatio = FontSizeRatio();

    var query = AllModelsQuery(
      repository: ref.pages,
      params: const {'slug': 'contact', 'quantity': 1},
    );

    var modelQuery = ref.watch(allModelsProvider(query));

    return modelQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resources) {
        var item = resources[0];

        return MyScaffold(
          title: const Text('Contact Us'),
          body: ItemContent(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: PageTitle(
                  text: item.title,
                  fontSizeRatio: fontSizeRatio,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: PageHtmlBody(
                  text: item.body,
                  fontSizeRatio: fontSizeRatio,
                ),
              ),
            ],
          ),
          bottomBar: BottomBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: [
              SocialShare(
                title: item.title,
                body: item.body,
              ),
              FontResizer(fontSizeRatio: fontSizeRatio),
            ],
          ),
        );
      },
    );
  }
}
