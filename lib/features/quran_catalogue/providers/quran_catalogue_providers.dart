import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quran_edition.dart';

Future<List<QuranEdition>> getQuranEditionData() async {
  final editions = [
    {
      'id': 'imdadia_hafezi',
      'title': 'হাফিজি কুরআন\n(এমদাদিয়া লাইব্রেরী)',
      'cover': 'assets/image/front_page/imdadia_hafezi.png',
      'url':
          'https://t3.storage.dev/static.islamijindegi.com/assets/al-quran/mushafs/imdadia_hafezi.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=tid_SVQEqpmkAvfcFleZgB_gQqyIZinQViMhmrBLpwlCLzNcowEneM%2F20260127%2Fauto%2Fs3%2Faws4_request&X-Amz-Date=20260127T201044Z&X-Amz-Expires=7776000&X-Amz-SignedHeaders=host&X-Amz-Signature=827252ff9cb06e450303c259cb39086a2644fbda074d90628e2e18d79125c273',
      'sizeBytes': 78614813,
      'width': 1152,
      'height': 2048,
      'ext': 'jpg',
    },
    {
      'id': 'hafezi',
      'title': 'হাফিজি কুরআন',
      'cover': 'assets/image/front_page/hafezi.png',
      'url':
          'https://t3.storage.dev/static.islamijindegi.com/assets/al-quran/mushafs/hafezi.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=tid_SVQEqpmkAvfcFleZgB_gQqyIZinQViMhmrBLpwlCLzNcowEneM%2F20260127%2Fauto%2Fs3%2Faws4_request&X-Amz-Date=20260127T201017Z&X-Amz-Expires=7776000&X-Amz-SignedHeaders=host&X-Amz-Signature=31dad6779c2741c04b39be81820287bee42ac13e51b822246dbf4fdc803db14b',
      'sizeBytes': 120611119,
      'width': 1152,
      'height': 2048,
      'ext': 'png',
    },
    {
      'id': 'colorful_tajweed',
      'title': 'রঙিন\nতাজবীদ কুরআন',
      'cover': 'assets/image/front_page/colorful_tajweed.png',
      'url':
          'https://t3.storage.dev/static.islamijindegi.com/assets/al-quran/mushafs/colorful_tajweed.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=tid_SVQEqpmkAvfcFleZgB_gQqyIZinQViMhmrBLpwlCLzNcowEneM%2F20260127%2Fauto%2Fs3%2Faws4_request&X-Amz-Date=20260127T200848Z&X-Amz-Expires=7776000&X-Amz-SignedHeaders=host&X-Amz-Signature=04763d38f21f05fdd1196dccec863b2c0d686d04a525e606a750b5606346b60a',
      'sizeBytes': 78145231,
      'width': 720,
      'height': 1057,
      'ext': 'png',
    },
    {
      'id': 'madani',
      'title': 'মাদানী কুরআন\n(উসমানী প্রিন্ট)',
      'cover': 'assets/image/front_page/madani.png',
      'url':
          'https://t3.storage.dev/static.islamijindegi.com/assets/al-quran/mushafs/madani.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=tid_SVQEqpmkAvfcFleZgB_gQqyIZinQViMhmrBLpwlCLzNcowEneM%2F20260127%2Fauto%2Fs3%2Faws4_request&X-Amz-Date=20260127T201134Z&X-Amz-Expires=7776000&X-Amz-SignedHeaders=host&X-Amz-Signature=de4a1d8e013e34453247243333b3f549730675840ddf4c840e0427c184a08673',
      'sizeBytes': 125700626,
      'width': 1352,
      'height': 2170,
      'ext': 'png',
    },
    {
      'id': 'nurani',
      'title': 'নূরানী কুরআন\n(এমদাদিয়া লাইব্রেরী)',
      'cover': 'assets/image/front_page/nurani.png',
      'url':
          'https://t3.storage.dev/static.islamijindegi.com/assets/al-quran/mushafs/nurani.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=tid_SVQEqpmkAvfcFleZgB_gQqyIZinQViMhmrBLpwlCLzNcowEneM%2F20260127%2Fauto%2Fs3%2Faws4_request&X-Amz-Date=20260127T201158Z&X-Amz-Expires=7776000&X-Amz-SignedHeaders=host&X-Amz-Signature=48c6fd0b566acc2f144414e5d0766d1cae1430508d44ac78d4cac2d293a93062',
      'sizeBytes': 106934272,
      'width': 670,
      'height': 996,
      'ext': 'png',
    },
    {
      'id': 'colorful_hafezi',
      'title': 'রঙিন হাফিজি',
      'cover': 'assets/image/front_page/colorful_hafezi.png',
      'url':
          'https://t3.storage.dev/static.islamijindegi.com/assets/al-quran/mushafs/colorful_hafezi.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=tid_SVQEqpmkAvfcFleZgB_gQqyIZinQViMhmrBLpwlCLzNcowEneM%2F20260127%2Fauto%2Fs3%2Faws4_request&X-Amz-Date=20260127T200717Z&X-Amz-Expires=7776000&X-Amz-SignedHeaders=host&X-Amz-Signature=d8d9d4107696d09a24645e5b3cf57c72f4f0c7e9a7c90699f0b531274a9ac20f',
      'sizeBytes': 162361420,
      'width': 560,
      'height': 829,
      'ext': 'jpg',
    },
  ];

  return Future.wait(editions.map(QuranEdition.fromMap));
}

class QuranEditionNotifier extends StateNotifier<List<QuranEdition>> {
  QuranEditionNotifier() : super([]) {
    refreshDownloadStatus();
  }

  Future<void> refreshDownloadStatus() async {
    final data = await getQuranEditionData();
    state = data;
  }
}

final quranEditionProvider =
    StateNotifierProvider<QuranEditionNotifier, List<QuranEdition>>((ref) {
  return QuranEditionNotifier();
});
