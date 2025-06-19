import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:native_app/providers/quran_settings.dart';
import 'package:native_app/providers/ayah_translation.dart';
import 'package:native_app/widgets/utils/html_text.dart';
import 'package:native_app/widgets/presentation/popup_dialog.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/theme/app_theme.dart';
import '../ayah_actions.dart';

class QuranBookAyah extends ConsumerWidget {
  const QuranBookAyah({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String currentLang = Localizations.localeOf(context).languageCode;
    var locales = AppLocalizations.of(context)!;
    var numFormatter = NumberFormat('#', currentLang);
    var textTheme = Theme.of(context).textTheme;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallMobile = screenWidth < 340;
    var qSettings = ref.watch(quranSettingsProvider);
    int? currentAyah =
        qSettings.containsKey('currentAyah') ? qSettings['currentAyah'] : null;

    return WithPreferences(
      builder: (context, preferences) {
        String theme = preferences.getString('theme') ?? 'classic';

        if (currentAyah != null) {
          int ayah = currentAyah == 0 ? 1 : currentAyah;

          return Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: isSmallMobile ? 0 : 3),
                child: Text(
                  numFormatter.format(ayah),
                  style: textTheme.titleMedium?.copyWith(
                    color: AppTheme.titleContrastColor[theme],
                  ),
                ),
              ),
              Previous(
                onPrevious: () {
                  if (qSettings.containsKey('qitabFromAyah') &&
                      ayah > qSettings['qitabFromAyah']) {
                    var notifier = ref.read(quranSettingsProvider.notifier);
                    notifier.updateParams(
                      'currentAyah',
                      ayah - 1,
                    );
                  }

                  return;
                },
              ),
              Next(
                onNext: () {
                  if (qSettings.containsKey('qitabToAyah') &&
                      ayah < qSettings['qitabToAyah']) {
                    var notifier = ref.read(quranSettingsProvider.notifier);
                    notifier.updateParams(
                      'currentAyah',
                      ayah + 1,
                    );
                  }

                  return;
                },
              ),
              SizedBox(width: isSmallMobile ? 0 : 3),
              TextButton(
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 0,
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  locales.ayah,
                  style: textTheme.titleMedium?.copyWith(
                    color: AppTheme.titleContrastColor[theme],
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PopupDialog(
                        direction: 'rtl',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                child: const SingleChildScrollView(
                                  child: AyahDetails(),
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
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class AyahDetails extends ConsumerWidget {
  const AyahDetails({super.key});

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
        int ayah = qSettings['currentAyah'] == 0 ? 1 : qSettings['currentAyah'];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AyahActions(ayah: translation.ayah.value),
                  Row(
                    children: [
                      Text(
                        qSettings['surahTitle'],
                        style: textTheme.labelMedium,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        ', ${locales.ayah}: ${numFormatter.format(ayah)}',
                        style: textTheme.labelMedium,
                      ),
                    ],
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

class Previous extends StatelessWidget {
  const Previous({
    super.key,
    required this.onPrevious,
    this.previousDisabled = false,
    this.contrastColor = true,
  });

  final Future? Function() onPrevious;
  final bool previousDisabled;
  final bool contrastColor;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallMobile = screenWidth < 340;

    return WithPreferences(
      builder: (context, preferences) {
        String theme = preferences.getString('theme') ?? 'classic';

        Color? iconColor = previousDisabled
            ? Colors.grey
            : contrastColor
                ? AppTheme.titleContrastColor[theme]
                : null;

        return IconButton(
          icon: const Icon(Icons.keyboard_arrow_left),
          color: iconColor,
          splashRadius: isSmallMobile ? 20 : 22,
          padding: const EdgeInsets.symmetric(vertical: 10),
          constraints: BoxConstraints(
            maxWidth: isSmallMobile ? 20 : 22,
          ),
          onPressed: onPrevious,
        );
      },
    );
  }
}

class Next extends StatelessWidget {
  const Next({
    super.key,
    required this.onNext,
    this.nextDisabled = false,
    this.contrastColor = true,
  });

  final Future? Function() onNext;
  final bool nextDisabled;
  final bool contrastColor;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallMobile = screenWidth < 340;

    return WithPreferences(
      builder: (context, preferences) {
        String theme = preferences.getString('theme') ?? 'classic';

        Color? iconColor = nextDisabled
            ? Colors.grey
            : contrastColor
                ? AppTheme.titleContrastColor[theme]
                : null;

        return IconButton(
          icon: const Icon(Icons.keyboard_arrow_right),
          color: iconColor,
          splashRadius: isSmallMobile ? 20 : 22,
          padding: const EdgeInsets.symmetric(vertical: 10),
          constraints: BoxConstraints(
            maxWidth: isSmallMobile ? 20 : 22,
          ),
          onPressed: onNext,
        );
      },
    );
  }
}
