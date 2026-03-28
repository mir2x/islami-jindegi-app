import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/constants.dart';
import '../../../shared/quran_data.dart';
import '../models/ayah_box.dart';
import '../models/page_quran_info.dart';
import '../models/selected_ayah_state.dart';

final ayahCountsProvider = Provider<List<int>>((ref) {
  return [
    7,
    286,
    200,
    176,
    120,
    165,
    206,
    75,
    129,
    109,
    123,
    111,
    43,
    52,
    99,
    128,
    111,
    110,
    98,
    135,
    112,
    78,
    118,
    64,
    77,
    227,
    93,
    88,
    69,
    60,
    34,
    30,
    73,
    54,
    45,
    83,
    182,
    88,
    75,
    85,
    54,
    53,
    89,
    59,
    37,
    35,
    38,
    29,
    18,
    45,
    60,
    49,
    62,
    55,
    78,
    96,
    29,
    22,
    24,
    13,
    14,
    11,
    11,
    18,
    12,
    12,
    30,
    52,
    52,
    44,
    28,
    28,
    20,
    56,
    40,
    31,
    50,
    40,
    46,
    42,
    29,
    19,
    36,
    25,
    22,
    17,
    19,
    26,
    30,
    20,
    15,
    21,
    11,
    8,
    8,
    19,
    5,
    8,
    8,
    11,
    11,
    8,
    3,
    9,
    5,
    4,
    7,
    3,
    6,
    3,
    5,
    4,
    5,
    6,
  ];
});

class EditionConfig {
  final Directory dir;
  final int imageWidth;
  final int imageHeight;
  final String imageExt;

  const EditionConfig({
    required this.dir,
    required this.imageWidth,
    required this.imageHeight,
    required this.imageExt,
  });
}

class EditionConfigNotifier extends StateNotifier<EditionConfig?> {
  EditionConfigNotifier() : super(null);

  void set(EditionConfig config) => state = config;

  void clear() => state = null;
}

final editionConfigProvider =
    StateNotifierProvider<EditionConfigNotifier, EditionConfig?>(
  (_) => EditionConfigNotifier(),
);

final allBoxesProvider = FutureProvider<List<AyahBox>>((ref) async {
  final config = ref.watch(editionConfigProvider);
  if (config == null) throw Exception('edition config not set');
  final jsonFile = File('${config.dir.path}/ayah_boxes.json');
  final jsonStr = await jsonFile.readAsString();
  final decoded = jsonDecode(jsonStr) as List;
  return decoded.map((e) => AyahBox.fromJson(e)).toList(growable: false);
});

final totalPageCountProvider = FutureProvider<int>((ref) async {
  final config = ref.watch(editionConfigProvider);
  if (config == null) throw Exception('edition config not set');
  final fileList = await config.dir
      .list()
      .where((f) => f.path.endsWith('.${config.imageExt}'))
      .toList();
  return fileList.length;
});

final boxesForPageProvider = Provider.family<List<AyahBox>, int>((
  ref,
  pageIndex,
) {
  final all = ref
      .watch(allBoxesProvider)
      .maybeWhen(data: (d) => d, orElse: () => const <AyahBox>[]);
  final logicalPage = pageIndex;
  if (logicalPage < kFirstPageNumber) return const <AyahBox>[];
  return all.where((b) => b.pageNumber == logicalPage).toList(growable: false);
});

class SelectedAyahNotifier extends StateNotifier<SelectedAyahState?> {
  SelectedAyahNotifier() : super(null);

  void selectByTap(int sura, int ayah) {
    if (state?.suraNumber == sura &&
        state?.ayahNumber == ayah &&
        state?.source == AyahSelectionSource.tap) {
      state = null;
    } else {
      state = SelectedAyahState(sura, ayah, AyahSelectionSource.tap);
    }
  }

  void selectByAudio(int sura, int ayah) {
    if (state == null ||
        state!.suraNumber != sura ||
        state!.ayahNumber != ayah ||
        state!.source != AyahSelectionSource.audio) {
      state = SelectedAyahState(sura, ayah, AyahSelectionSource.audio);
    }
  }

  void selectByNavigation(int sura, int ayah) {
    if (state == null ||
        state!.suraNumber != sura ||
        state!.ayahNumber != ayah ||
        state!.source != AyahSelectionSource.navigation) {
      state = SelectedAyahState(sura, ayah, AyahSelectionSource.navigation);
    }
  }

  void clear() => state = null;
}

final selectedAyahProvider =
    StateNotifierProvider<SelectedAyahNotifier, SelectedAyahState?>(
  (ref) => SelectedAyahNotifier(),
);
final currentPageProvider = StateProvider<int>((_) => 0);

final currentSuraProvider = Provider<int>((ref) {
  final page = ref.watch(currentPageProvider) + 1;
  if (page <= 2) return page;
  final suraMapping = ref.watch(suraPageMappingProvider);
  if (suraMapping.isEmpty) return 1;
  int currentSura = 1;
  final sortedSuraStarts = List.from(
    suraMapping.entries.toList()..sort((a, b) => a.value.compareTo(b.value)),
  );
  for (final entry in sortedSuraStarts) {
    if (entry.value <= page) {
      currentSura = entry.key;
    } else {
      break;
    }
  }
  return currentSura;
});

class TouchModeNotifier extends StateNotifier<bool> {
  TouchModeNotifier() : super(false);

  void toggle() => state = !state;
}

final touchModeProvider = StateNotifierProvider<TouchModeNotifier, bool>(
  (_) => TouchModeNotifier(),
);

class OrientationToggle {
  static bool _isPortraitOnly = true;

  static Future<void> toggle() async {
    _isPortraitOnly = !_isPortraitOnly;
    if (_isPortraitOnly) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    } else {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    }
  }

  /// Explicitly set portrait mode regardless of current state
  static Future<void> setPortrait() async {
    _isPortraitOnly = true;
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }
}

class DrawerNotifier extends StateNotifier<bool> {
  DrawerNotifier() : super(false);

  void open() => state = true;

  void close() => state = false;
}

final drawerOpenProvider = StateNotifierProvider<DrawerNotifier, bool>(
  (_) => DrawerNotifier(),
);

final navigateToPageCommandProvider = StateProvider<int?>((_) => null);

void navigateToPage({required WidgetRef ref, required int pageNumber}) {
  ref.read(navigateToPageCommandProvider.notifier).state = pageNumber;
}

const List<(int sura, int ayah)> paraStarts = [
  (1, 1),
  (2, 142),
  (2, 253),
  (3, 93),
  (4, 24),
  (4, 148),
  (5, 83),
  (6, 111),
  (7, 88),
  (8, 41),
  (9, 93),
  (11, 6),
  (12, 53),
  (15, 1),
  (17, 1),
  (18, 75),
  (21, 1),
  (23, 1),
  (25, 21),
  (27, 56),
  (29, 46),
  (33, 31),
  (36, 22),
  (39, 32),
  (41, 47),
  (46, 1),
  (51, 31),
  (58, 1),
  (67, 1),
  (78, 1),
];

class MushafMappings {
  final Map<int, int> suraPageMapping;
  final Map<(int, int), int> ayahPageMapping;
  final Map<int, int> paraPageMapping;
  final Map<int, List<int>> paraPageRanges;

  const MushafMappings({
    required this.suraPageMapping,
    required this.ayahPageMapping,
    required this.paraPageMapping,
    required this.paraPageRanges,
  });

  factory MushafMappings.fromJson(Map<String, dynamic> json) {
    return MushafMappings(
      suraPageMapping: (json['suraPageMapping'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(int.parse(key), value as int),
      ),
      ayahPageMapping: (json['ayahPageMapping'] as Map<String, dynamic>).map(
        (key, value) {
          final parts = key.split(':');
          return MapEntry((int.parse(parts[0]), int.parse(parts[1])), value as int);
        },
      ),
      paraPageMapping: (json['paraPageMapping'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(int.parse(key), value as int),
      ),
      paraPageRanges: (json['paraPageRanges'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          int.parse(key),
          (value as List<dynamic>).cast<int>(),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'suraPageMapping': suraPageMapping.map(
        (key, value) => MapEntry(key.toString(), value),
      ),
      'ayahPageMapping': ayahPageMapping.map(
        (key, value) => MapEntry('${key.$1}:${key.$2}', value),
      ),
      'paraPageMapping': paraPageMapping.map(
        (key, value) => MapEntry(key.toString(), value),
      ),
      'paraPageRanges': paraPageRanges.map(
        (key, value) => MapEntry(key.toString(), value),
      ),
    };
  }
}

Future<File> _mushafMappingsCacheFile(EditionConfig config) async {
  final docsDir = await getApplicationDocumentsDirectory();
  final cacheDir = Directory('${docsDir.path}/quran_mappings_cache');
  if (!await cacheDir.exists()) {
    await cacheDir.create(recursive: true);
  }

  final cacheKey = base64Url.encode(utf8.encode(config.dir.path));
  return File('${cacheDir.path}/$cacheKey.json');
}

MushafMappings _buildMushafMappings({
  required List<AyahBox> boxes,
  required int totalPages,
}) {
  final Map<int, int> suraMapping = {};
  final Map<(int, int), int> ayahMapping = {};

  for (final box in boxes) {
    suraMapping.putIfAbsent(box.suraNumber, () => box.pageNumber);
    ayahMapping.putIfAbsent(
      (box.suraNumber, box.ayahNumber),
      () => box.pageNumber,
    );
  }

  final Map<int, int> paraMapping = {};
  for (int i = 0; i < paraStarts.length; i++) {
    final paraNum = i + 1;
    final (startSura, startAyah) = paraStarts[i];
    final page = ayahMapping[(startSura, startAyah)];
    if (page != null) {
      paraMapping[paraNum] = page;
    }
  }

  final Map<int, List<int>> paraRanges = {};
  for (int i = 1; i <= 30; i++) {
    final startPage = paraMapping[i];
    final endPage = i < 30 ? (paraMapping[i + 1] != null ? paraMapping[i + 1]! - 1 : null) : totalPages;
    if (startPage != null && endPage != null && startPage <= endPage) {
      paraRanges[i] = List<int>.generate(
        endPage - startPage + 1,
        (index) => startPage + index,
      );
    }
  }

  return MushafMappings(
    suraPageMapping: suraMapping,
    ayahPageMapping: ayahMapping,
    paraPageMapping: paraMapping,
    paraPageRanges: paraRanges,
  );
}

final quranMappingsProvider = FutureProvider<MushafMappings>((ref) async {
  final config = ref.watch(editionConfigProvider);
  if (config == null) {
    throw Exception('edition config not set');
  }

  final cacheFile = await _mushafMappingsCacheFile(config);
  if (await cacheFile.exists()) {
    try {
      final cachedJson =
          jsonDecode(await cacheFile.readAsString()) as Map<String, dynamic>;
      return MushafMappings.fromJson(cachedJson);
    } catch (_) {
      await cacheFile.delete();
    }
  }

  final boxes = await ref.watch(allBoxesProvider.future);
  final totalPages = await ref.watch(totalPageCountProvider.future);
  final mappings = _buildMushafMappings(boxes: boxes, totalPages: totalPages);
  await cacheFile.writeAsString(jsonEncode(mappings.toJson()));
  return mappings;
});

final suraPageMappingProvider = Provider<Map<int, int>>((ref) {
  return ref.watch(quranMappingsProvider).maybeWhen(
        data: (mappings) => mappings.suraPageMapping,
        orElse: () => const {},
      );
});

final ayahPageMappingProvider = Provider<Map<(int, int), int>>((ref) {
  return ref.watch(quranMappingsProvider).maybeWhen(
        data: (mappings) => mappings.ayahPageMapping,
        orElse: () => const {},
      );
});

final suraNamesProvider = Provider<List<String>>((_) => suraNames);
final selectedNavigationSurahProvider = StateProvider<int?>((_) => null);
final paraPageMappingProvider = Provider<Map<int, int>>((ref) {
  return ref.watch(quranMappingsProvider).maybeWhen(
    data: (mappings) => mappings.paraPageMapping,
    orElse: () => const {},
  );
});

final paraPageRangesProvider = Provider<Map<int, List<int>>>((ref) {
  return ref.watch(quranMappingsProvider).maybeWhen(
    data: (mappings) => mappings.paraPageRanges,
    orElse: () => const {},
  );
});
final selectedNavigationParaProvider = StateProvider<int?>((_) => null);

class QuranInfoService {
  final Ref _ref;

  QuranInfoService(this._ref);

  int getParaBySuraAyah(int sura, int ayah) {
    for (int i = 0; i < paraStarts.length; i++) {
      final (startSura, startAyah) = paraStarts[i];
      if (sura < startSura || (sura == startSura && ayah < startAyah)) {
        return i;
      }
    }
    return 30;
  }

  int? getParaByPage(int page) {
    final paraMapping = _ref.read(paraPageMappingProvider);

    int? currentPara;
    int latestStartPage = -1;

    for (final entry in paraMapping.entries) {
      final paraNum = entry.key;
      final startPage = entry.value;

      if (startPage <= page && startPage > latestStartPage) {
        currentPara = paraNum;
        latestStartPage = startPage;
      }
    }
    if (currentPara == null && page >= 1 && page < kFirstPageNumber) {
      return 1;
    }

    return currentPara;
  }

  int? getSuraByPage(int page) {
    if (page == 1) return 1;
    if (page == 2) return 2;

    final suraMapping = _ref.read(suraPageMappingProvider);

    int? currentSura;
    int latestStartPage = -1;

    for (final entry in suraMapping.entries) {
      final suraNum = entry.key;
      final startPage = entry.value;

      if (startPage <= page && startPage > latestStartPage) {
        currentSura = suraNum;
        latestStartPage = startPage;
      }
    }

    return currentSura;
  }

  int? getPageBySuraAyah(int sura, int ayah) {
    final ayahPageMapping = _ref.read(ayahPageMappingProvider);
    return ayahPageMapping[(sura, ayah)];
  }
}

final quranInfoServiceProvider = Provider<QuranInfoService>(
  (ref) => QuranInfoService(ref),
);

class BarsVisibilityNotifier extends StateNotifier<bool> {
  BarsVisibilityNotifier() : super(true);

  void show() {
    if (!state) {
      state = true;
    }
  }

  void hide() {
    if (state) {
      state = false;
    }
  }

  void toggle() {
    state = !state;
  }
}

final pageInfoProvider = Provider.family<PageQuranInfo, int>((ref, pageNumber) {
  final boxesOnPage = ref.watch(boxesForPageProvider(pageNumber));
  final paraNumber =
      ref.read(quranInfoServiceProvider).getParaByPage(pageNumber);

  if (boxesOnPage.isEmpty) {
    return PageQuranInfo(
      pageNumber: pageNumber,
      paraNumber: paraNumber,
      suraAyahRanges: {},
    );
  }

  final Map<int, List<int>> suraAyahs = {};
  for (final box in boxesOnPage) {
    if (!suraAyahs.containsKey(box.suraNumber)) {
      suraAyahs[box.suraNumber] = [];
    }
    suraAyahs[box.suraNumber]!.add(box.ayahNumber);
  }

  final Map<int, (int, int)> suraAyahRanges = {};
  for (final sura in suraAyahs.keys) {
    final ayahs = suraAyahs[sura]!;
    ayahs.sort();
    suraAyahRanges[sura] = (ayahs.first, ayahs.last);
  }

  return PageQuranInfo(
    pageNumber: pageNumber,
    paraNumber: paraNumber,
    suraAyahRanges: suraAyahRanges,
  );
});

class PageInfoVisibilityNotifier extends StateNotifier<bool> {
  PageInfoVisibilityNotifier() : super(false);
  void show() {
    if (state) return;
    state = true;
    Timer(const Duration(seconds: 1), () {
      state = false;
    });
  }
}

final pageInfoVisibilityProvider =
    StateNotifierProvider<PageInfoVisibilityNotifier, bool>(
  (_) => PageInfoVisibilityNotifier(),
);

final barsVisibilityProvider =
    StateNotifierProvider<BarsVisibilityNotifier, bool>(
  (ref) => BarsVisibilityNotifier(),
);

// ── Zoom / Page Scale ─────────────────────────────────────────────────────────

class QuranPageScaleNotifier extends StateNotifier<double> {
  static const double _min = 1.0;
  static const double _max = 3.0;
  static const double _step = 0.25;

  QuranPageScaleNotifier() : super(1.0);

  void zoomIn() => state = (state + _step).clamp(_min, _max);
  void zoomOut() => state = (state - _step).clamp(_min, _max);
  void setScale(double s) => state = s.clamp(_min, _max);

  bool get canZoomIn => state < _max;
  bool get canZoomOut => state > _min;
}

final quranPageScaleProvider =
    StateNotifierProvider<QuranPageScaleNotifier, double>(
  (_) => QuranPageScaleNotifier(),
);

/// True when the viewer is zoomed in (either by button or pinch).
/// Updated by QuranPage whenever its TransformationController changes.
final quranPageZoomedProvider = StateProvider<bool>((_) => false);
