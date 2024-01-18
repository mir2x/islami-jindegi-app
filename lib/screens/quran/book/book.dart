import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:pdfx/pdfx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/pdf_controller.dart';
import 'package:native_app/providers/single_model.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/providers/check_downloaded_file.dart';
import 'package:native_app/providers/quran_settings.dart';
import 'package:native_app/widgets/utils/with_connectivity.dart';
import 'package:native_app/objects/single_model_query.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/objects/pdf_source.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/objects/pdf_builders.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/helpers/contextual_translation.dart';
import 'package:native_app/widgets/presentation/connect_to_internet.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/buttons/download.dart';
import 'package:native_app/widgets/buttons/delete.dart';
import 'package:native_app/helpers/file_title_path.dart';
import 'package:native_app/helpers/file_utils.dart';
import 'package:native_app/helpers/file_size.dart';
import 'package:native_app/settings/image.dart';
import 'drawer.dart';
import 'tilawat.dart';
import '../qari_list.dart';

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
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (qitab) {
        String qitabTitle = contextualTranslation(
          locale: currentLang,
          enText: qitab.title,
          bnText: qitab.titleBn,
        );

        if (qitab.document != null) {
          String filePath = fileTitlePath(qitab.title, qitab.document['id']);
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
                  filePath: filePath,
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
                      filePath: filePath,
                      pdfController: pdfController,
                    );
                  },
                );
              } else {
                int size = qitab.document['metadata']['size'];
                double screenWidth = MediaQuery.of(context).size.width;
                Map<String, int> dimensions =
                    imageSettings['quranBookQitab']['image'];

                return AppScaffold(
                  title: Text(qitabTitle),
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 15),
                        width: screenWidth / 2,
                        child: AspectRatio(
                          aspectRatio:
                              dimensions['width']! / dimensions['height']!,
                          child: Image(
                            image: AssetImage(
                              'assets/images/quran-qitabs/${qitab.id}.jpg',
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      WithConnectivity(
                        builder: (context, isConnected) {
                          if (isConnected) {
                            return Column(
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
                            return Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: const ConnectToInternet(),
                            );
                          }
                        },
                      ),
                    ],
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
    required this.filePath,
    required this.pdfController,
  });

  final dynamic qitab;
  final String qitabTitle;
  final String filePath;
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
        onTap: () {},
        /* onTap: () => toggleFullScreen(), */
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

            var qSettings = ref.read(quranSettingsProvider);

            if (qSettings.containsKey('qari')) {
              var query = AllModelsQuery(
                repository: ref.quranBookSurahs,
                params: {
                  'bookId': book.id,
                  'page': widget.pdfController.page,
                  'include': 'surah',
                  'offline': true,
                },
              );

              var resources = await ref.read(allModelsProvider(query).future);

              if (resources.length == 1) {
                var qitabSurah = resources.first;
                var notifier = ref.read(quranSettingsProvider.notifier);

                notifier.updateParams('fromAyah', qitabSurah.startAyah);
                notifier.updateParams('toAyah', qitabSurah.endAyah);
                notifier.updateParams(
                  'selectedSurah',
                  qitabSurah.surah.value.position,
                );
              }
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
          Row(
            children: [
              TextButton(
                child: Text(locales.qaris, style: textTheme.titleMedium),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: Container(
                          width: screenWidth,
                          height: screenHeight * 0.5,
                          padding: const EdgeInsets.only(
                            top: 15,
                            bottom: 25,
                            left: 15,
                            right: 15,
                          ),
                          child: const QariList(),
                        ),
                      );
                    },
                  );
                },
              ),
              QuranBookTilawat(
                bookId: book.id,
                pdfController: widget.pdfController,
              ),
            ],
          ),
          DeleteButton(filePath: widget.filePath),
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
