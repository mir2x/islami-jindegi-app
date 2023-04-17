import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:native_app/providers/connectivity_result.dart';
import 'package:native_app/providers/local_file.dart';
import 'package:native_app/objects/downloader.dart';
import 'package:native_app/theme/colors.dart';

class QuranDownload extends ConsumerWidget {
  const QuranDownload({
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
    var localFileProviderWithFile = localFileProvider(filePath);
    var downloadedFileP = ref.watch(localFileProviderWithFile);
    var downloader = Downloader();

    return downloadedFileP.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text(error.toString()),
      data: (downloadedFile) {
        if (downloadedFile != null) {
          return IconButton(
            icon: const Icon(
              Icons.delete,
              color: ThemeColors.danger,
            ),
            iconSize: 30,
            color: Colors.red,
            onPressed: () async {
              var localFile = await ref.read(
                localFileProviderWithFile.future,
              );

              if (localFile != null) {
                await localFile.delete();
                await ref
                    .read(localFileProviderWithFile.notifier)
                    .check(filePath);
              }
            },
          );
        } else {
          var connectivity = ref.watch(connectivityResultProvider);

          return connectivity.when(
            loading: () => const CircularProgressIndicator(),
            error: (error, stackTrace) => Text(error.toString()),
            data: (connectivityResult) {
              if (connectivityResult != ConnectivityResult.none) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
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
                    IconButton(
                      iconSize: 30,
                      icon: const Icon(Icons.download),
                      onPressed: () async {
                        var response = await downloader.download(
                          url: fileUrl,
                          savePath: filePath,
                        );

                        if (response is Response &&
                            response.statusCode == 200) {
                          await ref
                              .read(localFileProviderWithFile.notifier)
                              .check(filePath);
                        } else if (context.mounted) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: ThemeColors.color1,
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
                  ],
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
