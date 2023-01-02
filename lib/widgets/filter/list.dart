import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:inflection3/inflection3.dart';
import 'package:recase/recase.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/providers/query_params.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';

class FilterList extends ConsumerWidget {
  const FilterList({
    super.key,
    required this.resource,
    required this.itemBuilder,
    this.title,
  });

  final String resource;
  final ItemWidgetBuilder itemBuilder;
  final String? title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var qParams = ref.watch(queryParamsProvider);
    String resourceId = '${resource}Id';
    String respository = pluralize(resource);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title != null ? title! : ReCase(respository).titleCase),
              if (qParams.containsKey(resourceId) &&
                  qParams[resourceId].isNotEmpty) ...[
                IconButton(
                  onPressed: () {
                    ref
                        .read(
                          queryParamsProvider.notifier,
                        )
                        .updateParams(resourceId, '');
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
            resourceFetcher: (Map<String, dynamic> params) async {
              AllModelsQuery query = AllModelsQuery(
                repository: respository,
                params: params,
              );

              return await ref.read(
                allModelsProvider(query).future,
              );
            },
            itemBuilder: itemBuilder,
          ),
        ),
      ],
    );
  }
}
