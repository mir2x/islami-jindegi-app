import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:pdfx/pdfx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/single_model.dart';
import 'package:native_app/providers/pdf_controller.dart';
import 'package:native_app/objects/single_model_query.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/full_screen.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/helpers/contextual_translation.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/helpers/file_utils.dart';
import 'download.dart';
import 'drawer.dart';

class QuranBookItem extends ConsumerWidget {
  const QuranBookItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    String currentLang = Localizations.localeOf(context).languageCode;
    var textTheme = Theme.of(context).textTheme;

    var query = SingleModelQuery(
      repository: ref.quranBooks,
      id: QR.params['id'].toString(),
    );

    var modelQuery = ref.watch(singleModelProvider(query));

    return modelQuery.when(
      loading: () => const FullScreen(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (book) {
        String bookTitle = contextualTranslation(
          locale: currentLang,
          enText: book.title,
          bnText: book.titleBn,
        );

        if (book.document != null) {
          var pdfCtrl = ref.watch(pdfControllerProvider(book.document));

          return pdfCtrl.when(
            loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            error: (error, stackTrace) => Text(error.toString()),
            data: (pdfController) {
              final GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();

              return AppScaffold(
                scaffoldKey: sKey,
                title: Text(bookTitle),
                body: ItemContent(
                  children: [
                    Container(
                      height: 600,
                      margin: const EdgeInsets.only(bottom: 40),
                      child: PdfView(
                        controller: pdfController,
                        builders: PdfViewBuilders<DefaultBuilderOptions>(
                          options: const DefaultBuilderOptions(),
                          documentLoaderBuilder: (BuildContext context) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                drawer: Drawer(
                  child: QuranDrawer(pdfController: pdfController),
                ),
                bottomBar: BottomBar(
                  alignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: GestureDetector(
                        onTap: () => sKey.currentState!.openDrawer(),
                        child: SvgPicture.asset(
                          'assets/images/icons/menu.svg',
                          fit: BoxFit.scaleDown,
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ),
                    QuranDownload(
                      filePath: book.document['id'],
                      fileUrl: fileSrcUrl(book.document),
                    )
                  ],
                ),
              );
            },
          );
        } else {
          return AppScaffold(
            title: Text(bookTitle),
            body: Center(
              child: Text(locales.noContent, style: textTheme.labelLarge),
            ),
          );
        }
      },
    );
  }
}
