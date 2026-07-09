import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:native_app/providers/check_asset_file.dart';
import 'package:native_app/widgets/utils/with_connectivity.dart';
import 'package:native_app/settings/image.dart';
import 'package:native_app/theme/app_theme_color.dart';

class BookImage extends ConsumerWidget {
  const BookImage({
    super.key,
    required this.bookId,
    required this.coverUrl,
    this.highlightProvider,
  });

  final String bookId;
  final String? coverUrl;
  final dynamic highlightProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
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
              return Border.all(color: colors.active, width: 4);
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
          } else if (coverUrl == null || coverUrl!.isEmpty) {
            return _placeholder(dimensions);
          } else {
            return WithConnectivity(
              builder: (context, isConnected) {
                if (!isConnected) return _placeholder(dimensions);
                return AspectRatio(
                  aspectRatio: dimensions['width']! / dimensions['height']!,
                  child: CachedNetworkImage(
                    imageUrl: coverUrl!,
                    placeholder: (context, url) {
                      return Image.memory(kTransparentImage);
                    },
                    fit: BoxFit.fill,
                    fadeInDuration: const Duration(milliseconds: 150),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _placeholder(Map<String, int> dimensions) {
    return AspectRatio(
      aspectRatio: dimensions['width']! / dimensions['height']!,
      child: SvgPicture.asset(
        'assets/images/books/default.svg',
        fit: BoxFit.contain,
      ),
    );
  }
}
