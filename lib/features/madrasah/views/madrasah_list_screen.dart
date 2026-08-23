import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/with_connectivity.dart';
import 'package:native_app/widgets/utils/offline_db_prompt.dart';
import 'package:native_app/widgets/inputs/search_button_field.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/widgets/presentation/list_item.dart';
import 'package:native_app/widgets/presentation/continue_reading_card.dart';
import 'package:native_app/theme/app_theme_color.dart';
import 'package:native_app/core/navigation/retained_list_state.dart';
import '../providers/madrasah_providers.dart';
import '../providers/madrasah_progress_provider.dart';

class MadrasahListScreen extends ConsumerStatefulWidget {
  const MadrasahListScreen({super.key});

  @override
  ConsumerState<MadrasahListScreen> createState() => _MadrasahListScreenState();
}

class _MadrasahListScreenState extends ConsumerState<MadrasahListScreen> {
  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var appTheme = Theme.of(context).extension<AppThemeColors>()!;
    var qParams = ref.watch(madrasahQueryParamsProvider);
    final listState = ref.watch(
      madrasahListStateProvider(
        RetainedListKey(Map.unmodifiable(Map<String, dynamic>.from(qParams))),
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => listState.restore());
    final progress = ref.watch(madrasahProgressProvider);
    final lastMadrasahId = progress?.id;

    return AppScaffold(
      onBackPressed: () async {
        if (context.canPop())
          context.pop();
        else
          context.go('/');
      },
      title: Text(locales.madrasah),
      body: OfflineDbPrompt(
        feature: 'madrasahs',
        child: Column(
          children: [
            WithConnectivity(
              builder: (context, isConnected) {
                if (isConnected) {
                  return Container(
                    margin: const EdgeInsets.only(top: 20, left: 15, right: 15),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: appTheme.cardBg,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: appTheme.divider),
                    ),
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
            if (progress != null)
              ContinueReadingCard(
                title: progress.title,
                destination: '/madrasahs/${progress.id}',
                icon: Icons.school_outlined,
              ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: InfiniteList(
                  qParams: qParams,
                  controller: listState.controller,
                  scrollController: listState.scrollController,
                  resourceFetcher: (Map<String, dynamic> params) async {
                    final api = ref.read(madrasahApiServiceProvider);
                    final offline = ref.read(madrasahOfflineServiceProvider);
                    try {
                      return await api.fetchMadrasahs(
                        page: params['page'] ?? 1,
                        perPage: params['per_page'] ?? 9,
                        search: qParams['search'],
                      );
                    } catch (_) {
                      return await offline.queryMadrasahs(
                        page: params['page'] ?? 1,
                        perPage: params['per_page'] ?? 9,
                        search: qParams['search'],
                      );
                    }
                  },
                  itemBuilder: (_, item, __) {
                    final isRecent = item.id == lastMadrasahId;
                    return InkWell(
                      onTap: () => context.push('/madrasahs/${item.id}'),
                      child: ListItem(
                        recentlyVisited: isRecent,
                        item: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                item.title,
                                style: textTheme.titleMedium,
                              ),
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
      ),
    );
  }
}
