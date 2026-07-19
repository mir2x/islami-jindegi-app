import 'package:flutter/material.dart';
import 'package:native_app/l10n/app_localizations.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

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
  late final PagingController<int, ItemType> pController =
      PagingController<int, ItemType>(
    getNextPageKey: (state) {
      final pages = state.pages;
      if (pages == null || pages.isEmpty) return 1;
      // A short page means we've reached the end.
      if (pages.last.length < widget.pageSize) return null;
      return (state.keys?.last ?? 0) + 1;
    },
    fetchPage: _fetchPage,
  );

  bool _onLoadedFired = false;

  @override
  void didUpdateWidget(covariant InfiniteList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.qParams != widget.qParams) {
      _onLoadedFired = false;
      pController.refresh();
    }
  }

  @override
  void dispose() {
    pController.dispose();
    super.dispose();
  }

  Future<List<ItemType>> _fetchPage(int pageKey) async {
    final params = <String, dynamic>{
      'page': pageKey,
      'per_page': widget.pageSize,
      ...widget.qParams,
    };

    final items = await widget.resourceFetcher(params);
    final newItems = (items as List).cast<ItemType>();
    final isLastPage = newItems.length < widget.pageSize;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      // Eagerly load the next page until we reach preloadToPage.
      if (!isLastPage && pageKey < widget.preloadToPage) {
        pController.fetchNextPage();
      }

      // Fire onFirstPageLoaded once all preload pages are in (or the last
      // available page has been reached).
      if (!_onLoadedFired &&
          (pageKey >= widget.preloadToPage || isLastPage)) {
        _onLoadedFired = true;
        widget.onFirstPageLoaded?.call();
      }
    });

    return newItems;
  }

  @override
  Widget build(BuildContext context) {
    return PagingListener<int, ItemType>(
      controller: pController,
      builder: (context, state, fetchNextPage) {
        final delegate = PagedChildBuilderDelegate<ItemType>(
          itemBuilder: widget.itemBuilder,
          firstPageErrorIndicatorBuilder: (_) =>
              FirstPageErrorIndicator(onTryAgain: pController.refresh),
          newPageErrorIndicatorBuilder: (_) =>
              NewPageErrorIndicator(onTap: fetchNextPage),
          noItemsFoundIndicatorBuilder: (_) => const NoItemsFoundIndicator(),
        );

        if (widget.gridDelegate != null) {
          return PagedGridView<int, ItemType>(
            state: state,
            fetchNextPage: fetchNextPage,
            scrollController: widget.scrollController,
            builderDelegate: delegate,
            gridDelegate: widget.gridDelegate!,
            padding: EdgeInsets.symmetric(vertical: widget.padding),
          );
        }

        return PagedListView<int, ItemType>(
          state: state,
          fetchNextPage: fetchNextPage,
          scrollController: widget.scrollController,
          builderDelegate: delegate,
          padding: EdgeInsets.symmetric(vertical: widget.padding),
        );
      },
    );
  }
}

class NoItemsFoundIndicator extends StatelessWidget {
  const NoItemsFoundIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final locales = AppLocalizations.of(context)!;
    return _ExceptionIndicator(
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
    final locales = AppLocalizations.of(context)!;
    return _ExceptionIndicator(
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
    final locales = AppLocalizations.of(context)!;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
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

/// Simple first-page error / empty-state indicator, replacing the internal
/// `FirstPageExceptionIndicator` that infinite_scroll_pagination v5 removed.
class _ExceptionIndicator extends StatelessWidget {
  const _ExceptionIndicator({
    required this.title,
    required this.message,
    this.onTryAgain,
  });

  final String title;
  final String message;
  final VoidCallback? onTryAgain;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            if (onTryAgain != null) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: onTryAgain,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Try Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
