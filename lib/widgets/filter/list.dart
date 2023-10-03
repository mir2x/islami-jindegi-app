import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:native_app/providers/query_params.dart';
import 'package:native_app/widgets/inputs/search_field.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/providers/all_models.dart';

class FilterList extends ConsumerStatefulWidget {
  const FilterList({
    super.key,
    required this.title,
    required this.paramKeys,
    required this.queryBuilder,
    required this.itemBuilder,
    this.pageSize = 8,
    this.searchEnabled = false,
    this.queryProvider,
  });

  final String title;
  final List<String> paramKeys;
  final Function queryBuilder;
  final ItemWidgetBuilder itemBuilder;
  final int pageSize;
  final bool searchEnabled;
  final dynamic queryProvider;

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
                    Text(widget.title),
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
                    onUpdate: updateSearchText,
                  ),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: InfiniteList(
            pageSize: widget.pageSize,
            padding: 2,
            resourceFetcher: (Map<String, dynamic> params) async {
              if (widget.searchEnabled &&
                  searchText != null &&
                  searchText!.isNotEmpty) {
                params = {...params, 'search': searchText};
              }

              var query = widget.queryBuilder(params);

              return await ref.read(
                allModelsProvider(query).future,
              );
            },
            itemBuilder: widget.itemBuilder,
          ),
        ),
      ],
    );
  }
}
