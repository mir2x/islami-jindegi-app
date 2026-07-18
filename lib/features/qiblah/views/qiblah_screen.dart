import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/l10n/app_localizations.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:adhan/adhan.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/providers/geolocation.dart';
import 'package:native_app/widgets/location/index.dart';
import 'package:native_app/theme/app_theme_color.dart';

class Qiblah extends ConsumerWidget {
  const Qiblah({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallMobile = screenWidth < 340;
    double compassSize = isSmallMobile ? 230 : 320;
    var geoData = ref.watch(geolocationProvider);
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    return AppScaffold(
      onBackPressed: () async { if (context.canPop()) context.pop(); else context.go('/'); },
      title: Text(locales.qiblah),
      body: Container(
        margin: EdgeInsets.only(
          left: 20,
          right: 20,
          top: isSmallMobile ? 25 : 60,
        ),
        child: geoData.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, _) => Text(error.toString()),
          data: (Map geolocation) {
            Coordinates coordinates = Coordinates(
              geolocation['coordinates']['latitude'],
              geolocation['coordinates']['longitude'],
            );

            final qibla = Qibla(coordinates);

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CurrentLocation(alignment: MainAxisAlignment.center),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colors.cardBg,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: colors.divider),
                    boxShadow: [
                      BoxShadow(
                        color: colors.shadow.withValues(alpha: 0.12),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: StreamBuilder<CompassEvent>(
                    stream: FlutterCompass.events,
                    builder: (context, snapshot) {
                      double heading = snapshot.data?.heading ?? 0;

                      return SizedBox(
                        height: compassSize,
                        width: compassSize,
                        child: AnimatedRotation(
                          duration: const Duration(milliseconds: 800),
                          turns: -heading / 360,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: SvgPicture.asset(
                                  'assets/images/icons/compass.svg',
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: AnimatedRotation(
                                  duration: const Duration(milliseconds: 500),
                                  turns: qibla.direction / 360,
                                  child: SvgPicture.asset(
                                    'assets/images/icons/kaaba-compass.svg',
                                    fit: BoxFit.scaleDown,
                                    width: compassSize,
                                    height: compassSize,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  width: 250,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  margin: EdgeInsets.only(bottom: isSmallMobile ? 20 : 40),
                  decoration: BoxDecoration(
                    color: colors.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colors.divider),
                  ),
                  child: Text(
                    locales.qiblahInstruction,
                    style: textTheme.labelMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
