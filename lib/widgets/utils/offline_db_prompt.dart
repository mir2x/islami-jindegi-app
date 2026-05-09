import 'package:flutter/widgets.dart';

/// Compatibility wrapper for screens that used to show a blocking offline DB
/// prompt. Offline DBs are now prefetched globally in the background.
class OfflineDbPrompt extends StatelessWidget {
  final String feature;
  final Widget child;

  const OfflineDbPrompt({
    super.key,
    required this.feature,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
