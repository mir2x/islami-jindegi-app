import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:native_app/providers/quran_settings.dart';
import 'package:native_app/providers/ayah_translation.dart';
import 'package:native_app/widgets/utils/html_text.dart';
import 'package:native_app/widgets/presentation/popup_dialog.dart';
import 'package:native_app/theme/app_theme.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';

class QuranBookAyah extends ConsumerWidget {
  const QuranBookAyah({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String currentLang = Localizations.localeOf(context).languageCode;
    var locales = AppLocalizations.of(context)!;
    var numFormatter = NumberFormat('#', currentLang);
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallMobile = screenWidth < 340;
    var textTheme = Theme.of(context).textTheme;
    var qSettings = ref.watch(quranSettingsProvider);
    int currentAyah = qSettings['currentAyah'] ?? 1;

    return WithPreferences(
      builder: (context, preferences) {
        String theme = preferences.getString('theme') ?? 'classic';

        return Row(
          children: [
            Text(
              numFormatter.format(currentAyah),
              style: textTheme.titleMedium?.copyWith(
                color: AppTheme.titleContrastColor[theme],
              ),
            ),
            const SizedBox(width: 5),
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: EdgeInsets.all(isSmallMobile ? 0 : 5),
              ),
              child: Text(
                locales.translation,
                style: textTheme.titleMedium?.copyWith(
                  color: AppTheme.titleContrastColor[theme],
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return PopupDialog(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              child: const SingleChildScrollView(
                                child: AyahTranslation(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class AyahTranslation extends ConsumerWidget {
  const AyahTranslation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String currentLang = Localizations.localeOf(context).languageCode;
    var locales = AppLocalizations.of(context)!;
    var numFormatter = NumberFormat('#', currentLang);
    var textTheme = Theme.of(context).textTheme;

    var qSettings = ref.watch(quranSettingsProvider);
    var ayahTranslation = ref.watch(ayahTranslationProvider);

    return ayahTranslation.when(
      loading: () => Container(
        margin: const EdgeInsets.only(top: 30),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, _) => Text(locales.noAyahTranslation),
      data: (var translation) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Text(
                    qSettings['surahTitle'],
                    style: textTheme.headlineMedium,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    ', ${locales.ayah}: ${numFormatter.format(qSettings['currentAyah'])}',
                  ),
                ],
              ),
            ),
            if (translation.ayah.value != null) ...[
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                child: SelectableText(
                  translation.ayah.value.title.trim(),
                  textDirection: TextDirection.rtl,
                  style: textTheme.headlineMedium?.copyWith(
                    fontSize: 24,
                    height: 1.5,
                  ),
                ),
              ),
            ],
            HtmlText(text: translation.body),
          ],
        );
      },
    );
  }
}
