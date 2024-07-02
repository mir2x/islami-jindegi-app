import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/theme/app_theme.dart';
import 'package:native_app/theme/colors.dart';
import 'surahs.dart';
import 'paras.dart';

class QuranDrawer extends ConsumerStatefulWidget {
  const QuranDrawer({
    super.key,
    required this.book,
    required this.pdfController,
  });

  final dynamic book;
  final PdfViewerController pdfController;

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

    return WithPreferences(
      builder: (context, preferences) {
        String theme = preferences.getString('theme') ?? 'classic';

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
                              ? AppTheme.activeItemColor[theme]
                              : null,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        child: Text(
                          locales.surah,
                          style: textTheme.labelMedium?.copyWith(
                            color: AppTheme.labelContrastColor[theme],
                          ),
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
                              ? AppTheme.activeItemColor[theme]
                              : null,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        child: Text(
                          locales.para,
                          style: textTheme.labelMedium?.copyWith(
                            color: AppTheme.labelContrastColor[theme],
                          ),
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
                        style: textTheme.labelMedium?.copyWith(
                          color: AppTheme.labelContrastColor[theme],
                        ),
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
                  closeDrawer: () => Scaffold.of(context).closeDrawer(),
                ),
              ] else ...[
                QuranBookParas(
                  book: widget.book,
                  pdfController: widget.pdfController,
                  closeDrawer: () => Scaffold.of(context).closeDrawer(),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
