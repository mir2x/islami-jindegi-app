import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/providers/hijri_date_settings.dart';
import 'package:native_app/providers/geolocation.dart';
import 'package:native_app/helpers/adjusted_hijri_date.dart';
import 'package:native_app/widgets/location/index.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/theme/app_theme.dart';
import 'package:native_app/theme/colors.dart';
import 'calendar_dates.dart';
import 'namaz_time_items.dart';

class NamazTimes extends ConsumerWidget {
  const NamazTimes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var settingsProvider = ref.watch(hijriDateSettingsProvider);

    return AppScaffold(
      title: Text(locales.namazTime),
      body: settingsProvider.when(
        loading: () {
          var dataProvider = ref.watch(preferencesAndGeolocationProvider);

          return dataProvider.when(
            loading: () => Container(
              margin: const EdgeInsets.only(top: 100),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, _) => Text(error.toString()),
            data: (Map data) {
              int? localAdjustment =
                  data['preferences'].getInt('hijriLocalAdjustment');
              int adjustment = localAdjustment ?? 0;

              return NamazTimesPage(
                settings: {
                  'preferences': data['preferences'],
                  'coordinates': data['geolocation']['coordinates'],
                  'timezone': data['geolocation']['timezone'],
                  'hijriAdjustment': adjustment,
                },
                isHijriLoading: true,
              );
            },
          );
        },
        error: (error, _) => Text(error.toString()),
        data: (settings) {
          return NamazTimesPage(settings: settings);
        },
      ),
    );
  }
}

class NamazTimesPage extends ConsumerStatefulWidget {
  const NamazTimesPage({
    super.key,
    required this.settings,
    this.isHijriLoading = false,
  });

  final Map settings;
  final bool isHijriLoading;

  @override
  NamazTimesPageState createState() => NamazTimesPageState();
}

class NamazTimesPageState extends ConsumerState<NamazTimesPage> {
  HijriCalendar? selectedHijriDate;
  DateTime? selectedGregorianDate;
  bool isStartTime = true;

  updateHijriDate(HijriCalendar value) {
    setState(() {
      selectedHijriDate = value;
      selectedGregorianDate = null;
    });
  }

  updateGregorianDate(DateTime value) {
    setState(() {
      selectedGregorianDate = value;
      selectedHijriDate = null;
    });
  }

  toggleTime(bool value) {
    setState(() {
      isStartTime = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    String theme =
        widget.settings['preferences'].getString('theme') ?? 'classic';
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallMobile = screenWidth < 340;

    int adjustment = widget.settings['hijriAdjustment'];
    DateTime currentTime = DateTime.now();

    if (selectedHijriDate != null) {
      DateTime date = HijriCalendar().hijriToGregorian(
        selectedHijriDate!.hYear,
        selectedHijriDate!.hMonth,
        selectedHijriDate!.hDay - adjustment,
      );

      date = DateTime(
        date.year,
        date.month,
        date.day,
        currentTime.hour,
        currentTime.minute,
        currentTime.second,
      );

      if (isAfterDateStartTime(date, widget.settings)) {
        date = DateTime(date.year, date.month, date.day - 1);
      }

      selectedGregorianDate = DateTime(
        date.year,
        date.month,
        date.day,
        currentTime.hour,
        currentTime.minute,
        currentTime.second,
      );
    } else if (selectedGregorianDate != null) {
      DateTime date = DateTime(
        selectedGregorianDate!.year,
        selectedGregorianDate!.month,
        selectedGregorianDate!.day,
        currentTime.hour,
        currentTime.minute,
        currentTime.second,
      );

      if (isAfterDateStartTime(date, widget.settings)) {
        date = DateTime(date.year, date.month, date.day + 1);
      }

      selectedHijriDate = HijriCalendar.fromDate(
        DateTime(
          date.year,
          date.month,
          date.day + adjustment,
        ),
      );
    }

    return ItemContent(
      children: [
        Column(
          children: [
            CalendarDates(
              selectedHijriDate: selectedHijriDate,
              selectedGregorianDate: selectedGregorianDate,
              updateHijriDate: updateHijriDate,
              updateGregorianDate: updateGregorianDate,
              isHijriLoading: widget.isHijriLoading,
            ),
            const SizedBox(height: 10),
            const CurrentLocation(alignment: MainAxisAlignment.center),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => QR.to('qiblah'),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallMobile ? 5 : 10,
                      vertical: 7,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(locales.qiblah),
                        SizedBox(width: isSmallMobile ? 4 : 6),
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
                SizedBox(width: isSmallMobile ? 6 : 10),
                InkWell(
                  onTap: () => QR.to('mosques'),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallMobile ? 5 : 10,
                      vertical: 7,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(locales.mosques),
                        SizedBox(width: isSmallMobile ? 4 : 6),
                        const Icon(Icons.mosque),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: isSmallMobile ? 6 : 10),
                InkWell(
                  onTap: () => QR.to('namaz-times/settings'),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallMobile ? 5 : 10,
                      vertical: 7,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(locales.settings),
                        SizedBox(width: isSmallMobile ? 4 : 6),
                        const Icon(Icons.settings),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            AnimatedToggleSwitch<bool>.dual(
              current: isStartTime,
              first: true,
              second: false,
              spacing: 80,
              style: const ToggleStyle(
                borderColor: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 1.5),
                  ),
                ],
              ),
              borderWidth: 5,
              height: 36,
              onChanged: (b) => toggleTime(b),
              indicatorSize: const Size.fromWidth(26),
              styleBuilder: (b) => ToggleStyle(
                backgroundColor: AppTheme.backgroundColor[theme],
                indicatorColor:
                    b ? AppTheme.iconColor[theme] : ThemeColors.danger,
              ),
              textBuilder: (value) => value
                  ? Center(
                      child: Text(
                        locales.waqtStarts,
                        style: textTheme.labelMedium,
                      ),
                    )
                  : Center(
                      child: Text(
                        locales.waqtEnds,
                        style: textTheme.labelMedium,
                      ),
                    ),
            ),
            const SizedBox(height: 10),
            NamazTimeItems(
              currentDate: selectedGregorianDate,
              isStartTime: isStartTime,
            ),
          ],
        ),
      ],
    );
  }
}
