import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/with_connectivity.dart';
import 'package:native_app/widgets/utils/offline_db_prompt.dart';
import 'package:native_app/widgets/inputs/search_button_field.dart';
import 'package:native_app/widgets/inputs/search_field.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/features/book/views/image.dart';
import 'package:native_app/theme/app_theme_color.dart';
import 'package:native_app/providers/last_visited.dart';
import 'package:native_app/widgets/utils/last_visited.dart';
import 'package:native_app/widgets/buttons/floating_downloaded.dart';
import '../providers/book_providers.dart';
import '../providers/book_download_providers.dart';

class BookListScreen extends ConsumerStatefulWidget {
  const BookListScreen({super.key});

  @override
  ConsumerState<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends ConsumerState<BookListScreen> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _itemKeys = {};
  String? _lastScrolledToId;

  GlobalKey _keyForBook(String id) =>
      _itemKeys.putIfAbsent(id, () => GlobalKey());

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToLastVisited(String? lastId) {
    if (lastId == null || lastId == _lastScrolledToId) return;
    final ctx = _keyForBook(lastId).currentContext;
    debugPrint('[BookScroll] attempt — lastId=$lastId ctx=${ctx != null ? 'FOUND' : 'null'} keys=${_itemKeys.keys.length}');
    if (ctx != null) {
      _lastScrolledToId = lastId;
      debugPrint('[BookScroll] scrolling to item');
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        alignment: 0.3,
      );
    }
    // No retry here — itemBuilder fires again when item is rendered on any page
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(bookNavigationIdsProvider);

    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var appTheme = Theme.of(context).extension<AppThemeColors>()!;
    var qParams = ref.watch(bookQueryParamsProvider);
    final lastVisited = ref.watch(lastVisitedProvider);
    final lastBookId = lastVisited.value?.getString('lastBook');
    final lastBookIndex = lastVisited.value?.getInt('lastBookIndex') ?? 0;
    // pageSize is 12; compute which page the last-opened book was on so we can
    // preload up to that page when the screen loads fresh from home.
    final preloadToPage = (lastBookIndex ~/ 12) + 1;
    debugPrint('[BookScroll] build — lastBookId=$lastBookId index=$lastBookIndex preloadToPage=$preloadToPage _lastScrolledToId=$_lastScrolledToId');
    double screenWidth =
        View.of(context).physicalSize.width / View.of(context).devicePixelRatio;
    bool isMobile = screenWidth < 768;

    return AppScaffold(
      onBackPressed: () async { if (context.canPop()) context.pop(); else context.go('/'); },
      title: Text(locales.books),
      floatingActionButton: FloatingDownloadedButton(
        label: locales.downloadedBooks,
        onPressed: () async => context.push('/books/downloads'),
      ),
      body: OfflineDbPrompt(
        feature: 'books',
        child: Column(
          children: [
            WithConnectivity(
              builder: (context, isConnected) {
                if (isConnected) {
                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.only(top: 20, left: 15, right: 15),
                        child: Row(
                          children: [
                            Expanded(
                              child: _V2FilterButton(
                                label: locales.authors,
                                active: qParams.containsKey('authorId'),
                                activeLabel: qParams.containsKey('authorId')
                                    ? null // will be resolved async
                                    : null,
                                activeItemProvider:
                                    qParams.containsKey('authorId')
                                        ? singleAuthorProvider(
                                            qParams['authorId'],
                                          )
                                        : null,
                                activeItemLabel: (item) => item?.name ?? '',
                                onClear: () {
                                  ref
                                      .read(bookQueryParamsProvider.notifier)
                                      .removeParam('authorId');
                                },
                                dialogContent:
                                    _AuthorFilterDialog(parentRef: ref),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _V2FilterButton(
                                label: locales.categories,
                                active: qParams.keys.any(
                                  (k) => [
                                    'bookCategoryId',
                                    'bookSubcategoryId',
                                  ].contains(k),
                                ),
                                activeItemProvider: qParams
                                        .containsKey('bookCategoryId')
                                    ? singleCategoryProvider(
                                        qParams['bookCategoryId'],
                                      )
                                    : qParams.containsKey('bookSubcategoryId')
                                        ? singleSubcategoryProvider(
                                            qParams['bookSubcategoryId'],
                                          )
                                        : null,
                                activeItemLabel: (item) => item?.title ?? '',
                                onClear: () {
                                  ref
                                      .read(bookQueryParamsProvider.notifier)
                                      .removeParam('bookCategoryId');
                                  ref
                                      .read(bookQueryParamsProvider.notifier)
                                      .removeParam('bookSubcategoryId');
                                },
                                dialogContent:
                                    _CategoryFilterDialog(parentRef: ref),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding:
                            const EdgeInsets.only(top: 10, left: 15, right: 15),
                        child: SearchButtonField(
                          value: qParams['search'],
                          onUpdate: (value) {
                            ref
                                .read(bookQueryParamsProvider.notifier)
                                .updateParam('search', value);
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: InfiniteList(
                  qParams: qParams,
                  scrollController: _scrollController,
                  onFirstPageLoaded: () {
                    if (lastBookId == null || _lastScrolledToId == lastBookId) return;
                    if (preloadToPage > 1) {
                      // Item is on page 2+: jump to its approximate position so
                      // the viewport moves there and itemBuilder renders it,
                      // then the itemBuilder trigger calls ensureVisible precisely.
                      final crossAxisCount = isMobile ? 2 : 3;
                      final extent = isMobile ? 280.0 : 360.0;
                      final spacing = isMobile ? 16.0 : 22.0;
                      const topPadding = 25.0;
                      final row = lastBookIndex ~/ crossAxisCount;
                      final targetOffset = topPadding + row * (extent + spacing);
                      debugPrint('[BookScroll] jumping to offset=$targetOffset for index=$lastBookIndex row=$row');
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (!mounted || !_scrollController.hasClients) return;
                        _scrollController.jumpTo(
                          targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
                        );
                      });
                    } else {
                      _scrollToLastVisited(lastBookId);
                    }
                  },
                  resourceFetcher: (Map<String, dynamic> params) async {
                    final api = ref.read(bookApiServiceProvider);
                    final offline = ref.read(bookOfflineServiceProvider);

                    debugPrint(
                        '[BookListScreen] fetching books with params: $params');

                    try {
                      final books = await api.fetchBooks(
                        page: params['page'] ?? 1,
                        perPage: params['per_page'] ?? 12,
                        search: params['search'],
                        authorId: params['authorId'],
                        bookCategoryId: params['bookCategoryId'],
                        bookSubcategoryId: params['bookSubcategoryId'],
                      );
                      debugPrint(
                          '[BookListScreen] API returned ${books.length} books');
                      return books;
                    } catch (e) {
                      debugPrint('[BookListScreen] API error: $e');
                      debugPrint('[BookListScreen] Falling back to offline...');
                      try {
                        final offlineBooks = await offline.queryBooks(
                          page: params['page'],
                          perPage: params['per_page'],
                        );
                        debugPrint(
                            '[BookListScreen] Offline returned ${offlineBooks.length} books');
                        return offlineBooks;
                      } catch (offlineError) {
                        debugPrint(
                            '[BookListScreen] Offline error: $offlineError');
                        rethrow;
                      }
                    }
                  },
                  preloadToPage: preloadToPage,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isMobile ? 2 : 3,
                    crossAxisSpacing: isMobile ? 16 : 22,
                    mainAxisSpacing: isMobile ? 16 : 22,
                    mainAxisExtent: isMobile ? 280 : 360,
                  ),
                  itemBuilder: (_, item, index) {
                    final isRecent = item.id == lastBookId;
                    if (isRecent) {
                      debugPrint('[BookScroll] itemBuilder hit target — id=${item.id} idx=$index alreadyScrolled=${_lastScrolledToId == item.id}');
                      if (_lastScrolledToId != item.id) {
                        WidgetsBinding.instance.addPostFrameCallback(
                          (_) => _scrollToLastVisited(item.id),
                        );
                      }
                    }
                    return InkWell(
                      key: _keyForBook(item.id),
                      onTap: () {
                        debugPrint('[BookListScreen] Tapped book: ${item.id} idx=$index — ${item.title}');
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          ref.read(lastVisitedProvider.notifier)
                              .updateLastBook(item.id, index: index);
                        });
                        context.push('/books/${item.id}');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isRecent ? appTheme.highlight : appTheme.cardBg,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isRecent
                                ? appTheme.highlightBorder
                                : appTheme.divider,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: appTheme.shadow.withValues(alpha: 0.08),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            FractionallySizedBox(
                              widthFactor: 0.62,
                              child: BookImage(
                                bookId: item.id,
                                image: item.image,
                                highlightProvider:
                                    downloadedBookByBookIdProvider(
                                  item.id,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    item.title,
                                    style: textTheme.titleMedium?.copyWith(
                                      height: 1.2,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (item.authors.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      item.authors.first.name,
                                      textAlign: TextAlign.center,
                                      style: textTheme.labelSmall?.copyWith(
                                        height: 1.2,
                                        color: appTheme.secondaryText,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            if (isRecent) ...[
                              LastVisited(
                                resourceKey: 'lastBook',
                                resourceId: item.id,
                              ),
                            ],
                            SizedBox(
                              width: 36,
                              child: Divider(
                                height: 10,
                                thickness: 2,
                                color: appTheme.divider.withValues(alpha: 0.7),
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
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════
// Custom filter button that doesn't depend on Flutter Data's
// SingleModelQuery / AllModelsQuery
// ═══════════════════════════════════════════════════

class _V2FilterButton extends ConsumerWidget {
  const _V2FilterButton({
    required this.label,
    required this.active,
    this.activeLabel,
    this.activeItemProvider,
    this.activeItemLabel,
    required this.onClear,
    required this.dialogContent,
  });

  final String label;
  final bool active;
  final String? activeLabel;
  final dynamic activeItemProvider;
  final String Function(dynamic)? activeItemLabel;
  final VoidCallback onClear;
  final Widget dialogContent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTheme = Theme.of(context).textTheme;
    var appTheme = Theme.of(context).extension<AppThemeColors>()!;

    String displayLabel = label;

    // If there's an active item provider, try to resolve the label
    if (active && activeItemProvider != null) {
      final asyncValue = ref.watch(activeItemProvider);
      if (asyncValue is AsyncData && asyncValue.value != null) {
        displayLabel = activeItemLabel?.call(asyncValue.value) ?? label;
      }
    }

    return OutlinedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            double screenWidth = MediaQuery.of(dialogContext).size.width;
            double screenHeight = MediaQuery.of(dialogContext).size.height;

            return Dialog(
              backgroundColor: appTheme.dropdownBg,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(color: appTheme.divider),
              ),
              child: Container(
                width: screenWidth,
                height: screenHeight * 0.8,
                decoration: BoxDecoration(
                  color: appTheme.dropdownBg,
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.only(
                  top: 15,
                  bottom: 25,
                  left: 15,
                  right: 15,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(label, style: textTheme.titleMedium),
                        if (active)
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              onClear();
                              Navigator.of(dialogContext).pop();
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(child: dialogContent),
                  ],
                ),
              ),
            );
          },
        );
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: appTheme.divider),
        backgroundColor: active ? appTheme.highlight : appTheme.cardBg,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        minimumSize: const Size.fromHeight(45),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              displayLabel,
              style: textTheme.labelMedium?.copyWith(
                color: appTheme.primaryText,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(Icons.arrow_drop_down, color: appTheme.secondaryText),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════
// Author filter dialog — matches old FilterList + FilterItem layout
// ═══════════════════════════════════════════════════

class _AuthorFilterDialog extends ConsumerStatefulWidget {
  final WidgetRef parentRef;
  const _AuthorFilterDialog({required this.parentRef});

  @override
  ConsumerState<_AuthorFilterDialog> createState() =>
      _AuthorFilterDialogState();
}

class _AuthorFilterDialogState extends ConsumerState<_AuthorFilterDialog> {
  String? _searchText;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var appTheme = Theme.of(context).extension<AppThemeColors>()!;
    var qParams = widget.parentRef.watch(bookQueryParamsProvider);

    return Column(
      children: [
        // ── Search field ──
        Container(
          padding: const EdgeInsets.only(bottom: 8),
          child: SearchField(
            value: _searchText,
            maxHeight: 35,
            horizontalPadding: 10,
            onUpdate: (value) {
              setState(() {
                _searchText = value.isEmpty ? null : value;
              });
            },
          ),
        ),
        // ── List ──
        Expanded(
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: appTheme.divider),
            ),
            child: InfiniteList(
              key: ValueKey('author_search_$_searchText'),
              pageSize: 8,
              padding: 0,
              resourceFetcher: (Map<String, dynamic> params) async {
                final api = widget.parentRef.read(bookApiServiceProvider);
                if (_searchText != null && _searchText!.isNotEmpty) {
                  params = {...params, 'search': _searchText};
                }
                return await api.fetchAuthors(
                  page: params['page'] ?? 1,
                  perPage: params['per_page'] ?? 8,
                  search: params['search'],
                );
              },
              itemBuilder: (context, item, index) {
                final isSelected = qParams.containsKey('authorId') &&
                    qParams['authorId'] == item.id;
                return InkWell(
                  onTap: () {
                    widget.parentRef
                        .read(bookQueryParamsProvider.notifier)
                        .updateParam('authorId', item.id);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? appTheme.highlight : null,
                      border:
                          Border(bottom: BorderSide(color: appTheme.divider)),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    child: Text(
                      item.name,
                      style: isSelected
                          ? textTheme.labelMedium
                          : textTheme.titleMedium,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════
// Category filter dialog — matches old FilterList + FilterNestedItem
// ═══════════════════════════════════════════════════

class _CategoryFilterDialog extends ConsumerStatefulWidget {
  final WidgetRef parentRef;
  const _CategoryFilterDialog({required this.parentRef});

  @override
  ConsumerState<_CategoryFilterDialog> createState() =>
      _CategoryFilterDialogState();
}

class _CategoryFilterDialogState extends ConsumerState<_CategoryFilterDialog> {
  String? _searchText;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var appTheme = Theme.of(context).extension<AppThemeColors>()!;
    var qParams = widget.parentRef.watch(bookQueryParamsProvider);
    final hasActiveFilter = qParams.keys
        .any((k) => ['bookCategoryId', 'bookSubcategoryId'].contains(k));

    return Column(
      children: [
        // ── Header row: title + clear | search field ──
        Container(
          padding: const EdgeInsets.only(bottom: 8),
          child: SearchField(
            value: _searchText,
            maxHeight: 35,
            horizontalPadding: 10,
            onUpdate: (value) {
              setState(() {
                _searchText = value.isEmpty ? null : value;
              });
            },
          ),
        ),
        // ── List ──
        Expanded(
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: appTheme.divider),
            ),
            child: InfiniteList(
            key: ValueKey('category_search_$_searchText'),
            pageSize: 8,
            padding: 0,
            resourceFetcher: (Map<String, dynamic> params) async {
              final api = widget.parentRef.read(bookApiServiceProvider);
              if (_searchText != null && _searchText!.isNotEmpty) {
                params = {...params, 'search': _searchText};
              }
              return await api.fetchBookCategories(
                page: params['page'] ?? 1,
                perPage: params['per_page'] ?? 8,
                search: params['search'],
              );
            },
            itemBuilder: (context, item, index) {
              if (item.subcategories.isNotEmpty) {
                return _CategoryNestedItem(
                  category: item,
                  parentRef: widget.parentRef,
                );
              } else {
                final isSelected = qParams.containsKey('bookCategoryId') &&
                    qParams['bookCategoryId'] == item.id;
                return InkWell(
                  onTap: () {
                    widget.parentRef
                        .read(bookQueryParamsProvider.notifier)
                        .updateParam('bookCategoryId', item.id);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? appTheme.highlight : null,
                      border: Border(
                          bottom: BorderSide(color: appTheme.divider)),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    child: Text(
                      item.title,
                      style: isSelected
                          ? textTheme.labelMedium
                          : textTheme.titleMedium,
                    ),
                  ),
                );
              }
            },
          ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════
// Nested category item — matches old FilterNestedItem exactly
// ═══════════════════════════════════════════════════

class _CategoryNestedItem extends ConsumerStatefulWidget {
  final dynamic category;
  final WidgetRef parentRef;
  const _CategoryNestedItem({
    required this.category,
    required this.parentRef,
  });

  @override
  ConsumerState<_CategoryNestedItem> createState() =>
      _CategoryNestedItemState();
}

class _CategoryNestedItemState extends ConsumerState<_CategoryNestedItem> {
  bool isOpen = false;
  final ScrollController sectionController = ScrollController();

  @override
  void dispose() {
    sectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var appTheme = Theme.of(context).extension<AppThemeColors>()!;
    var qParams = widget.parentRef.watch(bookQueryParamsProvider);
    var isSelected = qParams.containsKey('bookSubcategoryId') &&
        widget.category.subcategories
            .map((s) => s.id)
            .any((id) => id == qParams['bookSubcategoryId']);

    final expanded = isSelected || isOpen;

    return Container(
      key: GlobalObjectKey(widget.category.id),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: appTheme.divider)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: isSelected
                ? null
                : () {
                    setState(() {
                      isOpen = !isOpen;
                      if (isOpen) {
                        WidgetsBinding.instance
                            .addPostFrameCallback((_) async {
                          final ctx = GlobalObjectKey(widget.category.id)
                              .currentContext;
                          if (ctx != null) {
                            Scrollable.ensureVisible(
                              ctx,
                              duration: const Duration(milliseconds: 500),
                            );
                          }
                        });
                      }
                    });
                  },
            child: Container(
              color: isSelected ? appTheme.highlight : null,
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.category.title,
                      style: isSelected
                          ? textTheme.labelMedium
                          : textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 20,
                    color: appTheme.primary,
                  ),
                ],
              ),
            ),
          ),
          if (expanded) ...[
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 160),
              child: Scrollbar(
                thumbVisibility: true,
                controller: sectionController,
                child: SingleChildScrollView(
                  controller: sectionController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ...widget.category.subcategories.map<Widget>((sub) {
                        final isSubSelected =
                            qParams.containsKey('bookSubcategoryId') &&
                                qParams['bookSubcategoryId'] == sub.id;
                        return InkWell(
                          onTap: () {
                            widget.parentRef
                                .read(bookQueryParamsProvider.notifier)
                                .updateParam('bookSubcategoryId', sub.id);
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSubSelected
                                  ? appTheme.highlight
                                  : null,
                              border: Border(
                                bottom:
                                    BorderSide(color: appTheme.divider),
                              ),
                            ),
                            child: Text(
                              sub.title,
                              style: isSubSelected
                                  ? textTheme.labelMedium
                                  : textTheme.titleMedium,
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
