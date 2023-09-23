import 'package:flutter/material.dart';

class FontSizeRatio extends ValueNotifier<double> {
  FontSizeRatio({double? value}) : super(value ?? 1.0);

  double increment() {
    if (value < 1.5) {
      value += 0.1;
    }

    return value;
  }

  double decrement() {
    if (value > 0.8) {
      value -= 0.1;
    }

    return value;
  }
}
