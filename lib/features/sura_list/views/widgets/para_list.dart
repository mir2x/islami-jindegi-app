import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/core/utils/bengali_digit_extension.dart';
import 'package:native_app/features/quran/providers/ayah_highlight_providers.dart';
import 'package:native_app/features/sura/utils/navigation_routes.dart';
import 'package:native_app/shared/quran_data.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/theme/app_theme_color.dart';

class ParaList extends ConsumerWidget {
  const ParaList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      itemCount: paraStarts.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        final paraNumber = index + 1;
        final (suraNumber, ayahNumber) = paraStarts[index];
        final suraName = suraNames[suraNumber - 1];
        final paraName = paraNamesBengali[index];

        return _ParaListItem(
          paraNumber: paraNumber,
          paraName: paraName,
          suraNumber: suraNumber,
          ayahNumber: ayahNumber,
          suraName: suraName,
        );
      },
      separatorBuilder: (context, index) {
        return Divider(
          height: 1,
          thickness: 0.5,
          indent: 16,
          endIndent: 16,
          color: Theme.of(context).extension<AppThemeColors>()!.divider,
        );
      },
    );
  }
}

class _ParaListItem extends StatelessWidget {
  final int paraNumber;
  final String paraName;
  final int suraNumber;
  final int ayahNumber;
  final String suraName;

  const _ParaListItem({
    required this.paraNumber,
    required this.paraName,
    required this.suraNumber,
    required this.ayahNumber,
    required this.suraName,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(
          buildSuraRoute(
            suraNumber: suraNumber,
            scrollIndex: ayahNumber - 1,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            _buildParaNumber(context),
            const SizedBox(width: 16),
            Expanded(child: _buildParaInfo(context)),
            _buildArrow(context),
          ],
        ),
      ),
    );
  }

  Widget _buildParaNumber(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final isClassic = colors.primary == AppThemeColors.classic.primary &&
        colors.appBarBg == AppThemeColors.classic.appBarBg;
    final accentColor = isClassic ? colors.appBarBg : colors.active;
    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.highlight.withValues(alpha: isClassic ? 0.62 : 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        paraNumber.toBengaliDigit(),
        style: TextStyle(
          wordSpacing: 3,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: accentColor,
        ),
      ),
    );
  }

  Widget _buildParaInfo(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          paraName,
          style: const TextStyle(
            wordSpacing: 3,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              Icons.play_arrow,
              size: 16,
              color: colors.secondaryText,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                'সূরা $suraName, আয়াত ${ayahNumber.toBengaliDigit()}',
                style: TextStyle(
                  wordSpacing: 3,
                  fontSize: 14,
                  color: colors.secondaryText,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildArrow(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    return Icon(
      Icons.chevron_right,
      color: colors.secondaryText,
    );
  }
}
