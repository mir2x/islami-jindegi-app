import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/providers/check_downloaded_file.dart';
import 'package:native_app/helpers/file_fallback_path.dart';
import 'package:native_app/helpers/delete_file_diretory.dart';

Future deleteFile({
  required BuildContext context,
  required WidgetRef ref,
  required String filePath,
  Function()? callback,
}) async {
  var locales = AppLocalizations.of(context)!;
  var textTheme = Theme.of(context).textTheme;

  Widget cancelButton = TextButton(
    child: Text(locales.no, style: textTheme.labelLarge),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  Widget continueButton = TextButton(
    child: Text(
      locales.yes,
      style: textTheme.labelLarge
          ?.copyWith(color: Theme.of(context).colorScheme.error),
    ),
    onPressed: () async {
      Navigator.of(context).pop();

      var path = await fileFallbackPath(filePath);

      if (path != null) {
        await deleteFileDirectory(path);
        await ref
            .read(checkDownloadedFileProvider(filePath).notifier)
            .check(filePath);

        if (callback != null) {
          await callback();
        }
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
