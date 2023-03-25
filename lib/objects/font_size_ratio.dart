import 'package:flutter/material.dart';

class FontSizeRatio extends ValueNotifier<double> {
  FontSizeRatio() : super(1.0);

  void increment() {
    if (value < 1.6) {
      value += 0.2;
    }
  }

  void decrement() {
    if (value > 0.8) {
      value -= 0.2;
    }
  }
}
