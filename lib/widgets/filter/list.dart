import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:native_app/providers/query_params.dart';
import 'package:native_app/theme/app_theme_color.dart';
import 'package:native_app/widgets/inputs/search_field.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';

class FilterList extends ConsumerStatefulWidget {
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
  ConsumerState<FilterList> createState() => _FilterListState();
}

class _FilterListState extends ConsumerState<FilterList> {
  String? searchText;

  updateSearchText(value) {
    setState(() {
      searchText = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    var paramsProvider = widget.queryProvider ?? queryParamsProvider;
    var qParams = ref.watch(paramsProvider);
    var appTheme = Theme.of(context).extension<AppThemeColors>()!;
    var textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
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
                    Text(
                      widget.title,
                      style: textTheme.titleMedium?.copyWith(
                        color: appTheme.primaryText,
                      ),
                    ),
                    if (qParams.keys
                        .any((k) => widget.paramKeys.contains(k))) ...[
                      IconButton(
                        constraints: const BoxConstraints(
                          maxHeight: 40,
                        ),
                        splashRadius: 24,
                        icon: const Icon(
                          Icons.close,
                        ),
                        color: appTheme.secondaryText,
                        onPressed: () {
                          var qParamsNotifier =
                              ref.read(paramsProvider.notifier);
                          for (var k in widget.paramKeys) {
                            qParamsNotifier.updateParams(k, '');
                          }
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ],
                ),
              ),
              if (widget.searchEnabled) ...[
                Expanded(
                  child: SearchField(
                    value: searchText,
                    maxHeight: 35,
                    horizontalPadding: 10,
                    onUpdate: updateSearchText,
                  ),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: appTheme.cardBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: appTheme.divider),
            ),
            child: InfiniteList(
              key: widget.searchEnabled
                  ? ValueKey('filter_search_$searchText')
                  : null,
              pageSize: widget.pageSize,
              padding: 10,
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
