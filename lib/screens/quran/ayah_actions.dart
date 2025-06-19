import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:flutter/services.dart';
import 'package:html/parser.dart';
import 'package:share_plus/share_plus.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/single_model.dart';
import 'package:native_app/objects/single_model_query.dart';
import 'package:native_app/helpers/contextual_translation.dart';
import 'package:native_app/providers/ayah_bookmarks.dart';

class AyahActions extends ConsumerWidget {
  const AyahActions({
    super.key,
    required this.ayah,
  });

  final dynamic ayah;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    String currentLang = Localizations.localeOf(context).languageCode;
    var numFormatter = NumberFormat('#', currentLang);

    return PopupMenuButton<int>(
      child: const SizedBox(
        width: 50,
        height: 40,
        child: Icon(
          Icons.more_horiz,
        ),
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        PopupMenuItem<int>(
          value: 0,
          child: Text(
            locales.readTafseer,
            style: textTheme.labelMedium,
          ),
        ),
        PopupMenuItem<int>(
          value: 1,
          child: Text(
            locales.saveAyah,
            style: textTheme.labelMedium,
          ),
        ),
        PopupMenuItem<int>(
          value: 2,
          child: Text(
            locales.copyAyah,
            style: textTheme.labelMedium,
          ),
        ),
        PopupMenuItem<int>(
          value: 3,
          child: Text(
            locales.share,
            style: textTheme.labelMedium,
          ),
        ),
      ],
      onSelected: (int item) async {
        switch (item) {
          case 0:
            QR.to('quran/tafseers/${ayah.id}');
            break;
          case 1:
            var query = SingleModelQuery(
              repository: ref.ayahs,
              id: ayah.id,
              params: const {'include': 'surah,ayah-translations'},
            );

            var reloadedAyah = await ref.read(
              singleModelProvider(query).future,
            );

            await ref.read(ayahBookmarkProvider(ayah.id).notifier).createItem({
              'ayahId': ayah.id,
              'title': ayah.title,
              if (ayah.ayahTranslations.isNotEmpty) ...{
                'translation': reloadedAyah.ayahTranslations.first.body,
              },
              'position': ayah.surahPosition,
              'surahId': reloadedAyah.surah.id,
              'surahTitle': reloadedAyah.surah.value.title,
              'surahTitleBn': reloadedAyah.surah.value.titleBn,
            });

            break;
          case 2:
            await Clipboard.setData(ClipboardData(text: ayah.title));
            break;
          case 3:
            var query = SingleModelQuery(
              repository: ref.ayahs,
              id: ayah.id,
              params: const {'include': 'surah,ayah-translations'},
            );

            var reloadedAyah = await ref.read(
              singleModelProvider(query).future,
            );

            String surahTitle = contextualTranslation(
              locale: currentLang,
              enText: reloadedAyah.surah.value.title,
              bnText: reloadedAyah.surah.value.titleBn,
            );

            String ayahPosition = numFormatter.format(
              ayah.surahPosition,
            );

            var text = ayah.title;

            if (ayah.ayahTranslations.isNotEmpty) {
              final document = parse(ayah.ayahTranslations.first.body);
              List pList = document.querySelectorAll('p');

              if (pList.isNotEmpty) {
                text += '\n\n';
                for (var p in pList) {
                  if (p.text != '') {
                    text += '${p.text}\n\n';
                  }
                }
              }
            }

            text += '\n\n$surahTitle - $ayahPosition';

            await Clipboard.setData(ClipboardData(text: text));

            Share.share(
              text,
              subject: '$surahTitle - $ayahPosition',
            );

            break;
        }
      },
    );
  }
}
