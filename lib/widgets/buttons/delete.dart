import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    return IconButton(
      icon: const Icon(
        Icons.delete,
        color: ThemeColors.danger,
      ),
      iconSize: 30,
      color: Colors.red,
      onPressed: () async {
        var localFile = await ref.read(
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
  }
}
