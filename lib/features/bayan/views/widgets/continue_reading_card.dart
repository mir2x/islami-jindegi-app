import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/theme/app_theme_color.dart';

import '../../providers/bayan_progress_provider.dart';

class BayanContinueReadingCard extends StatelessWidget {
  const BayanContinueReadingCard({super.key, required this.progress});
  final BayanProgress progress;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 14, 15, 2),
      child: Material(
        color: colors.highlight,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.push('/bayans/${progress.id}'),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              const Icon(Icons.headphones_outlined),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  progress.title.isEmpty ? 'Continue reading' : progress.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const Icon(Icons.chevron_right),
            ]),
          ),
        ),
      ),
    );
  }
}
