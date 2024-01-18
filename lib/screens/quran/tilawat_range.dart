import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:idkit_inputformatters/idkit_inputformatters.dart';
import 'package:native_app/providers/quran_settings.dart';
import 'package:native_app/widgets/inputs/input_field.dart';
import 'package:native_app/theme/colors.dart';

class TilwatRange extends ConsumerStatefulWidget {
  const TilwatRange({
    super.key,
    required this.chapter,
    required this.fromAyah,
    required this.toAyah,
  });

  final dynamic chapter;
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
                minValue: 1,
                maxValue: widget.chapter.totalAyat - 1,
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
                minValue: 1,
                maxValue: widget.chapter.totalAyat,
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
          constraints: const BoxConstraints(maxHeight: 26),
          child: TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
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

              Navigator.of(context).pop();
            },
            child: (fromValue != widget.fromAyah || toValue != widget.toAyah)
                ? Text(locales.save, style: textTheme.titleSmall)
                : const Icon(
                    Icons.done,
                    color: ThemeColors.color2,
                  ),
          ),
        ),
      ],
    );
  }
}
