import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quran_edition.dart';

Future<List<QuranEdition>> getQuranEditionData() async {
  final editions = [
    {
      'id': 'imdadia_hafezi',
      'title': 'হাফিজি কুরআন\n(এমদাদিয়া লাইব্রেরী)',
      'cover': 'assets/image/front_page/imdadia_hafezi.png',
      'sizeBytes': 78614813,
      'width': 1152,
      'height': 2048,
      'ext': 'jpg',
    },
    {
      'id': 'hafezi',
      'title': 'হাফিজি কুরআন',
      'cover': 'assets/image/front_page/hafezi.png',
      'sizeBytes': 120611119,
      'width': 1152,
      'height': 2048,
      'ext': 'png',
    },
    {
      'id': 'colorful_tajweed',
      'title': 'রঙিন\nতাজবীদ কুরআন',
      'cover': 'assets/image/front_page/colorful_tajweed.png',
      'sizeBytes': 78145231,
      'width': 720,
      'height': 1057,
      'ext': 'png',
    },
    {
      'id': 'madani',
      'title': 'মাদানী কুরআন\n(উসমানী প্রিন্ট)',
      'cover': 'assets/image/front_page/madani.png',
      'sizeBytes': 125700626,
      'width': 1352,
      'height': 2170,
      'ext': 'png',
    },
    {
      'id': 'nurani',
      'title': 'নূরানী কুরআন\n(এমদাদিয়া লাইব্রেরী)',
      'cover': 'assets/image/front_page/nurani.png',
      'sizeBytes': 106934272,
      'width': 670,
      'height': 996,
      'ext': 'png',
    },
    {
      'id': 'colorful_hafezi',
      'title': 'রঙিন হাফিজি',
      'cover': 'assets/image/front_page/colorful_hafezi.png',
      'sizeBytes': 162361420,
      'width': 560,
      'height': 829,
      'ext': 'jpg',
    },
  ];

  return Future.wait(editions.map(QuranEdition.fromMap));
}

class QuranEditionNotifier extends Notifier<List<QuranEdition>> {
  @override
  List<QuranEdition> build() {
    refreshDownloadStatus();
    return [];
  }

  Future<void> refreshDownloadStatus() async {
    final data = await getQuranEditionData();
    state = data;
  }
}

final quranEditionProvider =
    NotifierProvider<QuranEditionNotifier, List<QuranEdition>>(QuranEditionNotifier.new);
