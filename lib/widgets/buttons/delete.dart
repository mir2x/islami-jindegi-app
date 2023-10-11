import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/providers/check_downloaded_file.dart';
import 'package:native_app/providers/local_file.dart';
import 'package:native_app/theme/colors.dart';

class DeleteButton extends ConsumerWidget {
  const DeleteButton({
    super.key,
    required this.filePath,
  });

  final String filePath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;

    return IconButton(
      icon: const Icon(
        Icons.delete,
        color: ThemeColors.danger,
      ),
      iconSize: 30,
      color: Colors.red,
      onPressed: () async {
        Widget cancelButton = TextButton(
          child: Text(locales.no, style: textTheme.labelLarge),
          onPressed: () {
            Navigator.of(context).pop();
          },
        );

        Widget continueButton = TextButton(
          child: Text(
            locales.yes,
            style: textTheme.labelLarge?.copyWith(color: Colors.red),
          ),
          onPressed: () async {
            Navigator.of(context).pop();

            var localFile = await ref.watch(
              localFileProvider(filePath).future,
            );

            if (localFile != null) {
              await localFile.delete();
              await ref
                  .read(checkDownloadedFileProvider(filePath).notifier)
                  .check(filePath);
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
      },
    );
  }
}
