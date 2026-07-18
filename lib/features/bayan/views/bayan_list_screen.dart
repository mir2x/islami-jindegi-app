import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/inputs/search_button_field.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/widgets/utils/with_connectivity.dart';
import 'package:native_app/widgets/utils/offline_db_prompt.dart';
import 'package:native_app/widgets/filter/button.dart';
import 'package:native_app/widgets/filter/list.dart';
import 'package:native_app/widgets/filter/item.dart';
import 'package:native_app/widgets/presentation/content_list_card.dart';
import 'package:native_app/providers/downloaded_bayans.dart';
import 'package:native_app/providers/last_visited.dart';
import 'package:native_app/widgets/buttons/floating_downloaded.dart';
import 'package:native_app/helpers/format_date.dart';
import 'package:native_app/widgets/utils/last_visited.dart';
import '../providers/bayan_providers.dart';

class BayanListScreen extends ConsumerStatefulWidget {
  const BayanListScreen({super.key});

  @override
  ConsumerState<BayanListScreen> createState() => _BayanListScreenState();
}

class _BayanListScreenState extends ConsumerState<BayanListScreen> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _itemKeys = {};
  String? _lastScrolledToId;

  GlobalKey _keyFor(String id) => _itemKeys.putIfAbsent(id, () => GlobalKey());

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToLastVisited(String? lastId) {
    if (lastId == null || lastId == _lastScrolledToId) return;
    final ctx = _keyFor(lastId).currentContext;
    if (ctx != null) {
      _lastScrolledToId = lastId;
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        alignment: 0.3,
      );
    } else {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        final retryCtx = _keyFor(lastId).currentContext;
        if (retryCtx != null) {
          _lastScrolledToId = lastId;
          Scrollable.ensureVisible(
            retryCtx,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            alignment: 0.3,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    String currentLang = Localizations.localeOf(context).languageCode;
    var textTheme = Theme.of(context).textTheme;
    var qParams = ref.watch(bayanQueryParamsProvider);
    final lastVisited = ref.watch(lastVisitedProvider);
    final lastBayanId = lastVisited.value?.getString('lastBayan');

    return AppScaffold(
      onBackPressed: () async { if (context.canPop()) context.pop(); else context.go('/'); },
      title: Text(locales.bayans),
      floatingActionButton: FloatingDownloadedButton(
        label: locales.downloadedBayans,
        onPressed: () async => context.push('/bayans/downloads'),
      ),
      body: OfflineDbPrompt(
        feature: 'bayans',
        child: Column(
          children: [
            WithConnectivity(
              builder: (context, isConnected) {
                if (isConnected) {
                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.only(top: 20, left: 15, right: 15),
                        child: Row(
                          children: [
                            Expanded(
                              child: FilterButton(
                                label: locales.speakers,
                                active: qParams.containsKey('speakerId'),
                                onClear: () {
                                  ref
                                      .read(bayanQueryParamsProvider.notifier)
                                      .updateParams('speakerId', '');
                                },
                                selectedItemProvider:
                                    qParams.containsKey('speakerId')
                                        ? singleSpeakerProvider(
                                            qParams['speakerId'],
                                          )
                                        : null,
                                selectedItemLabel: (dynamic item) {
                                  return item.name;
                                },
                                children: [
                                  Expanded(
                                    child: FilterList(
                                      title: locales.speakers,
                                      paramKeys: const ['speakerId'],
                                      pageSize: 16,
                                      searchEnabled: true,
                                      queryProvider: bayanQueryParamsProvider,
                                      resourceFetcher:
                                          (Map<String, dynamic> params) async {
                                        final api =
                                            ref.read(bayanApiServiceProvider);
                                        return await api.fetchSpeakers(
                                          page: params['page'] ?? 1,
                                          perPage: params['per_page'] ?? 16,
                                          search: params['search'],
                                        );
                                      },
                                      itemBuilder: (_, item, __) {
                                        return FilterItem(
                                          itemId: item.id,
                                          itemTitle: item.name,
                                          paramKey: 'speakerId',
                                          queryProvider:
                                              bayanQueryParamsProvider,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: FilterButton(
                                label: locales.categories,
                                active: qParams.containsKey('categoryId'),
                                onClear: () {
                                  ref
                                      .read(bayanQueryParamsProvider.notifier)
                                      .updateParams('categoryId', '');
                                },
                                selectedItemProvider:
                                    qParams.containsKey('categoryId')
                                        ? singleBayanCategoryProvider(
                                            qParams['categoryId'],
                                          )
                                        : null,
                                selectedItemLabel: (dynamic item) {
                                  return item.title;
                                },
                                children: [
                                  Expanded(
                                    child: FilterList(
                                      title: locales.categories,
                                      paramKeys: const ['categoryId'],
                                      pageSize: 16,
                                      searchEnabled: true,
                                      queryProvider: bayanQueryParamsProvider,
                                      resourceFetcher:
                                          (Map<String, dynamic> params) async {
                                        final api =
                                            ref.read(bayanApiServiceProvider);
                                        return await api.fetchBayanCategories(
                                          page: params['page'] ?? 1,
                                          perPage: params['per_page'] ?? 16,
                                          search: params['search'],
                                        );
                                      },
                                      itemBuilder: (_, item, __) {
                                        return FilterItem(
                                          itemId: item.id,
                                          itemTitle: item.title,
                                          paramKey: 'categoryId',
                                          queryProvider:
                                              bayanQueryParamsProvider,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.only(top: 10, left: 15, right: 15),
                        child: SearchButtonField(
                          value: qParams['search'],
                          onUpdate: (value) {
                            ref
                                .read(bayanQueryParamsProvider.notifier)
                                .updateParams('search', value);
                          },
                        ),
                      ),
                    ],
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
                  pageSize: 9,
                  qParams: qParams,
                  scrollController: _scrollController,
                  onFirstPageLoaded: () => _scrollToLastVisited(lastBayanId),
                  resourceFetcher: (Map<String, dynamic> params) async {
                    final api = ref.read(bayanApiServiceProvider);
                    final offline = ref.read(bayanOfflineServiceProvider);
                    try {
                      return await api.fetchBayans(
                        page: params['page'] ?? 1,
                        perPage: params['per_page'] ?? 9,
                        search: qParams['search'],
                        speakerId: qParams['speakerId'],
                        categoryId: qParams['categoryId'],
                      );
                    } catch (_) {
                      return await offline.queryBayans(
                        page: params['page'] ?? 1,
                        perPage: params['per_page'] ?? 9,
                        search: qParams['search'],
                        speakerId: qParams['speakerId'],
                        categoryId: qParams['categoryId'],
                      );
                    }
                  },
                  itemBuilder: (_, item, __) {
                    final isRecent = item.id == lastBayanId;
                    if (isRecent && _lastScrolledToId != item.id) {
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) => _scrollToLastVisited(item.id),
                      );
                    }
                    return InkWell(
                      key: _keyFor(item.id),
                      onTap: () => context.push('/bayans/${item.id}'),
                      child: ContentListCard(
                        recentlyVisited: isRecent,
                        highlightProvider: getDownloadedBayanByIdProvider(
                          item.id,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: textTheme.titleMedium?.copyWith(
                                      height: 1.25,
                                    ),
                                  ),
                                  if (item.speakerName != null) ...[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(
                                        item.speakerName!,
                                        style: textTheme.labelMedium?.copyWith(
                                          height: 1.2,
                                        ),
                                      ),
                                    ),
                                  ],
                                  if (item.location != null) ...[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        item.location!,
                                        style: textTheme.labelSmall?.copyWith(
                                          height: 1.25,
                                        ),
                                      ),
                                    ),
                                  ],
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      formatDate(item.publishedAt, currentLang),
                                      style: textTheme.labelSmall?.copyWith(
                                        height: 1.2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            LastVisited(
                              resourceKey: 'lastBayan',
                              resourceId: item.id,
                              isAudio: true,
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
