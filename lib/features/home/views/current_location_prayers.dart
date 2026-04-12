import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:adhan/adhan.dart';
import 'package:native_app/providers/geolocation.dart';
import 'package:native_app/theme/app_theme_color.dart';
import 'package:native_app/widgets/location/index.dart';
import 'package:native_app/objects/prayer_time.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/helpers/update_app_widget.dart';

class CurrentLocationPrayers extends StatelessWidget {
  const CurrentLocationPrayers({super.key, this.heroCard = false});

  final bool heroCard;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 768;

    if (heroCard) {
      return const CurrentPrayers(heroCard: true);
    }

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
  const CurrentPrayers({super.key, this.heroCard = false});

  final bool heroCard;

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
                heroCard: widget.heroCard,
                prayerTimes: {
                  'current': {
                    'title': currentPrayerTitle,
                    'time': currentPrayerTime,
                  },
                  'next': nextPrayer,
                },
              );
            } else {
              return SizedBox(height: widget.heroCard ? 80 : 45);
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
          heroCard: widget.heroCard,
          prayerTimes: {
            'current': prayerTimes['current'],
            'next': widget.heroCard
                ? prayerTimes['next']
                : '${locales.next} ${prayerTimes['next']['title']} ${prayerTimes['next']['time']}',
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
    this.heroCard = false,
  });

  final Map prayerTimes;
  final bool heroCard;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var locales = AppLocalizations.of(context)!;
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

        final nextValue = prayerTimes['next'];
        final nextString = nextValue is Map
            ? '${nextValue['title']} ${nextValue['time']}'
            : nextValue as String;
        if (preferences.getString('nextPrayer') != nextString) {
          preferences.setString('nextPrayer', nextString);
          updatableParams['nextPrayer'] = nextString;
        }

        updateAppWidget(updatableParams);

        if (heroCard) {
          return InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => context.push('/namaz-times'),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locales.currentPrayerLabel,
                          style: textTheme.labelMedium?.copyWith(
                            color: appColors.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        if (hasCurrentPrayer) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '${prayerTimes['current']['title']}',
                                style: textTheme.titleLarge?.copyWith(
                                  color: titleColor,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${locales.startsLabel} ',
                                style: textTheme.labelSmall?.copyWith(
                                  color: appColors.secondary
                                      .withValues(alpha: 0.85),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                (prayerTimes['current']['time'] as String)
                                    .split(' - ')
                                    .first,
                                style: textTheme.titleLarge?.copyWith(
                                  color: titleColor,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '${locales.endsLabel} ',
                                style: textTheme.labelSmall?.copyWith(
                                  color: appColors.secondary
                                      .withValues(alpha: 0.85),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                (prayerTimes['current']['time'] as String)
                                    .split(' - ')
                                    .last,
                                style: textTheme.headlineMedium?.copyWith(
                                  color: titleColor,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          locales.nextLabel,
                          style: textTheme.labelMedium?.copyWith(
                            color: appColors.secondary.withValues(alpha: 0.6),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (prayerTimes['next'] is Map) ...[
                          Text(
                            '${prayerTimes['next']['title']}',
                            style: textTheme.labelMedium?.copyWith(
                              color: labelColor,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.end,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '${locales.startsLabel} ',
                                style: textTheme.labelSmall?.copyWith(
                                  color: appColors.secondary
                                      .withValues(alpha: 0.85),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${prayerTimes['next']['time']}',
                                style: textTheme.titleMedium?.copyWith(
                                  color: labelColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ] else
                          Text(
                            '${prayerTimes['next']}',
                            style: textTheme.labelMedium?.copyWith(
                              color: labelColor,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.end,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => context.push('/namaz-times'),
          child: Column(
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
          ),
        );
      },
    );
  }
}
