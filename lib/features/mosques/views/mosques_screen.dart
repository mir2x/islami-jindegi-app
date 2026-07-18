import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/l10n/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/providers/geolocation.dart';
import 'package:native_app/theme/app_theme_color.dart';
import 'package:url_launcher/url_launcher.dart';

class MosquePlace {
  MosquePlace({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  final String id;
  final String name;
  final double latitude;
  final double longitude;
}

final nearbyMosquesProvider = FutureProvider.family.autoDispose<
    List<MosquePlace>, ({double latitude, double longitude, int radiusKm})>(
  (
    ref,
    coords,
  ) async {
    final radiusInMeters = coords.radiusKm * 1000;
    final query = '''
[out:json][timeout:25];
(
  node["amenity"="place_of_worship"]["religion"="muslim"](around:$radiusInMeters,${coords.latitude},${coords.longitude});
  way["amenity"="place_of_worship"]["religion"="muslim"](around:$radiusInMeters,${coords.latitude},${coords.longitude});
  relation["amenity"="place_of_worship"]["religion"="muslim"](around:$radiusInMeters,${coords.latitude},${coords.longitude});
);
out center;
''';

    final dio = Dio();
    final response = await dio.get(
      'https://overpass-api.de/api/interpreter',
      queryParameters: {'data': query},
    );

    final data = response.data;
    if (data is! Map || data['elements'] is! List) return [];

    const distance = Distance();
    final userPoint = LatLng(coords.latitude, coords.longitude);
    final mosques = <MosquePlace>[];

    for (final item in (data['elements'] as List)) {
      if (item is! Map) continue;

      final type = item['type']?.toString() ?? 'unknown';
      final id = item['id']?.toString() ?? '';
      if (id.isEmpty) continue;

      final tags = item['tags'];
      final name = tags is Map && tags['name'] != null
          ? tags['name'].toString()
          : 'Unnamed Mosque';

      double? lat;
      double? lon;

      if (item['lat'] != null && item['lon'] != null) {
        lat = (item['lat'] as num).toDouble();
        lon = (item['lon'] as num).toDouble();
      } else if (item['center'] is Map &&
          item['center']['lat'] != null &&
          item['center']['lon'] != null) {
        lat = (item['center']['lat'] as num).toDouble();
        lon = (item['center']['lon'] as num).toDouble();
      }

      if (lat == null || lon == null) continue;

      mosques.add(
        MosquePlace(
          id: '$type-$id',
          name: name,
          latitude: lat,
          longitude: lon,
        ),
      );
    }

    mosques.sort((a, b) {
      final da = distance(
        userPoint,
        LatLng(a.latitude, a.longitude),
      );
      final db = distance(
        userPoint,
        LatLng(b.latitude, b.longitude),
      );
      return da.compareTo(db);
    });

    return mosques;
  },
);

class Mosques extends ConsumerStatefulWidget {
  const Mosques({super.key});

  @override
  ConsumerState<Mosques> createState() => _MosquesState();
}

class _MosquesState extends ConsumerState<Mosques> {
  static const _radiusOptions = [1, 3, 5, 10];
  int _selectedRadiusKm = 5;

  String _formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.round()} m';
    }
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }

  Future<void> _openInGoogleMaps(double lat, double lon) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lon',
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void _showMosqueBottomSheet(
    BuildContext context,
    MosquePlace mosque,
    LatLng userPoint,
  ) {
    const distance = Distance();
    final distanceMeters = distance(
      userPoint,
      LatLng(mosque.latitude, mosque.longitude),
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).extension<AppThemeColors>()!.cardBg,
      builder: (context) {
        final colors = Theme.of(context).extension<AppThemeColors>()!;
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mosque.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Distance: ${_formatDistance(distanceMeters)}',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: colors.secondaryText),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _openInGoogleMaps(mosque.latitude, mosque.longitude);
                  },
                  icon: const Icon(Icons.directions),
                  label: const Text('Open In Google Maps'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    var geoData = ref.watch(geolocationProvider);
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    return AppScaffold(
      onBackPressed: () async { if (context.canPop()) context.pop(); else context.go('/'); },
      title: Text(locales.mosques),
      body: geoData.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) => Text(error.toString()),
        data: (Map geolocation) {
          final latitude = geolocation['coordinates']['latitude'] as double;
          final longitude = geolocation['coordinates']['longitude'] as double;
          final mosquesQuery = ref.watch(
            nearbyMosquesProvider(
              (
                latitude: latitude,
                longitude: longitude,
                radiusKm: _selectedRadiusKm,
              ),
            ),
          );

          return mosquesQuery.when(
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Failed to load nearby mosques.\n$error',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            data: (mosques) {
              final userPoint = LatLng(latitude, longitude);
              final userMarkerColor = colors.active;
              final mosqueMarkerColor = colors.primary;

              final markers = <Marker>[
                Marker(
                  point: userPoint,
                  width: 44,
                  height: 44,
                  child: Icon(
                    Icons.my_location,
                    color: userMarkerColor,
                    size: 30,
                  ),
                ),
                ...mosques.map(
                  (mosque) => Marker(
                    point: LatLng(mosque.latitude, mosque.longitude),
                    width: 40,
                    height: 40,
                    child: GestureDetector(
                      onTap: () =>
                          _showMosqueBottomSheet(context, mosque, userPoint),
                      child: Tooltip(
                        message: mosque.name,
                        child: Icon(
                          Icons.mosque,
                          color: mosqueMarkerColor,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
              ];

              return Stack(
                children: [
                  FlutterMap(
                    options: MapOptions(
                      initialCenter: userPoint,
                      initialZoom: 14,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.islami_jindegi',
                      ),
                      MarkerLayer(markers: markers),
                    ],
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    right: 12,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Search Radius',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: colors.primaryText),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: _radiusOptions
                                  .map(
                                    (km) => ChoiceChip(
                                      label: Text('$km km'),
                                      selected: _selectedRadiusKm == km,
                                      onSelected: (_) {
                                        setState(() {
                                          _selectedRadiusKm = km;
                                        });
                                      },
                                    ),
                                  )
                                  .toList(),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${mosques.length} mosques found',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: colors.secondaryText),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
