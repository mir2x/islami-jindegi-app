import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/providers/single_model.dart';
import 'package:native_app/objects/single_model_query.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/styles/settings/theme_colors.dart';
import 'package:native_app/widgets/utils/html_text.dart';
import 'package:native_app/helpers/format_date.dart';

class Article extends ConsumerWidget {
  const Article({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SingleModelQuery query = SingleModelQuery(
      repository: 'articles',
      id: QR.params['id'].toString()
    );

    return ref.watch(singleModelProvider(query)).when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resource) {
        return MyScaffold(
          title: Text(resource.title),
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: 50
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: Text(
                      resource.title,
                      style: TextStyle(
                        color: ThemeColors().themeColor3,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: Text(
                      formatDate(resource.createdAt!),
                      style: TextStyle(
                        color: ThemeColors().themeColor3,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    child: HtmlText(
                      text: resource.body,
                    ),
                  ),
                ],
              )
            ),
          ),
        );
      }
    );
  }
}
