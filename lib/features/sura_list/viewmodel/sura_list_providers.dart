import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Stores the sura number that was last viewed.
/// Used for scroll + highlight animation when navigating back to sura list.
final lastViewedSuraProvider = StateProvider<int?>((ref) => null);
