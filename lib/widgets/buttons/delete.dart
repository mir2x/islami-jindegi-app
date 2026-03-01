import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/helpers/delete_file.dart';

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
    var colorScheme = Theme.of(context).colorScheme;

    return IconButton(
      icon: Icon(
        Icons.delete,
        color: colorScheme.error,
      ),
      iconSize: 30,
      color: colorScheme.error,
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
