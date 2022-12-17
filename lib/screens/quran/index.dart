import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/widgets/presentation/list_item.dart';

class Quran extends ConsumerWidget {
  const Quran({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTheme = Theme.of(context).textTheme;

    return MyScaffold(
      title: const Text('Quran'),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: InfiniteList(
          resourceFetcher: (Map<String, dynamic> params) async {
            AllModelsQuery query = AllModelsQuery(
              repository: 'surahs',
              params: params,
            );

            return await ref.read(allModelsProvider(query).future);
          },
          itemBuilder: (_, item, __) {
            return InkWell(
              onTap: () => QR.to('quran/surah/${item.id}'),
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
    );
  }
}
