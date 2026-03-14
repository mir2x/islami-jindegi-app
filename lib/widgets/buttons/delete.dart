import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/helpers/delete_file.dart';
import 'package:native_app/theme/app_theme_color.dart';

class DeleteButton extends ConsumerWidget {
  const DeleteButton({
    super.key,
    required this.filePath,
    this.callback,
  });

  final String filePath;
  final Future? Function()? callback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    return IconButton(
      icon: Icon(
        Icons.delete,
        color: colors.primary,
      ),
      iconSize: 30,
      color: colors.primary,
      onPressed: () async {
        await deleteFile(
          context: context,
          ref: ref,
          filePath: filePath,
          callback: callback,
        );
      },
    );
  }
}
