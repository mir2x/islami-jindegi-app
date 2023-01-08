import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';
import 'package:native_app/widgets/inputs/search_field.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/providers/query_params.dart';
import 'package:native_app/widgets/presentation/list_item.dart';

class Madrasahs extends ConsumerWidget {
  const Madrasahs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTheme = Theme.of(context).textTheme;
    var qParams = ref.watch(queryParamsProvider);

    return MyScaffold(
      title: const Text('Madrasahs'),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
            child: SearchField(
              onUpdate: (value) {
                ref
                    .read(queryParamsProvider.notifier)
                    .updateParams('search', value);
              },
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: InfiniteList(
                qParams: qParams,
                resourceFetcher: (Map<String, dynamic> params) async {
                  AllModelsQuery query = AllModelsQuery(
                    repository: ref.madrasahs,
                    params: params,
                  );

                  return await ref.read(allModelsProvider(query).future);
                },
                itemBuilder: (_, item, __) {
                  return InkWell(
                    onTap: () => QR.to('madrasahs/${item.id}'),
                    child: ListItem(
                      item: Text(
                        item.title,
                        style: textTheme.titleMedium,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
