import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pdfx/pdfx.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/helpers/contextual_translation.dart';
import 'package:native_app/theme/colors.dart';

class QuranDrawer extends ConsumerWidget {
  const QuranDrawer({
    super.key,
    required this.pdfController,
  });

  final PdfController pdfController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var query = AllModelsQuery(
      repository: ref.surahs,
      params: const {'quantity': 114},
    );

    var modelQuery = ref.watch(allModelsProvider(query));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: modelQuery.when(
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (error, _) => Text(error.toString()),
        data: (resources) {
          return StatefulSurahs(
            surahs: resources,
            pdfController: pdfController,
          );
        },
      ),
    );
  }
}

class StatefulSurahs extends StatefulWidget {
  const StatefulSurahs({
    super.key,
    required this.surahs,
    required this.pdfController,
  });

  final List surahs;
  final PdfController pdfController;

  @override
  State<StatefulSurahs> createState() => _SurahsState();
}

class _SurahsState extends State<StatefulSurahs> {
  dynamic selectedSurah;

  @override
  void initState() {
    super.initState();

    selectedSurah = widget.surahs.first;
  }

  updateSelectedSurah(surah) {
    setState(() {
      selectedSurah = surah;
    });
  }

  @override
  Widget build(BuildContext context) {
    String currentLang = Localizations.localeOf(context).languageCode;
    var numFormatter = NumberFormat('#', currentLang);
    var textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ListView.builder(
            itemCount: widget.surahs.length,
            itemBuilder: (BuildContext context, int index) {
              var item = widget.surahs[index];

              String surahTitle = contextualTranslation(
                locale: currentLang,
                enText: item.title,
                bnText: item.titleBn,
              );

              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color:
                      selectedSurah.id == item.id ? ThemeColors.color7 : null,
                ),
                child: GestureDetector(
                  onTap: () => updateSelectedSurah(item),
                  child: Row(
                    children: [
                      Text(
                        '${numFormatter.format(item.position)}.',
                        style: textTheme.titleMedium,
                      ),
                      const SizedBox(width: 3),
                      Text(surahTitle, style: textTheme.titleMedium),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: ListView.builder(
            itemCount: selectedSurah.totalAyat,
            itemBuilder: (BuildContext context, int index) {
              var number = index + 1;

              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ThemeColors.color7,
                    width: 0.5,
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: GestureDetector(
                  onTap: () {
                    widget.pdfController.jumpToPage(number);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    numFormatter.format(number),
                    style: textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
