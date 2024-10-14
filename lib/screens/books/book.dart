import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:flutter_svg/svg.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/single_model.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/providers/check_downloaded_file.dart';
import 'package:native_app/providers/downloaded_books.dart';
import 'package:native_app/objects/single_model_query.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/layouts/placeholder_scaffold.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/widgets/gestures/next_page_swipe.dart';
import 'package:native_app/widgets/utils/with_last_visited.dart';
import 'package:native_app/widgets/utils/comma_separated_list.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/buttons/social_share.dart';
import 'package:native_app/widgets/buttons/bookmark.dart';
import 'package:native_app/widgets/buttons/previous.dart';
import 'package:native_app/widgets/buttons/next.dart';
import 'package:native_app/widgets/buttons/download.dart';
import 'package:native_app/widgets/buttons/open_file.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/widgets/utils/with_connectivity.dart';
import 'package:native_app/widgets/presentation/connect_to_internet.dart';
import 'package:native_app/widgets/presentation/description_item.dart';
import 'package:native_app/widgets/utils/pdf_menu.dart';
import 'package:native_app/helpers/file_title_path.dart';
import 'package:native_app/helpers/file_utils.dart';
import 'package:native_app/theme/colors.dart';
import 'pdf_reader.dart';
import 'image.dart';

class BookItem extends ConsumerWidget {
  const BookItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;

    var query = SingleModelQuery(
      repository: ref.books,
      id: QR.params['id'].toString(),
      params: const {'include': 'authors'},
    );

    var modelQuery = ref.watch(singleModelProvider(query));

    return modelQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (book) {
        Future? previousPage() async {
          var previousResources = await ref.books.findAll(
            params: {
              'quantity': 1,
              'include': 'authors',
              'position': book.position - 1,
            },
          );

          if (previousResources.isEmpty) {
            await QR.to('books');
          } else {
            await QR.to('books/${previousResources.first.id}');
          }
        }

        Future? nextPage() async {
          var nextResources = await ref.books.findAll(
            params: {
              'quantity': 1,
              'include': 'authors',
              'position': book.position + 1,
            },
          );

          if (nextResources.isNotEmpty) {
            await QR.to('books/${nextResources.first.id}');
          }
        }

        var cQuery = AllModelsQuery(
          repository: ref.chapters,
          params: {
            'bookId': book.id,
            'quantity': 1,
            'sort': '-position',
            'localFirst': true,
          },
        );

        var chapterQuery = ref.watch(allModelsProvider(cQuery));

        String? fileLink;

        if (book.document != null) {
          fileLink = fileSrcUrl(book.document);
        }

        return chapterQuery.when(
          loading: () {
            return const PlaceholderScaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
          error: (error, _) => Text(error.toString()),
          data: (chapters) {
            if (chapters.isNotEmpty) {
              var lastChapter = chapters.first;

              return AppScaffold(
                onBackPressed: () async => await QR.to('books'),
                showPattern: false,
                title: Text(locales.book),
                body: NextPageSwipe(
                  onPrevious: previousPage,
                  onNext: nextPage,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          top: 15,
                          left: 15,
                          right: 15,
                        ),
                        child: Text(
                          book.title,
                          textAlign: TextAlign.center,
                          style: textTheme.headlineLarge?.copyWith(height: 1.2),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 3, bottom: 15),
                        child: CommaSeparatedList(
                          resources: book.authors.map((e) => e).toList(),
                          alignment: WrapAlignment.center,
                          builder: (_, author, __) {
                            return Text(
                              author.name,
                              textAlign: TextAlign.center,
                              style: textTheme.labelMedium,
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          bottom: 10,
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
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: WithLastVisited(
                            builder: (context, settings) {
                              String? lastChapterId;

                              Map books = json.decode(
                                settings.getString('lastChapters') ?? '{}',
                              );

                              if (books.containsKey(book.id.toString())) {
                                lastChapterId = books[book.id.toString()];
                              }

                              var cQuery = AllModelsQuery(
                                repository: ref.chapters,
                                params: {
                                  'bookId': book.id,
                                  'quantity': lastChapter.position,
                                  'include': 'subchapters',
                                  'localFirst': true,
                                },
                              );

                              var chaptersQuery =
                                  ref.watch(allModelsProvider(cQuery));

                              return chaptersQuery.when(
                                loading: () {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                                error: (error, _) => Text(error.toString()),
                                data: (resources) {
                                  return ListView.builder(
                                    key: PageStorageKey<String>(book.id),
                                    itemCount: resources.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var chapter = resources[index];

                                      if (chapter.subchapters.length > 0) {
                                        return Subchapters(
                                          key: PageStorageKey<String>(
                                            chapter.id,
                                          ),
                                          book: book,
                                          chapter: chapter,
                                          lastSubchapterId: lastChapterId,
                                          isOpen: chapter.subchapters
                                              .map((s) => s.id.toString())
                                              .any((id) => id == lastChapterId),
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
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    chapter.title,
                                                    style: textTheme.titleLarge,
                                                  ),
                                                ),
                                                if (lastChapterId ==
                                                    chapter.id.toString()) ...[
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                      left: 10,
                                                    ),
                                                    child: SvgPicture.asset(
                                                      'assets/images/icons/open-book.svg',
                                                      fit: BoxFit.scaleDown,
                                                      width: 25,
                                                      height: 20,
                                                    ),
                                                  ),
                                                ] else ...[
                                                  const SizedBox.shrink(),
                                                ],
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                bottomBar: BottomBar(
                  alignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Previous(onPrevious: previousPage),
                    Row(
                      children: [
                        SocialShare(
                          title: book.title,
                          subtitle: book.authors
                              .map((e) => e.name)
                              .toList()
                              .join(', '),
                          link: 'books/${book.id}',
                          fileLink: fileLink,
                        ),
                        BookmarkButton(
                          type: 'Book',
                          title: book.title,
                          link: 'books/${book.id}',
                        ),
                      ],
                    ),
                    Next(onNext: nextPage),
                  ],
                ),
              );
            } else {
              String filePath = fileTitlePath(book.title, book.document['id']);
              var checkFileProvider = checkDownloadedFileProvider(filePath);
              var checkDownloadedFile = ref.watch(checkFileProvider);

              return checkDownloadedFile.when(
                loading: () {
                  return const PlaceholderScaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
                error: (error, stackTrace) => Text(error.toString()),
                data: (isDownloaded) {
                  if (isDownloaded) {
                    return PDFBook(
                      book: book,
                      filePath: filePath,
                      fileLink: fileLink,
                      previousPage: previousPage,
                      nextPage: nextPage,
                    );
                  } else {
                    double screenWidth = MediaQuery.of(context).size.width;

                    return AppScaffold(
                      onBackPressed: () async => await QR.to('books'),
                      showPattern: false,
                      title: Text(locales.book),
                      body: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(
                                top: 20,
                                left: 20,
                                right: 20,
                                bottom: 5,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    book.title,
                                    textAlign: TextAlign.center,
                                    style: textTheme.headlineLarge?.copyWith(
                                      height: 1.2,
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 3),
                                    child: CommaSeparatedList(
                                      resources:
                                          book.authors.map((e) => e).toList(),
                                      alignment: WrapAlignment.center,
                                      builder: (_, author, __) {
                                        return Text(
                                          author.name,
                                          textAlign: TextAlign.center,
                                          style: textTheme.labelMedium,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            WithConnectivity(
                              builder: (context, isConnected) {
                                if (!isConnected) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 20,
                                    ),
                                    child: const ConnectToInternet(),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                            ),
                            Center(
                              child: Container(
                                margin:
                                    const EdgeInsets.only(top: 20, bottom: 30),
                                width: screenWidth / 2,
                                child: BookImage(
                                  bookId: book.id,
                                  image: book.image,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                top: 30,
                                left: 20,
                                right: 20,
                                bottom: 50,
                              ),
                              child: Column(
                                children: [
                                  if (book.document != null) ...[
                                    WithConnectivity(
                                      builder: (context, isConnected) {
                                        if (isConnected) {
                                          return DescriptionItem(
                                            title: '${locales.download}:',
                                            description: Align(
                                              alignment: Alignment.centerLeft,
                                              child: DownloadButton(
                                                filePath: filePath,
                                                fileUrl:
                                                    fileSrcUrl(book.document),
                                                callback: () async {
                                                  await ref.watch(
                                                    createDownloadedBookProvider({
                                                      'bookId': book.id,
                                                      'title': book.title,
                                                      'excerpt': book.excerpt,
                                                      'publisher':
                                                          book.publisher,
                                                      'price': book.price,
                                                      'image': json
                                                          .encode(book.image),
                                                      'document': json.encode(
                                                        book.document,
                                                      ),
                                                      'authors': book.authors
                                                          .map((e) => e.name)
                                                          .toList()
                                                          .join(', '),
                                                      'publishedAt':
                                                          book.publishedAt,
                                                    }).future,
                                                  );
                                                },
                                              ),
                                            ),
                                            alignment:
                                                CrossAxisAlignment.center,
                                            textWidth: 120,
                                          );
                                        } else {
                                          return const SizedBox.shrink();
                                        }
                                      },
                                    ),
                                  ],
                                  if (book.publisher != null) ...[
                                    DescriptionItem(
                                      title: '${locales.publisher}:',
                                      description: Text(
                                        book.publisher!,
                                        style: textTheme.labelMedium,
                                      ),
                                    ),
                                  ],
                                  if (book.publishedAt != null) ...[
                                    DescriptionItem(
                                      title: '${locales.publicationDate}:',
                                      description: Text(
                                        book.publishedAt!,
                                        style: textTheme.labelMedium,
                                      ),
                                    ),
                                  ],
                                  if (book.price != null) ...[
                                    DescriptionItem(
                                      title: '${locales.price}:',
                                      description: Text(
                                        book.price!,
                                        style: textTheme.labelMedium,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      bottomBar: BottomBar(
                        alignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Previous(onPrevious: previousPage),
                          Row(
                            children: [
                              SocialShare(
                                title: book.title,
                                subtitle: book.authors
                                    .map((e) => e.name)
                                    .toList()
                                    .join(', '),
                                link: 'books/${book.id}',
                                fileLink: fileLink,
                              ),
                              BookmarkButton(
                                type: 'Book',
                                title: book.title,
                                link: 'books/${book.id}',
                              ),
                            ],
                          ),
                          Next(onNext: nextPage),
                        ],
                      ),
                    );
                  }
                },
              );
            }
          },
        );
      },
    );
  }
}

class PDFBook extends ConsumerStatefulWidget {
  const PDFBook({
    super.key,
    required this.book,
    required this.filePath,
    this.fileLink,
    required this.previousPage,
    required this.nextPage,
  });

  final dynamic book;
  final String filePath;
  final String? fileLink;
  final Future? Function() previousPage;
  final Future? Function() nextPage;

  @override
  ConsumerState<PDFBook> createState() => _PDFBookState();
}

class _PDFBookState extends ConsumerState<PDFBook> {
  bool isFullScreen = false;
  bool darkMode = false;
  bool landscape = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  void toggleFullScreen() {
    setState(() {
      isFullScreen = !isFullScreen;

      isFullScreen
          ? SystemChrome.setEnabledSystemUIMode(
              SystemUiMode.manual,
              overlays: [],
            )
          : SystemChrome.setEnabledSystemUIMode(
              SystemUiMode.manual,
              overlays: SystemUiOverlay.values,
            );
    });
  }

  void toggleMode() {
    setState(() {
      darkMode = !darkMode;
    });
  }

  void toggleOrientation() {
    setState(() {
      landscape = !landscape;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      onBackPressed: () async => await QR.to('books'),
      showPattern: false,
      showAppBar: !isFullScreen,
      showBottomBar: !isFullScreen,
      title: Text(widget.book.title),
      body: WithPreferences(
        builder: (context, preferences) {
          return PDFReader(
            bookId: widget.book.id,
            filePath: widget.filePath,
            preferences: preferences,
            isFullScreen: isFullScreen,
            darkMode: darkMode,
            landscape: landscape,
            toggleFullScreen: toggleFullScreen,
          );
        },
      ),
      bottomBar: BottomBar(
        alignment: MainAxisAlignment.spaceBetween,
        children: [
          Previous(onPrevious: widget.previousPage),
          Row(
            children: [
              SocialShare(
                title: widget.book.title,
                subtitle:
                    widget.book.authors.map((e) => e.name).toList().join(', '),
                link: 'books/${widget.book.id}',
                fileLink: widget.fileLink,
              ),
              BookmarkButton(
                type: 'Book',
                title: widget.book.title,
                link: 'books/${widget.book.id}',
              ),
              OpenFile(filePath: widget.filePath),
              PDFMenu(
                filePath: widget.filePath,
                darkMode: darkMode,
                landscape: landscape,
                toggleMode: toggleMode,
                toggleOrientation: toggleOrientation,
              ),
            ],
          ),
          Next(onNext: widget.nextPage),
        ],
      ),
    );
  }
}

class Subchapters extends ConsumerStatefulWidget {
  const Subchapters({
    super.key,
    required this.book,
    required this.chapter,
    required this.lastSubchapterId,
    required this.isOpen,
  });

  final dynamic book;
  final dynamic chapter;
  final String? lastSubchapterId;
  final bool isOpen;

  @override
  SubchaptersState createState() => SubchaptersState();
}

class SubchaptersState extends ConsumerState<Subchapters> {
  bool isOpen = false;
  final ScrollController sectionController = ScrollController();

  @override
  void initState() {
    super.initState();
    isOpen = widget.isOpen;
  }

  toggleOpen() {
    setState(() {
      isOpen = !isOpen;

      if (isOpen) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          Scrollable.ensureVisible(
            GlobalObjectKey(widget.chapter.id).currentContext!,
            duration: const Duration(milliseconds: 500),
          );
        });
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    subchapter.title,
                                    style: textTheme.titleMedium,
                                  ),
                                ),
                                if (widget.lastSubchapterId ==
                                    subchapter.id.toString()) ...[
                                  Container(
                                    margin: const EdgeInsets.only(
                                      left: 10,
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/images/icons/open-book.svg',
                                      fit: BoxFit.scaleDown,
                                      width: 25,
                                      height: 20,
                                    ),
                                  ),
                                ] else ...[
                                  const SizedBox.shrink(),
                                ],
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
