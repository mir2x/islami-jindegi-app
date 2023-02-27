import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/widgets/image/static_image.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';
import 'package:native_app/widgets/presentation/description_item.dart';
import 'package:native_app/widgets/presentation/download_item.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/helpers/file_utils.dart';

class QuranDownload extends ConsumerWidget {
  const QuranDownload({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTheme = Theme.of(context).textTheme;
    String assetPath = 'al-quran/qitabs/al-quran-kolkata.pdf';

    return MyScaffold(
      title: const Text('Quran in PDF'),
      body: ItemContent(
        children: [
          const StaticImage(
            image: 'assets/al-quran/images/al-quran-kolkata/al-quran-kolkata',
            width: 1200,
            height: 1756,
          ),
          const SizedBox(height: 40),
          DescriptionItem(
            title: 'Title:',
            description: Text(
              'Sahih Nurani Quran Sharif',
              style: textTheme.labelMedium,
            ),
          ),
          DescriptionItem(
            title: 'File Size:',
            description: Text(
              '21.17 MB',
              style: textTheme.labelMedium,
            ),
          ),
          DownloadItem(
            filePath: 'assets/$assetPath',
            fileUrl: externalAssetUrl(assetPath),
          ),
        ],
      ),
    );
  }
}
