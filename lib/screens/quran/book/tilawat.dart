import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pdfx/pdfx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:idkit_inputformatters/idkit_inputformatters.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/helpers/contextual_translation.dart';
import 'package:native_app/providers/quran_settings.dart';
import 'package:native_app/widgets/inputs/input_field.dart';
import 'package:native_app/theme/colors.dart';
import 'player.dart';

class QuranBookTilawat extends ConsumerWidget {
  const QuranBookTilawat({
    super.key,
    required this.bookId,
    required this.pdfController,
  });

  final String bookId;
  final PdfController pdfController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    var qSettings = ref.watch(quranSettingsProvider);

    if (qSettings.containsKey('qari')) {
      return Row(
        children: [
          TextButton(
            child: SvgPicture.asset(
              'assets/images/icons/play.svg',
              width: 30,
              height: 30,
            ),
            onPressed: () async {
              var query = AllModelsQuery(
                repository: ref.quranBookSurahs,
                params: {
                  'bookId': bookId,
                  'page': pdfController.page,
                  'include': 'surah',
                  'offline': true,
                },
              );

              var resources = await ref.read(allModelsProvider(query).future);

              if (resources.length > 1) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: Container(
                        width: screenWidth,
                        height: screenHeight * 0.4,
                        padding: const EdgeInsets.only(
                          top: 15,
                          bottom: 25,
                          left: 15,
                          right: 15,
                        ),
                        child: QuranBookTilawatRanges(
                          resources: resources,
                        ),
                      ),
                    );
                  },
                );
              } else {}
            },
          ),
          if (qSettings.containsKey('qari') &&
              qSettings.containsKey('selectedSurah') &&
              qSettings.containsKey('fromAyah') &&
              qSettings.containsKey('toAyah')) ...[
            QuranBookPlayer(
              qari: qSettings['qari'],
              surah: qSettings['selectedSurah'],
              fromAyah: qSettings['fromAyah'],
              toAyah: qSettings['toAyah'],
            ),
          ],
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class QuranBookTilawatRanges extends ConsumerWidget {
  const QuranBookTilawatRanges({
    super.key,
    required this.resources,
  });

  final List resources;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String currentLang = Localizations.localeOf(context).languageCode;

    return ListView.builder(
      itemCount: resources.length,
      itemBuilder: (BuildContext context, int index) {
        var bookSurah = resources[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contextualTranslation(
                  locale: currentLang,
                  enText: bookSurah.surah.value.title,
                  bnText: bookSurah.surah.value.titleBn,
                ),
              ),
              TilwatRange(
                surah: bookSurah.surah.value,
                fromAyah: bookSurah.startAyah,
                toAyah: bookSurah.endAyah,
              ),
            ],
          ),
        );
      },
    );
  }
}

class TilwatRange extends ConsumerStatefulWidget {
  const TilwatRange({
    super.key,
    required this.surah,
    required this.fromAyah,
    required this.toAyah,
  });

  final dynamic surah;
  final int fromAyah;
  final int toAyah;

  @override
  ConsumerState<TilwatRange> createState() => _TilawatRangeState();
}

class _TilawatRangeState extends ConsumerState<TilwatRange> {
  int? fromValue;
  int? toValue;

  updateFrom(value) {
    if (value != null && int.tryParse(value) != null) {
      setState(() {
        fromValue = int.parse(value);
      });
    }
  }

  updateTo(value) {
    if (value != null && int.tryParse(value) != null) {
      setState(() {
        toValue = int.parse(value);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    fromValue = widget.fromAyah;
    toValue = widget.toAyah;
  }

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('${locales.from}:', style: textTheme.labelMedium),
        Container(
          width: 40,
          margin: const EdgeInsets.only(left: 3),
          child: InputField(
            initialValue: fromValue.toString(),
            keyboardType: TextInputType.number,
            inputFormatters: [
              IDKitNumeralTextInputFormatter.range(
                minValue: widget.fromAyah,
                maxValue: widget.toAyah,
                decimalPoint: false,
              ),
            ],
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 4),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: ThemeColors.border,
                ),
              ),
            ),
            onChanged: updateFrom,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 15),
          child: Text('${locales.to}:', style: textTheme.labelMedium),
        ),
        Container(
          width: 40,
          margin: const EdgeInsets.only(left: 3),
          child: InputField(
            initialValue: toValue.toString(),
            keyboardType: TextInputType.number,
            inputFormatters: [
              IDKitNumeralTextInputFormatter.range(
                minValue: widget.fromAyah,
                maxValue: widget.toAyah,
                decimalPoint: false,
              ),
            ],
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 4),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: ThemeColors.border,
                ),
              ),
            ),
            onChanged: updateTo,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 20),
          constraints: const BoxConstraints(maxHeight: 28),
          child: TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              backgroundColor: ThemeColors.color4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              ref.read(quranSettingsProvider.notifier).updateParams(
                    'fromAyah',
                    fromValue,
                  );

              ref.read(quranSettingsProvider.notifier).updateParams(
                    'toAyah',
                    toValue,
                  );

              ref.read(quranSettingsProvider.notifier).updateParams(
                    'selectedSurah',
                    widget.surah.position,
                  );

              Navigator.of(context).pop();
            },
            child: Text(locales.select, style: textTheme.titleSmall),
          ),
        ),
      ],
    );
  }
}
