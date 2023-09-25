import 'package:flutter/material.dart';

class ProgressPercentage extends ValueNotifier<Map> {
  ProgressPercentage() : super({});

  void update(Map val) {
    value = val;
  }
}
