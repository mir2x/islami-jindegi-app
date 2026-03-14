import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:adhan/adhan.dart';
import 'package:native_app/providers/geolocation.dart';
import 'package:native_app/theme/app_theme_color.dart';
import 'package:native_app/widgets/location/index.dart';
import 'package:native_app/objects/prayer_time.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/helpers/update_app_widget.dart';

class CurrentLocationPrayers extends StatelessWidget {
  const CurrentLocationPrayers({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 768;

    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment:
              isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: isMobile ? 0 : 5),
              child: const CurrentLocation(oppositeColor: true),
            ),
          ],
        ),
        const CurrentPrayers(),
      ],
    );
  }
}

class CurrentPrayers extends ConsumerStatefulWidget {
  const CurrentPrayers({super.key});

  @override
  CurrentPrayersState createState() => CurrentPrayersState();
}

class CurrentPrayersState extends ConsumerState<CurrentPrayers> {
  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
      const Duration(minutes: 1),
      (Timer t) => setState(() {}),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    String currentLang = Localizations.localeOf(context).languageCode;
    var dataProvider = ref.watch(preferencesAndGeolocationProvider);

    return dataProvider.when(
      loading: () {
        return WithPreferences(
          builder: (context, preferences) {
            String? currentPrayerTitle =
                preferences.getString('currentPrayerTitle');
            String? currentPrayerTime =
                preferences.getString('currentPrayerTime');
            String? nextPrayer = preferences.getString('nextPrayer');

            if (currentPrayerTitle != null &&
                currentPrayerTime != null &&
                nextPrayer != null) {
              return Prayers(
                prayerTimes: {
                  'current': {
                    'title': currentPrayerTitle,
                    'time': currentPrayerTime,
                  },
                  'next': nextPrayer,
                },
              );
            } else {
              return const SizedBox(height: 45);
            }
          },
        );
      },
      error: (error, _) => Text(error.toString()),
      data: (Map data) {
        Map geolocation = data['geolocation'];
        Map coordinates = geolocation['coordinates'];

        PrayerTime prayerTime = PrayerTime(
          coordinates: Coordinates(
            coordinates['latitude'],
            coordinates['longitude'],
          ),
          timezone: geolocation['timezone'],
          preferences: data['preferences'],
        );

        Map prayerTimes = prayerTime.getCurrentAndNextPrayers(
          locales,
          currentLang,
        );

        return Prayers(
          prayerTimes: {
            'current': prayerTimes['current'],
            'next':
                '${locales.next} ${prayerTimes['next']['title']} ${prayerTimes['next']['time']}',
          },
        );
      },
    );
  }
}

class Prayers extends StatelessWidget {
  const Prayers({
    super.key,
    required this.prayerTimes,
  });

  final Map prayerTimes;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 768;
    bool isSmallMobile = screenWidth < 340;

    return WithPreferences(
      builder: (context, preferences) {
        final appColors = Theme.of(context).extension<AppThemeColors>()!;
        Color titleColor = appColors.appBarText;
        Color labelColor = appColors.appBarText.withValues(alpha: 0.88);

        bool hasCurrentPrayer = prayerTimes.containsKey('current') &&
            (prayerTimes['current'] != null);

        Map updatableParams = {};

        if (hasCurrentPrayer) {
          String currentPrayerTitle = prayerTimes['current']['title'];
          String currentPrayerTime = prayerTimes['current']['time'];
          String currentPrayer = '$currentPrayerTitle $currentPrayerTime';

          if (preferences.getString('currentPrayerTitle') !=
              currentPrayerTitle) {
            preferences.setString('currentPrayerTitle', currentPrayerTitle);
          }

          if (preferences.getString('currentPrayerTime') != currentPrayerTime) {
            preferences.setString('currentPrayerTime', currentPrayerTime);
          }

          if (preferences.getString('currentPrayer') != currentPrayer) {
            preferences.setString('currentPrayer', currentPrayer);
            updatableParams['currentPrayer'] = currentPrayer;
          }
        }

        if (preferences.getString('nextPrayer') != prayerTimes['next']) {
          preferences.setString('nextPrayer', prayerTimes['next']);
          updatableParams['nextPrayer'] = prayerTimes['next'];
        }

        updateAppWidget(updatableParams);

        return Column(
          crossAxisAlignment:
              isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            if (hasCurrentPrayer) ...[
              Container(
                margin: EdgeInsets.only(bottom: isMobile ? 0 : 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${prayerTimes['current']['title']}',
                      style: isSmallMobile
                          ? textTheme.titleMedium?.copyWith(
                              fontSize: 17,
                              color: titleColor,
                            )
                          : textTheme.titleLarge?.copyWith(color: titleColor),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      margin: EdgeInsets.only(top: isSmallMobile ? 1 : 3),
                      child: Text(
                        '${prayerTimes['current']['time']}',
                        style: textTheme.titleMedium?.copyWith(
                          color: titleColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            Text(
              prayerTimes['next'],
              style: textTheme.labelSmall?.copyWith(
                color: labelColor,
              ),
            ),
          ],
        );
      },
    );
  }
}
