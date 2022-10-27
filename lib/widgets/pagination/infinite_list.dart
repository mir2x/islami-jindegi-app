import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class InfiniteList<ItemType> extends StatefulWidget {
  const InfiniteList({
    super.key,
    required this.resourceFetcher,
    required this.itemBuilder,
    this.gridDelegate,
    this.pageSize = 12,
  });

  final Function resourceFetcher;
  final ItemWidgetBuilder itemBuilder;
  final SliverGridDelegate? gridDelegate;
  final int pageSize;

  @override
  State createState() => InfiniteListState();
}

class InfiniteListState<ItemType> extends State<InfiniteList> {
  final PagingController<int, ItemType> pController = PagingController(
    firstPageKey: 1,
    invisibleItemsThreshold: 4,
  );

  @override
  void initState() {
    super.initState();

    pController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  @override
  void dispose() {
    pController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      var items = await widget.resourceFetcher(pageKey, widget.pageSize);
      if (mounted) {
        var newItems = items as List<ItemType>;

        final isLastPage = newItems.length < widget.pageSize;

        if (isLastPage) {
          pController.appendLastPage(newItems);
        } else {
          final nextPageKey = pageKey + 1;
          pController.appendPage(newItems, nextPageKey);
        }
      }
    } catch (error) {
      pController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.gridDelegate != null) {
      return PagedGridView(
        pagingController: pController,
        builderDelegate: PagedChildBuilderDelegate(
          itemBuilder: widget.itemBuilder,
        ),
        gridDelegate: widget.gridDelegate!,
        padding: const EdgeInsets.symmetric(vertical: 25),
      );
    } else {
      return PagedListView<int, ItemType>(
        pagingController: pController,
        builderDelegate: PagedChildBuilderDelegate<ItemType>(
          itemBuilder: widget.itemBuilder,
        ),
        padding: const EdgeInsets.symmetric(vertical: 25),
      );
    }
  }
}
