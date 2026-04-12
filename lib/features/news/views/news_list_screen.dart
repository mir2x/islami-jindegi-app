import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/with_connectivity.dart';
import 'package:native_app/widgets/inputs/search_button_field.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/widgets/presentation/list_item.dart';
import 'package:native_app/helpers/format_date.dart';
import 'package:native_app/providers/last_visited.dart';
import 'package:native_app/widgets/utils/last_visited.dart';
import 'package:native_app/theme/app_theme_color.dart';
import '../providers/news_providers.dart';

class NewsListScreen extends ConsumerStatefulWidget {
  const NewsListScreen({super.key});

  @override
  ConsumerState<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends ConsumerState<NewsListScreen> {
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
    var appTheme = Theme.of(context).extension<AppThemeColors>()!;
    var qParams = ref.watch(newsQueryParamsProvider);
    final lastVisited = ref.watch(lastVisitedProvider);
    final lastNewsId = lastVisited.value?.getString('lastNews');

    return AppScaffold(
      onBackPressed: () async { if (context.canPop()) context.pop(); else context.go('/'); },
      title: Text(locales.news),
      body: WithConnectivity(
        builder: (context, isConnected) {
          if (isConnected) {
            return Column(
              children: [
                Container(
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
                          .read(newsQueryParamsProvider.notifier)
                          .updateParams('search', value);
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: InfiniteList(
                      qParams: qParams,
                      scrollController: _scrollController,
                      onFirstPageLoaded: () => _scrollToLastVisited(lastNewsId),
                      resourceFetcher: (Map<String, dynamic> params) async {
                        final api = ref.read(newsApiServiceProvider);
                        return await api.fetchNews(
                          page: params['page'] ?? 1,
                          perPage: params['per_page'] ?? 9,
                          search: qParams['search'],
                        );
                      },
                      itemBuilder: (_, item, __) {
                        final isRecent = item.id == lastNewsId;
                        if (isRecent && _lastScrolledToId != item.id) {
                          WidgetsBinding.instance.addPostFrameCallback(
                            (_) => _scrollToLastVisited(item.id),
                          );
                        }
                        return InkWell(
                          key: _keyFor(item.id),
                          onTap: () => context.push('/news/${item.id}'),
                          child: ListItem(
                            recentlyVisited: isRecent,
                            item: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title,
                                        style: textTheme.titleMedium,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          formatDate(
                                            item.publishedAt,
                                            currentLang,
                                          ),
                                          style: textTheme.labelSmall,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                LastVisited(
                                  resourceKey: 'lastNews',
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
            );
          } else {
            return Center(
              child: Text(
                locales.connectToInternetMsg,
                style: textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
            );
          }
        },
      ),
    );
  }
}
