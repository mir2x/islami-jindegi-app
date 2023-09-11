import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/objects/font_size_ratio.dart';
import 'package:native_app/providers/quran_settings.dart';

class Bismillah extends ConsumerWidget {
  const Bismillah({
    super.key,
    required this.chapter,
    required this.preferences,
    required this.arabicFontSizeRatio,
    required this.banglaFontSizeRatio,
  });

  final dynamic chapter;
  final dynamic preferences;
  final FontSizeRatio arabicFontSizeRatio;
  final FontSizeRatio banglaFontSizeRatio;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var qSettings = ref.watch(quranSettingsProvider);
    String chapterType = chapter.runtimeType.toString();

    if (chapter.position != 9 || chapterType != 'Surah') {
      return Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: 15,
              bottom: 10,
              left: 15,
              right: chapterType == 'Para' ? 15 : 0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: ValueListenableBuilder<double>(
                    valueListenable: arabicFontSizeRatio,
                    builder: (context, ratio, child) {
                      return Text(
                        'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِیْمِ',
                        textDirection: TextDirection.rtl,
                        style: textTheme.labelLarge?.copyWith(
                          fontSize: 22 * ratio,
                        ),
                      );
                    },
                  ),
                ),
                if (chapterType != 'Para') ...[
                  PopupMenuButton<int>(
                    child: const SizedBox(
                      height: 40,
                      width: 35,
                      child: Icon(Icons.more_vert),
                    ),
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<int>>[
                      PopupMenuItem<int>(
                        value: 0,
                        child: Text(locales.surahIntroduction),
                      ),
                    ],
                    onSelected: (int item) async {
                      switch (item) {
                        case 0:
                          await QR
                              .to('quran/surah/${chapter.slug}/description');
                      }
                    },
                  ),
                ],
              ],
            ),
          ),
          if (qSettings.containsKey('translation') &&
              qSettings['translation']) ...[
            Container(
              padding: const EdgeInsets.only(bottom: 5, left: 15, right: 15),
              child: ValueListenableBuilder<double>(
                valueListenable: banglaFontSizeRatio,
                builder: (context, ratio, child) {
                  return Text(
                    locales.bismillah,
                    style: textTheme.labelMedium?.copyWith(
                      fontSize: 17 * ratio,
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
