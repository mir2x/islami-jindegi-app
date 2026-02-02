import 'package:flutter_riverpod/flutter_riverpod.dart';

final arabicFontProvider = StateProvider<String>((ref) => 'arabic/noorehuda');
final arabicFontSizeProvider = StateProvider<double>((ref) => 32.0);

final bengaliFontProvider =
    StateProvider<String>((ref) => 'bangla/solaimanlipi');
final bengaliFontSizeProvider = StateProvider<double>((ref) => 16.0);
