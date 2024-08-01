import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/helpers/delete_file.dart';
import 'package:native_app/theme/colors.dart';

class PDFMenu extends ConsumerWidget {
  const PDFMenu({
    super.key,
    required this.filePath,
    required this.darkMode,
    required this.landscape,
    required this.toggleMode,
    required this.toggleOrientation,
    this.deleteCallback,
  });

  final String filePath;
  final bool darkMode;
  final bool landscape;
  final void Function() toggleMode;
  final void Function() toggleOrientation;
  final Future? Function()? deleteCallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;

    return PopupMenuButton<int>(
      child: const SizedBox(
        width: 45,
        height: 50,
        child: Icon(
          Icons.more_vert,
        ),
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        PopupMenuItem<int>(
          value: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                locales.deleteFile,
                style: textTheme.labelMedium,
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.delete,
                color: ThemeColors.danger,
              ),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                locales.switchMode,
                style: textTheme.labelMedium,
              ),
              const SizedBox(width: 10),
              Icon(
                Icons.dark_mode,
                color: darkMode ? Colors.white : Colors.black,
              ),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                landscape ? locales.portrait : locales.landscape,
                style: textTheme.labelMedium,
              ),
              const SizedBox(width: 10),
              Icon(
                landscape
                    ? Icons.stay_primary_portrait
                    : Icons.stay_primary_landscape,
              ),
            ],
          ),
        ),
      ],
      onSelected: (int item) {
        switch (item) {
          case 0:
            deleteFile(
              context: context,
              ref: ref,
              filePath: filePath,
              callback: deleteCallback,
            );
            break;
          case 1:
            toggleMode();
            break;
          case 2:
            toggleOrientation();
            break;
        }
      },
    );
  }
}
