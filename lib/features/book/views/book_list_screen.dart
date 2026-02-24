import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/with_connectivity.dart';
import 'package:native_app/widgets/inputs/search_button_field.dart';
import 'package:native_app/widgets/inputs/search_field.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/widgets/buttons/floating_downloaded.dart';
import 'package:native_app/features/book/views/image.dart';
import 'package:native_app/theme/colors.dart';
import 'package:flutter_svg/svg.dart';
import '../providers/book_providers.dart';
import '../providers/book_download_providers.dart';

class BookListScreen extends ConsumerWidget {
  const BookListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var qParams = ref.watch(bookQueryParamsProvider);
    double screenWidth =
        View.of(context).physicalSize.width / View.of(context).devicePixelRatio;
    bool isMobile = screenWidth < 768;

    return AppScaffold(
      title: Text(locales.books),
      body: Column(
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
                              activeItemProvider:
                                  qParams.containsKey('bookCategoryId')
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
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isMobile ? 2 : 3,
                  crossAxisSpacing: isMobile ? 15 : 20,
                  mainAxisExtent: isMobile ? 300 : 360,
                ),
                itemBuilder: (_, item, __) {
                  return InkWell(
                    onTap: () {
                      debugPrint(
                          '[BookListScreen] Tapped book: ${item.id} — ${item.title}');
                      QR.to('books/${item.id}');
                    },
                    child: Column(
                      children: [
                        FractionallySizedBox(
                          widthFactor: 0.7,
                          child: BookImage(
                            bookId: item.id,
                            image: item.image,
                            highlightProvider: downloadedBookByBookIdProvider(
                              item.id,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            item.title,
                            style: textTheme.titleMedium,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (item.authors.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            child: Text(
                              item.authors.first.name,
                              textAlign: TextAlign.center,
                              style: textTheme.labelSmall,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 200,
        height: 40,
        child: FloatingDownloadedButton(
          onPressed: () => QR.to('books/downloads'),
          label: '${locales.downloaded} ${locales.books}',
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
              child: Container(
                width: screenWidth,
                height: screenHeight * 0.8,
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
        backgroundColor: active ? Colors.blue.withOpacity(0.1) : null,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        minimumSize: const Size.fromHeight(45),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              displayLabel,
              style: textTheme.labelMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Icon(Icons.arrow_drop_down),
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
    var qParams = widget.parentRef.watch(bookQueryParamsProvider);

    return Column(
      children: [
        // ── Header row: title + clear | search field ──
        Container(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.authors),
                    if (qParams.containsKey('authorId')) ...[
                      IconButton(
                        constraints: const BoxConstraints(maxHeight: 40),
                        splashRadius: 24,
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          widget.parentRef
                              .read(bookQueryParamsProvider.notifier)
                              .removeParam('authorId');
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ],
                ),
              ),
              Expanded(
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
            ],
          ),
        ),
        // ── List ──
        Expanded(
          child: InfiniteList(
            key: ValueKey('author_search_$_searchText'),
            pageSize: 8,
            padding: 2,
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
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: ThemeColors.color4),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
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
    var qParams = widget.parentRef.watch(bookQueryParamsProvider);
    final hasActiveFilter = qParams.keys
        .any((k) => ['bookCategoryId', 'bookSubcategoryId'].contains(k));

    return Column(
      children: [
        // ── Header row: title + clear | search field ──
        Container(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.categories),
                    if (hasActiveFilter) ...[
                      IconButton(
                        constraints: const BoxConstraints(maxHeight: 40),
                        splashRadius: 24,
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          widget.parentRef
                              .read(bookQueryParamsProvider.notifier)
                              .removeParam('bookCategoryId');
                          widget.parentRef
                              .read(bookQueryParamsProvider.notifier)
                              .removeParam('bookSubcategoryId');
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ],
                ),
              ),
              Expanded(
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
            ],
          ),
        ),
        // ── List ──
        Expanded(
          child: InfiniteList(
            key: ValueKey('category_search_$_searchText'),
            pageSize: 8,
            padding: 2,
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
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: ThemeColors.color4),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
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
    var qParams = widget.parentRef.watch(bookQueryParamsProvider);
    var isSelected = qParams.containsKey('bookSubcategoryId') &&
        widget.category.subcategories
            .map((s) => s.id)
            .any((id) => id == qParams['bookSubcategoryId']);

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: ThemeColors.color4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isSelected) ...[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.category.title,
                      style: textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SvgPicture.asset(
                    'assets/images/icons/angle-up.svg',
                    fit: BoxFit.scaleDown,
                    width: 20,
                  ),
                ],
              ),
            ),
          ] else ...[
            InkWell(
              key: GlobalObjectKey(widget.category.id),
              onTap: () {
                setState(() {
                  isOpen = !isOpen;
                  if (isOpen) {
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      final ctx =
                          GlobalObjectKey(widget.category.id).currentContext;
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
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.category.title,
                        style: textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(width: 10),
                    SvgPicture.asset(
                      isOpen
                          ? 'assets/images/icons/angle-up.svg'
                          : 'assets/images/icons/angle-down.svg',
                      fit: BoxFit.scaleDown,
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (isSelected || isOpen) ...[
            Container(
              padding: const EdgeInsets.only(left: 25, bottom: 5),
              constraints: const BoxConstraints(maxHeight: 150),
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
                            padding: const EdgeInsets.symmetric(vertical: 6),
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
