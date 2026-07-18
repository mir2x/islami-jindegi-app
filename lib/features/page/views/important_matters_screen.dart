import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/l10n/app_localizations.dart';
import 'package:native_app/widgets/layouts/placeholder_scaffold.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/presentation/resizable_font.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/page/html_body.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/buttons/social_share.dart';
import 'package:native_app/widgets/buttons/font_resizer.dart';
import '../providers/page_providers.dart';

class ImportantMattersScreen extends ConsumerWidget {
  const ImportantMattersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var pageQuery = ref.watch(pageBySlugProvider('important-matters'));

    return pageQuery.when(
      loading: () {
        return const PlaceholderScaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (item) {

        return ResizableFont(
          storeKey: 'importantMattersFontRatio',
          builder: (context, fontSizeRatio) {
            return AppScaffold(
              showPattern: false,
              title: Text(locales.importantMatters),
              body: ItemContent(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    child: PageHtmlBody(
                      text: item.body,
                      fontSizeRatio: fontSizeRatio,
                    ),
                  ),
                ],
              ),
              bottomBar: BottomBar(
                alignment: MainAxisAlignment.spaceBetween,
                children: [
                  SocialShare(
                    title: item.title,
                    body: item.body,
                  ),
                  FontResizer(
                    fontSizeRatio: fontSizeRatio,
                    storeKey: 'importantMattersFontRatio',
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
