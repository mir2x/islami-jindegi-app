import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/single_model.dart';
import 'package:native_app/objects/single_model_query.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/full_screen.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/responsive/image.dart';
import 'package:native_app/widgets/document/pdf_reader.dart';
import 'package:native_app/helpers/contextual_translation.dart';

class QuranBookItem extends ConsumerWidget {
  const QuranBookItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String currentLang = Localizations.localeOf(context).languageCode;

    var query = SingleModelQuery(
      repository: ref.quranBooks,
      id: QR.params['id'].toString(),
    );

    var modelQuery = ref.watch(singleModelProvider(query));

    return modelQuery.when(
      loading: () => const FullScreen(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (book) {
        double screenWidth = MediaQuery.of(context).size.width;

        String bookTitle = contextualTranslation(
          locale: currentLang,
          enText: book.title,
          bnText: book.titleBn,
        );

        return AppScaffold(
          title: Text(bookTitle),
          body: ItemContent(
            children: [
              if (book.document != null) ...[
                Container(
                  height: 600,
                  margin: const EdgeInsets.only(bottom: 40),
                  child: PDFReader(document: book.document),
                ),
              ] else ...[
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  width: screenWidth / 2,
                  child: ResponsiveImage(
                    image: book.image,
                    model: 'book',
                    vwset: const {'xs': 50},
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
