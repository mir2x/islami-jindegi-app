import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/providers/single_model.dart';
import 'package:native_app/objects/single_model_query.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/styles/settings/theme_colors.dart';
import 'package:native_app/widgets/utils/html_text.dart';

class MasailItem extends ConsumerWidget {
  const MasailItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SingleModelQuery query = SingleModelQuery(
      repository: 'masails',
      id: QR.params['id'].toString(),
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
                margin: const EdgeInsets.only(bottom: 30),
                child: Text(
                  resource.title,
                  style: TextStyle(
                    color: ThemeColors().themeColor3,
                    fontSize: 20,
                  ),
                ),
              ),
              Text(
                'Question:',
                style: TextStyle(
                  color: ThemeColors().themeColor3,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 30),
                child: HtmlText(
                  text: resource.question,
                ),
              ),
              Text(
                'Answer:',
                style: TextStyle(
                  color: ThemeColors().themeColor3,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 30),
                child: HtmlText(
                  text: resource.answer,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
