import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:native_app/theme/app_theme_color.dart';
import 'package:native_app/widgets/inputs/search_field.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';

class FilterList extends StatefulWidget {
  const FilterList({
    super.key,
    required this.title,
    required this.paramKeys,
    required this.itemBuilder,
    this.pageSize = 8,
    this.searchEnabled = false,
    this.queryProvider,
    required this.resourceFetcher,
  });

  final String title;
  final List<String> paramKeys;
  final ItemWidgetBuilder itemBuilder;
  final int pageSize;
  final bool searchEnabled;
  final dynamic queryProvider;

  /// Accepts pagination params and returns the list of items directly.
  final Future<List> Function(Map<String, dynamic>) resourceFetcher;

  @override
  State<FilterList> createState() => _FilterListState();
}

class _FilterListState extends State<FilterList> {
  String? searchText;

  updateSearchText(value) {
    setState(() {
      searchText = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    return Column(
      children: [
        if (widget.searchEnabled) ...[
          Container(
            padding: const EdgeInsets.only(bottom: 8),
            child: SearchField(
              value: searchText,
              maxHeight: 35,
              horizontalPadding: 10,
              onUpdate: updateSearchText,
            ),
          ),
        ],
        Expanded(
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colors.divider),
            ),
            child: InfiniteList(
              key: widget.searchEnabled
                  ? ValueKey('filter_search_$searchText')
                  : null,
              pageSize: widget.pageSize,
              padding: 0,
              resourceFetcher: (Map<String, dynamic> params) async {
                if (widget.searchEnabled &&
                    searchText != null &&
                    searchText!.isNotEmpty) {
                  params = {...params, 'search': searchText};
                }

                return await widget.resourceFetcher(params);
              },
              itemBuilder: widget.itemBuilder,
            ),
          ),
        ),
      ],
    );
  }
}
