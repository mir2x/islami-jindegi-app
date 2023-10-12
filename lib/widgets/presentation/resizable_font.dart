import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/objects/font_size_ratio.dart';

class ResizableFont extends ConsumerWidget {
  const ResizableFont({
    super.key,
    required this.storeKey,
    required this.builder,
  });

  final String storeKey;
  final Widget Function(BuildContext context, FontSizeRatio ratio) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WithPreferences(
      builder: (context, preferences) {
        var fontSizeRatio =
            FontSizeRatio(value: preferences.getDouble(storeKey));

        return builder(context, fontSizeRatio);
      },
    );
  }
}
