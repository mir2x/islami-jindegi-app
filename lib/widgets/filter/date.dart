import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:date_field/date_field.dart';
import 'package:intl/intl.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/providers/query_params.dart';
import 'package:native_app/theme/colors.dart';

class DateFilter extends ConsumerWidget {
  const DateFilter({super.key});

  String formatDate(String date, String locale) {
    var inputDate = DateFormat('yyyy-MM-dd').parse(date);
    return DateFormat('dd MMMM yyyy', locale).format(inputDate);
  }

  String selectedDate(
    Map qParams,
    List options,
    String locale,
    AppLocalizations locales,
  ) {
    if (qParams.containsKey('dateFrom')) {
      String from = formatDate(qParams['dateFrom'], locale);

      if (qParams.containsKey('dateTo')) {
        String to = formatDate(qParams['dateTo'], locale);
        return '$from - $to';
      } else {
        if (locale == 'bn') {
          return '$from এর পরে';
        } else {
          return 'After $from';
        }
      }
    } else if (qParams.containsKey('dateTo')) {
      String to = formatDate(qParams['dateTo'], locale);
      if (locale == 'bn') {
        return '$to এর আগে';
      } else {
        return 'Before $to';
      }
    } else if (qParams.containsKey('dateRange')) {
      Map? option = options.firstWhereOrNull(
        (o) => o['value'] == qParams['dateRange'],
      );
      if (option != null) {
        return option['label'];
      }
    }

    return locales.date;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    String currentLang = Localizations.localeOf(context).languageCode;
    var textTheme = Theme.of(context).textTheme;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallMobile = screenWidth < 340;
    var qParams = ref.watch(queryParamsProvider);

    final List<Map> options = [
      {'value': '', 'label': locales.anyTime},
      {'value': 'now-1w', 'label': locales.pastWeek},
      {'value': 'now-1m', 'label': locales.pastMonth},
      {'value': 'now-1y', 'label': locales.pastYear},
      {'value': 'now-5y', 'label': locales.pastFiveYears},
      {'value': 'now-10y', 'label': locales.pastTenYears},
    ];

    String selectedLabel = selectedDate(qParams, options, currentLang, locales);

    return WithPreferences(
      builder: (context, preferences) {
        String theme = preferences.getString('theme') ?? 'dark';

        return OutlinedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                var qParamsNotifier = ref.read(queryParamsProvider.notifier);
                double screenWidth = MediaQuery.of(context).size.width;
                double screenHeight = MediaQuery.of(context).size.height;

                bool isSmallMobile = screenHeight < 600;

                return Dialog(
                  child: Container(
                    width: screenWidth,
                    height: isSmallMobile
                        ? screenHeight * 0.85
                        : screenHeight * 0.6,
                    padding: const EdgeInsets.only(
                      top: 15,
                      bottom: 25,
                      left: 15,
                      right: 15,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                              padding: EdgeInsets.symmetric(
                                vertical: isSmallMobile ? 6 : 10,
                              ),
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
                          margin: EdgeInsets.only(
                            top: isSmallMobile ? 10 : 25,
                            bottom: isSmallMobile ? 10 : 15,
                          ),
                          child: Text(
                            locales.customDate,
                            style: qParams.containsKey('dateFrom') ||
                                    qParams.containsKey('dateTo')
                                ? textTheme.labelMedium
                                : textTheme.titleMedium,
                          ),
                        ),
                        CustomDateField(
                          field: 'dateFrom',
                          label: locales.dateFrom,
                        ),
                        SizedBox(
                          height: isSmallMobile ? 10 : 15,
                        ),
                        CustomDateField(field: 'dateTo', label: locales.dateTo),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: theme == 'dark' ? ThemeColors.color3 : ThemeColors.color9,
            ),
            backgroundColor: selectedLabel != locales.date
                ? theme == 'dark'
                    ? ThemeColors.color1
                    : ThemeColors.color3
                : null,
            padding: EdgeInsets.symmetric(horizontal: isSmallMobile ? 13 : 16),
            minimumSize: const Size.fromHeight(45),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  selectedLabel,
                  style: selectedLabel != locales.date
                      ? textTheme.labelSmall?.copyWith(height: 1.1)
                      : textTheme.labelMedium,
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
                color:
                    theme == 'dark' ? ThemeColors.color4 : ThemeColors.color8,
              ),
            ],
          ),
        );
      },
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
