import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/widgets/responsive/image.dart';

class Books extends ConsumerWidget {
  const Books({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTheme = Theme.of(context).textTheme;

    return MyScaffold(
      title: const Text('Books'),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: InfiniteList(
          resourceFetcher: (int pageKey, int pageSize) async {
            AllModelsQuery query = AllModelsQuery(
              repository: 'books',
              params: {'page': pageKey, 'per_page': pageSize},
            );

            return await ref.read(allModelsProvider(query).future);
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisExtent: 390,
          ),
          itemBuilder: (_, item, __) {
            return Container(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                children: [
                  InkWell(
                    onTap: () => QR.to('books/${item.id}'),
                    child: ResponsiveImage(
                      image: item.image,
                      model: 'book',
                      vwset: const {'xs': 50},
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: InkWell(
                      onTap: () => QR.to('books/${item.id}'),
                      child: Text(
                        item.title,
                        style: textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
