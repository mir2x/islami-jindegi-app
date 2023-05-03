import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:flutter_svg/svg.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/providers/single_model.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/objects/single_model_query.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/full_screen.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/presentation/description_item.dart';
import 'package:native_app/widgets/presentation/download_item.dart';
import 'package:native_app/widgets/responsive/image.dart';
import 'package:native_app/widgets/document/pdf_reader.dart';
import 'package:native_app/helpers/file_utils.dart';
import 'package:native_app/theme/colors.dart';

class BookItem extends ConsumerWidget {
  const BookItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;

    var query = SingleModelQuery(
      repository: ref.books,
      id: QR.params['id'].toString(),
    );

    var modelQuery = ref.watch(singleModelProvider(query));

    return modelQuery.when(
      loading: () => const FullScreen(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (book) {
        var cQuery = AllModelsQuery(
          repository: ref.chapters,
          params: {'bookId': book.id, 'quantity': 1},
        );

        var chapterQuery = ref.watch(allModelsProvider(cQuery));

        return AppScaffold(
          title: Text(locales.book),
          body: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 15,
                ),
                child: Text(
                  book.title,
                  style: textTheme.headlineMedium,
                ),
              ),
              chapterQuery.when(
                loading: () => const SizedBox.shrink(),
                error: (error, _) => Text(error.toString()),
                data: (chapters) {
                  if (chapters.isNotEmpty) {
                    return Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                              top: 20,
                              bottom: 8,
                              left: 15,
                              right: 15,
                            ),
                            child: Text(
                              locales.contents,
                              style: textTheme.labelLarge,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: InfiniteList(
                                padding: 0,
                                resourceFetcher:
                                    (Map<String, dynamic> params) async {
                                  AllModelsQuery query = AllModelsQuery(
                                    repository: ref.chapters,
                                    params: {
                                      ...params,
                                      'bookId': book.id,
                                      'include': 'subchapters',
                                    },
                                  );

                                  return await ref
                                      .read(allModelsProvider(query).future);
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
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 15,
                                        ),
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
                  } else {
                    double screenWidth = MediaQuery.of(context).size.width;

                    return ItemContent(
                      children: [
                        if (book.document != null) ...[
                          Container(
                            height: 540,
                            margin: const EdgeInsets.only(bottom: 40),
                            child: PDFReader(document: book.document),
                          ),
                        ] else ...[
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            width: screenWidth / 2,
                            child: ResponsiveImage(
                              image: book.image,
                              model: 'book',
                              vwset: const {'xs': 50},
                            ),
                          ),
                        ],
                        if (book.publisher != null) ...[
                          DescriptionItem(
                            title: '${locales.publisher}:',
                            description: Text(
                              book.publisher,
                              style: textTheme.labelMedium,
                            ),
                          ),
                        ],
                        if (book.publishedAt != null) ...[
                          DescriptionItem(
                            title: '${locales.publicationDate}:',
                            description: Text(
                              book.publishedAt,
                              style: textTheme.labelMedium,
                            ),
                          ),
                        ],
                        if (book.price != null) ...[
                          DescriptionItem(
                            title: '${locales.price}:',
                            description: Text(
                              book.price,
                              style: textTheme.labelMedium,
                            ),
                          ),
                        ],
                        if (book.document != null) ...[
                          DownloadItem(
                            filePath: book.document['id'],
                            fileUrl: fileSrcUrl(book.document),
                          ),
                        ],
                      ],
                    );
                  }
                },
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

      if (isOpen) {
        Scrollable.ensureVisible(
          GlobalObjectKey(widget.chapter.id).currentContext!,
        );
      }
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
            key: GlobalObjectKey(widget.chapter.id),
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
                  const SizedBox(width: 20),
                  isOpen
                      ? SvgPicture.asset(
                          'assets/images/icons/angle-up.svg',
                          fit: BoxFit.scaleDown,
                          width: 20,
                        )
                      : SvgPicture.asset(
                          'assets/images/icons/angle-down.svg',
                          fit: BoxFit.scaleDown,
                          width: 20,
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
