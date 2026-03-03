import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/features/sura/providers/sura_providers.dart';
import 'package:native_app/features/sura_list/providers/bookmark_providers.dart'
    as sura_bookmarks;

class SuraBookmarkNavigationView extends ConsumerWidget {
  final int currentSuraNumber;

  const SuraBookmarkNavigationView({
    super.key,
    required this.currentSuraNumber,
  });

  String _toBengaliNumber(int number) {
    const bn = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    return number.toString().split('').map((d) => bn[int.parse(d)]).join();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(sura_bookmarks.bookmarkProvider);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final itemTitleFontSize = isLandscape ? 12.0 : 14.sp;
    final itemSubtitleFontSize = isLandscape ? 10.0 : 12.sp;

    if (bookmarks.isEmpty) {
      return Center(
        child: Text(
          'কোনো বুকমার্ক নেই।',
          style: TextStyle(
            fontSize: 14.sp,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: bookmarks.length,
      separatorBuilder: (context, _) =>
          Divider(height: 1.h, color: Theme.of(context).dividerColor),
      itemBuilder: (context, i) {
        final bookmark = bookmarks[i];

        return ListTile(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${_toBengaliNumber(i + 1)}.',
                style: TextStyle(
                  fontSize: itemTitleFontSize,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      bookmark.suraName,
                      style: TextStyle(
                        fontSize: itemSubtitleFontSize,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'আয়াত ${_toBengaliNumber(bookmark.ayahNumber)}',
                      style: TextStyle(
                        fontSize: itemSubtitleFontSize,
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color
                            ?.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          onTap: () {
            Scaffold.of(context).closeDrawer();
            if (bookmark.suraNumber == currentSuraNumber) {
              ref.read(suraScrollCommandProvider.notifier).state = ScrollCommand(
                suraNumber: bookmark.suraNumber,
                scrollIndex: bookmark.ayahNumber - 1,
              );
            } else {
              Future.delayed(const Duration(milliseconds: 200), () async {
                await QR.back();
                await Future.delayed(const Duration(milliseconds: 50));
                QR.to(
                  '/qurans/sura/${bookmark.suraNumber}?scroll=${bookmark.ayahNumber - 1}',
                );
              });
            }
          },
          trailing: IconButton(
            icon: Icon(
              Icons.delete,
              size: 20.r,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            onPressed: () {
              ref.read(sura_bookmarks.bookmarkProvider.notifier).removeBookmark(
                    bookmark.suraNumber,
                    bookmark.ayahNumber,
                  );
            },
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          minVerticalPadding: 0,
          visualDensity: VisualDensity.compact,
        );
      },
    );
  }
}
