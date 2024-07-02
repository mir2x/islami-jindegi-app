import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/local_file.dart';
import 'package:native_app/providers/single_model.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/providers/check_downloaded_file.dart';
import 'package:native_app/providers/quran_settings.dart';
import 'package:native_app/widgets/utils/with_connectivity.dart';
import 'package:native_app/objects/single_model_query.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
// import 'package:native_app/objects/pdf_builders.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/helpers/contextual_translation.dart';
import 'package:native_app/widgets/presentation/connect_to_internet.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/theme/app_theme.dart';
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

  @override
  Widget build(BuildContext context) {
    String currentLang = Localizations.localeOf(context).languageCode;
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;

    var book = widget.qitab.quranBook.value;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double heightAdjustment = isFullScreen ? 0 : 160;

    var pdfFile = ref.watch(localFileProvider(widget.filePath));

    return AppScaffold(
      showAppBar: !isFullScreen,
      showBottomBar: !isFullScreen,
      title: Text(widget.qitabTitle),
      body: GestureDetector(
        onTap: () => toggleFullScreen(),
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
            return PdfViewer.file(
              localFile!.path,
              controller: pdfController,
              initialPageNumber: initalPage,
              params: PdfViewerParams(
                margin: 0,
                layoutPages: (pages, params) {
                  final pageCount = pages.length;
                  final height = screenHeight - heightAdjustment;
                  final width = pageCount * screenWidth;
                  final pageLayouts = <Rect>[];
                  double x = width;

                  while (x > 10) {
                    x -= screenWidth;
                    pageLayouts.add(
                      Rect.fromLTWH(
                        x,
                        0,
                        screenWidth,
                        height,
                      ),
                    );
                  }
                  return PdfPageLayout(
                    pageLayouts: pageLayouts,
                    documentSize: Size(width, height),
                  );
                },
                onPageChanged: (page) async {
                  if (page == null) {
                    return;
                  }

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

                  if (qitabSurahs.length == 1) {
                    var qitabSurah = qitabSurahs.first;
                    var notifier = ref.read(quranSettingsProvider.notifier);

                    notifier.updateParams(
                      'qitabFromAyah',
                      qitabSurah.startAyah,
                    );
                    notifier.updateParams('qitabToAyah', qitabSurah.endAyah);
                    notifier.updateParams(
                      'surahNo',
                      qitabSurah.surah.value.position,
                    );
                    notifier.updateParams(
                      'surahSlug',
                      qitabSurah.surah.value.slug,
                    );
                    notifier.updateParams(
                      'surahTitle',
                      contextualTranslation(
                        locale: currentLang,
                        enText: qitabSurah.surah.value.title,
                        bnText: qitabSurah.surah.value.titleBn,
                      ),
                    );
                  }
                },
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

              return Row(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.all(isSmallMobile ? 0 : 5),
                    ),
                    child: Text(
                      locales.translation,
                      style: textTheme.titleMedium?.copyWith(
                        color: AppTheme.titleContrastColor[theme],
                      ),
                    ),
                    onPressed: () async {
                      var qSettings = ref.read(quranSettingsProvider);

                      String? slug;
                      int? qitabFromAyah;

                      if (qSettings.containsKey('surahSlug') &&
                          qSettings.containsKey('qitabFromAyah')) {
                        slug = qSettings['surahSlug'];
                        qitabFromAyah = qSettings['qitabFromAyah'];
                      } else if (pdfController.pageNumber != null) {
                        var qitabSurahQuery = AllModelsQuery(
                          repository: ref.quranBookSurahs,
                          params: {
                            'bookId': book.id,
                            'page': pdfController.pageNumber,
                            'include': 'surah',
                            'offline': true,
                          },
                        );

                        var qitabSurahs = await ref.read(
                          allModelsProvider(qitabSurahQuery).future,
                        );

                        if (qitabSurahs.length == 1) {
                          var qitabSurah = qitabSurahs.first;
                          slug = qitabSurah.surah.value.slug;
                          qitabFromAyah = qitabSurah.startAyah;
                        }
                      }

                      if (slug != null && qitabFromAyah != null) {
                        await widget.preferences.setInt(
                          'lastAyahPosition',
                          qitabFromAyah - 1,
                        );

                        ref
                            .read(quranSettingsProvider.notifier)
                            .updateParams('translation', true);

                        QR.to('quran/surah/$slug');
                      }
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.all(isSmallMobile ? 0 : 5),
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
                  QuranBookTilawat(
                    bookId: book.id,
                    pdfController: pdfController,
                  ),
                ],
              );
            },
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
