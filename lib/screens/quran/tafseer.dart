import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/quran_settings.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/widgets/utils/html_text.dart';
import 'package:native_app/widgets/buttons/dropdown.dart';
import 'package:native_app/widgets/presentation/section_title.dart';

class Tafseer extends ConsumerWidget {
  const Tafseer({
    super.key,
    required this.ayah,
  });

  final dynamic ayah;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTheme = Theme.of(context).textTheme;
    var qSettings = ref.watch(quranSettingsProvider);

    if (qSettings.containsKey('qitab')) {
      var query = AllModelsQuery(
        repository: ref.tafseers,
        params: {
          'ayahId': ayah.id,
          'tafseerQitabId': qSettings['qitab'],
          'quantity': 1,
        },
      );

      var modelQuery = ref.watch(allModelsProvider(query));

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              child: Text(
                'Tafseer',
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
                var item = resources[0];

                return Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  child: HtmlText(
                    text: item.body,
                  ),
                );
              },
            ),
          ],
        ),
      );
    } else {
      var qNotifier = ref.read(quranSettingsProvider.notifier);
      var qitabQuery = ref.watch(
        allModelsProvider(AllModelsQuery(repository: ref.tafseerQitabs)),
      );
      String? selectedQitab = qSettings['qitab'];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: const Text('Select a Tafseer Qitab from Settings'),
          ),
          Container(
            margin: const EdgeInsets.only(top: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SectionTitle(title: 'Tafseer Qitabs'),
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
          ),
        ],
      );
    }
  }
}
