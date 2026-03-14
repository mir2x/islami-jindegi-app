import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:idkit_inputformatters/idkit_inputformatters.dart';
import 'package:native_app/theme/app_theme_color.dart';
import 'package:native_app/widgets/inputs/input_field.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';

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
        var appTheme = Theme.of(context).extension<AppThemeColors>()!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 130,
                  margin: const EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    color: appTheme.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: appTheme.divider),
                  ),
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
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: appTheme.divider,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: appTheme.highlightBorder,
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
                                  color: appTheme.secondaryText,
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
