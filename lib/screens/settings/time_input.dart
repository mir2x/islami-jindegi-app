import 'package:flutter/material.dart';
import 'package:idkit_inputformatters/idkit_inputformatters.dart';
import 'package:native_app/widgets/inputs/input_field.dart';
import 'package:native_app/theme/colors.dart';

class TimeInput extends StatelessWidget {
  const TimeInput({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  final String initialValue;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
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
                onChanged: onChanged,
              ),
            ),
            const Text('minute(s)'),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: Text(
            'min: -60, max: 60',
            style: textTheme.labelSmall?.copyWith(
              color: ThemeColors.placeholder,
            ),
          ),
        )
      ],
    );
  }
}
