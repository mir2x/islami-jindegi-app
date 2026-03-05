import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/widgets/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/layouts/placeholder_scaffold.dart';
import 'package:native_app/widgets/gestures/next_page_swipe.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/responsive/image.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/buttons/previous.dart';
import 'package:native_app/widgets/buttons/next.dart';
import '../providers/madrasah_providers.dart';

class MadrasahGalleryScreen extends ConsumerWidget {
  const MadrasahGalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var madrasahId = GoRouterState.of(context).pathParameters['id'].toString();
    var madrasahQuery = ref.watch(singleMadrasahWithPhotosProvider(madrasahId));

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
        final api = ref.read(madrasahApiServiceProvider);

        Future? previousPage() async {
          var previousResources = await api.fetchInfosByMadrasah(
            madrasahId: resource.id,
            sort: '-position',
            quantity: 1,
          );

          if (previousResources.isNotEmpty) {
            await context.push(
              'madrasahs/${resource.id}/infos/${previousResources.first.id}',
            );
          } else {
            await context.push('/madrasahs/${resource.id}/introduction');
          }
        }

        Future? nextPage() async {}

        return AppScaffold(
          onBackPressed: () async => await context.push('/madrasahs/${resource.id}'),
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
                ...resource.madrasahPhotos.map((photo) {
                  return Container(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: ResponsiveImage(
                      image: photo.image,
                      model: 'madrasahPhoto',
                    ),
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
