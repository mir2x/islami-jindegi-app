import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/quran_settings.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/widgets/filter/list.dart';
import 'package:native_app/widgets/filter/item.dart';
import 'package:native_app/helpers/contextual_translation.dart';

class QariList extends ConsumerWidget {
  const QariList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String currentLang = Localizations.localeOf(context).languageCode;
    var locales = AppLocalizations.of(context)!;

    return FilterList(
      title: locales.qaris,
      paramKeys: const ['qari'],
      queryProvider: quranSettingsProvider,
      queryBuilder: (Map<String, dynamic> params) {
        return AllModelsQuery(
          repository: ref.qaris,
          params: {...params, 'offline': true},
        );
      },
      itemBuilder: (_, item, __) {
        return FilterItem(
          itemId: item.slug,
          itemTitle: contextualTranslation(
            locale: currentLang,
            enText: item.name,
            bnText: item.nameBn,
          ),
          paramKey: 'qari',
          queryProvider: quranSettingsProvider,
        );
      },
    );
  }
}
