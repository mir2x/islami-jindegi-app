import 'package:flutter/material.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/utils/hijri_date.dart';

class NamazTime extends StatelessWidget {
  const NamazTime({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: const Text('Namaz Time'),
      body: ItemContent(
        children: [
          Center(
            child: HijriDate(),
          ),
        ],
      ),
    );
  }
}
