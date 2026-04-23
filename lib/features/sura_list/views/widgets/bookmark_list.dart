import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:native_app/core/utils/bengali_digit_extension.dart';
import 'package:native_app/features/quran/models/bookmark.dart';
import 'package:native_app/features/quran/providers/ayah_highlight_providers.dart';
import 'package:native_app/features/quran/providers/bookmark_providers.dart';
import 'package:native_app/features/sura/utils/navigation_routes.dart';
import 'package:native_app/features/sura_list/models/sources/sura_information.dart';
import 'package:native_app/theme/app_theme_color.dart';

class BookmarkList extends ConsumerWidget {
  const BookmarkList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final bookmarksAsync = ref.watch(bookmarkProvider);

    return bookmarksAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text(
          error.toString(),
          style: TextStyle(
            wordSpacing: 3,
            color: colors.secondaryText,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      data: (bookmarks) {
        final ayahBookmarks = bookmarks
            .where((bookmark) => bookmark.type == 'ayah')
            .toList()
          ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

        if (ayahBookmarks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bookmark_border,
                  size: 64,
                  color: colors.secondaryText,
                ),
                const SizedBox(height: 16),
                Text(
                  'কোনো বুকমার্ক নেই',
                  style: TextStyle(
                    wordSpacing: 3,
                    fontSize: 18,
                    color: colors.secondaryText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'আয়াতে ট্যাপ করে বুকমার্ক যোগ করুন',
                  style: TextStyle(
                    wordSpacing: 3,
                    fontSize: 14,
                    color: colors.secondaryText,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          itemCount: ayahBookmarks.length,
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemBuilder: (context, index) {
            final bookmark = ayahBookmarks[index];
            return _BookmarkListItem(bookmark: bookmark);
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: 1,
              thickness: 0.5,
              indent: 16,
              endIndent: 16,
              color: colors.divider,
            );
          },
        );
      },
    );
  }
}

class _BookmarkListItem extends ConsumerWidget {
  const _BookmarkListItem({required this.bookmark});

  final Bookmark bookmark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final isClassic = colors.primary == AppThemeColors.classic.primary &&
        colors.appBarBg == AppThemeColors.classic.appBarBg;
    final suraNumber = bookmark.sura;
    final ayahNumber = bookmark.ayah;

    if (suraNumber == null || ayahNumber == null) {
      return const SizedBox.shrink();
    }

    return Dismissible(
      key: Key(bookmark.identifier),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        ref.read(bookmarkProvider.notifier).remove(bookmark.identifier);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'বুকমার্ক সরানো হয়েছে',
              style: TextStyle(wordSpacing: 3),
            ),
          ),
        );
      },
      background: Container(
        color: isClassic
            ? colors.secondary.withValues(alpha: 0.9)
            : colors.primary.withValues(alpha: 0.9),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: Icon(Icons.delete, color: colors.appBarText),
      ),
      child: InkWell(
        onTap: () {
          ref
              .read(selectedAyahProvider.notifier)
              .selectByNavigation(suraNumber, ayahNumber);
          context.push(
            buildSuraRoute(
              suraNumber: suraNumber,
              scrollIndex: ayahNumber - 1,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              _buildAyahInfo(context, ayahNumber),
              const SizedBox(width: 16),
              Expanded(child: _buildMeta(context, suraNumber, ayahNumber)),
              _buildDeleteButton(context, ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAyahInfo(BuildContext context, int ayahNumber) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final isClassic = colors.primary == AppThemeColors.classic.primary &&
        colors.appBarBg == AppThemeColors.classic.appBarBg;
    final accentColor = isClassic ? colors.appBarBg : colors.active;

    return Container(
      width: 60,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: colors.highlight.withValues(alpha: isClassic ? 0.62 : 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            ayahNumber.toBengaliDigit(),
            style: TextStyle(
              wordSpacing: 3,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
          Text(
            'আয়াত',
            style: TextStyle(
              wordSpacing: 3,
              fontSize: 12,
              color: accentColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeta(BuildContext context, int suraNumber, int ayahNumber) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final suraName =
        suraNumber > 0 && suraNumber <= allSuras.length
            ? allSuras[suraNumber - 1].nameBangla
            : 'সূরা $suraNumber';
    final para = bookmark.para;
    final page = bookmark.page;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          suraName,
          style: const TextStyle(
            wordSpacing: 3,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          [
            'আয়াত ${ayahNumber.toBengaliDigit()}',
            if (para != null) 'পারা ${para.toBengaliDigit()}',
            if (page != null) 'পৃষ্ঠা ${page.toBengaliDigit()}',
          ].join('  •  '),
          style: TextStyle(
            wordSpacing: 3,
            fontSize: 13,
            color: colors.secondaryText,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          bookmark.timestamp.toLocal().toString().split('.').first,
          style: GoogleFonts.amiri(
            fontSize: 13,
            height: 1.4,
            color: colors.secondaryText.withValues(alpha: 0.8),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildDeleteButton(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final isClassic = colors.primary == AppThemeColors.classic.primary &&
        colors.appBarBg == AppThemeColors.classic.appBarBg;
    final accentColor = isClassic ? colors.appBarBg : colors.active;

    return IconButton(
      icon: Icon(Icons.bookmark, color: accentColor),
      onPressed: () {
        ref.read(bookmarkProvider.notifier).remove(bookmark.identifier);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'বুকমার্ক সরানো হয়েছে',
              style: TextStyle(wordSpacing: 3),
            ),
          ),
        );
      },
    );
  }
}
