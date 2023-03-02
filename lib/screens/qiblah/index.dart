import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_compass/utils/src/compass_ui.dart';
import 'package:adhan/adhan.dart';
import 'package:flutter_svg/svg.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';
import 'package:native_app/providers/geolocation.dart';

class Qiblah extends ConsumerWidget {
  const Qiblah({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTheme = Theme.of(context).textTheme;
    var geoData = ref.watch(geolocationProvider);

    return MyScaffold(
      title: const Text('Qiblah'),
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
          data: (Map data) {
            Coordinates coordinates = Coordinates(
              data['coordinates']['latitude'],
              data['coordinates']['longitude'],
            );

            final qibla = Qibla(coordinates);

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!data['isGeolocated']) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Dhaka'),
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 5),
                        child: GestureDetector(
                          onTap: () => ref
                              .read(geolocationProvider.notifier)
                              .updateCoordinates(),
                          child: SvgPicture.asset(
                            'assets/images/icons/location.svg',
                            fit: BoxFit.scaleDown,
                            width: 40,
                            height: 30,
                          ),
                        ),
                      ),
                      const Text('Set Location')
                    ],
                  ),
                ],
                SmoothCompass(
                  height: 320,
                  width: 320,
                  compassBuilder: (context, snapshot, child) {
                    return AnimatedRotation(
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
                                'assets/images/icons/kaaba.svg',
                                fit: BoxFit.scaleDown,
                                width: 320,
                                height: 320,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Container(
                  width: 250,
                  margin: const EdgeInsets.only(bottom: 40),
                  child: Text(
                    'Set the device horizontally to get the best result.',
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
