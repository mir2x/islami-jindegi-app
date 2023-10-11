import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:pdfx/pdfx.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/pdf_controller.dart';
import 'package:native_app/providers/single_model.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/providers/connectivity_result.dart';
import 'package:native_app/providers/check_downloaded_file.dart';
import 'package:native_app/objects/single_model_query.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/objects/pdf_source.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/document/pdf_builders.dart';
import 'package:native_app/widgets/utils/full_screen.dart';
import 'package:native_app/helpers/contextual_translation.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/buttons/download.dart';
import 'package:native_app/widgets/buttons/delete.dart';
import 'package:native_app/helpers/file_utils.dart';
import 'package:native_app/helpers/file_size.dart';
import 'drawer.dart';

class QuranBook extends ConsumerWidget {
  const QuranBook({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    String currentLang = Localizations.localeOf(context).languageCode;
    var textTheme = Theme.of(context).textTheme;

    var query = SingleModelQuery(
      repository: ref.quranBookQitabs,
      id: QR.params['id'].toString(),
      params: const {'include': 'quran-book'},
    );

    var modelQuery = ref.watch(singleModelProvider(query));

    return modelQuery.when(
      loading: () => const FullScreen(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (qitab) {
        String qitabTitle = contextualTranslation(
          locale: currentLang,
          enText: qitab.title,
          bnText: qitab.titleBn,
        );

        if (qitab.document != null) {
          String filePath = qitab.document['id'];
          String fileUrl = fileSrcUrl(qitab.document);

          var checkFileProvider = checkDownloadedFileProvider(filePath);
          var checkDownloadedFile = ref.watch(checkFileProvider);

          return checkDownloadedFile.when(
            loading: () => const CircularProgressIndicator(),
            error: (error, stackTrace) => Text(error.toString()),
            data: (isDownloaded) {
              if (isDownloaded) {
                PdfSource params = PdfSource(
                  resourceId: qitab.id,
                  document: qitab.document,
                );

                var pdfCtrl = ref.watch(pdfControllerProvider(params));

                return pdfCtrl.when(
                  loading: () {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  error: (error, stackTrace) => Text(error.toString()),
                  data: (pdfController) {
                    return QuranDisplay(
                      qitab: qitab,
                      qitabTitle: qitabTitle,
                      pdfController: pdfController,
                    );
                  },
                );
              } else {
                var connectivity = ref.watch(connectivityResultProvider);

                return AppScaffold(
                  title: Text(qitabTitle),
                  body: Center(
                    child: connectivity.when(
                      loading: () => const CircularProgressIndicator(),
                      error: (error, stackTrace) => Text(error.toString()),
                      data: (connectivityResult) {
                        if (connectivityResult != ConnectivityResult.none) {
                          int size = qitab.document['metadata']['size'];

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                locales.download,
                                style: textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${locales.fileSize}:  ${fileSize(size)}',
                                style: textTheme.labelMedium,
                              ),
                              const SizedBox(height: 10),
                              DownloadButton(
                                filePath: filePath,
                                fileUrl: fileUrl,
                                direction: 'column',
                              ),
                            ],
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                );
              }
            },
          );
        } else {
          return AppScaffold(
            title: Text(qitabTitle),
            body: Center(
              child: Text(locales.noContent, style: textTheme.labelLarge),
            ),
          );
        }
      },
    );
  }
}

class QuranDisplay extends ConsumerStatefulWidget {
  const QuranDisplay({
    super.key,
    required this.qitab,
    required this.qitabTitle,
    required this.pdfController,
  });

  final dynamic qitab;
  final String qitabTitle;
  final PdfController pdfController;

  @override
  ConsumerState<QuranDisplay> createState() => _QuranDisplayState();
}

class _QuranDisplayState extends ConsumerState<QuranDisplay> {
  bool isFullScreen = false;

  @override
  void initState() {
    super.initState();
    /* SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []); */
  }

  @override
  void dispose() {
    /* SystemChrome.setEnabledSystemUIMode( */
    /*   SystemUiMode.manual, */
    /*   overlays: SystemUiOverlay.values, */
    /* ); */
    super.dispose();
  }

  void toggleFullScreen() {
    setState(() {
      isFullScreen = !isFullScreen;

      isFullScreen
          ? SystemChrome.setEnabledSystemUIMode(
              SystemUiMode.manual,
              overlays: [],
            )
          : SystemChrome.setEnabledSystemUIMode(
              SystemUiMode.manual,
              overlays: SystemUiOverlay.values,
            );
    });
  }

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;

    var book = widget.qitab.quranBook.value;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double heightAdjustment = isFullScreen ? 0 : 160;

    return AppScaffold(
      showAppBar: !isFullScreen,
      showBottomBar: !isFullScreen,
      title: Text(widget.qitabTitle),
      body: GestureDetector(
        onTap: () => {},
        child: PdfView(
          reverse: true,
          controller: widget.pdfController,
          builders: PdfBuilders(locales: locales, textTheme: textTheme)
              .getViewBuilders(),
          renderer: (PdfPage page) {
            return page.render(
              width: screenWidth * 2.5,
              height: (screenHeight - heightAdjustment) * 2.5,
              backgroundColor: '#FFFFFF',
            );
          },
          onPageChanged: (page) async {
            var scaffoldMessenger = ScaffoldMessenger.of(context);

            var query = AllModelsQuery(
              repository: ref.quranBookPages,
              params: {
                'quranBookId': book.id,
                'position': page,
                'quantity': 1,
              },
            );

            var resources = await ref.watch(allModelsProvider(query).future);

            if (resources.isNotEmpty) {
              var prefs = await SharedPreferences.getInstance();
              await prefs.setInt('pdfResource-${widget.qitab.id}', page);

              scaffoldMessenger.removeCurrentSnackBar();

              scaffoldMessenger.showSnackBar(
                SnackBar(
                  content: Text(
                    resources.first.title,
                    textAlign: TextAlign.center,
                  ),
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          },
        ),
      ),
      drawer: SafeArea(
        child: Drawer(
          child: QuranDrawer(
            book: book,
            pdfController: widget.pdfController,
          ),
        ),
      ),
      bottomBar: BottomBar(
        alignment: MainAxisAlignment.spaceBetween,
        children: [
          const QuranMenuButton(),
          DeleteButton(filePath: widget.qitab.document['id']),
        ],
      ),
    );
  }
}

class QuranMenuButton extends StatelessWidget {
  const QuranMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      child: GestureDetector(
        onTap: () => Scaffold.of(context).openDrawer(),
        child: SvgPicture.asset(
          'assets/images/icons/menu.svg',
          fit: BoxFit.scaleDown,
          width: 30,
          height: 30,
        ),
      ),
    );
  }
}
