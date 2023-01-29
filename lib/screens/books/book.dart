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
                  bottom: 8,
                  left: 15,
                  right: 15,
                ),
                child: Text('Contents', style: textTheme.labelLarge),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: InfiniteList(
                    padding: 0,
                    resourceFetcher: (Map<String, dynamic> params) async {
                      AllModelsQuery query = AllModelsQuery(
                        repository: ref.chapters,
                        params: {
                          ...params,
                          'bookId': book.id,
                          'include': 'subchapters',
                        },
                      );

                      return await ref.read(allModelsProvider(query).future);
                    },
                    itemBuilder: (_, chapter, __) {
                      if (chapter.subchapters.length > 0) {
                        return Subchapters(
                          book: book,
                          chapter: chapter,
                        );
                      } else {
                        return InkWell(
                          onTap: () => QR.to(
                            'books/${book.id}/chapters/${chapter.id}',
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: ThemeColors.color4,
                                ),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
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

class Subchapters extends ConsumerStatefulWidget {
  const Subchapters({
    super.key,
    required this.book,
    required this.chapter,
  });

  final dynamic book;
  final dynamic chapter;

  @override
  SubchaptersState createState() => SubchaptersState();
}

class SubchaptersState extends ConsumerState<Subchapters> {
  bool isOpen = false;
  final ScrollController sectionController = ScrollController();

  toggleOpen() {
    setState(() {
      isOpen = !isOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: ThemeColors.color4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: toggleOpen,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.chapter.title,
                      style: textTheme.titleLarge,
                    ),
                  ),
                  Icon(
                    isOpen ? Icons.arrow_upward : Icons.arrow_downward,
                  ),
                ],
              ),
            ),
          ),
          if (isOpen) ...[
            Container(
              padding: const EdgeInsets.only(
                left: 30,
                bottom: 10,
              ),
              constraints: BoxConstraints(
                maxHeight: screenHeight * 0.4,
              ),
              child: Scrollbar(
                thumbVisibility: true,
                controller: sectionController,
                child: SingleChildScrollView(
                  controller: sectionController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ...widget.chapter.subchapters.map((subchapter) {
                        return InkWell(
                          onTap: () => QR.to(
                            'books/${widget.book.id}/subchapters/${subchapter.id}',
                          ),
                          child: Container(
                            padding: const EdgeInsets.only(
                              bottom: 15,
                              right: 15,
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
              ),
            ),
          ]
        ],
      ),
    );
  }
}
