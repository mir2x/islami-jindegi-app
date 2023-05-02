import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pdfx/pdfx.dart';
import 'package:native_app/providers/preferences.dart';
import 'package:native_app/theme/colors.dart';
import 'surahs.dart';
import 'paras.dart';

class QuranDrawer extends ConsumerStatefulWidget {
  const QuranDrawer({
    super.key,
    required this.book,
    required this.pdfController,
    required this.closeDrawer,
  });

  final dynamic book;
  final PdfController pdfController;
  final Function closeDrawer;

  @override
  ConsumerState<QuranDrawer> createState() => _QuranDrawerState();
}

class _QuranDrawerState extends ConsumerState<QuranDrawer> {
  dynamic selectedSection;

  @override
  void initState() {
    super.initState();

    selectedSection = 'Surah';
  }

  updateSelectedSection(section) {
    setState(() {
      selectedSection = section;
    });
  }

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;

    var prefs = ref.watch(preferencesProvider);

    return prefs.when(
      loading: () => const SizedBox.shrink(),
      error: (error, _) => Text(error.toString()),
      data: (preferences) {
        String theme = preferences.getString('theme') ?? 'dark';

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () => updateSelectedSection('Surah'),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: ThemeColors.color7,
                            width: 0.5,
                          ),
                          color: selectedSection == 'Surah'
                              ? theme == 'dark'
                                  ? ThemeColors.color1
                                  : ThemeColors.color9
                              : null,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        child: Text(
                          locales.surah,
                          style: textTheme.labelMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () => updateSelectedSection('Para'),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: ThemeColors.color7,
                            width: 0.5,
                          ),
                          color: selectedSection == 'Para'
                              ? theme == 'dark'
                                  ? ThemeColors.color1
                                  : ThemeColors.color9
                              : null,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        child: Text(
                          locales.para,
                          style: textTheme.labelMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ThemeColors.color7,
                          width: 0.5,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: Text(
                        selectedSection == 'Surah'
                            ? locales.ayah
                            : locales.page,
                        style: textTheme.labelMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              if (selectedSection == 'Surah') ...[
                QuranBookSurahs(
                  book: widget.book,
                  pdfController: widget.pdfController,
                  closeDrawer: widget.closeDrawer,
                ),
              ] else ...[
                QuranBookParas(
                  book: widget.book,
                  pdfController: widget.pdfController,
                  closeDrawer: widget.closeDrawer,
                ),
              ]
            ],
          ),
        );
      },
    );
  }
}
