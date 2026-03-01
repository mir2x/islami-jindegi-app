import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/providers/check_asset_file.dart';
import 'package:native_app/widgets/responsive/image.dart';
import 'package:native_app/settings/image.dart';

class BookImage extends ConsumerWidget {
  const BookImage({
    super.key,
    required this.bookId,
    required this.image,
    this.highlightProvider,
  });

  final String bookId;
  final dynamic image;
  final dynamic highlightProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var assetChecker = ref.watch(
      checkAssetFileProvider('images/books/$bookId.jpg'),
    );

    Map<String, int> dimensions = imageSettings['book']['image'];

    AsyncValue? highlighter;

    if (highlightProvider != null) {
      highlighter = ref.watch(highlightProvider);
    }

    return Container(
      decoration: BoxDecoration(
        border: highlighter?.when(
          loading: () => null,
          error: (error, _) => null,
          data: (highlight) {
            if (highlight != null) {
              return Border.all(
                  color: Theme.of(context).colorScheme.error, width: 4);
            } else {
              return null;
            }
          },
        ),
      ),
      child: assetChecker.when(
        loading: () => AspectRatio(
          aspectRatio: dimensions['width']! / dimensions['height']!,
          child: const SizedBox.shrink(),
        ),
        error: (error, _) => const SizedBox.shrink(),
        data: (exists) {
          if (exists) {
            return AspectRatio(
              aspectRatio: dimensions['width']! / dimensions['height']!,
              child: Image(
                image: AssetImage(
                  'assets/images/books/$bookId.jpg',
                ),
                fit: BoxFit.fill,
              ),
            );
          } else {
            return ResponsiveImage(
              image: image,
              model: 'book',
              vwset: const {'xs': 50},
            );
          }
        },
      ),
    );
  }
}
