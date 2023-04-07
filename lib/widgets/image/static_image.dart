import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:native_app/providers/connectivity_result.dart';
import 'package:collection/collection.dart';

class StaticImage extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    var connectivity = ref.watch(connectivityResultProvider);

    return connectivity.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text(error.toString()),
      data: (connectivityResult) {
        if (connectivityResult != ConnectivityResult.none) {
          double screenWidth = MediaQuery.of(context).size.width;
          double vwsetWidth = screenWidth * (vwset['xs']! / 100);
          int? selectedWidth = selectWidth(widths, vwsetWidth);
          String staticHost = dotenv.env['STATIC_HOST_NAME']!;
          String imageSrc = '$staticHost/$image${selectedWidth}w.$extension';

          return AspectRatio(
            aspectRatio: width / height,
            child: CachedNetworkImage(
              imageUrl: imageSrc,
              placeholder: (context, url) => Image.memory(kTransparentImage),
              fit: BoxFit.fill,
              fadeInDuration: const Duration(milliseconds: 150),
            ),
          );
        } else {
          return AspectRatio(
            aspectRatio: width / height,
            child: const Image(
              image: AssetImage('assets/images/books/default.png'),
            ),
          );
        }
      },
    );
  }

  int? selectWidth(List widths, double vwsetWidth) {
    return widths.firstWhereOrNull((w) => w >= vwsetWidth) ??
        widths.lastWhereOrNull((w) => w < vwsetWidth);
  }
}
