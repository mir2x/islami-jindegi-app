import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/utils/html_text.dart';

class Donation extends ConsumerWidget {
  const Donation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTheme = Theme.of(context).textTheme;

    var query = AllModelsQuery(
      repository: ref.pages,
      params: const {'slug': 'donation', 'quantity': 1},
    );

    var modelQuery = ref.watch(allModelsProvider(query));

    return MyScaffold(
      title: const Text('Donation'),
      body: modelQuery.when(
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (error, _) => ModelExeptionHandler(error: error),
        data: (resources) {
          var item = resources[0];

          return ItemContent(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: Text(
                  item.title,
                  style: textTheme.headlineMedium,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: HtmlText(
                  text: item.body,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
