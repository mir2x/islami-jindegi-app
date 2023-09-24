import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:native_app/providers/downloader.dart';
import 'package:native_app/providers/check_downloaded_file.dart';
import 'package:native_app/providers/preferences.dart';
import 'package:native_app/objects/progress_percentage.dart';
import 'package:native_app/objects/download_params.dart';
import 'package:native_app/theme/colors.dart';

class DownloadButton extends ConsumerWidget {
  const DownloadButton({
    super.key,
    required this.filePath,
    required this.fileUrl,
    this.direction = 'row',
  });

  final String filePath;
  final String fileUrl;
  final String direction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var progressNotifier = ProgressPercentage();

    if (direction == 'column') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DownloadIcon(
            filePath: filePath,
            fileUrl: fileUrl,
            progressNotifier: progressNotifier,
          ),
          DownloadProgress(progressNotifier: progressNotifier),
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DownloadIcon(
            filePath: filePath,
            fileUrl: fileUrl,
            progressNotifier: progressNotifier,
          ),
          DownloadProgress(progressNotifier: progressNotifier),
        ],
      );
    }
  }
}

class DownloadIcon extends ConsumerWidget {
  const DownloadIcon({
    super.key,
    required this.filePath,
    required this.fileUrl,
    required this.progressNotifier,
  });

  final String filePath;
  final String fileUrl;
  final ProgressPercentage progressNotifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;

    return IconButton(
      iconSize: 35,
      icon: const Icon(Icons.download),
      onPressed: () async {
        var params = DownloadParams(
          url: fileUrl,
          savePath: filePath,
          downloadProgress: progressNotifier,
        );

        Response? response = await ref.watch(
          downloaderProvider(params).future,
        );

        if (response != null && response.statusCode == 200) {
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
    );
  }
}

class DownloadProgress extends ConsumerWidget {
  const DownloadProgress({
    super.key,
    required this.progressNotifier,
  });

  final ProgressPercentage progressNotifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var prefs = ref.watch(preferencesProvider);

    return prefs.when(
      loading: () => const SizedBox.shrink(),
      error: (error, _) => Text(error.toString()),
      data: (preferences) {
        String theme = preferences.getString('theme') ?? 'dark';

        return SizedBox(
          width: 100,
          child: ValueListenableBuilder<double>(
            valueListenable: progressNotifier,
            builder: (context, percent, child) {
              if (percent > 0) {
                return LinearProgressIndicator(
                  backgroundColor:
                      theme == 'dark' ? ThemeColors.color3 : ThemeColors.color9,
                  value: percent,
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        );
      },
    );
  }
}
