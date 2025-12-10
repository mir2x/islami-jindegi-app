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

    return AppBar(
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'bangla/solaimanlipi',
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontFamily: 'bangla/solaimanlipi',
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.menu_book, color: Colors.white),
          onPressed: () {
            debugPrint(
                'Navigating to TilawatPage with suraNumber: $suraNumber');
            QR.to('/qurans/tilawat?sura=$suraNumber&ayah=1');
          },
        ),
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
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
