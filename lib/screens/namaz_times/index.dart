import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/providers/preferences.dart';
import 'package:native_app/widgets/location/index.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'calendar_dates.dart';
import 'namaz_time_items.dart';

class NamazTimes extends ConsumerStatefulWidget {
  const NamazTimes({super.key});

  @override
  NamazTimesState createState() => NamazTimesState();
}

class NamazTimesState extends ConsumerState<NamazTimes> {
  HijriCalendar? selectedHijriDate;

  updateHijriDate(HijriCalendar value) {
    setState(() {
      selectedHijriDate = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    var prefs = ref.watch(preferencesProvider);

    return AppScaffold(
      title: Text(locales.namazTime),
      body: prefs.when(
        loading: () => Container(
          margin: const EdgeInsets.only(top: 100),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, _) => Text(error.toString()),
        data: (preferences) {
          DateTime? currentGregorianDate;

          if (selectedHijriDate != null) {
            int adjustment = preferences.getInt('hijriAdjustment') ?? 0;

            currentGregorianDate = HijriCalendar().hijriToGregorian(
              selectedHijriDate!.hYear,
              selectedHijriDate!.hMonth,
              selectedHijriDate!.hDay - adjustment,
            );
          }

          return ItemContent(
            children: [
              Column(
                children: [
                  CalendarDates(
                    selectedHijriDate: selectedHijriDate,
                    currentGregorianDate: currentGregorianDate,
                    updateHijriDate: updateHijriDate,
                  ),
                  const SizedBox(height: 10),
                  const CurrentLocation(alignment: MainAxisAlignment.center),
                  const SizedBox(height: 15),
                  InkWell(
                    onTap: () => QR.to('namaz-times/settings'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(locales.settings),
                        const SizedBox(width: 10),
                        const Icon(Icons.settings),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  NamazTimeItems(currentDate: currentGregorianDate),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
