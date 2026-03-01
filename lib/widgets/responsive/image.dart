import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:collection/collection.dart';
import 'package:native_app/widgets/utils/with_connectivity.dart';
import 'package:native_app/settings/image.dart';

class ResponsiveImage extends ConsumerWidget {
  const ResponsiveImage({
    super.key,
    required this.image,
    required this.model,
    this.attr = 'image',
    this.vwset = const {'xs': 100},
  });

  final dynamic image;
  final String model;
  final String attr;
  final Map<String, int> vwset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenWidth = MediaQuery.of(context).size.width;
    double vwsetWidth = screenWidth * (vwset['xs']! / 100);

    if (image is Map && image.containsKey('original')) {
      String? selectedWidth = selectWidth(image, vwsetWidth);

      if (selectedWidth != null) {
        return WithConnectivity(
          builder: (context, isConnected) {
            if (isConnected) {
              Map metadata = getImageMetadata(image, model, attr);

              Map img = image[selectedWidth];
              String staticHostName = dotenv.env['STATIC_HOST_NAME']!;
              String imageSrc =
                  "$staticHostName/uploads/${img['storage']}/${img['id']}";

              return AspectRatio(
                aspectRatio: metadata['width']! / metadata['height']!,
                child: CachedNetworkImage(
                  imageUrl: imageSrc,
                  placeholder: (context, url) {
                    return Image.memory(kTransparentImage);
                  },
                  fit: BoxFit.fill,
                  fadeInDuration: const Duration(milliseconds: 150),
                ),
              );
            } else {
              return displayPlaceHolder(context, model, attr);
            }
          },
        );
      } else {
        return displayPlaceHolder(context, model, attr);
      }
    } else {
      return displayPlaceHolder(context, model, attr);
    }
  }

  String? selectWidth(image, double vwsetWidth) {
    List widths = image.keys.where((k) => k != 'original').toList();
    return widths.firstWhereOrNull((w) => int.parse(w) >= vwsetWidth) ??
        widths.lastWhereOrNull((w) => int.parse(w) < vwsetWidth);
  }

  Map getImageMetadata(image, String model, String attr) {
    Map<String, int> settings = imageSettings[model]![attr]!;

    return image[settings['width'].toString()]?['metadata'] ?? settings;
  }

  Widget displayPlaceHolder(BuildContext context, model, String attr) {
    Map<String, int> settings = imageSettings[model]![attr]!;

    if (model == 'book') {
      return AspectRatio(
        aspectRatio: settings['width']! / settings['height']!,
        child: SvgPicture.asset(
          'assets/images/books/default.svg',
          fit: BoxFit.contain,
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: settings['width']! / settings['height']!,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
        ),
      );
    }
  }
}
