import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:open_filex/open_filex.dart';
import 'package:native_app/helpers/file_fallback_path.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/theme/app_theme.dart';

class OpenFile extends StatelessWidget {
  const OpenFile({
    super.key,
    required this.filePath,
  });

  final String filePath;

  @override
  Widget build(BuildContext context) {
    return WithPreferences(
      builder: (context, preferences) {
        String theme = preferences.getString('theme') ?? 'classic';

        return IconButton(
          icon: const Icon(Icons.file_open),
          color: AppTheme.titleContrastColor[theme],
          onPressed: () async {
            var path = await fileFallbackPath(filePath);

            var downloadDir = Platform.isAndroid
                ? await getExternalStorageDirectory()
                : await getApplicationSupportDirectory();

            if (downloadDir != null && path != null) {
              await OpenFilex.open(
                p.join(downloadDir.path, path),
              );
            }
          },
        );
      },
    );
  }
}
