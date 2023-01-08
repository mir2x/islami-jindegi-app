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
import 'package:native_app/widgets/utils/html_text.dart';
import 'package:native_app/helpers/format_date.dart';

class NewsItem extends ConsumerWidget {
  const NewsItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTheme = Theme.of(context).textTheme;

    var query = SingleModelQuery(
      repository: ref.news,
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
                margin: const EdgeInsets.only(bottom: 15),
                child: Text(
                  resource.title,
                  style: textTheme.headlineMedium,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: Text(
                  formatDate(resource.createdAt!),
                  style: textTheme.labelMedium,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: HtmlText(
                  text: resource.body,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
