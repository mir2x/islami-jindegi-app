import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:just_audio/just_audio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:idkit_inputformatters/idkit_inputformatters.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:collection/collection.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/providers/quran_settings.dart';
import 'package:native_app/providers/preferences.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/providers/local_file.dart';
import 'package:native_app/providers/player.dart';
import 'package:native_app/providers/bismillah_player.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/helpers/contextual_translation.dart';
import 'package:native_app/widgets/inputs/input_field.dart';
import 'package:native_app/objects/font_size_ratio.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/buttons/font_resizer.dart';
import 'package:native_app/widgets/presentation/section_title.dart';
import 'package:native_app/widgets/buttons/dropdown.dart';
import 'package:native_app/theme/app_theme.dart';
import 'package:native_app/theme/colors.dart';
import 'bismillah.dart';
import 'ayah.dart';
import '../shared/qari_list.dart';

class AyahList extends ConsumerWidget {
  const AyahList({
    super.key,
    required this.chapter,
    required this.filterParams,
    required this.previousPage,
    required this.nextPage,
  });

  final dynamic chapter;
  final Map filterParams;
  final Future? Function() previousPage;
  final Future? Function() nextPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String currentLang = Localizations.localeOf(context).languageCode;
    // MediaQuery.of(context) refreshes the screen when tilawat range input is focused.
    double screenWidth =
        View.of(context).physicalSize.width / View.of(context).devicePixelRatio;
    bool isSmallMobile = screenWidth < 340;
    var qSettings = ref.watch(quranSettingsProvider);
    bool isSurah = chapter.runtimeType.toString() == 'Surah';

    return WithPreferences(
      builder: (context, preferences) {
        var arabicFontSizeRatio =
            FontSizeRatio(value: preferences.getDouble('ayahFontRatio'));
        var banglaFontSizeRatio =
            FontSizeRatio(value: preferences.getDouble('translationFontRatio'));

        var query = AllModelsQuery(
          repository: ref.ayahs,
          params: {
            ...filterParams,
            'quantity': chapter.totalAyat,
            'offline': true,
            if (qSettings.containsKey('translation') &&
                qSettings['translation']) ...{'include': 'ayah-translations'},
          },
        );

        var modelQuery = ref.watch(allModelsProvider(query));

        int fromAyah;
        int toAyah;

        if (qSettings.containsKey('fromAyah') &&
            qSettings['fromAyah'] <= chapter.totalAyat) {
          fromAyah = qSettings['fromAyah'];
        } else {
          fromAyah = 1;
        }

        if (qSettings.containsKey('toAyah') &&
            qSettings['toAyah'] <= chapter.totalAyat) {
          toAyah = qSettings['toAyah'];
        } else {
          toAyah = chapter.totalAyat;
        }

        var player = ref.read(playerProvider);

        return AppScaffold(
          onBackPressed: () async => await QR.to('quran'),
          showPattern: false,
          title: Text(
            contextualTranslation(
              locale: currentLang,
              enText: chapter.title,
              bnText: chapter.titleBn,
            ),
          ),
          body: modelQuery.when(
            loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            error: (error, _) => Text(error.toString()),
            data: (ayahs) {
              if (qSettings.containsKey('tilawat') && qSettings['tilawat']) {
                return TilawatModeAyahList(
                  ayahs: ayahs,
                  arabicFontSizeRatio: arabicFontSizeRatio,
                );
              } else {
                return ReadingModeAyahList(
                  player: player,
                  chapter: chapter,
                  ayahs: ayahs,
                  qari: qSettings['qari'],
                  serialTilawat: qSettings.containsKey('serialTilawat') &&
                      qSettings['serialTilawat'],
                  fromAyah: fromAyah,
                  toAyah: toAyah,
                  preferences: preferences,
                  previousPage: previousPage,
                  nextPage: nextPage,
                  arabicFontSizeRatio: arabicFontSizeRatio,
                  banglaFontSizeRatio: banglaFontSizeRatio,
                );
              }
            },
          ),
          bottomBar: BottomBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: isSmallMobile ? 0 : 2),
                    child: const TilawatOption(),
                  ),
                  if (!(qSettings.containsKey('tilawat') &&
                      qSettings['tilawat'])) ...[
                    Container(
                      margin: const EdgeInsets.only(left: 2),
                      child: const TranslationOption(),
                    ),
                  ],
                ],
              ),
              Row(
                children: [
                  if (isSurah &&
                      !(qSettings.containsKey('tilawat') &&
                          qSettings['tilawat'])) ...[
                    QariOptions(
                      chapter: chapter,
                      fromAyah: fromAyah,
                      toAyah: toAyah,
                      player: player,
                    ),
                  ],
                  FontOptions(
                    preferences: preferences,
                    arabicFontSizeRatio: arabicFontSizeRatio,
                    banglaFontSizeRatio: banglaFontSizeRatio,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class TilawatModeAyahList extends StatelessWidget {
  const TilawatModeAyahList({
    super.key,
    required this.ayahs,
    required this.arabicFontSizeRatio,
  });

  final List ayahs;
  final FontSizeRatio arabicFontSizeRatio;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    String allAyahs = ayahs.map((a) => a.title).join(' ');

    return ValueListenableBuilder<double>(
      valueListenable: arabicFontSizeRatio,
      builder: (context, ratio, child) {
        return ItemContent(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 15),
              child: Text(
                'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِیْمِ',
                textDirection: TextDirection.rtl,
                style: textTheme.labelLarge?.copyWith(
                  fontSize: 27 * ratio,
                  height: 1.6,
                ),
              ),
            ),
            Text(
              allAyahs,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.justify,
              style: textTheme.labelLarge?.copyWith(
                fontSize: 27 * ratio,
                height: 1.6,
              ),
            ),
          ],
        );
      },
    );
  }
}

class ReadingModeAyahList extends ConsumerStatefulWidget {
  const ReadingModeAyahList({
    super.key,
    required this.player,
    required this.chapter,
    required this.ayahs,
    required this.qari,
    required this.serialTilawat,
    required this.fromAyah,
    required this.toAyah,
    required this.preferences,
    required this.previousPage,
    required this.nextPage,
    required this.arabicFontSizeRatio,
    required this.banglaFontSizeRatio,
  });

  final AudioPlayer player;
  final dynamic chapter;
  final List ayahs;
  final String? qari;
  final bool serialTilawat;
  final int fromAyah;
  final int toAyah;
  final dynamic preferences;
  final Future? Function() previousPage;
  final Future? Function() nextPage;
  final FontSizeRatio arabicFontSizeRatio;
  final FontSizeRatio banglaFontSizeRatio;

  @override
  ConsumerState createState() => _ReadingModeAyahListState();
}

class _ReadingModeAyahListState extends ConsumerState<ReadingModeAyahList> {
  StreamSubscription? _playerStateSubscription;
  bool isPlaying = false;

  int currentAyah = -1;

  final itemScrollController = ItemScrollController();
  final scrollOffsetController = ScrollOffsetController();
  final itemPositionsListener = ItemPositionsListener.create();
  final scrollOffsetListener = ScrollOffsetListener.create();

  updateCurrentAyah(ayahPosition) {
    setState(() => currentAyah = ayahPosition);
  }

  void updateLastAyahPosition() {
    EasyDebounce.debounce(
      'ayah-position',
      const Duration(milliseconds: 1000),
      () {
        widget.preferences.setInt(
          'lastAyahPosition',
          itemPositionsListener.itemPositions.value.first.index,
        );

        widget.preferences.setString('lastChapter', widget.chapter.id);
      },
    );
  }

  @override
  void initState() {
    super.initState();

    int lastAyahPosition = widget.preferences.getInt('lastAyahPosition') ?? 0;
    String? lastChapter = widget.preferences.getString('lastChapter');

    if (lastChapter == widget.chapter.id && lastAyahPosition > 0) {
      scrollToLastPosition(lastAyahPosition);
    }

    itemPositionsListener.itemPositions.addListener(updateLastAyahPosition);

    _playerStateSubscription =
        widget.player.playerStateStream.listen((PlayerState s) {
      setState(() {
        if (s.processingState == ProcessingState.completed) {
          if (widget.serialTilawat && currentAyah < widget.toAyah) {
            currentAyah = currentAyah + 1;
            if (currentAyah > 0) {
              itemScrollController.scrollTo(
                index: currentAyah - 1,
                duration: const Duration(milliseconds: 1),
              );
            }
          } else {
            widget.player.pause();
            widget.player.seek(const Duration(seconds: 0));
          }
        }

        isPlaying = s.playing;
      });
    });
  }

  void scrollToLastPosition(int lastAyahPosition) async {
    await Future.delayed(const Duration(milliseconds: 200));

    if (itemScrollController.isAttached) {
      itemScrollController.scrollTo(
        index: lastAyahPosition,
        duration: const Duration(milliseconds: 1),
      );
    }
  }

  @override
  void didUpdateWidget(covariant oldwidget) {
    super.didUpdateWidget(oldwidget);

    setState(() {
      bool qariChanged = widget.qari != oldwidget.qari;

      if (widget.serialTilawat) {
        if (widget.qari != null && currentAyah == -1) {
          if (widget.fromAyah == 1 && widget.chapter.position != 9) {
            currentAyah = 0;
            String firstAyahPath =
                '${widget.qari}/${widget.chapter.position}/1.mp3';
            ref.read(bismillahPlayerProvider(firstAyahPath));
          } else {
            currentAyah = widget.fromAyah;
          }
        }

        if (currentAyah > 0) {
          itemScrollController.jumpTo(index: currentAyah - 1);
        }
      } else if (qariChanged) {
        widget.player.stop();
        currentAyah = -1;
      }
    });
  }

  @override
  Future<void> dispose() async {
    itemPositionsListener.itemPositions.removeListener(updateLastAyahPosition);
    super.dispose();
    await _playerStateSubscription?.cancel();
    await widget.player.stop();
  }

  @override
  Widget build(BuildContext context) {
    String currentLang = Localizations.localeOf(context).languageCode;
    var numFormatter = NumberFormat('#', currentLang);
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    String theme = widget.preferences.getString('theme') ?? 'classic';

    List<int> marks = [];

    if (widget.ayahs.length > 30) {
      int jump = ((widget.ayahs.length - 1) / 10).floor();

      for (var i = 1; i < widget.ayahs.length; i = i + jump) {
        marks.add(i);
      }
    }

    double screenHeight = MediaQuery.of(context).size.height;
    var safeArea = MediaQuery.of(context).padding;
    double markHeight =
        (screenHeight - safeArea.top - safeArea.bottom - 170) / 11;
    double offset = markHeight / 2 + 35;

    return Stack(
      children: [
        Column(
          children: [
            Bismillah(
              chapter: widget.chapter,
              preferences: widget.preferences,
              previousPage: widget.previousPage,
              nextPage: widget.nextPage,
            ),
            Expanded(
              child: ScrollablePositionedList.separated(
                key: PageStorageKey<String>(widget.chapter.id),
                itemScrollController: itemScrollController,
                scrollOffsetController: scrollOffsetController,
                itemPositionsListener: itemPositionsListener,
                scrollOffsetListener: scrollOffsetListener,
                itemCount: widget.ayahs.length,
                itemBuilder: (BuildContext context, int index) {
                  var ayah = widget.ayahs[index];
                  bool isActive = currentAyah == ayah.surahPosition;

                  return Ayah(
                    ayah: ayah,
                    chapter: widget.chapter,
                    qari: widget.qari,
                    isActive: isActive,
                    isPlaying: isPlaying,
                    preferences: widget.preferences,
                    arabicFontSizeRatio: widget.arabicFontSizeRatio,
                    banglaFontSizeRatio: widget.banglaFontSizeRatio,
                    markAdjustment: marks.isNotEmpty ? 10 : 0,
                    loadQirat: (selectedAyah) async {
                      if (widget.serialTilawat &&
                          selectedAyah.surahPosition == 1 &&
                          widget.chapter.position != 9) {
                        updateCurrentAyah(0);
                        String firstAyahPath =
                            '${widget.qari}/${widget.chapter.position}/1.mp3';
                        ref.read(bismillahPlayerProvider(firstAyahPath));
                      } else {
                        var scaffoldMessenger = ScaffoldMessenger.of(context);

                        String audioPath =
                            '${widget.qari}/${widget.chapter.position}/${selectedAyah.surahPosition}.mp3';

                        final List<ConnectivityResult> connectivityResult =
                            await (Connectivity().checkConnectivity());

                        bool hasNoConnection = connectivityResult
                            .contains(ConnectivityResult.none);

                        var localFile = await ref.watch(
                          localFileProvider('al-quran/qirats/$audioPath')
                              .future,
                        );

                        if (hasNoConnection && localFile == null) {
                          scaffoldMessenger.removeCurrentSnackBar();

                          scaffoldMessenger.showSnackBar(
                            SnackBar(
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.wifi),
                                  const SizedBox(width: 10),
                                  Text(
                                    locales.connectToInternetMsg,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              duration: const Duration(seconds: 5),
                            ),
                          );
                        } else {
                          updateCurrentAyah(selectedAyah.surahPosition);
                        }
                      }
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 0.7,
                    color: AppTheme.separatorColor[theme],
                  );
                },
              ),
            ),
          ],
        ),
        ...List.generate(marks.length, (index) {
          return Positioned(
            top: offset + markHeight * index,
            left: 0,
            child: InkWell(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 6,
                ),
                child: Text(
                  numFormatter.format(marks[index]),
                  style: textTheme.labelSmall?.copyWith(
                    fontSize: 10,
                  ),
                ),
              ),
              onTap: () {
                itemScrollController.jumpTo(
                  index: marks[index] - 1,
                );
              },
            ),
          );
        }),
      ],
    );
  }
}

class TilawatOption extends ConsumerWidget {
  const TilawatOption({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var qSettings = ref.watch(quranSettingsProvider);
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallMobile = screenWidth < 340;

    return WithPreferences(
      builder: (context, preferences) {
        String theme = preferences.getString('theme') ?? 'classic';

        return TextButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (qSettings.containsKey('tilawat') && qSettings['tilawat']) ...[
                const Icon(
                  Icons.check_box,
                  color: ThemeColors.color4,
                  size: 20,
                ),
              ] else ...[
                const Icon(
                  Icons.check_box_outline_blank,
                  color: ThemeColors.color4,
                  size: 20,
                ),
              ],
              Container(
                margin: const EdgeInsets.only(left: 2, bottom: 1),
                child: Text(
                  locales.tilawat,
                  style: isSmallMobile
                      ? textTheme.labelSmall?.copyWith(
                          color: AppTheme.labelContrastColor[theme],
                        )
                      : textTheme.labelMedium?.copyWith(
                          color: AppTheme.labelContrastColor[theme],
                        ),
                ),
              ),
            ],
          ),
          onPressed: () {
            bool selectedTranslationOption =
                qSettings.containsKey('tilawat') ? qSettings['tilawat'] : false;

            ref.read(quranSettingsProvider.notifier).updateParams(
                  'tilawat',
                  !selectedTranslationOption,
                );
          },
        );
      },
    );
  }
}

class TranslationOption extends ConsumerWidget {
  const TranslationOption({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var qSettings = ref.watch(quranSettingsProvider);
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallMobile = screenWidth < 340;

    return WithPreferences(
      builder: (context, preferences) {
        String theme = preferences.getString('theme') ?? 'classic';

        return TextButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (qSettings.containsKey('translation') &&
                  qSettings['translation']) ...[
                const Icon(
                  Icons.check_box,
                  color: ThemeColors.color4,
                  size: 20,
                ),
              ] else ...[
                const Icon(
                  Icons.check_box_outline_blank,
                  color: ThemeColors.color4,
                  size: 20,
                ),
              ],
              Container(
                margin: const EdgeInsets.only(left: 2, bottom: 1),
                child: Text(
                  locales.translation,
                  style: isSmallMobile
                      ? textTheme.labelSmall?.copyWith(
                          color: AppTheme.labelContrastColor[theme],
                        )
                      : textTheme.labelMedium?.copyWith(
                          color: AppTheme.labelContrastColor[theme],
                        ),
                ),
              ),
            ],
          ),
          onPressed: () {
            bool selectedTranslationOption =
                qSettings.containsKey('translation')
                    ? qSettings['translation']
                    : false;

            ref.read(quranSettingsProvider.notifier).updateParams(
                  'translation',
                  !selectedTranslationOption,
                );
          },
        );
      },
    );
  }
}

class QariOptions extends ConsumerWidget {
  const QariOptions({
    super.key,
    required this.chapter,
    required this.fromAyah,
    required this.toAyah,
    required this.player,
  });

  final dynamic chapter;
  final int fromAyah;
  final int toAyah;
  final AudioPlayer player;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return WithPreferences(
      builder: (context, preferences) {
        String theme = preferences.getString('theme') ?? 'classic';

        return TextButton(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SerialTilawat(player: player),
                        TilwatRange(
                          chapter: chapter,
                          fromAyah: fromAyah,
                          toAyah: toAyah,
                        ),
                        const SizedBox(height: 50),
                        const Expanded(
                          child: QariList(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class SerialTilawat extends ConsumerWidget {
  const SerialTilawat({
    super.key,
    required this.player,
  });

  final AudioPlayer player;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var qSettings = ref.watch(quranSettingsProvider);

    return Container(
      constraints: const BoxConstraints(maxHeight: 40),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: Row(
          children: [
            if (qSettings.containsKey('serialTilawat') &&
                qSettings['serialTilawat']) ...[
              const Icon(
                Icons.check_box,
                color: ThemeColors.color4,
                size: 20,
              ),
            ] else ...[
              const Icon(
                Icons.check_box_outline_blank,
                color: ThemeColors.color4,
                size: 20,
              ),
            ],
            Container(
              margin: const EdgeInsets.only(left: 4, bottom: 1),
              child: Text(
                locales.serialTilawat,
                style: textTheme.labelMedium,
              ),
            ),
          ],
        ),
        onPressed: () async {
          bool selectedSerialTilawatOption =
              qSettings.containsKey('serialTilawat')
                  ? qSettings['serialTilawat']
                  : false;

          ref.read(quranSettingsProvider.notifier).updateParams(
                'serialTilawat',
                !selectedSerialTilawatOption,
              );

          if (qSettings['qari'] != null) {
            await player.stop();
            await player.play();

            if (context.mounted) {
              Navigator.of(context).pop();
            }
          }
        },
      ),
    );
  }
}

class TilwatRange extends ConsumerStatefulWidget {
  const TilwatRange({
    super.key,
    required this.chapter,
    required this.fromAyah,
    required this.toAyah,
  });

  final dynamic chapter;
  final int fromAyah;
  final int toAyah;

  @override
  ConsumerState<TilwatRange> createState() => _TilawatRangeState();
}

class _TilawatRangeState extends ConsumerState<TilwatRange> {
  int? fromValue;
  int? toValue;

  updateFrom(value) {
    if (value != null && int.tryParse(value) != null) {
      setState(() {
        fromValue = int.parse(value);
      });
    }
  }

  updateTo(value) {
    if (value != null && int.tryParse(value) != null) {
      setState(() {
        toValue = int.parse(value);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    fromValue = widget.fromAyah;
    toValue = widget.toAyah;
  }

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('${locales.from}:', style: textTheme.labelMedium),
        Container(
          width: 40,
          margin: const EdgeInsets.only(left: 3),
          child: InputField(
            initialValue: fromValue.toString(),
            keyboardType: TextInputType.number,
            inputFormatters: [
              IDKitNumeralTextInputFormatter.range(
                minValue: 1,
                maxValue: widget.chapter.totalAyat - 1,
                decimalPoint: false,
              ),
            ],
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 4),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: ThemeColors.border,
                ),
              ),
            ),
            onChanged: updateFrom,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 15),
          child: Text('${locales.to}:', style: textTheme.labelMedium),
        ),
        Container(
          width: 40,
          margin: const EdgeInsets.only(left: 3),
          child: InputField(
            initialValue: toValue.toString(),
            keyboardType: TextInputType.number,
            inputFormatters: [
              IDKitNumeralTextInputFormatter.range(
                minValue: 1,
                maxValue: widget.chapter.totalAyat,
                decimalPoint: false,
              ),
            ],
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 4),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: ThemeColors.border,
                ),
              ),
            ),
            onChanged: updateTo,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 20),
          constraints: const BoxConstraints(maxHeight: 26),
          child: TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              backgroundColor: ThemeColors.color4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              var notifier = ref.read(quranSettingsProvider.notifier);

              notifier.updateParams('fromAyah', fromValue);
              notifier.updateParams('toAyah', toValue);

              Navigator.of(context).pop();
            },
            child: (fromValue != widget.fromAyah || toValue != widget.toAyah)
                ? Text(locales.save, style: textTheme.titleSmall)
                : const Icon(
                    Icons.done,
                    color: ThemeColors.color2,
                  ),
          ),
        ),
      ],
    );
  }
}

class FontOptions extends ConsumerWidget {
  const FontOptions({
    super.key,
    required this.preferences,
    required this.arabicFontSizeRatio,
    required this.banglaFontSizeRatio,
  });

  final dynamic preferences;
  final FontSizeRatio arabicFontSizeRatio;
  final FontSizeRatio banglaFontSizeRatio;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    double screenWidth = MediaQuery.of(context).size.width;
    String theme = preferences.getString('theme') ?? 'classic';

    return TextButton(
      child: Text(
        locales.font,
        style: textTheme.titleMedium?.copyWith(
          color: AppTheme.titleContrastColor[theme],
        ),
      ),
      onPressed: () {
        const List<Map<String, String>> arabicFonts = [
          {
            'label': 'Al Qalam Quran Majeed',
            'value': 'arabic/al-qalam-quran-majeed',
          },
          {
            'label': 'Al Qalam Kolkatta Quran Majeed',
            'value': 'arabic/al-qalam-kolkatta',
          },
          {
            'label': 'Al Mushaf Quran',
            'value': 'arabic/al-mushaf',
          },
          {
            'label': 'Al Qalam Quran',
            'value': 'arabic/al-qalam-quran',
          }
        ];

        showDialog(
          context: context,
          builder: (BuildContext context) {
            String selectedArabicFont =
                arabicFonts.map((i) => i['value']).firstWhereOrNull((i) {
                      return i == preferences.getString('arabicFont');
                    }) ??
                    'arabic/al-qalam-quran-majeed';

            return Dialog(
              child: Container(
                width: screenWidth,
                height: 270,
                decoration: BoxDecoration(
                  color: AppTheme.backgroundColor[theme],
                ),
                padding: const EdgeInsets.only(
                  top: 15,
                  bottom: 25,
                  left: 15,
                  right: 15,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SectionTitle(
                            title: locales.arabicFont,
                          ),
                          Dropdown(
                            items: arabicFonts,
                            selectedValue: selectedArabicFont,
                            updateItem: (value) {
                              ref
                                  .read(
                                    preferencesProvider.notifier,
                                  )
                                  .updateArabicFont(value);
                            },
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Center(
                          child: FontResizer(
                            fontSizeRatio: arabicFontSizeRatio,
                            text: locales.arabicFont,
                            storeKey: 'ayahFontRatio',
                            contrastColor: false,
                          ),
                        ),
                        FontResizer(
                          fontSizeRatio: banglaFontSizeRatio,
                          text: locales.banglaFont,
                          storeKey: 'translationFontRatio',
                          contrastColor: false,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
