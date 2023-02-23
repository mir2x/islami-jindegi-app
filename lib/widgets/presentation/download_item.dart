import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:native_app/providers/check_downloaded_file.dart';
import 'package:native_app/objects/downloader.dart';
import 'package:native_app/helpers/file_utils.dart';
import 'package:native_app/theme/colors.dart';
import 'description_item.dart';

class DownloadItem extends ConsumerWidget {
  const DownloadItem({
    super.key,
    required this.file,
  });

  final Map file;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTheme = Theme.of(context).textTheme;
    var filePath = file['id'];
    var checkFileProvider = checkDownloadedFileProvider(filePath);
    var checkDownloadedFile = ref.watch(checkFileProvider);
    var downloader = Downloader();

    return checkDownloadedFile.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text(error.toString()),
      data: (isFileExists) {
        if (isFileExists) {
          return DescriptionItem(
            title: 'Downloaded:',
            description: Container(
              padding: const EdgeInsets.all(8),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.download_done,
                  size: 35,
                ),
              ),
            ),
            alignment: CrossAxisAlignment.center,
          );
        } else {
          return DescriptionItem(
            title: 'Download:',
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
                        url: fileSrcUrl(file),
                        savePath: filePath,
                      );

                      if (response is Response && response.statusCode == 200) {
                        await ref
                            .read(checkFileProvider.notifier)
                            .check(filePath);
                      } else if (context.mounted) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: ThemeColors.color1,
                              title: const Text('Error!'),
                              content: Text(
                                'There has been a problem while downloading the file. Please check your network connection and try again.',
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
        }
      },
    );
  }
}
