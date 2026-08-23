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
    this.controller,
  });

  final Function resourceFetcher;
  final ItemWidgetBuilder itemBuilder;
  final SliverGridDelegate? gridDelegate;
  final int pageSize;
  final Map<String, dynamic> qParams;
  final double padding;

  /// Optional external [ScrollController] for the list/grid.
  final ScrollController? scrollController;

  /// A caller-owned controller. It remains alive when this widget's route is
  /// removed, allowing a list to restore its loaded pages without refetching.
  final PagingController<int, ItemType>? controller;

  @override
  State<InfiniteList<ItemType>> createState() => InfiniteListState<ItemType>();
}

class InfiniteListState<ItemType> extends State<InfiniteList<ItemType>> {
  PagingController<int, ItemType>? _ownedController;

  PagingController<int, ItemType> get pController =>
      widget.controller ?? _ownedController!;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _ownedController = PagingController<int, ItemType>(
        getNextPageKey: (state) {
          final pages = state.pages;
          if (pages == null || pages.isEmpty) return 1;
          if (pages.last.length < widget.pageSize) return null;
          return (state.keys?.last ?? 0) + 1;
        },
        fetchPage: _fetchPage,
      );
    }
  }

  @override
  void didUpdateWidget(covariant InfiniteList<ItemType> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null && oldWidget.qParams != widget.qParams) {
      pController.refresh();
    }
  }

  @override
  void dispose() {
    _ownedController?.dispose();
    super.dispose();
  }

  Future<List<ItemType>> _fetchPage(int pageKey) async {
    final params = <String, dynamic>{
      'page': pageKey,
      'per_page': widget.pageSize,
      ...widget.qParams,
    };

    final items = await widget.resourceFetcher(params);
    return (items as List).cast<ItemType>();
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
            // Keyed on the scroll controller so switching filter/tab builds a
            // FRESH Scrollable. Without this Flutter updates the existing one
            // in place and ScrollPosition.absorb() carries the old pixel offset
            // onto the new controller — which made every tab share one scroll
            // position even though each has its own retained state.
            key: ObjectKey(widget.scrollController),
            state: state,
            fetchNextPage: fetchNextPage,
            scrollController: widget.scrollController,
            builderDelegate: delegate,
            gridDelegate: widget.gridDelegate!,
            padding: EdgeInsets.symmetric(vertical: widget.padding),
          );
        }

        return PagedListView<int, ItemType>(
          key: ObjectKey(widget.scrollController),
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
