import 'package:flutter/material.dart';
import 'package:native_app/l10n/app_localizations.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:infinite_scroll_pagination/src/widgets/helpers/default_status_indicators/first_page_exception_indicator.dart';
import 'package:infinite_scroll_pagination/src/widgets/helpers/default_status_indicators/footer_tile.dart';

class InfiniteList<ItemType> extends StatefulWidget {
  const InfiniteList({
    super.key,
    required this.resourceFetcher,
    required this.itemBuilder,
    this.gridDelegate,
    this.pageSize = 12,
    this.qParams = const {},
    this.padding = 25,
    this.scrollController,
    this.onFirstPageLoaded,
    this.preloadToPage = 1,
  });

  final Function resourceFetcher;
  final ItemWidgetBuilder itemBuilder;
  final SliverGridDelegate? gridDelegate;
  final int pageSize;
  final Map<String, dynamic> qParams;
  final double padding;

  /// Optional external [ScrollController] for the list/grid.
  final ScrollController? scrollController;

  /// Called once, after the very first page has been appended successfully.
  /// Use this to trigger scroll-to-item logic after initial items are rendered.
  final VoidCallback? onFirstPageLoaded;

  /// Eagerly load pages 1..preloadToPage on fresh load (silently, without
  /// user scrolling). Useful when you need to scroll to an item that may be
  /// on page 2 or 3 and the pager wouldn't otherwise load those pages until
  /// the user scrolls down.
  final int preloadToPage;

  @override
  State createState() => InfiniteListState();
}

class InfiniteListState<ItemType> extends State<InfiniteList> {
  final PagingController<int, ItemType> pController = PagingController(
    firstPageKey: 1,
    invisibleItemsThreshold: 4,
  );

  bool _firstPageEverLoaded = false;
  bool _onLoadedFired = false;

  @override
  void initState() {
    super.initState();
    pController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  @override
  void didUpdateWidget(covariant InfiniteList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.qParams != widget.qParams) {
      _firstPageEverLoaded = false;
      _onLoadedFired = false;
      pController.refresh();
    }
  }

  @override
  void dispose() {
    pController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      Map<String, dynamic> params = {
        'page': pageKey,
        'per_page': widget.pageSize,
        ...widget.qParams,
      };

      var items = await widget.resourceFetcher(params);
      if (mounted) {
        var newItems = items as List<ItemType>;

        final isLastPage = newItems.length < widget.pageSize;

        if (isLastPage) {
          pController.appendLastPage(newItems);
        } else {
          final nextPageKey = pageKey + 1;
          pController.appendPage(newItems, nextPageKey);
        }

        if (pageKey == 1 && !_firstPageEverLoaded) {
          _firstPageEverLoaded = true;
        }

        // Eagerly load the next page if we haven't yet reached preloadToPage.
        if (!isLastPage && pageKey < widget.preloadToPage) {
          _fetchPage(pageKey + 1);
        }

        // Fire onFirstPageLoaded after all preload pages are done (or at the
        // last available page). This ensures the callback sees all eagerly-
        // loaded items, not just page 1.
        if (!_onLoadedFired &&
            (pageKey >= widget.preloadToPage || isLastPage)) {
          _onLoadedFired = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.onFirstPageLoaded?.call();
          });
        }
      }
    } catch (error, stack) {
      debugPrint('[InfiniteList] page $pageKey error: $error\n$stack');
      pController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.gridDelegate != null) {
      return PagedGridView(
        pagingController: pController,
        scrollController: widget.scrollController,
        builderDelegate: PagedChildBuilderDelegate<ItemType>(
          itemBuilder: widget.itemBuilder,
          firstPageErrorIndicatorBuilder: (_) => FirstPageErrorIndicator(
            onTryAgain: () => pController.refresh(),
          ),
          newPageErrorIndicatorBuilder: (_) => NewPageErrorIndicator(
            onTap: () => pController.retryLastFailedRequest(),
          ),
          noItemsFoundIndicatorBuilder: (_) => const NoItemsFoundIndicator(),
        ),
        gridDelegate: widget.gridDelegate!,
        padding: EdgeInsets.symmetric(vertical: widget.padding),
      );
    } else {
      return PagedListView<int, ItemType>(
        pagingController: pController,
        scrollController: widget.scrollController,
        builderDelegate: PagedChildBuilderDelegate<ItemType>(
          itemBuilder: widget.itemBuilder,
          firstPageErrorIndicatorBuilder: (_) => FirstPageErrorIndicator(
            onTryAgain: () => pController.refresh(),
          ),
          newPageErrorIndicatorBuilder: (_) => NewPageErrorIndicator(
            onTap: () => pController.retryLastFailedRequest(),
          ),
          noItemsFoundIndicatorBuilder: (_) => const NoItemsFoundIndicator(),
        ),
        padding: EdgeInsets.symmetric(vertical: widget.padding),
      );
    }
  }
}

class NoItemsFoundIndicator extends StatelessWidget {
  const NoItemsFoundIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;

    return FirstPageExceptionIndicator(
      title: locales.noItemsTitle,
      message: locales.noItemsMsg,
    );
  }
}

class FirstPageErrorIndicator extends StatelessWidget {
  const FirstPageErrorIndicator({
    this.onTryAgain,
    super.key,
  });

  final VoidCallback? onTryAgain;

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;

    return FirstPageExceptionIndicator(
      title: locales.applicationErrorTitle,
      message: locales.applicationErrorMsg,
      onTryAgain: onTryAgain,
    );
  }
}

class NewPageErrorIndicator extends StatelessWidget {
  const NewPageErrorIndicator({
    super.key,
    this.onTap,
  });
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;

    return InkWell(
      onTap: onTap,
      child: FooterTile(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              locales.newPageErrorTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            const Icon(Icons.refresh, size: 16),
          ],
        ),
      ),
    );
  }
}
