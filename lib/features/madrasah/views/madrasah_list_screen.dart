import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/with_connectivity.dart';
import 'package:native_app/widgets/utils/offline_db_prompt.dart';
import 'package:native_app/widgets/inputs/search_button_field.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/widgets/presentation/list_item.dart';
import 'package:native_app/providers/last_visited.dart';
import 'package:native_app/widgets/utils/last_visited.dart';
import 'package:native_app/theme/app_theme_color.dart';
import '../providers/madrasah_providers.dart';

class MadrasahListScreen extends ConsumerStatefulWidget {
  const MadrasahListScreen({super.key});

  @override
  ConsumerState<MadrasahListScreen> createState() => _MadrasahListScreenState();
}

class _MadrasahListScreenState extends ConsumerState<MadrasahListScreen> {
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
    var textTheme = Theme.of(context).textTheme;
    var appTheme = Theme.of(context).extension<AppThemeColors>()!;
    var qParams = ref.watch(madrasahQueryParamsProvider);
    final lastVisited = ref.watch(lastVisitedProvider);
    final lastMadrasahId = lastVisited.value?.getString('lastMadrasah');

    return AppScaffold(
      onBackPressed: () async { if (context.canPop()) context.pop(); else context.go('/'); },
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
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: InfiniteList(
                  qParams: qParams,
                  scrollController: _scrollController,
                  onFirstPageLoaded: () => _scrollToLastVisited(lastMadrasahId),
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
                    if (isRecent && _lastScrolledToId != item.id) {
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) => _scrollToLastVisited(item.id),
                      );
                    }
                    return InkWell(
                      key: _keyFor(item.id),
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
      ),
    );
  }
}
