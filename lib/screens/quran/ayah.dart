import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Ayah extends StatelessWidget {
  const Ayah({
    super.key,
    required this.ayah,
  });

  final dynamic ayah;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              ayah.title,
              textAlign: TextAlign.right,
              style: textTheme.headlineMedium?.copyWith(
                fontFamily: 'arabic/al-qalam',
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 15),
            width: 50,
            height: 42,
            child: Stack(
              children: [
                SvgPicture.asset(
                  'assets/images/icons/ayah-symbol.svg',
                  fit: BoxFit.scaleDown,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    ayah.surahPosition.toString(),
                    style: textTheme.titleMedium,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
