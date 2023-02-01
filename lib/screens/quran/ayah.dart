import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:native_app/providers/quran_settings.dart';
import 'package:native_app/widgets/audio/qirat.dart';
import 'package:native_app/theme/colors.dart';
import 'tafseer.dart';

class Ayah extends ConsumerWidget {
  const Ayah({
    super.key,
    required this.ayah,
    required this.chapter,
  });

  final dynamic ayah;
  final dynamic chapter;

  final Map langMap = const {
    'bn-bd': 'Bangla',
    'en-gb': 'English',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTheme = Theme.of(context).textTheme;
    var qSettings = ref.watch(quranSettingsProvider);

    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        double screenWidth = MediaQuery.of(context).size.width;
                        double screenHeight =
                            MediaQuery.of(context).size.height;

                        return Dialog(
                          backgroundColor: ThemeColors.color1,
                          child: Container(
                            width: screenWidth,
                            height: screenHeight * 0.8,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                            child: Tafseer(ayah: ayah),
                          ),
                        );
                      },
                    );
                  },
                  child: Text(
                    ayah.title,
                    textAlign: TextAlign.right,
                    style: textTheme.headlineMedium?.copyWith(
                      fontFamily: 'arabic/al-qalam',
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 15),
                child: Column(
                  children: [
                    SizedBox(
                      width: 50,
                      height: 42,
                      child: Stack(
                        children: [
                          SvgPicture.asset(
                            'assets/images/icons/ayah-symbol.svg',
                            fit: BoxFit.scaleDown,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              ayah.surahPosition.toString(),
                              style: textTheme.titleMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (qSettings.containsKey('qari') &&
                        chapter.runtimeType.toString() == 'Surah') ...[
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Qirat(
                          surah: chapter,
                          ayah: ayah,
                          qari: qSettings['qari'],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (qSettings.containsKey('language') &&
              ayah.ayahTranslations
                  .map((a) => a.title)
                  .any((t) => t == langMap[qSettings['language']])) ...[
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Text(
                ayah.ayahTranslations
                    .map((a) => a)
                    .firstWhere(
                      (t) => t.title == langMap[qSettings['language']],
                    )
                    .body,
              ),
            )
          ],
        ],
      ),
    );
  }
}
