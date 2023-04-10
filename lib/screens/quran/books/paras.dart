import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pdfx/pdfx.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/helpers/contextual_translation.dart';
import 'package:native_app/theme/colors.dart';

class QuranBookParas extends ConsumerWidget {
  const QuranBookParas({
    super.key,
    required this.pdfController,
  });

  final PdfController pdfController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var query = AllModelsQuery(
      repository: ref.paras,
      params: const {'quantity': 30},
    );

    var modelQuery = ref.watch(allModelsProvider(query));

    return Container(
      child: modelQuery.when(
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (error, _) => Text(error.toString()),
        data: (resources) {
          return StatefulParas(
            paras: resources,
            pdfController: pdfController,
          );
        },
      ),
    );
  }
}

class StatefulParas extends StatefulWidget {
  const StatefulParas({
    super.key,
    required this.paras,
    required this.pdfController,
  });

  final List paras;
  final PdfController pdfController;

  @override
  State<StatefulParas> createState() => _ParasState();
}

class _ParasState extends State<StatefulParas> {
  dynamic selectedPara;

  @override
  void initState() {
    super.initState();

    selectedPara = widget.paras.first;
  }

  updateSelectedPara(para) {
    setState(() {
      selectedPara = para;
    });
  }

  @override
  Widget build(BuildContext context) {
    String currentLang = Localizations.localeOf(context).languageCode;
    var numFormatter = NumberFormat('#', currentLang);
    var textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(color: ThemeColors.color7, width: 0.5),
                ),
              ),
              child: ListView.builder(
                itemCount: widget.paras.length,
                itemBuilder: (BuildContext context, int index) {
                  var item = widget.paras[index];

                  String paraTitle = contextualTranslation(
                    locale: currentLang,
                    enText: item.title,
                    bnText: item.titleBn,
                  );

                  return GestureDetector(
                    onTap: () => updateSelectedPara(item),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: selectedPara.id == item.id
                            ? ThemeColors.color7
                            : null,
                      ),
                      child: Row(
                        children: [
                          Text(paraTitle, style: textTheme.titleMedium),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: 20,
              itemBuilder: (BuildContext context, int index) {
                var number = index + 1;

                return GestureDetector(
                  onTap: () {
                    widget.pdfController.jumpToPage(number);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: ThemeColors.color7,
                        width: 0.5,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 10,
                    ),
                    child: Text(
                      numFormatter.format(number),
                      style: textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
