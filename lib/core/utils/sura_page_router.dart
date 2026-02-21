import 'package:flutter/material.dart';
import '../../features/sura/views/sura_page.dart';

MaterialPageRoute<dynamic> createSurahPageRoute(
    int suraNumber, int? initialScrollIndex) {
  return MaterialPageRoute(
    settings: RouteSettings(name: '/surah/$suraNumber'),
    builder: (context) => SurahPage(
      suraNumber: suraNumber,
      initialScrollIndex: initialScrollIndex,
    ),
  );
}
