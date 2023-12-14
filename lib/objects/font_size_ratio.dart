import 'package:flutter/material.dart';

class FontSizeRatio extends ValueNotifier<double> {
  FontSizeRatio({double? value}) : super(value ?? 1.0);

  double increment() {
    if (value < 2.2) {
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
