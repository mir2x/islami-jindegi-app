import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/providers/hijri_date_settings.dart';
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
    var settingsProvider = ref.watch(hijriDateSettingsProvider);

    return AppScaffold(
      title: Text(locales.namazTime),
      body: settingsProvider.when(
        loading: () => Container(
          margin: const EdgeInsets.only(top: 100),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, _) => Text(error.toString()),
        data: (settings) {
          DateTime? currentGregorianDate;

          if (selectedHijriDate != null) {
            int adjustment = settings['hijriAdjustment'];

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
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => QR.to('qiblah'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 7,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(locales.qiblah),
                              const SizedBox(width: 8),
                              SvgPicture.asset(
                                'assets/images/icons/kaaba.svg',
                                fit: BoxFit.scaleDown,
                                width: 20,
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () => QR.to('namaz-times/settings'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 7,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(locales.settings),
                              const SizedBox(width: 6),
                              const Icon(Icons.settings),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
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
