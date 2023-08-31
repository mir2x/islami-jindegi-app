import 'package:flutter/material.dart';

class ProgressPercentage extends ValueNotifier<double> {
  ProgressPercentage() : super(0);

  void update(double val) {
    value = val;
  }
}
