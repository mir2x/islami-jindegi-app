import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:collection/collection.dart';

class StaticImage extends StatelessWidget {
  const StaticImage({
    super.key,
    required this.image,
    required this.width,
    required this.height,
    this.extension = 'jpg',
    this.vwset = const {'xs': 100},
    this.widths = const [1200, 800, 400, 200, 100],
  });

  final String image;
  final int width;
  final int height;
  final String extension;
  final Map<String, int> vwset;
  final List<int> widths;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double vwsetWidth = screenWidth * (vwset['xs']! / 100);
    int? selectedWidth = selectWidth(widths, vwsetWidth);

    String imageSrc =
        "${dotenv.env['STATIC_HOST_NAME']}/$image${selectedWidth}w.$extension";

    return AspectRatio(
      aspectRatio: width / height,
      child: CachedNetworkImage(
        imageUrl: imageSrc,
        placeholder: (context, url) => Image.memory(kTransparentImage),
        fit: BoxFit.fill,
        fadeInDuration: const Duration(milliseconds: 150),
      ),
    );
  }

  int? selectWidth(List widths, double vwsetWidth) {
    return widths.firstWhereOrNull((w) => w >= vwsetWidth) ??
        widths.lastWhereOrNull((w) => w < vwsetWidth);
  }
}
