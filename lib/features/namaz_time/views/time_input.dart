import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:idkit_inputformatters/idkit_inputformatters.dart';
import 'package:native_app/widgets/inputs/input_field.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/theme/app_theme.dart';
import 'package:native_app/theme/colors.dart';

class TimeInput extends ConsumerStatefulWidget {
  const TimeInput({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  final String initialValue;
  final void Function(String?) onChanged;

  @override
  ConsumerState<TimeInput> createState() => _TimeInputState();
}

class _TimeInputState extends ConsumerState<TimeInput> {
  String? inputText;

  updateInputText(value) {
    setState(() {
      inputText = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    return WithPreferences(
      builder: (context, preferences) {
        String theme = preferences.getString('theme') ?? 'classic';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 130,
                  margin: const EdgeInsets.only(right: 15),
                  child: InputField(
                    initialValue: widget.initialValue,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      IDKitNumeralTextInputFormatter.range(
                        minValue: -60,
                        maxValue: 60,
                        decimalPoint: false,
                      ),
                    ],
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: ThemeColors.border,
                        ),
                      ),
                      constraints: const BoxConstraints(maxHeight: 45),
                      suffix: TextButton(
                        child: (inputText != null &&
                                inputText != widget.initialValue)
                            ? Text(
                                locales.save,
                                style: textTheme.labelSmall,
                              )
                            : Container(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Icon(
                                  Icons.done,
                                  color: AppTheme.iconColor[theme],
                                  size: 15,
                                ),
                              ),
                        onPressed: () {
                          widget.onChanged(inputText);
                          inputText = null;
                        },
                      ),
                    ),
                    onChanged: updateInputText,
                  ),
                ),
                Text(locales.minutes),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Text(
                locales.minutesHint,
                style: textTheme.labelSmall,
              ),
            ),
          ],
        );
      },
    );
  }
}
