import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/theme/app_theme_color.dart';

import '../../models/book_reading_progress.dart';

class ContinueReadingCard extends StatelessWidget {
  const ContinueReadingCard({super.key, required this.progress});

  final BookReadingProgress progress;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final canResumeNode = progress.nodeId != null && progress.nodeKind != null;
    final destination = canResumeNode
        ? '/books/${progress.bookId}/${progress.nodeKind == BookNodeKind.chapter ? 'chapters' : 'subchapters'}/${progress.nodeId}'
        : '/books/${progress.bookId}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 14, 15, 2),
      child: Material(
        color: colors.highlight,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.push(destination),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                const Icon(Icons.menu_book_outlined),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        progress.bookTitle.isEmpty
                            ? 'Continue reading'
                            : progress.bookTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleMedium,
                      ),
                      if (progress.nodeTitle?.isNotEmpty == true)
                        Text(
                          progress.nodeTitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colors.secondaryText,
                          ),
                        ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
