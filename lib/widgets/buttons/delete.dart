import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/helpers/delete_file.dart';
import 'package:native_app/theme/colors.dart';

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
    return IconButton(
      icon: const Icon(
        Icons.delete,
        color: ThemeColors.danger,
      ),
      iconSize: 30,
      color: Colors.red,
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
