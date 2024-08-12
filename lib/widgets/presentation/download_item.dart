import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:open_filex/open_filex.dart';
import 'package:native_app/providers/check_downloaded_file.dart';
import 'package:native_app/widgets/utils/with_connectivity.dart';
import 'package:native_app/widgets/buttons/delete.dart';
import 'package:native_app/widgets/buttons/download.dart';
import 'package:native_app/helpers/file_fallback_path.dart';
import 'description_item.dart';

class DownloadItem extends ConsumerWidget {
  const DownloadItem({
    super.key,
    required this.filePath,
    required this.fileUrl,
    this.textWidth = 120,
    this.downloadedTextWidth,
    this.downloadCallback,
    this.deleteCallback,
  });

  final String filePath;
  final String fileUrl;
  final double textWidth;
  final double? downloadedTextWidth;
  final Future? Function()? downloadCallback;
  final Future? Function()? deleteCallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var checkFileProvider = checkDownloadedFileProvider(filePath);
    var checkDownloadedFile = ref.watch(checkFileProvider);

    return checkDownloadedFile.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text(error.toString()),
      data: (isDownloaded) {
        if (isDownloaded) {
          return DescriptionItem(
            title: '${locales.downloaded}:',
            description: Container(
              padding: const EdgeInsets.all(8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: const Icon(
                        Icons.download_done,
                        size: 35,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.file_open),
                      iconSize: 30,
                      onPressed: () async {
                        var path = await fileFallbackPath(filePath);

                        var downloadDir = Platform.isAndroid
                            ? await getExternalStorageDirectory()
                            : await getApplicationSupportDirectory();

                        if (downloadDir != null && path != null) {
                          await OpenFilex.open(
                            p.join(downloadDir.path, path),
                          );
                        }
                      },
                    ),
                    DeleteButton(filePath: filePath, callback: deleteCallback),
                  ],
                ),
              ),
            ),
            alignment: CrossAxisAlignment.center,
            textWidth: downloadedTextWidth ?? textWidth,
          );
        } else {
          return WithConnectivity(
            builder: (context, isConnected) {
              if (isConnected) {
                return DescriptionItem(
                  title: '${locales.download}:',
                  description: Align(
                    alignment: Alignment.centerLeft,
                    child: DownloadButton(
                      filePath: filePath,
                      fileUrl: fileUrl,
                      callback: downloadCallback,
                    ),
                  ),
                  alignment: CrossAxisAlignment.center,
                  textWidth: textWidth,
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          );
        }
      },
    );
  }
}
