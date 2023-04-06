import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:collection/collection.dart';
import 'package:native_app/settings/image.dart';
import 'package:native_app/theme/colors.dart';

class ResponsiveImage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double vwsetWidth = screenWidth * (vwset['xs']! / 100);

    if (image is Map && image.containsKey('original')) {
      String? selectedWidth = selectWidth(image, vwsetWidth);

      if (selectedWidth != null) {
        Map<String, dynamic> metadata = getImageMetadata(image, model, attr);

        Map<String, dynamic> img = image[selectedWidth];
        String imageSrc =
            "${dotenv.env['STATIC_HOST_NAME']}/uploads/${img['storage']}/${img['id']}";

        return AspectRatio(
          aspectRatio: metadata['width']! / metadata['height']!,
          child: CachedNetworkImage(
            imageUrl: imageSrc,
            placeholder: (context, url) => Image.memory(kTransparentImage),
            fit: BoxFit.fill,
            fadeInDuration: const Duration(milliseconds: 150),
          ),
        );
      } else {
        return displayPlaceHolder(model, attr);
      }
    } else {
      return displayPlaceHolder(model, attr);
    }
  }

  String? selectWidth(image, double vwsetWidth) {
    Iterable<String> widths = image.keys.where((k) => k != 'original');
    return widths.firstWhereOrNull((w) => int.parse(w) >= vwsetWidth) ??
        widths.lastWhereOrNull((w) => int.parse(w) < vwsetWidth);
  }

  Map<String, dynamic> getImageMetadata(image, String model, String attr) {
    Map<String, int> settings = imageSettings[model]![attr]!;

    return image[settings['width'].toString()]?['metadata'] ?? settings;
  }

  Widget displayPlaceHolder(model, String attr) {
    Map<String, int> settings = imageSettings[model]![attr]!;

    if (model == 'book') {
      return AspectRatio(
        aspectRatio: settings['width']! / settings['height']!,
        child: const Image(
          image: AssetImage('assets/images/books/default.png'),
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: settings['width']! / settings['height']!,
        child: const DecoratedBox(
          decoration: BoxDecoration(
            color: ThemeColors.placeholder,
          ),
        ),
      );
    }
  }
}
