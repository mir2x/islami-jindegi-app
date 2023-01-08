import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/providers/single_model.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/objects/single_model_query.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/theme/colors.dart';

class Book extends ConsumerWidget {
  const Book({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTheme = Theme.of(context).textTheme;

    var query = SingleModelQuery(
      repository: ref.books,
      id: QR.params['id'].toString(),
    );

    var modelQuery = ref.watch(singleModelProvider(query));

    return modelQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (book) {
        return MyScaffold(
          title: Text(book.title),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(
                  top: 30,
                  left: 15,
                  right: 15,
                ),
                child: Text('Contents', style: textTheme.labelLarge),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                    bottom: 30,
                  ),
                  child: InfiniteList(
                    resourceFetcher: (Map<String, dynamic> params) async {
                      AllModelsQuery query = AllModelsQuery(
                        repository: ref.chapters,
                        params: {
                          ...params,
                          'book_id': book.id,
                          'include': 'subchapters',
                        },
                      );

                      return await ref.read(allModelsProvider(query).future);
                    },
                    itemBuilder: (_, chapter, __) {
                      if (chapter.subchapters.length > 0) {
                        return Container(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                chapter.title,
                                style: textTheme.titleLarge?.copyWith(
                                  color: ThemeColors.color8,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                  left: 30,
                                  top: 15,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ...chapter.subchapters.map((subchapter) {
                                      return InkWell(
                                        onTap: () => QR.to(
                                          'books/${book.id}/subchapters/${subchapter.id}',
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                            bottom: 15,
                                          ),
                                          child: Text(
                                            subchapter.title,
                                            style: textTheme.titleMedium,
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return InkWell(
                          onTap: () => QR.to(
                            'books/${book.id}/chapters/${chapter.id}',
                          ),
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Text(
                              chapter.title,
                              style: textTheme.titleLarge,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
