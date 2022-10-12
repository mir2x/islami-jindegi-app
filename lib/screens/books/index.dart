import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/widgets/presentation/list_item.dart';
import 'package:native_app/styles/settings/theme_colors.dart';

class Books extends ConsumerWidget {
  const Books({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MyScaffold(
      title: const Text('Books'),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
          child: InfiniteList(
            resourceFetcher: (int pageKey, int pageSize) async {
              AllModelsQuery query = AllModelsQuery(
                repository: 'books',
                params: {'page': pageKey, 'per_page': pageSize},
              );

              return await ref.read(allModelsProvider(query).future);
            },
            itemBuilder: (_, item, __) {
              return InkWell(
                onTap: () => QR.to('books/${item.id}'),
                child: ListItem(
                  item: Text(
                    item.title,
                    style: TextStyle(color: ThemeColors().themeColor4),
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
