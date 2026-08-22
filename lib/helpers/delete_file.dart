import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/l10n/app_localizations.dart';
import 'package:native_app/providers/check_downloaded_file.dart';
import 'package:native_app/helpers/file_fallback_path.dart';
import 'package:native_app/helpers/delete_file_diretory.dart';
import 'package:native_app/theme/app_theme_color.dart';

Future deleteFile({
  required BuildContext context,
  required WidgetRef ref,
  required String filePath,
  Function()? callback,
}) async {
  var locales = AppLocalizations.of(context)!;
  var textTheme = Theme.of(context).textTheme;
  final colors = Theme.of(context).extension<AppThemeColors>()!;

  Widget cancelButton = TextButton(
    child: Text(locales.no, style: textTheme.labelLarge),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  Widget continueButton = TextButton(
    child: Text(
      locales.yes,
      style: textTheme.labelLarge?.copyWith(color: colors.primary),
    ),
    onPressed: () async {
      Navigator.of(context).pop();

      var path = await fileFallbackPath(filePath);

      // The file may already be gone — cleared by the OS, removed by hand, or
      // left behind by a download that never finished. Removing it is the only
      // step that depends on it still being there; the bookkeeping below has to
      // run either way, or the entry stays in the downloads list with nothing
      // behind it and no way to get rid of it.
      if (path != null) {
        try {
          await deleteFileDirectory(path);
        } catch (error, stackTrace) {
          debugPrint('deleteFile: removing $path failed: $error\n$stackTrace');
        }
      }

      await ref
          .read(checkDownloadedFileProvider(filePath).notifier)
          .check(filePath);

      if (callback != null) {
        await callback();
      }
    },
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(locales.fileDelete),
        content: Text(
          locales.doYouWantToDeleteFile,
          style: textTheme.labelMedium,
        ),
        actions: [
          cancelButton,
          continueButton,
        ],
      );
    },
  );
}
