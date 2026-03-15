import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/features/quran/providers/ayah_highlight_providers.dart';
import '../models/tilawat_models.dart';

final quranPagesProvider =
    FutureProvider.family<List<QuranPage>, int>((ref, int suraNumber) async {
  final jsonString = await rootBundle.loadString('assets/sura_data.json');
  final Map<String, dynamic> jsonData = json.decode(jsonString);
  final List<dynamic> surasJson = jsonData['suras'];

  final targetSuraJson = surasJson.firstWhere(
    (sura) => sura['sura_number'] == suraNumber,
    orElse: () => null,
  );

  if (targetSuraJson == null) {
    return [];
  }

  final List<QuranPage> surahPages = [];

  final String suraNameBengali = targetSuraJson['name_bengali'];
  final String suraNameArabic = targetSuraJson['name_arabic'];
  final quranInfoService = ref.read(quranInfoServiceProvider);

  for (var pageJson in targetSuraJson['pages']) {
    final List<dynamic> ayahsJson = pageJson['ayahs'];
    final List<TilawatAyah> ayahs =
        ayahsJson.map((ayahJson) => TilawatAyah.fromJson(ayahJson)).toList();
    final int pageNumberInSurah =
        pageJson['page_number_in_sura'] as int? ?? (surahPages.length + 1);
    final int firstAyahNumber = ayahs.isNotEmpty ? ayahs.first.ayahNumber : 1;
    final int paraNumber =
        quranInfoService.getParaBySuraAyah(suraNumber, firstAyahNumber);

    surahPages.add(
      QuranPage(
        pageNumberInSurah: pageNumberInSurah,
        paraNumber: paraNumber,
        content: [
          PageContent(
            suraNumber: suraNumber,
            suraNameBengali: suraNameBengali,
            suraNameArabic: suraNameArabic,
            ayahs: ayahs,
          ),
        ],
      ),
    );
  }

  return surahPages;
});
