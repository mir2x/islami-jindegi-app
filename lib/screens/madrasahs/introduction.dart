import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/single_model.dart';
import 'package:native_app/objects/single_model_query.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/objects/font_size_ratio.dart';
import 'package:native_app/widgets/page/title.dart';
import 'package:native_app/widgets/page/html_body.dart';
import 'package:native_app/widgets/presentation/download_item.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/buttons/font_resizer.dart';
import 'package:native_app/helpers/file_utils.dart';

class MadrasahIntroduction extends ConsumerWidget {
  const MadrasahIntroduction({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var fontSizeRatio = FontSizeRatio();

    var query = SingleModelQuery(
      repository: ref.madrasahs,
      id: QR.params['id'].toString(),
    );

    var modelQuery = ref.watch(singleModelProvider(query));

    return modelQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resource) {
        return AppScaffold(
          title: Text(locales.introduction),
          body: ItemContent(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: PageTitle(
                  text: resource.title,
                  fontSizeRatio: fontSizeRatio,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: PageHtmlBody(
                  text: resource.introduction,
                  fontSizeRatio: fontSizeRatio,
                ),
              ),
              if (resource.document != null) ...[
                DownloadItem(
                  filePath: resource.document['id'],
                  fileUrl: fileSrcUrl(resource.document),
                ),
              ]
            ],
          ),
          bottomBar: BottomBar(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 15),
                child: FontResizer(fontSizeRatio: fontSizeRatio),
              ),
            ],
          ),
        );
      },
    );
  }
}
