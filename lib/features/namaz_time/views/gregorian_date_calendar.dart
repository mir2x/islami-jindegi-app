import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:date_picker_plus/date_picker_plus.dart';

class GregorianDateCalendar extends ConsumerWidget {
  const GregorianDateCalendar({
    super.key,
    required this.child,
    required this.onUpdate,
    this.currentDate,
  });

  final Widget child;
  final Function onUpdate;
  final DateTime? currentDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Container(
                padding: const EdgeInsets.all(10),
                width: 300,
                height: 300,
                child: DatePicker(
                  selectedDate: currentDate,
                  minDate: DateTime(633, 1, 1),
                  maxDate: DateTime(2100, 1, 1),
                  onDateSelected: (DateTime value) {
                    onUpdate(value);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            );
          },
        );
      },
      child: child,
    );
  }
}
