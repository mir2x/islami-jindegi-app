import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inflection3/inflection3.dart';
import 'package:recase/recase.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/providers/query_params.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/widgets/presentation/filter_list_item.dart';

class FilterList extends ConsumerWidget {
  const FilterList({
    super.key,
    required this.resource,
    required this.qParams,
  });

  final String resource;
  final Map qParams;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTheme = Theme.of(context).textTheme;
    String resourceId = '${resource}Id';
    String respository = pluralize(resource);
    String title = ReCase(pluralize(resource)).titleCase;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title),
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
        Expanded(
          child: InfiniteList(
            pageSize: 8,
            padding: 5,
            resourceFetcher: (Map<String, dynamic> params) async {
              AllModelsQuery query = AllModelsQuery(
                repository: respository,
                params: params,
              );

              return await ref.read(
                allModelsProvider(query).future,
              );
            },
            itemBuilder: (_, item, __) {
              return InkWell(
                onTap: () {
                  ref
                      .read(
                        queryParamsProvider.notifier,
                      )
                      .updateParams(
                        resourceId,
                        item.id,
                      );
                  Navigator.of(context).pop();
                },
                child: FilterListItem(
                  item: Text(
                    item.name,
                    style: (qParams.containsKey(resourceId) &&
                            qParams[resourceId] == item.id)
                        ? textTheme.labelMedium
                        : textTheme.titleMedium,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
