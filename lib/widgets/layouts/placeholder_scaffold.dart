import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_scaffold.dart';

class PlaceholderScaffold extends ConsumerWidget {
  const PlaceholderScaffold({
    super.key,
    required this.body,
    this.bottomBar,
    this.showPattern = false,
  });

  final Widget body;
  final Widget? bottomBar;
  final bool showPattern;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      title: const SizedBox.shrink(),
      body: body,
      bottomBar: bottomBar,
      showPattern: showPattern,
    );
  }
}
