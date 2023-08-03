import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:native_app/providers/check_downloaded_file.dart';
import 'package:native_app/objects/downloader.dart';
import 'package:native_app/theme/colors.dart';

class DownloadButton extends ConsumerWidget {
  const DownloadButton({
    super.key,
    required this.filePath,
    required this.fileUrl,
  });

  final String filePath;
  final String fileUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var downloader = Downloader();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          iconSize: 35,
          icon: const Icon(Icons.download),
          onPressed: () async {
            var response = await downloader.download(
              url: fileUrl,
              savePath: filePath,
            );

            if (response is Response && response.statusCode == 200) {
              await ref
                  .read(checkDownloadedFileProvider(filePath).notifier)
                  .check(filePath);
            } else if (context.mounted) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(locales.errorTitle),
                    content: Text(
                      locales.downloadErrorMsg,
                      style: textTheme.labelMedium,
                    ),
                  );
                },
              );
            }
          },
        ),
        Container(
          width: 100,
          margin: const EdgeInsets.only(left: 15),
          child: ValueListenableBuilder<double>(
            valueListenable: downloader.progressNotifier,
            builder: (context, percent, child) {
              if (percent > 0) {
                return LinearProgressIndicator(
                  backgroundColor: ThemeColors.color3,
                  value: percent,
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ],
    );
  }
}
