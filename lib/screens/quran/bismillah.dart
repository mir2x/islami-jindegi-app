import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/widgets/buttons/previous.dart';
import 'package:native_app/widgets/buttons/next.dart';
import 'package:native_app/theme/app_theme.dart';

class Bismillah extends ConsumerWidget {
  const Bismillah({
    super.key,
    required this.chapter,
    required this.preferences,
    required this.previousPage,
    required this.nextPage,
  });

  final dynamic chapter;
  final dynamic preferences;
  final Future? Function() previousPage;
  final Future? Function() nextPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    String chapterType = chapter.runtimeType.toString();
    String theme = preferences.getString('theme') ?? 'dark';

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.headerColor[theme],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Previous(onPrevious: previousPage, contrastColor: false),
          ),
          if (chapter.position != 9 || chapterType != 'Surah') ...[
            Expanded(
              child: InkWell(
                onTap: () => QR.to('quran/bismillah-tafseer'),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        top: 0,
                        bottom: 10,
                        left: 15,
                        right: chapterType == 'Para' ? 15 : 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِیْمِ',
                            textDirection: TextDirection.rtl,
                            style: textTheme.labelLarge?.copyWith(
                              fontSize: 25,
                              height: 1.6,
                            ),
                          ),
                          if (chapterType != 'Para') ...[
                            PopupMenuButton<int>(
                              child: Container(
                                padding: const EdgeInsets.only(top: 5),
                                child: const SizedBox(
                                  height: 40,
                                  width: 35,
                                  child: Icon(Icons.more_vert),
                                ),
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
                                    await QR.to(
                                      'quran/surah/${chapter.slug}/description',
                                    );
                                }
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            const SizedBox.shrink(),
          ],
          Container(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Next(onNext: nextPage, contrastColor: false),
          ),
        ],
      ),
    );
  }
}
