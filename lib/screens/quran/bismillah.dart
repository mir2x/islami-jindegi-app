import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/providers/quran_settings.dart';

class Bismillah extends ConsumerWidget {
  const Bismillah({
    super.key,
    required this.chapter,
  });

  final dynamic chapter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTheme = Theme.of(context).textTheme;
    var qSettings = ref.watch(quranSettingsProvider);

    if (chapter.position != 9 || chapter.runtimeType.toString() != 'Surah') {
      return Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 15,
              bottom: 10,
              left: 15,
              right: 15,
            ),
            child: Text(
              'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِیْمِ',
              textAlign: TextAlign.right,
              softWrap: false,
              style: textTheme.headlineLarge?.copyWith(
                fontFamily: 'arabic/al-qalam',
              ),
            ),
          ),
          if (qSettings.containsKey('language')) ...[
            Container(
              padding: const EdgeInsets.only(bottom: 5, left: 15, right: 15),
              child: Text(
                (qSettings['language'] == 'en-gb')
                    ? 'In the name of Allah, Most Gracious, Most Merciful.'
                    : 'পরম করুণাময় অসীম দয়ালু মহান আল্লাহ্‌র নামে শুরু করছি।',
              ),
            )
          ],
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
