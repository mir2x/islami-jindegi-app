import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:idkit_inputformatters/idkit_inputformatters.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:native_app/widgets/inputs/input_field.dart';
import 'package:native_app/theme/colors.dart';

class TimeInput extends StatelessWidget {
  const TimeInput({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  final String initialValue;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 100,
              margin: const EdgeInsets.only(right: 15),
              child: InputField(
                initialValue: initialValue,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  IDKitNumeralTextInputFormatter.range(
                    minValue: -60,
                    maxValue: 60,
                    decimalPoint: false,
                  )
                ],
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: ThemeColors.border,
                    ),
                  ),
                  constraints: BoxConstraints(maxHeight: 45),
                ),
                onChanged: (value) {
                  EasyDebounce.debounce(
                    'search-debouncer',
                    const Duration(milliseconds: 2000),
                    () => onChanged(value),
                  );
                },
              ),
            ),
            Text(locales.minutes),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: Text(
            locales.minutesHint,
            style: textTheme.labelSmall?.copyWith(
              color: ThemeColors.placeholder,
            ),
          ),
        )
      ],
    );
  }
}
