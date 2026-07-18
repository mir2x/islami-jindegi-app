import 'dart:io' show Platform;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:open_filex/open_filex.dart';
import 'package:native_app/providers/check_downloaded_file.dart';
import 'package:native_app/widgets/utils/with_connectivity.dart';
import 'package:native_app/helpers/file_fallback_path.dart';
import 'package:native_app/helpers/delete_file.dart';
import 'package:native_app/helpers/file_size.dart';
import 'package:native_app/objects/progress_percentage.dart';
import 'package:native_app/theme/app_theme_color.dart';

class DownloadItem extends ConsumerStatefulWidget {
  const DownloadItem({
    super.key,
    required this.filePath,
    required this.fileUrl,
    this.downloadCallback,
    this.deleteCallback,
  });

  final String filePath;
  final String fileUrl;
  final Future? Function()? downloadCallback;
  final Future? Function()? deleteCallback;

  @override
  ConsumerState<DownloadItem> createState() => _DownloadItemState();
}

class _DownloadItemState extends ConsumerState<DownloadItem> {
  final _progressNotifier = ProgressPercentage();
  CancelToken _cancelToken = CancelToken();

  @override
  void dispose() {
    _progressNotifier.dispose();
    super.dispose();
  }

  Future<void> _startDownload() async {
    // Fresh token each attempt (old token may be cancelled)
    _cancelToken = CancelToken();
    _progressNotifier.update({});

    try {
      var dir = Platform.isAndroid
          ? await getExternalStorageDirectory()
          : await getApplicationSupportDirectory();

      if (dir == null || !mounted) return;

      await Dio().download(
        widget.fileUrl,
        p.join(dir.path, widget.filePath),
        cancelToken: _cancelToken,
        onReceiveProgress: (received, total) {
          if (!_cancelToken.isCancelled && total != -1) {
            _progressNotifier.update({'received': received, 'total': total});
          }
        },
      );

      if (!mounted) return;
      _progressNotifier.update({});

      await ref
          .read(checkDownloadedFileProvider(widget.filePath).notifier)
          .check(widget.filePath);

      if (widget.downloadCallback != null) {
        await widget.downloadCallback!();
      }
    } on DioException catch (e) {
      if (!mounted) return;
      _progressNotifier.update({});
      if (!CancelToken.isCancel(e)) {
        var locales = AppLocalizations.of(context)!;
        var textTheme = Theme.of(context).textTheme;
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(locales.errorTitle),
            content:
                Text(locales.downloadErrorMsg, style: textTheme.labelMedium),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var checkFileProvider = checkDownloadedFileProvider(widget.filePath);
    var checkDownloadedFile = ref.watch(checkFileProvider);

    return checkDownloadedFile.when(
      loading: () => const SizedBox.shrink(),
      error: (error, _) => const SizedBox.shrink(),
      data: (isDownloaded) {
        if (isDownloaded) {
          return _DownloadedCard(
            filePath: widget.filePath,
            deleteCallback: widget.deleteCallback,
          );
        }

        return WithConnectivity(
          builder: (context, isConnected) {
            if (!isConnected) return const SizedBox.shrink();

            return _DownloadCard(
              progressNotifier: _progressNotifier,
              onCancel: () => _cancelToken.cancel(),
              onDownload: _startDownload,
            );
          },
        );
      },
    );
  }
}

class _DownloadCard extends StatelessWidget {
  const _DownloadCard({
    required this.progressNotifier,
    required this.onCancel,
    required this.onDownload,
  });

  final ProgressPercentage progressNotifier;
  final VoidCallback onCancel;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    var textTheme = Theme.of(context).textTheme;
    final isClassic = colors.primary == AppThemeColors.classic.primary &&
        colors.appBarBg == AppThemeColors.classic.appBarBg;
    final actionColor = isClassic ? colors.appBarBg : colors.active;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: colors.highlight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.divider),
      ),
      child: ValueListenableBuilder<Map>(
        valueListenable: progressNotifier,
        builder: (context, progress, _) {
          final downloading = progress.isNotEmpty;

          if (downloading) {
            final received = progress['received'] as int;
            final total = progress['total'] as int;
            final ratio = total > 0 ? received / total : 0.0;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.download_rounded,
                        color: actionColor,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${fileSize(received)} / ${fileSize(total)}',
                          style: textTheme.labelSmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: onCancel,
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: colors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: ratio,
                    backgroundColor: colors.divider,
                    valueColor: AlwaysStoppedAnimation<Color>(actionColor),
                    borderRadius: BorderRadius.circular(4),
                    minHeight: 4,
                  ),
                ],
              ),
            );
          }

          return InkWell(
            onTap: onDownload,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.download_rounded, color: actionColor, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    locales.download,
                    style: textTheme.labelLarge?.copyWith(
                      color: colors.primaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DownloadedCard extends ConsumerWidget {
  const _DownloadedCard({
    required this.filePath,
    this.deleteCallback,
  });

  final String filePath;
  final Future? Function()? deleteCallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    var textTheme = Theme.of(context).textTheme;
    final isClassic = colors.primary == AppThemeColors.classic.primary &&
        colors.appBarBg == AppThemeColors.classic.appBarBg;
    final actionColor = isClassic ? colors.appBarBg : colors.active;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: colors.highlight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.divider),
      ),
      child: Row(
        children: [
          Icon(Icons.download_done_rounded, color: actionColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              locales.downloaded,
              style: textTheme.labelLarge?.copyWith(
                color: colors.primaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.file_open_outlined,
              color: colors.secondaryText,
              size: 22,
            ),
            onPressed: () async {
              var path = await fileFallbackPath(filePath);
              var downloadDir = Platform.isAndroid
                  ? await getExternalStorageDirectory()
                  : await getApplicationSupportDirectory();
              if (downloadDir != null && path != null) {
                await OpenFilex.open(p.join(downloadDir.path, path));
              }
            },
          ),
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: colors.secondaryText,
              size: 22,
            ),
            onPressed: () async {
              await deleteFile(
                context: context,
                ref: ref,
                filePath: filePath,
                callback: deleteCallback,
              );
            },
          ),
        ],
      ),
    );
  }
}
