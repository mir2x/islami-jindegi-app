import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:native_app/providers/connectivity_result.dart';
import 'package:native_app/providers/check_downloaded_file.dart';
import 'package:native_app/widgets/buttons/download.dart';
import 'package:native_app/widgets/buttons/delete.dart';

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
    var checkFileProvider = checkDownloadedFileProvider(filePath);
    var checkDownloadedFile = ref.watch(checkFileProvider);

    return checkDownloadedFile.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text(error.toString()),
      data: (isDownloaded) {
        if (isDownloaded) {
          return DeleteButton(filePath: filePath);
        } else {
          var connectivity = ref.watch(connectivityResultProvider);

          return connectivity.when(
            loading: () => const CircularProgressIndicator(),
            error: (error, stackTrace) => Text(error.toString()),
            data: (connectivityResult) {
              if (connectivityResult != ConnectivityResult.none) {
                return DownloadButton(filePath: filePath, fileUrl: fileUrl);
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
