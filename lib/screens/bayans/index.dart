import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/widgets/presentation/list_item.dart';
import 'package:native_app/helpers/format_date.dart';

class Bayans extends ConsumerWidget {
  const Bayans({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTheme = Theme.of(context).textTheme;

    return MyScaffold(
      title: const Text('Bayans'),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
          child: InfiniteList(
            pageSize: 9,
            resourceFetcher: (int pageKey, int pageSize) async {
              AllModelsQuery query = AllModelsQuery(
                repository: 'bayans',
                params: {
                  'page': pageKey,
                  'per_page': pageSize,
                  'include': 'speaker',
                },
              );

              return await ref.read(allModelsProvider(query).future);
            },
            itemBuilder: (_, item, __) {
              return InkWell(
                onTap: () => QR.to('bayans/${item.id}'),
                child: ListItem(
                  item: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: textTheme.titleMedium,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Text(
                          formatDate(item.publishedAt),
                          style: textTheme.labelSmall,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
