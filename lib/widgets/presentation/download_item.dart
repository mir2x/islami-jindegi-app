import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:open_file/open_file.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:native_app/providers/check_downloaded_file.dart';
import 'package:native_app/providers/connectivity_result.dart';
import 'package:native_app/providers/local_file.dart';
import 'package:native_app/objects/downloader.dart';
import 'package:native_app/theme/colors.dart';
import 'description_item.dart';

class DownloadItem extends ConsumerWidget {
  const DownloadItem({
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
    var checkFileProvider = checkDownloadedFileProvider(filePath);
    var checkDownloadedFile = ref.watch(checkFileProvider);
    var downloader = Downloader();

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
                      icon: const Icon(Icons.open_in_new),
                      iconSize: 30,
                      onPressed: () async {
                        var downloadDir = Platform.isAndroid
                            ? await getExternalStorageDirectory()
                            : await getApplicationSupportDirectory();

                        if (downloadDir != null) {
                          await OpenFile.open(
                            p.join(downloadDir.path, filePath),
                          );
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: ThemeColors.danger,
                      ),
                      iconSize: 30,
                      color: Colors.red,
                      onPressed: () async {
                        var localFile = await ref.read(
                          localFileProvider(filePath).future,
                        );

                        if (localFile != null) {
                          await localFile.delete();
                          await ref
                              .read(checkFileProvider.notifier)
                              .check(filePath);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            alignment: CrossAxisAlignment.center,
          );
        } else {
          var connectivity = ref.watch(connectivityResultProvider);

          return connectivity.when(
            loading: () => const CircularProgressIndicator(),
            error: (error, stackTrace) => Text(error.toString()),
            data: (connectivityResult) {
              if (connectivityResult != ConnectivityResult.none) {
                return DescriptionItem(
                  title: '${locales.download}:',
                  description: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
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

                            if (response is Response &&
                                response.statusCode == 200) {
                              await ref
                                  .read(checkFileProvider.notifier)
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
                    ),
                  ),
                  alignment: CrossAxisAlignment.center,
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
