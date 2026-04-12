import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/features/quran/providers/bookmark_providers.dart';
import 'package:native_app/features/quran/providers/ayah_highlight_providers.dart';
import 'package:native_app/features/sura/providers/sura_providers.dart';
import 'package:native_app/features/sura/utils/navigation_routes.dart';
import 'package:native_app/theme/app_theme_color.dart';

class SuraBookmarkNavigationView extends ConsumerWidget {
  final int currentSuraNumber;
  final String returnTo;

  const SuraBookmarkNavigationView({
    super.key,
    required this.currentSuraNumber,
    required this.returnTo,
  });

  String _toBengaliNumber(int number) {
    const bn = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    return number.toString().split('').map((d) => bn[int.parse(d)]).join();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksAsync = ref.watch(bookmarkProvider);
    final suraNames = ref.watch(suraNamesProvider);
    final appColors = Theme.of(context).extension<AppThemeColors>()!;
    final isClassic = appColors.primary == AppThemeColors.classic.primary &&
        appColors.appBarBg == AppThemeColors.classic.appBarBg;
    final accent = isClassic ? appColors.appBarBg : appColors.active;
    final contentBg = isClassic ? appColors.cardBg : Colors.transparent;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final itemTitleFontSize = isLandscape ? 12.0 : 14.sp;
    final itemSubtitleFontSize = isLandscape ? 10.0 : 12.sp;

    return ColoredBox(
      color: contentBg,
      child: bookmarksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'বুকমার্ক লোড করা যায়নি',
            style: TextStyle(
              fontSize: 14.sp,
              color: appColors.secondaryText,
            ),
          ),
        ),
        data: (bookmarks) {
          final ayahBookmarks =
              bookmarks.where((bookmark) => bookmark.type == 'ayah').toList();

          if (ayahBookmarks.isEmpty) {
            return Center(
              child: Text(
                'কোনো বুকমার্ক নেই।',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: appColors.secondaryText,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: ayahBookmarks.length,
            separatorBuilder: (context, _) =>
                Divider(height: 1.h, color: appColors.divider),
            itemBuilder: (context, i) {
              final bookmark = ayahBookmarks[i];
              final suraNumber = bookmark.sura;
              final ayahNumber = bookmark.ayah;
              final suraName = (suraNumber != null &&
                      suraNumber > 0 &&
                      suraNumber <= suraNames.length)
                  ? suraNames[suraNumber - 1]
                  : 'Unknown Sura';

              return ListTile(
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${_toBengaliNumber(i + 1)}.',
                      style: TextStyle(
                        fontSize: itemTitleFontSize,
                        fontWeight: FontWeight.bold,
                        color: accent,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            suraName,
                            style: TextStyle(
                              fontSize: itemSubtitleFontSize,
                              fontWeight: FontWeight.w500,
                              color: appColors.primaryText,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            ayahNumber == null
                                ? 'আয়াত তথ্য নেই'
                                : 'আয়াত ${_toBengaliNumber(ayahNumber)}',
                            style: TextStyle(
                              fontSize: itemSubtitleFontSize,
                              color: appColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                onTap: suraNumber == null || ayahNumber == null
                    ? null
                    : () {
                        Scaffold.of(context).closeDrawer();
                        if (suraNumber == currentSuraNumber) {
                          ref.read(suraScrollCommandProvider.notifier).state =
                              ScrollCommand(
                            suraNumber: suraNumber,
                            scrollIndex: ayahNumber - 1,
                          );
                        } else {
                          Future.delayed(const Duration(milliseconds: 200),
                              () async {
                            if (!context.mounted) return;
                            if (context.canPop()) context.pop();
                            await Future.delayed(
                              const Duration(milliseconds: 50),
                            );
                            if (!context.mounted) return;
                            context.push(
                              buildSuraRoute(
                                suraNumber: suraNumber,
                                scrollIndex: ayahNumber - 1,
                                returnTo: returnTo,
                              ),
                            );
                          });
                        }
                      },
                trailing: IconButton(
                  icon: Icon(
                    Icons.delete,
                    size: 20.r,
                    color: appColors.secondaryText,
                  ),
                  onPressed: () {
                    ref
                        .read(bookmarkProvider.notifier)
                        .remove(bookmark.identifier);
                  },
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                minVerticalPadding: 0,
                visualDensity: VisualDensity.compact,
              );
            },
          );
        },
      ),
    );
  }
}
