import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/widgets/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/layouts/placeholder_scaffold.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/widgets/gestures/next_page_swipe.dart';
import 'package:native_app/widgets/utils/with_last_visited.dart';
import 'package:native_app/widgets/utils/comma_separated_list.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/buttons/social_share.dart';
import 'package:native_app/widgets/buttons/bookmark.dart';
import 'package:native_app/widgets/buttons/previous.dart';
import 'package:native_app/widgets/buttons/next.dart';
import 'package:native_app/widgets/buttons/download.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/widgets/utils/with_connectivity.dart';
import 'package:native_app/widgets/presentation/connect_to_internet.dart';
import 'package:native_app/widgets/presentation/description_item.dart';
import 'package:native_app/providers/check_downloaded_file.dart';
import 'package:native_app/helpers/file_title_path.dart';
import 'package:native_app/helpers/file_utils.dart';
import 'package:native_app/features/book/views/pdf_reader.dart';
import 'package:native_app/features/book/views/image.dart';
import 'package:native_app/theme/app_theme_color.dart';
import '../providers/book_providers.dart';
import '../providers/book_download_providers.dart';
import '../models/book.dart';

class BookDetailScreen extends ConsumerStatefulWidget {
  const BookDetailScreen({super.key});

  @override
  ConsumerState<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends ConsumerState<BookDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final bookId = GoRouterState.of(context).pathParameters['id'].toString();
    debugPrint('[BookDetailScreen] Building for bookId: $bookId');
    final bookQuery = ref.watch(bookDetailProvider(bookId));

    return bookQuery.when(
      loading: () {
        debugPrint('[BookDetailScreen] Book loading...');
        return const FullScreenLoader();
      },
      error: (error, stack) {
        debugPrint('[BookDetailScreen] Book error: $error');
        debugPrint('[BookDetailScreen] Stack: $stack');
        return ModelExeptionHandler(error: error);
      },
      data: (book) {
        if (book == null) {
          debugPrint('[BookDetailScreen] Book is null!');
          return const ModelExeptionHandler(error: 'Book not found');
        }
        debugPrint('[BookDetailScreen] Book loaded: ${book.title}');
        return _BookContent(book: book);
      },
    );
  }
}

class _BookContent extends ConsumerWidget {
  final Book book;

  const _BookContent({required this.book});

  Future<Book?> _findAdjacentBook(WidgetRef ref, {required bool next}) async {
    try {
      final orderedIds = await ref.read(bookNavigationIdsProvider.future);
      final currentIndex = orderedIds.indexOf(book.id);
      if (currentIndex != -1) {
        final targetIndex = next ? currentIndex + 1 : currentIndex - 1;
        if (targetIndex >= 0 && targetIndex < orderedIds.length) {
          final targetId = orderedIds[targetIndex];
          final api = ref.read(bookApiServiceProvider);
          try {
            return await api.fetchBook(targetId, includeAuthors: false);
          } catch (_) {
            final offline = ref.read(bookOfflineServiceProvider);
            return await offline.findBookById(targetId, includeAuthors: false);
          }
        }
        return null;
      }
    } catch (_) {
      // Fall back to offline position-based lookup below if API traversal fails.
    }

    final offline = ref.read(bookOfflineServiceProvider);
    final offlineBook = await offline.findBookById(book.id);
    final position = offlineBook?.position ?? book.position;
    if (position == null) return null;

    return next
        ? offline.findNextBookByPosition(position)
        : offline.findPreviousBookByPosition(position);
  }

  Future<void> _previousPage(BuildContext context, WidgetRef ref) async {
    try {
      final previousBook = await _findAdjacentBook(ref, next: false);
      if (previousBook == null) {
        context.go('/books');
        return;
      }

      context.go('/books/${previousBook.id}');
    } catch (_) {
      context.go('/books');
    }
  }

  Future<void> _nextPage(BuildContext context, WidgetRef ref) async {
    try {
      final nextBook = await _findAdjacentBook(ref, next: true);
      if (nextBook != null) {
        context.go('/books/${nextBook.id}');
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(bookNavigationIdsProvider);

    final locales = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final appTheme = Theme.of(context).extension<AppThemeColors>()!;

    // Check if book has chapters by fetching the last chapter
    final chaptersQuery = ref.watch(chapterListProvider(
      ChapterListParams(
        bookId: book.id,
        quantity: 1,
        sort: '-position',
        includeSubchapters: true,
      ),
    ));

    String? fileLink;
    if (book.document != null) {
      fileLink = fileSrcUrl(book.document);
    }

    return chaptersQuery.when(
      loading: () {
        return const PlaceholderScaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
      error: (error, _) => Text(error.toString()),
      data: (chapters) {
        if (chapters.isNotEmpty) {
          return AppScaffold(
            onBackPressed: () async => context.go('/books'),
            showPattern: false,
            title: Text(locales.book),
            body: NextPageSwipe(
              onPrevious: () => _previousPage(context, ref),
              onNext: () => _nextPage(context, ref),
              child: ItemContent(
                children: [
                  Text(
                    book.title,
                    textAlign: TextAlign.center,
                    style: textTheme.headlineLarge?.copyWith(height: 1.2),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 3, bottom: 15),
                    child: CommaSeparatedList(
                      resources: book.authors,
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
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: appTheme.highlight,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: appTheme.divider),
                        boxShadow: [
                          BoxShadow(
                            color: appTheme.shadow.withValues(alpha: 0.06),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Text(
                        locales.contents,
                        textAlign: TextAlign.center,
                        style: textTheme.titleMedium?.copyWith(
                          color: appTheme.primaryText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: appTheme.cardBg,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: appTheme.divider),
                    ),
                    child: Padding(
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

                          var allChaptersQuery = ref.watch(
                            chapterListProvider(
                              ChapterListParams(
                                bookId: book.id,
                                includeSubchapters: true,
                              ),
                            ),
                          );

                          return allChaptersQuery.when(
                            loading: () => const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 24),
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            error: (error, _) => Text(error.toString()),
                            data: (resources) {
                              final shouldScroll = resources.length > 6;
                              Widget buildChapterItem(
                                BuildContext context,
                                int index,
                              ) {
                                var chapter = resources[index];
                                final isLastItem =
                                    index == resources.length - 1;

                                if (chapter.subchapters.isNotEmpty) {
                                  return _Subchapters(
                                    key: PageStorageKey<String>(chapter.id),
                                    book: book,
                                    chapter: chapter,
                                    lastSubchapterId: lastChapterId,
                                    isOpen: chapter.subchapters
                                        .map((s) => s.id.toString())
                                        .any((id) => id == lastChapterId),
                                    isLast: isLastItem,
                                  );
                                }

                                return InkWell(
                                  onTap: () => context.push(
                                    '/books/${book.id}/chapters/${chapter.id}',
                                  ),
                                  child: Container(
                                    decoration: isLastItem
                                        ? null
                                        : BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: appTheme.divider,
                                              ),
                                            ),
                                          ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                              }

                              if (!shouldScroll) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List<Widget>.generate(
                                    resources.length,
                                    (index) => buildChapterItem(context, index),
                                  ),
                                );
                              }

                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.58,
                                child: ListView.builder(
                                  key: PageStorageKey<String>(book.id),
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: resources.length,
                                  itemBuilder: buildChapterItem,
                                ),
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
                Previous(onPrevious: () => _previousPage(context, ref)),
                Row(
                  children: [
                    SocialShare(
                      title: book.title,
                      subtitle:
                          book.authors.map((e) => e.name).toList().join(', '),
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
                Next(onNext: () => _nextPage(context, ref)),
              ],
            ),
          );
        } else {
          // PDF-only book (no chapters)
          return _buildPdfOnlyBook(context, ref, locales, textTheme, fileLink);
        }
      },
    );
  }

  Widget _buildPdfOnlyBook(BuildContext context, WidgetRef ref,
      AppLocalizations locales, TextTheme textTheme, String? fileLink) {
    String? filePath;
    if (book.document != null) {
      filePath = fileTitlePath(book.title, book.document!['id']);
    }

    final checkDownloadedFile = filePath != null
        ? ref.watch(checkDownloadedFileProvider(filePath))
        : const AsyncValue.data(false);

    return checkDownloadedFile.when(
      loading: () {
        return const PlaceholderScaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
      error: (error, stackTrace) => Text(error.toString()),
      data: (isDownloaded) {
        if (isDownloaded && filePath != null) {
          return _PDFBook(
            book: book,
            filePath: filePath,
            fileLink: fileLink,
            previousPage: () => _previousPage(context, ref),
            nextPage: () => _nextPage(context, ref),
          );
        } else {
          double screenWidth = MediaQuery.of(context).size.width;

          return AppScaffold(
            onBackPressed: () async => context.go('/books'),
            showPattern: false,
            title: Text(locales.book),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                        top: 20, left: 20, right: 20, bottom: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          book.title,
                          textAlign: TextAlign.center,
                          style: textTheme.headlineLarge?.copyWith(height: 1.2),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 3),
                          child: CommaSeparatedList(
                            resources: book.authors,
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
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          child: const ConnectToInternet(),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 30),
                      width: screenWidth / 2,
                      child: BookImage(
                        bookId: book.id,
                        image: book.image,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        top: 30, left: 20, right: 20, bottom: 50),
                    child: Column(
                      children: [
                        if (book.document != null && filePath != null) ...[
                          WithConnectivity(
                            builder: (context, isConnected) {
                              if (isConnected) {
                                return DescriptionItem(
                                  title: '${locales.download}:',
                                  description: Align(
                                    alignment: Alignment.centerLeft,
                                    child: DownloadButton(
                                      filePath: filePath!,
                                      fileUrl: fileSrcUrl(book.document),
                                      callback: () async {
                                        await ref.watch(
                                          createDownloadedBookProvider({
                                            'bookId': book.id,
                                            'title': book.title,
                                            'excerpt': book.excerpt,
                                            'publisher': book.publisher,
                                            'price': book.price,
                                            'image': json.encode(book.image),
                                            'document':
                                                json.encode(book.document),
                                            'authors': book.authors
                                                .map((e) => e.name)
                                                .toList()
                                                .join(', '),
                                            'publishedAt': book.publishedAt,
                                          }).future,
                                        );
                                      },
                                    ),
                                  ),
                                  alignment: CrossAxisAlignment.center,
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
                Previous(onPrevious: () => _previousPage(context, ref)),
                Row(
                  children: [
                    SocialShare(
                      title: book.title,
                      subtitle:
                          book.authors.map((e) => e.name).toList().join(', '),
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
                Next(onNext: () => _nextPage(context, ref)),
              ],
            ),
          );
        }
      },
    );
  }
}

class _PDFBook extends ConsumerWidget {
  const _PDFBook({
    required this.book,
    required this.filePath,
    this.fileLink,
    required this.previousPage,
    required this.nextPage,
  });

  final Book book;
  final String filePath;
  final String? fileLink;
  final Future? Function() previousPage;
  final Future? Function() nextPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WithPreferences(
      builder: (context, preferences) {
        return PDFReader(
          bookId: book.id,
          filePath: filePath,
          preferences: preferences,
          title: book.title,
          authors: book.authors.map((e) => e.name).toList().join(', '),
          fileLink: fileLink,
          onPreviousPdf: previousPage,
          onNextPdf: nextPage,
        );
      },
    );
  }
}

class _Subchapters extends ConsumerStatefulWidget {
  const _Subchapters({
    super.key,
    required this.book,
    required this.chapter,
    required this.lastSubchapterId,
    required this.isOpen,
    required this.isLast,
  });

  final Book book;
  final dynamic chapter;
  final String? lastSubchapterId;
  final bool isOpen;
  final bool isLast;

  @override
  _SubchaptersState createState() => _SubchaptersState();
}

class _SubchaptersState extends ConsumerState<_Subchapters> {
  bool isOpen = false;
  final ScrollController sectionController = ScrollController();
  final GlobalKey _headerKey = GlobalKey();

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
          if (!mounted) return;
          final headerContext = _headerKey.currentContext;
          if (headerContext == null || !headerContext.mounted) return;
          await Scrollable.ensureVisible(
            headerContext,
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
      decoration: widget.isLast
          ? null
          : BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).extension<AppThemeColors>()!.divider,
                ),
              ),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            key: _headerKey,
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
              padding: const EdgeInsets.only(left: 30, bottom: 10),
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
                          onTap: () => context.push(
                            '/books/${widget.book.id}/subchapters/${subchapter.id}',
                          ),
                          child: Container(
                            padding:
                                const EdgeInsets.only(bottom: 15, right: 15),
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
                                    margin: const EdgeInsets.only(left: 10),
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
