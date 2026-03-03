import 'package:flutter/material.dart';
import 'package:native_app/core/utils/bengali_digit_extension.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/shared/quran_data.dart';

class SuraAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final int suraNumber;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  /// When provided, replaces the default actions entirely.
  final List<Widget>? actions;

  const SuraAppBar({
    super.key,
    required this.title,
    required this.suraNumber,
    this.scaffoldKey,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final surahInfo = surahInfoList[suraNumber - 1];
    final subtitle =
        '${surahInfo.typeLabel} | আয়াত সংখ্যা: ${surahInfo.ayatCount.toBengaliDigit()}';
    final fg = Theme.of(context).appBarTheme.foregroundColor;

    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              wordSpacing: 3,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: fg?.withOpacity(0.7),
              fontSize: 12,
              wordSpacing: 3,
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: actions ??
          [
            if (scaffoldKey != null)
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => scaffoldKey!.currentState?.openDrawer(),
              ),
            IconButton(
              icon: const Icon(Icons.menu_book),
              onPressed: () =>
                  QR.to('/qurans/tilawat?sura=$suraNumber&ayah=1'),
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => QR.to('/qurans/search'),
            ),
          ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
