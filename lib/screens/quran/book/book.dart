import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/local_file.dart';
import 'package:native_app/providers/single_model.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/providers/check_downloaded_file.dart';
import 'package:native_app/providers/quran_settings.dart';
import 'package:native_app/providers/player.dart';
import 'package:native_app/widgets/utils/with_connectivity.dart';
import 'package:native_app/objects/single_model_query.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/layouts/placeholder_scaffold.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/helpers/contextual_translation.dart';
import 'package:native_app/widgets/presentation/connect_to_internet.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/widgets/utils/pdf_menu.dart';
import 'package:native_app/widgets/buttons/download.dart';
import 'package:native_app/widgets/buttons/open_file.dart';
import 'package:native_app/helpers/file_title_path.dart';
import 'package:native_app/helpers/file_utils.dart';
import 'package:native_app/helpers/file_size.dart';
import 'package:native_app/theme/app_theme.dart';
import 'package:native_app/settings/image.dart';
import 'drawer.dart';
import 'tilawat.dart';
import 'player.dart';
import 'ayah.dart';
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
      loading: () {
        return const PlaceholderScaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
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
            loading: () {
              return const PlaceholderScaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
            error: (error, stackTrace) => Text(error.toString()),
            data: (isDownloaded) {
              if (isDownloaded) {
                return WithPreferences(
                  builder: (context, preferences) {
                    return QuranDisplay(
                      qitab: qitab,
                      qitabTitle: qitabTitle,
                      filePath: filePath,
                      preferences: preferences,
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
    required this.preferences,
  });

  final dynamic qitab;
  final String qitabTitle;
  final String filePath;
  final dynamic preferences;

  @override
  ConsumerState<QuranDisplay> createState() => _QuranDisplayState();
}

class _QuranDisplayState extends ConsumerState<QuranDisplay> {
  bool isFullScreen = false;
  bool darkMode = false;
  bool landscape = false;
  final pdfController = PdfViewerController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
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

  void toggleMode() {
    setState(() {
      darkMode = !darkMode;
    });
  }

  void toggleOrientation() {
    setState(() {
      landscape = !landscape;
    });
  }

  @override
  Widget build(BuildContext context) {
    String currentLang = Localizations.localeOf(context).languageCode;
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;

    var book = widget.qitab.quranBook.value;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    int platformAjdustment = Platform.isAndroid ? -4 : 30;
    double barHeight = kToolbarHeight +
        MediaQuery.of(context).padding.top +
        kBottomNavigationBarHeight +
        platformAjdustment;
    double heightAdjustment = isFullScreen ? 0 : barHeight;

    var pdfFile = ref.watch(localFileProvider(widget.filePath));

    return AppScaffold(
      showAppBar: !isFullScreen,
      showBottomBar: !isFullScreen,
      title: Text(widget.qitabTitle),
      tabletBodyPadding: false,
      body: GestureDetector(
        onTap: () {
          if (!landscape) {
            toggleFullScreen();
          }
        },
        child: pdfFile.when(
          loading: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
          error: (error, stackTrace) => Text(error.toString()),
          data: (localFile) {
            int initalPage =
                widget.preferences.getInt('pdfResource-${widget.qitab.id}') ??
                    1;

            return ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.white,
                darkMode ? BlendMode.difference : BlendMode.dst,
              ),
              child: RotatedBox(
                quarterTurns: landscape ? 3 : 0,
                child: PdfViewer.file(
                  localFile!.path,
                  controller: pdfController,
                  initialPageNumber: initalPage,
                  params: PdfViewerParams(
                    margin: 0,
                    layoutPages: (pages, params) {
                      final pageCount = pages.length;
                      double height;
                      double viewWidth;

                      if (landscape) {
                        height = (screenHeight - heightAdjustment) * 1.5;
                        viewWidth = screenHeight - heightAdjustment;
                      } else {
                        height = screenHeight - heightAdjustment;
                        viewWidth = screenWidth;
                      }

                      final width = pageCount * viewWidth;
                      final pageLayouts = <Rect>[];
                      double x = width;

                      while (x > 10) {
                        x -= viewWidth;
                        pageLayouts.add(
                          Rect.fromLTWH(
                            x,
                            0,
                            viewWidth,
                            height,
                          ),
                        );
                      }

                      return PdfPageLayout(
                        pageLayouts: pageLayouts,
                        documentSize: Size(width, height),
                      );
                    },
                    onPageChanged: (page) {
                      if (page == null) {
                        return;
                      }

                      EasyDebounce.debounce(
                          'quran-page', const Duration(milliseconds: 500),
                          () async {
                        var scaffoldMessenger = ScaffoldMessenger.of(context);

                        var query = AllModelsQuery(
                          repository: ref.quranBookPages,
                          params: {
                            'quranBookId': book.id,
                            'position': page,
                            'quantity': 1,
                            'offline': true,
                          },
                        );

                        var resources =
                            await ref.watch(allModelsProvider(query).future);

                        if (resources.isNotEmpty) {
                          await widget.preferences
                              .setInt('pdfResource-${widget.qitab.id}', page);
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

                        var qitabSurahQuery = AllModelsQuery(
                          repository: ref.quranBookSurahs,
                          params: {
                            'bookId': book.id,
                            'page': page,
                            'include': 'surah',
                            'offline': true,
                          },
                        );

                        var qitabSurahs = await ref.read(
                          allModelsProvider(qitabSurahQuery).future,
                        );

                        var notifier = ref.read(
                          quranSettingsProvider.notifier,
                        );

                        if (qitabSurahs.length == 1) {
                          var qitabSurah = qitabSurahs.first;
                          int currentAyah = (qitabSurah.startAyah == 1 &&
                                  qitabSurah.surah.value.position != 9)
                              ? 0
                              : qitabSurah.startAyah;

                          notifier.updateMultipleParams({
                            'currentAyah': currentAyah,
                            'qitabFromAyah': qitabSurah.startAyah,
                            'qitabToAyah': qitabSurah.endAyah,
                            'surahNo': qitabSurah.surah.value.position,
                            'surahId': qitabSurah.surah.id,
                            'surahTitle': contextualTranslation(
                              locale: currentLang,
                              enText: qitabSurah.surah.value.title,
                              bnText: qitabSurah.surah.value.titleBn,
                            ),
                          });
                        } else {
                          notifier.updateParams('currentAyah', null);
                        }
                      });
                    },
                    onViewSizeChanged: (_, __, controller) {
                      if (controller.pageNumber != null) {
                        int pageNumber = controller.pageNumber!;

                        Future.delayed(const Duration(milliseconds: 100), () {
                          controller.goToPage(pageNumber: pageNumber);
                        });
                      }
                    },
                    loadingBannerBuilder: (_, __, ___) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    errorBannerBuilder: (context, _, __, ___) {
                      var locales = AppLocalizations.of(context)!;
                      var textTheme = Theme.of(context).textTheme;

                      return AlertDialog(
                        title: Text(locales.errorTitle),
                        content: Text(
                          locales.documentLoadErrorMsg,
                          style: textTheme.labelMedium,
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
      drawer: SafeArea(
        child: Drawer(
          child: QuranDrawer(
            book: book,
            pdfController: pdfController,
          ),
        ),
      ),
      bottomBar: BottomBar(
        alignment: MainAxisAlignment.spaceBetween,
        children: [
          const QuranMenuButton(),
          Builder(
            builder: (context) {
              String theme = widget.preferences.getString('theme') ?? 'classic';
              double screenWidth = MediaQuery.of(context).size.width;
              bool isSmallMobile = screenWidth < 340;
              var qSettings = ref.watch(quranSettingsProvider);

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  QuranBookTilawat(
                    bookId: book.id,
                    pdfController: pdfController,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.all(isSmallMobile ? 2 : 4),
                    ),
                    child: Text(
                      locales.qaris,
                      style: textTheme.titleMedium?.copyWith(
                        color: AppTheme.titleContrastColor[theme],
                      ),
                    ),
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
                  if (qSettings.containsKey('qari') &&
                      qSettings.containsKey('surahId') &&
                      qSettings.containsKey('surahNo') &&
                      qSettings.containsKey('surahTitle') &&
                      qSettings.containsKey('qitabFromAyah') &&
                      qSettings.containsKey('qitabToAyah')) ...[
                    QuranBookPlayer(
                      player: ref.read(playerProvider),
                      qari: qSettings['qari'],
                      surahId: qSettings['surahId'],
                      surahNo: qSettings['surahNo'],
                      surahTitle: qSettings['surahTitle'],
                      fromAyah: qSettings['qitabFromAyah'],
                      toAyah: qSettings['qitabToAyah'],
                    ),
                  ],
                  const QuranBookAyah(),
                  if (!(qSettings.containsKey('currentAyah') &&
                      qSettings['currentAyah'] != null)) ...[
                    OpenFile(filePath: widget.filePath),
                  ],
                ],
              );
            },
          ),
          PDFMenu(
            filePath: widget.filePath,
            darkMode: darkMode,
            landscape: landscape,
            toggleMode: toggleMode,
            toggleOrientation: toggleOrientation,
          ),
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
      padding: const EdgeInsets.all(10),
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
