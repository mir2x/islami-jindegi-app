import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:native_app/widgets/utils/with_connectivity.dart';
import 'package:native_app/settings/image.dart';
import 'package:native_app/theme/app_theme_color.dart';

/// A book cover.
///
/// Online it renders [coverUrl] straight from the API. Offline it renders
/// [coverImagePath] — the copy `BookSyncService` downloaded alongside the
/// book's text when the admin marked it offline-available. Anything else
/// falls back to the placeholder.
class BookImage extends ConsumerWidget {
  const BookImage({
    super.key,
    required this.bookId,
    required this.coverUrl,
    this.coverImagePath,
    this.highlightProvider,
  });

  final String bookId;
  final String? coverUrl;

  /// Local file cached by the offline sync (`BookSyncService`). Only set when
  /// the book was loaded from the local database — `Book.fromJson` leaves it
  /// null, so online reads always go to the network.
  final String? coverImagePath;
  final dynamic highlightProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final Map<String, int> dimensions = imageSettings['book']['image'];

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
      child: _cover(dimensions),
    );
  }

  Widget _cover(Map<String, int> dimensions) {
    final localCover = coverImagePath;
    if (localCover != null && File(localCover).existsSync()) {
      return _sized(
        dimensions,
        Image.file(File(localCover), fit: BoxFit.fill),
      );
    }

    if (coverUrl == null || coverUrl!.isEmpty) {
      return _placeholder(dimensions);
    }

    return WithConnectivity(
      builder: (context, isConnected) {
        if (!isConnected) return _placeholder(dimensions);
        return _sized(
          dimensions,
          CachedNetworkImage(
            imageUrl: coverUrl!,
            placeholder: (context, url) => Image.memory(kTransparentImage),
            fit: BoxFit.fill,
            fadeInDuration: const Duration(milliseconds: 150),
          ),
        );
      },
    );
  }

  Widget _sized(Map<String, int> dimensions, Widget child) {
    return AspectRatio(
      aspectRatio: dimensions['width']! / dimensions['height']!,
      child: child,
    );
  }

  Widget _placeholder(Map<String, int> dimensions) {
    return _sized(
      dimensions,
      SvgPicture.asset(
        'assets/images/book-placeholder.svg',
        fit: BoxFit.contain,
      ),
    );
  }
}
