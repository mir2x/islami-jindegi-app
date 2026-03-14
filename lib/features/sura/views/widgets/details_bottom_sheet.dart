import 'package:flutter/material.dart';
import 'package:native_app/features/sura/views/widgets/reciter_selection_dialog.dart';
import 'package:native_app/features/sura/views/widgets/search_page.dart';
import 'package:native_app/features/sura/views/widgets/theme_change_dialog.dart';
import 'package:native_app/features/sura/views/widgets/tilawat_page.dart';
import 'package:native_app/features/sura/views/widgets/translation_selection_dialog.dart';
import 'package:native_app/theme/app_theme_color.dart';
import '../../models/grid_item_data.dart';
import 'font_change_dialog.dart';

void showDetailsBottomSheet(BuildContext context, {required int suraNumber}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).extension<AppThemeColors>()!.cardBg,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext context) =>
        DetailsBottomSheet(suraNumber: suraNumber),
  );
}

class DetailsBottomSheet extends StatelessWidget {
  final int suraNumber;
  const DetailsBottomSheet({super.key, required this.suraNumber});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDragHandle(context),
            _DetailsSection(
              title: 'ফিচার',
              items: [
                GridItemData(
                    icon: Icons.search,
                    label: 'অনুসন্ধান',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchPage(),
                        ),
                      );
                    }),
              ],
            ),
            _DetailsSection(
              title: 'ভিউ',
              items: [
                GridItemData(
                    icon: Icons.font_download_outlined,
                    label: 'ফন্ট পরিবর্তন',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const FontChangeDialog(),
                      );
                    }),
                GridItemData(
                    icon: Icons.palette_outlined,
                    label: 'থিম পরিবর্তন',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const ThemeChangeDialog(),
                      );
                    }),
                GridItemData(
                    icon: Icons.chrome_reader_mode,
                    label: 'তিলাওয়াত মোড',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TilawatPage(
                            initialSuraNumber: suraNumber,
                            initialAyahNumber: 1,
                          ),
                        ),
                      );
                    }),
              ],
            ),
            _DetailsSection(
              title: 'সেটিংস',
              items: [
                GridItemData(
                    icon: Icons.translate_outlined,
                    label: 'অনুবাদক পরিবর্তন',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const TranslatorSelectionDialog(),
                      );
                    }),
                GridItemData(
                    icon: Icons.person_outline,
                    label: 'কারী পরিবর্তন',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const ReciterSelectionDialog(),
                      );
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDragHandle(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Theme.of(context).extension<AppThemeColors>()!.divider,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _DetailsSection extends StatelessWidget {
  final String title;
  final List<GridItemData> items;

  const _DetailsSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final sectionHeaderBg = colors.highlight;
    final sectionHeaderFg = colors.primaryText;
    final iconColor = colors.active;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          color: sectionHeaderBg,
          child: Text(
            title,
            style: TextStyle(
              wordSpacing: 3,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: sectionHeaderFg,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 3,
            mainAxisSpacing: 4,
            childAspectRatio: 1.1,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: item.onTap,
              child: Container(
                decoration: BoxDecoration(
                  color: colors.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.divider),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item.icon, size: 28, color: iconColor),
                    const SizedBox(height: 4),
                    Text(
                      item.label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        wordSpacing: 3,
                        fontSize: 12,
                        color: colors.primaryText,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
