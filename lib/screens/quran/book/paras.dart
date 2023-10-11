import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:pdfx/pdfx.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/providers/preferences.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/helpers/contextual_translation.dart';
import 'package:native_app/theme/colors.dart';

class QuranBookParas extends ConsumerWidget {
  const QuranBookParas({
    super.key,
    required this.book,
    required this.pdfController,
    required this.closeDrawer,
  });

  final dynamic book;
  final PdfController pdfController;
  final Function closeDrawer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;

    var query = AllModelsQuery(
      repository: ref.quranBookParas,
      params: {'quranBookId': book.id, 'include': 'para', 'quantity': 30},
    );

    var modelQuery = ref.watch(allModelsProvider(query));

    return Container(
      child: modelQuery.when(
        loading: () {
          return Center(
            child: Container(
              margin: const EdgeInsets.only(top: 30),
              child: const CircularProgressIndicator(),
            ),
          );
        },
        error: (error, _) => Text(error.toString()),
        data: (resources) {
          if (resources.isNotEmpty) {
            return StatefulParas(
              book: book,
              bookParas: resources,
              pdfController: pdfController,
              closeDrawer: closeDrawer,
            );
          } else {
            return Center(
              child: Container(
                margin: const EdgeInsets.only(top: 35),
                child: Text(locales.noContent),
              ),
            );
          }
        },
      ),
    );
  }
}

class StatefulParas extends ConsumerStatefulWidget {
  const StatefulParas({
    super.key,
    required this.book,
    required this.bookParas,
    required this.pdfController,
    required this.closeDrawer,
  });

  final dynamic book;
  final List bookParas;
  final PdfController pdfController;
  final Function closeDrawer;

  @override
  ConsumerState<StatefulParas> createState() => _ParasState();
}

class _ParasState extends ConsumerState<StatefulParas> {
  dynamic selectedBookPara;

  @override
  void initState() {
    super.initState();

    selectedBookPara = widget.bookParas.first;
  }

  updateSelectedBookPara(para) {
    setState(() {
      selectedBookPara = para;
    });
  }

  @override
  Widget build(BuildContext context) {
    String currentLang = Localizations.localeOf(context).languageCode;
    var numFormatter = NumberFormat('#', currentLang);
    var textTheme = Theme.of(context).textTheme;
    var prefs = ref.watch(preferencesProvider);

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
              child: prefs.when(
                loading: () => const SizedBox.shrink(),
                error: (error, _) => Text(error.toString()),
                data: (preferences) {
                  String theme = preferences.getString('theme') ?? 'dark';

                  return ListView.builder(
                    itemCount: widget.bookParas.length,
                    itemBuilder: (BuildContext context, int index) {
                      var bookPara = widget.bookParas[index];
                      var para = bookPara.para.value;

                      String paraTitle = contextualTranslation(
                        locale: currentLang,
                        enText: para.title,
                        bnText: para.titleBn,
                      );

                      return GestureDetector(
                        onTap: () => updateSelectedBookPara(bookPara),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: selectedBookPara.id == bookPara.id
                                ? theme == 'dark'
                                    ? ThemeColors.color7
                                    : ThemeColors.color9
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
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: selectedBookPara.totalPage,
              itemBuilder: (BuildContext context, int index) {
                var number = index + 1;

                return InkWell(
                  onTap: () async {
                    var query = AllModelsQuery(
                      repository: ref.quranBookPages,
                      params: {
                        'quranBookId': widget.book.id,
                        'paraId': selectedBookPara.para.value.id,
                        'paraPage': number,
                        'quantity': 1,
                      },
                    );

                    var resources =
                        await ref.watch(allModelsProvider(query).future);

                    if (resources.isNotEmpty) {
                      var bookPage = resources.first;
                      widget.pdfController.jumpToPage(bookPage.position);
                    }

                    widget.closeDrawer();
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
