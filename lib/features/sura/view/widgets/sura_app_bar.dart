import 'package:flutter/material.dart';
import 'package:native_app/core/utils/bengali_digit_extension.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/shared/quran_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return AppBar(
      title: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Theme.of(context).primaryColor,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            value: suraNumber,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'bangla/solaimanlipi',
            ),
            onChanged: (int? newValue) async {
              if (newValue != null && newValue != suraNumber) {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setInt('last_read_sura', newValue);
                await prefs.setInt('last_read_ayah_index', 0);

                if (!context.mounted) return;

                await QR.back();
                QR.to('/qurans/sura/$newValue');
              }
            },
            items: List.generate(suraNames.length, (index) {
              final suraNum = index + 1;
              return DropdownMenuItem<int>(
                value: suraNum,
                child: Text(
                  '${suraNum.toBengaliDigit()}. ${suraNames[index]}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'bangla/solaimanlipi',
                  ),
                ),
              );
            }),
            selectedItemBuilder: (BuildContext context) {
              return List.generate(suraNames.length, (index) {
                final suraNum = index + 1;
                return Center(
                  child: Text(
                    '${suraNum.toBengaliDigit()}. ${suraNames[index]}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'bangla/solaimanlipi',
                    ),
                  ),
                );
              });
            },
          ),
        ),
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
