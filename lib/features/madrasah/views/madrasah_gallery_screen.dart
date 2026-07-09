import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:native_app/widgets/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/layouts/placeholder_scaffold.dart';
import 'package:native_app/widgets/gestures/next_page_swipe.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/utils/with_connectivity.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/buttons/previous.dart';
import 'package:native_app/widgets/buttons/next.dart';
import 'package:native_app/theme/app_theme_color.dart';
import '../providers/madrasah_providers.dart';

class MadrasahGalleryScreen extends ConsumerWidget {
  const MadrasahGalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var madrasahId = GoRouterState.of(context).pathParameters['id'].toString();
    var madrasahQuery = ref.watch(singleMadrasahProvider(madrasahId));

    return madrasahQuery.when(
      loading: () {
        return const PlaceholderScaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resource) {
        Future? previousPage() async {
          if (resource.infos.isNotEmpty) {
            await context.push(
              'madrasahs/${resource.id}/infos/${resource.infos.last.id}',
            );
          } else {
            await context.push('/madrasahs/${resource.id}/introduction');
          }
        }

        Future? nextPage() async {}

        return AppScaffold(
          onBackPressed: () async { if (context.canPop()) context.pop(); else context.go('/madrasahs/${resource.id}'); },
          showPattern: false,
          title: Text(resource.title),
          body: NextPageSwipe(
            onPrevious: previousPage,
            onNext: nextPage,
            child: ItemContent(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 25),
                  child: Text(locales.gallery, style: textTheme.labelLarge),
                ),
                ...resource.photos.map((photo) {
                  return Container(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: _MadrasahPhotoImage(imageUrl: photo.imageUrl),
                  );
                }),
              ],
            ),
          ),
          bottomBar: BottomBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: [
              Previous(onPrevious: previousPage),
              Next(
                onNext: nextPage,
                nextDisabled: true,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Renders a madrasah gallery photo directly via `CachedNetworkImage` off the
/// .NET API's flat `imageUrl` string — mirroring how `BookImage`
/// (`features/book/views/image.dart`) was forked off the shared
/// `ResponsiveImage` widget rather than adapting `ResponsiveImage` itself.
/// `ResponsiveImage` still expects the old JSON:API derivative-map `image`
/// shape and isn't touched here.
class _MadrasahPhotoImage extends StatelessWidget {
  const _MadrasahPhotoImage({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context).extension<AppThemeColors>()!;

    if (imageUrl == null || imageUrl!.isEmpty) {
      return _placeholder(appTheme);
    }

    return WithConnectivity(
      builder: (context, isConnected) {
        if (!isConnected) return _placeholder(appTheme);
        return AspectRatio(
          aspectRatio: 1,
          child: CachedNetworkImage(
            imageUrl: imageUrl!,
            placeholder: (context, url) => Image.memory(kTransparentImage),
            fit: BoxFit.fill,
            fadeInDuration: const Duration(milliseconds: 150),
          ),
        );
      },
    );
  }

  Widget _placeholder(AppThemeColors appTheme) {
    return AspectRatio(
      aspectRatio: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(color: appTheme.highlight),
      ),
    );
  }
}
