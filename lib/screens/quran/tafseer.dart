import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/quran_settings.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/providers/single_model.dart';
import 'package:native_app/objects/single_model_query.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/utils/html_text.dart';
import 'package:native_app/widgets/buttons/dropdown.dart';
import 'package:native_app/widgets/presentation/section_title.dart';

class Tafseer extends ConsumerWidget {
  const Tafseer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;

    var query = SingleModelQuery(
      repository: ref.ayahs,
      id: QR.params['ayah_id'].toString(),
    );

    var ayahQuery = ref.watch(singleModelProvider(query));

    return AppScaffold(
      title: Text(locales.tafseer),
      body: ayahQuery.when(
        loading: () => const FullScreenLoader(),
        error: (error, _) => ModelExeptionHandler(error: error),
        data: (ayah) {
          return ItemContent(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 5),
                child: Text(
                  locales.ayah,
                  style: textTheme.headlineMedium,
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 30),
                child: Text(
                  ayah.title,
                  textDirection: TextDirection.rtl,
                  style: textTheme.headlineMedium,
                ),
              ),
              const SelectQitab(),
              const TafseerDisplay(),
            ],
          );
        },
      ),
    );
  }
}

class TafseerDisplay extends ConsumerWidget {
  const TafseerDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var qSettings = ref.watch(quranSettingsProvider);

    var query = AllModelsQuery(
      repository: ref.tafseers,
      params: {
        'ayahId': QR.params['ayah_id'].toString(),
        'tafseerQitabId': qSettings['qitab'],
        'quantity': 1,
      },
    );

    var modelQuery = ref.watch(allModelsProvider(query));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (qSettings.containsKey('qitab')) ...[
          Container(
            margin: const EdgeInsets.only(top: 30, bottom: 10),
            child: Text(
              locales.tafseer,
              style: textTheme.headlineMedium,
            ),
          ),
          modelQuery.when(
            loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            error: (error, _) => Text(error.toString()),
            data: (resources) {
              if (resources.isNotEmpty) {
                var item = resources[0];

                return Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  child: HtmlText(
                    text: item.body,
                  ),
                );
              } else {
                return Text(locales.noContent);
              }
            },
          ),
        ] else ...[
          Container(
            margin: const EdgeInsets.only(top: 15),
            child: Text(locales.selectTafseer),
          ),
        ]
      ],
    );
  }
}

class SelectQitab extends ConsumerWidget {
  const SelectQitab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var qSettings = ref.watch(quranSettingsProvider);

    var qNotifier = ref.read(quranSettingsProvider.notifier);
    var qitabQuery = ref.watch(
      allModelsProvider(AllModelsQuery(repository: ref.tafseerQitabs)),
    );
    String? selectedQitab = qSettings['qitab'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionTitle(title: locales.tafseerQitabs),
            qitabQuery.when(
              loading: () {
                return Center(
                  child: Container(
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.only(top: 10),
                    child: const CircularProgressIndicator(),
                  ),
                );
              },
              error: (error, _) => Text(error.toString()),
              data: (resources) {
                var qitabs = resources
                    .map<Map<String, String>>(
                      (r) => {'label': r.title, 'value': r.id},
                    )
                    .toList();

                return Dropdown(
                  items: qitabs,
                  selectedValue: selectedQitab,
                  updateItem: (value) {
                    qNotifier.updateSettings('qitab', value!);
                  },
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
