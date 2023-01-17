import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:date_field/date_field.dart';
import 'package:intl/intl.dart';
import 'package:native_app/providers/query_params.dart';
import 'package:native_app/theme/colors.dart';

class DateFilter extends ConsumerWidget {
  DateFilter({super.key});

  final List<Map> options = [
    {'value': '', 'label': 'Any Time'},
    {'value': 'now-1w', 'label': 'Past Week'},
    {'value': 'now-1m', 'label': 'Past Month'},
    {'value': 'now-1y', 'label': 'Past Year'},
    {'value': 'now-5y', 'label': 'Past 5 Years'},
    {'value': 'now-10y', 'label': 'Past 10 Years'}
  ];

  String formatDate(String date) {
    var inputDate = DateFormat('yyyy-MM-dd').parse(date);
    return DateFormat('dd/MM/yyyy').format(inputDate);
  }

  String selectedDate(Map qParams, List options) {
    if (qParams.containsKey('dateFrom')) {
      String from = formatDate(qParams['dateFrom']);

      if (qParams.containsKey('dateTo')) {
        String to = formatDate(qParams['dateTo']);
        return '$from - $to';
      } else {
        return 'After $from';
      }
    } else if (qParams.containsKey('dateTo')) {
      String to = formatDate(qParams['dateTo']);
      return 'Before $to';
    } else if (qParams.containsKey('dateRange')) {
      Map? option = options.firstWhereOrNull(
        (o) => o['value'] == qParams['dateRange'],
      );
      if (option != null) {
        return option['label'];
      }
    }

    return 'Filter by Date';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTheme = Theme.of(context).textTheme;
    var qParams = ref.watch(queryParamsProvider);

    String selectedLabel = selectedDate(qParams, options);

    return OutlinedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            double screenWidth = MediaQuery.of(context).size.width;
            double screenHeight = MediaQuery.of(context).size.height;
            var qParamsNotifier = ref.read(queryParamsProvider.notifier);

            return Dialog(
              backgroundColor: ThemeColors.color1,
              child: Container(
                width: screenWidth,
                height: screenHeight * 0.6,
                padding: const EdgeInsets.only(
                  top: 15,
                  bottom: 25,
                  left: 15,
                  right: 15,
                ),
                child: Column(
                  children: [
                    ...options.map((option) {
                      return InkWell(
                        onTap: () {
                          qParamsNotifier.updateParams(
                            'dateRange',
                            option['value'],
                          );

                          for (var k in ['dateFrom', 'dateTo']) {
                            qParamsNotifier.updateParams(k, '');
                          }

                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            option['label'],
                            style: (qParams.containsKey('dateRange') &&
                                    qParams['dateRange'] == option['value'])
                                ? textTheme.labelMedium
                                : textTheme.titleMedium,
                          ),
                        ),
                      );
                    }),
                    Container(
                      margin: const EdgeInsets.only(top: 30, bottom: 15),
                      child: Text(
                        'Custom Date',
                        style: qParams.containsKey('dateFrom') ||
                                qParams.containsKey('dateTo')
                            ? textTheme.labelMedium
                            : textTheme.titleMedium,
                      ),
                    ),
                    CustomDateField(field: 'dateFrom', label: 'Date From'),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomDateField(field: 'dateTo', label: 'Date To'),
                  ],
                ),
              ),
            );
          },
        );
      },
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: ThemeColors.color3),
        minimumSize: const Size.fromHeight(45),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            selectedLabel,
            style: textTheme.labelMedium,
          ),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }
}

class CustomDateField extends ConsumerWidget {
  CustomDateField({
    super.key,
    required this.field,
    required this.label,
  });

  final String field;
  final String label;
  final _formFieldStateKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTheme = Theme.of(context).textTheme;
    var qParams = ref.watch(queryParamsProvider);
    var qParamsNotifier = ref.read(queryParamsProvider.notifier);

    return DateTimeFormField(
      key: _formFieldStateKey,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: qParams.containsKey(field)
                ? ThemeColors.color3
                : ThemeColors.color4,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: qParams.containsKey(field)
                ? ThemeColors.color3
                : ThemeColors.color4,
          ),
        ),
        suffixIcon: !qParams.containsKey(field)
            ? const Icon(Icons.event_outlined, color: ThemeColors.color4)
            : IconButton(
                icon: const Icon(
                  Icons.clear_outlined,
                  color: ThemeColors.color3,
                ),
                onPressed: () {
                  _formFieldStateKey.currentState!.didChange(null);
                  qParamsNotifier.updateParams(field, '');
                  Navigator.of(context).pop();
                },
              ),
        labelStyle: qParams.containsKey(field)
            ? textTheme.labelMedium
            : textTheme.titleMedium,
        labelText: label,
      ),
      mode: DateTimeFieldPickerMode.date,
      initialValue: qParams.containsKey(field)
          ? DateFormat('yyyy-MM-dd').parse(qParams[field])
          : null,
      onDateSelected: (DateTime value) {
        qParamsNotifier.updateParams(
          field,
          DateFormat('yyyy-MM-dd').format(value),
        );
        qParamsNotifier.updateParams('dateRange', '');
        Navigator.of(context).pop();
      },
    );
  }
}
