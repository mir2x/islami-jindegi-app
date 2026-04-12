import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:native_app/core/utils/bengali_digit_extension.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/features/sura/utils/navigation_routes.dart';
import 'package:native_app/theme/app_theme_color.dart';
import '../../models/bookmark.dart';
import '../../providers/bookmark_providers.dart';

class BookmarkList extends ConsumerWidget {
  const BookmarkList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(bookmarkProvider);
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    if (bookmarks.isEmpty) {
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
      itemCount: bookmarks.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        final bookmark = bookmarks[index];
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
  }
}

class _BookmarkListItem extends ConsumerWidget {
  final Bookmark bookmark;

  const _BookmarkListItem({required this.bookmark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final isClassic = colors.primary == AppThemeColors.classic.primary &&
        colors.appBarBg == AppThemeColors.classic.appBarBg;
    return Dismissible(
      key: Key(bookmark.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        ref.read(bookmarkProvider.notifier).removeBookmark(
              bookmark.suraNumber,
              bookmark.ayahNumber,
            );
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
          context.push(
            buildSuraRoute(
              suraNumber: bookmark.suraNumber,
              scrollIndex: bookmark.ayahNumber - 1,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              _buildSuraInfo(context),
              const SizedBox(width: 16),
              Expanded(child: _buildArabicPreview(context)),
              _buildDeleteButton(context, ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuraInfo(BuildContext context) {
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
            bookmark.ayahNumber.toBengaliDigit(),
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

  Widget _buildArabicPreview(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          bookmark.suraName,
          style: const TextStyle(
            wordSpacing: 3,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          bookmark.arabicText.length > 60
              ? '${bookmark.arabicText.substring(0, 60)}...'
              : bookmark.arabicText,
          style: GoogleFonts.amiri(
            fontSize: 16,
            height: 1.5,
            color: colors.secondaryText,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textDirection: TextDirection.rtl,
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
        ref.read(bookmarkProvider.notifier).removeBookmark(
              bookmark.suraNumber,
              bookmark.ayahNumber,
            );
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
