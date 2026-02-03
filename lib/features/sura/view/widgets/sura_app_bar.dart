import 'package:flutter/material.dart';
import 'package:native_app/core/utils/bengali_digit_extension.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/shared/quran_data.dart';

class SuraAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final int suraNumber;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const SuraAppBar(
      {super.key,
      required this.title,
      required this.suraNumber,
      this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    final surahInfo = surahInfoList[suraNumber - 1];
    final subtitle =
        '${surahInfo.typeLabel} | আয়াত সংখ্যা: ${surahInfo.ayatCount.toBengaliDigit()}';

    final appBarForeground = Theme.of(context).appBarTheme.foregroundColor;

    return AppBar(
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              color: appBarForeground,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'bangla/solaimanlipi',
              wordSpacing: 3,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: appBarForeground?.withOpacity(0.7),
              fontSize: 12,
              fontFamily: 'bangla/solaimanlipi',
              wordSpacing: 3,
            ),
          ),
        ],
      ),
      centerTitle: true,
      iconTheme: IconThemeData(color: appBarForeground),
      actions: [
        IconButton(
          icon: Icon(Icons.menu_book, color: appBarForeground),
          onPressed: () {
            debugPrint(
                'Navigating to TilawatPage with suraNumber: $suraNumber');
            QR.to('/qurans/tilawat?sura=$suraNumber&ayah=1');
          },
        ),
        IconButton(
          icon: Icon(Icons.search, color: appBarForeground),
          onPressed: () {
            QR.to('/qurans/search');
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
