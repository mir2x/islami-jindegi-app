import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:native_app/core/utils/bengali_digit_extension.dart';
import 'package:qlevar_router/qlevar_router.dart';
import '../../models/bookmark.dart';
import '../../providers/bookmark_providers.dart';

class BookmarkList extends ConsumerWidget {
  const BookmarkList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(bookmarkProvider);

    if (bookmarks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_border,
              size: 64,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'কোনো বুকমার্ক নেই',
              style: TextStyle(
                      wordSpacing: 3,
                fontSize: 18,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'আয়াতে ট্যাপ করে বুকমার্ক যোগ করুন',
              style: TextStyle(
                      wordSpacing: 3,
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
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
        return const Divider(
          height: 1,
          thickness: 0.5,
          indent: 16,
          endIndent: 16,
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
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: Icon(Icons.delete, color: Theme.of(context).colorScheme.onError),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to the ayah in SurahPage
          // The initialScrollIndex is ayahNumber - 1 (0-indexed)
          QR.to(
              '/qurans/sura/${bookmark.suraNumber}?scroll=${bookmark.ayahNumber - 1}');
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
    return Container(
      width: 60,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
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
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Text(
            'আয়াত',
            style: TextStyle(
                  wordSpacing: 3,
              fontSize: 12,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArabicPreview(BuildContext context) {
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
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textDirection: TextDirection.rtl,
        ),
      ],
    );
  }

  Widget _buildDeleteButton(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: Icon(Icons.bookmark, color: Theme.of(context).colorScheme.primary),
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
