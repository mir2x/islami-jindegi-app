import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smooth_compass/utils/src/compass_ui.dart';
import 'package:adhan/adhan.dart';
import 'package:flutter_svg/svg.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/providers/geolocation.dart';
import 'package:native_app/widgets/location/index.dart';

class Qiblah extends ConsumerWidget {
  const Qiblah({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var geoData = ref.watch(geolocationProvider);

    return AppScaffold(
      title: Text(locales.qiblah),
      body: Container(
        margin: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 50,
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
                SmoothCompass(
                  compassBuilder: (context, snapshot, child) {
                    return SizedBox(
                      height: 320,
                      width: 320,
                      child: AnimatedRotation(
                        duration: const Duration(milliseconds: 800),
                        turns: snapshot?.data?.turns ?? 0,
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
                                  width: 320,
                                  height: 320,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Container(
                  width: 250,
                  margin: const EdgeInsets.only(bottom: 40),
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
