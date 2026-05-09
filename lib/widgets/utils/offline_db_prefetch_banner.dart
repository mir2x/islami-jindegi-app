import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/offline_db_prefetch_service.dart';
import '../../theme/app_theme_color.dart';

class OfflineDbPrefetchBanner extends ConsumerWidget {
  const OfflineDbPrefetchBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(offlineDbPrefetchProvider);
    if (!state.isVisible || state.total == 0) {
      return const SizedBox.shrink();
    }

    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final progress = state.overallProgress.clamp(0.0, 1.0);
    final message = switch (state.status) {
      OfflineDbPrefetchStatus.completed => 'অফলাইন ডাটা প্রস্তুত হয়েছে',
      OfflineDbPrefetchStatus.failed =>
        'কিছু অফলাইন ডাটা পরে আবার চেষ্টা করা হবে',
      _ => 'অফলাইন ডাটা প্রস্তুত হচ্ছে... ${state.completed}/${state.total}',
    };

    return Positioned(
      left: 14,
      right: 14,
      bottom: bottomPadding + 14,
      child: IgnorePointer(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: Material(
            key: ValueKey(state.status),
            type: MaterialType.transparency,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: colors.divider),
                boxShadow: [
                  BoxShadow(
                    color: colors.shadow.withValues(alpha: 0.16),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 22,
                      height: 22,
                      child: state.status ==
                              OfflineDbPrefetchStatus.downloading
                          ? CircularProgressIndicator(
                              strokeWidth: 2.5,
                              value: progress > 0 ? progress : null,
                              color: colors.secondary,
                            )
                          : Icon(
                              state.status == OfflineDbPrefetchStatus.completed
                                  ? Icons.check_circle_outline
                                  : Icons.info_outline,
                              size: 22,
                              color: colors.secondary,
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: colors.primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          if (state.status ==
                              OfflineDbPrefetchStatus.downloading) ...[
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(99),
                              child: LinearProgressIndicator(
                                minHeight: 4,
                                value: progress > 0 ? progress : null,
                                backgroundColor: colors.divider,
                                color: colors.secondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
