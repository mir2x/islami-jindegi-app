import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:native_app/providers/query_params.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';

class FilterList extends ConsumerWidget {
  const FilterList({
    super.key,
    required this.title,
    required this.paramKeys,
    required this.resourceFetcher,
    required this.itemBuilder,
  });

  final String title;
  final List<String> paramKeys;
  final Function resourceFetcher;
  final ItemWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var qParams = ref.watch(queryParamsProvider);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title),
              if (qParams.keys.any((k) => paramKeys.contains(k))) ...[
                IconButton(
                  onPressed: () {
                    var qParamsNotifier =
                        ref.read(queryParamsProvider.notifier);
                    for (var k in paramKeys) {
                      qParamsNotifier.updateParams(k, '');
                    }
                    Navigator.of(context).pop();
                  },
                  constraints: const BoxConstraints(
                    maxHeight: 40,
                  ),
                  splashRadius: 24,
                  icon: const Icon(
                    Icons.close,
                  ),
                )
              ] else
                ...[],
            ],
          ),
        ),
        Expanded(
          child: InfiniteList(
            pageSize: 8,
            padding: 2,
            resourceFetcher: resourceFetcher,
            itemBuilder: itemBuilder,
          ),
        ),
      ],
    );
  }
}
