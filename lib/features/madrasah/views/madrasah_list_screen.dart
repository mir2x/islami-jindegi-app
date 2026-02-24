import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/with_connectivity.dart';
import 'package:native_app/widgets/inputs/search_button_field.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/widgets/presentation/list_item.dart';
import 'package:native_app/widgets/utils/last_visited.dart';
import '../providers/madrasah_providers.dart';

class MadrasahListScreen extends ConsumerWidget {
  const MadrasahListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var qParams = ref.watch(madrasahQueryParamsProvider);

    return AppScaffold(
      title: Text(locales.madrasah),
      body: Column(
        children: [
          WithConnectivity(
            builder: (context, isConnected) {
              if (isConnected) {
                return Container(
                  padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
                  child: SearchButtonField(
                    value: qParams['search'],
                    onUpdate: (value) {
                      ref
                          .read(madrasahQueryParamsProvider.notifier)
                          .updateParams('search', value);
                    },
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: InfiniteList(
                qParams: qParams,
                resourceFetcher: (Map<String, dynamic> params) async {
                  final api = ref.read(madrasahApiServiceProvider);
                  return await api.fetchMadrasahs(
                    page: params['page'] ?? 1,
                    perPage: params['per_page'] ?? 9,
                    search: qParams['search'],
                  );
                },
                itemBuilder: (_, item, __) {
                  return InkWell(
                    onTap: () => QR.to('madrasahs/${item.id}'),
                    child: ListItem(
                      item: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              item.title,
                              style: textTheme.titleMedium,
                            ),
                          ),
                          LastVisited(
                            resourceKey: 'lastMadrasah',
                            resourceId: item.id,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
