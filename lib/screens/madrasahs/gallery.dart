import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/single_model.dart';
import 'package:native_app/objects/single_model_query.dart';
import 'package:native_app/widgets/layouts/placeholder_scaffold.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/responsive/image.dart';

class MadrasahGallery extends ConsumerWidget {
  const MadrasahGallery({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;

    var query = SingleModelQuery(
      repository: ref.madrasahs,
      id: QR.params['id'].toString(),
      params: const {'include': 'madrasah-photos'},
      remote: true,
    );

    var modelQuery = ref.watch(singleModelProvider(query));

    return modelQuery.when(
      loading: () {
        return const PlaceholderScaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resource) {
        return AppScaffold(
          title: Text(resource.title),
          body: ItemContent(
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
        );
      },
    );
  }
}
