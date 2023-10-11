import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  });

  final Function resourceFetcher;
  final ItemWidgetBuilder itemBuilder;
  final SliverGridDelegate? gridDelegate;
  final int pageSize;
  final Map<String, dynamic> qParams;
  final double padding;

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
      }
    } catch (error) {
      pController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    pController.refresh();

    if (widget.gridDelegate != null) {
      return PagedGridView(
        pagingController: pController,
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
    Key? key,
  }) : super(key: key);

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
    Key? key,
    this.onTap,
  }) : super(key: key);
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
