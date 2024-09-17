import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/main.data.dart';
import 'quran_settings.dart';

final ayahTranslationProvider = FutureProvider.autoDispose((ref) async {
  await ref.watch(repositoryInitializerProvider.future);

  var qSettings = ref.watch(quranSettingsProvider);

  bool hasCurrentAyah =
      qSettings.containsKey('currentAyah') && qSettings['currentAyah'] != null;
  bool hasSurahId =
      qSettings.containsKey('surahId') && qSettings['surahId'] != null;

  List resources;

  if (hasCurrentAyah && hasSurahId) {
    try {
      resources = await ref.ayahTranslations.findAll(
        params: {
          'ayahNo': qSettings['currentAyah'],
          'surahId': qSettings['surahId'],
          'quantity': 1,
          'include': 'ayah',
        },
      );
    } catch (error) {
      resources = [];
    }
  } else {
    resources = [];
  }

  if (resources.isEmpty) {
    throw Exception('Record not found');
  }

  return resources.first;
});
