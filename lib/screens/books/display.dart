import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/widgets/presentation/description_item.dart';
import 'pdf_reader.dart';

class BookDisplay extends ConsumerWidget {
  const BookDisplay({
    super.key,
    required this.id,
    required this.title,
    required this.excerpt,
    required this.publisher,
    required this.price,
    required this.image,
    required this.document,
    required this.publishedAt,
    required this.downloadItem,
  });

  final String id;
  final String title;
  final String? excerpt;
  final String? publisher;
  final String? price;
  final Widget image;
  final Map? document;
  final String? publishedAt;
  final Widget? downloadItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        if (document != null) ...[
          PDFReader(
            bookId: id,
            bookTitle: title,
            image: image,
            document: document!,
          ),
        ],
        if (downloadItem != null) ...[
          downloadItem!,
        ],
        if (publisher != null) ...[
          DescriptionItem(
            title: '${locales.publisher}:',
            description: Text(
              publisher!,
              style: textTheme.labelMedium,
            ),
          ),
        ],
        if (publishedAt != null) ...[
          DescriptionItem(
            title: '${locales.publicationDate}:',
            description: Text(
              publishedAt!,
              style: textTheme.labelMedium,
            ),
          ),
        ],
        if (price != null) ...[
          DescriptionItem(
            title: '${locales.price}:',
            description: Text(
              price!,
              style: textTheme.labelMedium,
            ),
          ),
        ],
      ],
    );
  }
}
