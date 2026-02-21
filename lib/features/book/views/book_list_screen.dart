import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/with_connectivity.dart';
import 'package:native_app/widgets/inputs/search_button_field.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/widgets/buttons/floating_downloaded.dart';
import 'package:native_app/screens/books/image.dart';
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
                              dialogContent: _AuthorFilterDialog(ref: ref),
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
                              dialogContent: _CategoryFilterDialog(ref: ref),
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
                      QR.to('books-v2/${item.id}');
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
          onPressed: () => QR.to('books-v2/downloads'),
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
// Author filter dialog — uses InfiniteList directly
// ═══════════════════════════════════════════════════

class _AuthorFilterDialog extends ConsumerWidget {
  final WidgetRef ref;
  const _AuthorFilterDialog({required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef outerRef) {
    return InfiniteList(
      pageSize: 16,
      padding: 2,
      resourceFetcher: (Map<String, dynamic> params) async {
        final api = ref.read(bookApiServiceProvider);
        debugPrint('[AuthorFilter] fetching with params: $params');
        try {
          final authors = await api.fetchAuthors(
            page: params['page'] ?? 1,
            perPage: params['per_page'] ?? 16,
            search: params['search'],
          );
          debugPrint('[AuthorFilter] got ${authors.length} authors');
          return authors;
        } catch (e) {
          debugPrint('[AuthorFilter] error: $e');
          rethrow;
        }
      },
      itemBuilder: (context, item, index) {
        return ListTile(
          title: Text(item.name),
          onTap: () {
            ref
                .read(bookQueryParamsProvider.notifier)
                .updateParam('authorId', item.id);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════
// Category filter dialog — uses InfiniteList directly
// ═══════════════════════════════════════════════════

class _CategoryFilterDialog extends ConsumerWidget {
  final WidgetRef ref;
  const _CategoryFilterDialog({required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef outerRef) {
    return InfiniteList(
      pageSize: 16,
      padding: 2,
      resourceFetcher: (Map<String, dynamic> params) async {
        final api = ref.read(bookApiServiceProvider);
        debugPrint('[CategoryFilter] fetching with params: $params');
        try {
          final categories = await api.fetchBookCategories(
            page: params['page'] ?? 1,
            perPage: params['per_page'] ?? 16,
          );
          debugPrint('[CategoryFilter] got ${categories.length} categories');
          return categories;
        } catch (e) {
          debugPrint('[CategoryFilter] error: $e');
          rethrow;
        }
      },
      itemBuilder: (context, item, index) {
        if (item.subcategories.isNotEmpty) {
          return ExpansionTile(
            title: Text(item.title),
            children: item.subcategories.map<Widget>((sub) {
              return ListTile(
                title: Text(sub.title),
                contentPadding: const EdgeInsets.only(left: 32),
                onTap: () {
                  ref
                      .read(bookQueryParamsProvider.notifier)
                      .updateParam('bookSubcategoryId', sub.id);
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          );
        } else {
          return ListTile(
            title: Text(item.title),
            onTap: () {
              ref
                  .read(bookQueryParamsProvider.notifier)
                  .updateParam('bookCategoryId', item.id);
              Navigator.of(context).pop();
            },
          );
        }
      },
    );
  }
}
