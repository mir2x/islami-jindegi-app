import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/features/sura/view/widgets/quran_page_widget.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:native_app/core/utils/bengali_digit_extension.dart';
import 'package:native_app/shared/quran_data.dart';
import '../../model/tilawat_models.dart';
import '../../viewmodel/tilawat_providers.dart';
import 'font_change_dialog.dart';
import 'drawer/tilawat_selection_drawer.dart';

class TilawatPage extends ConsumerStatefulWidget {
  final int initialSuraNumber;
  final int initialAyahNumber;

  const TilawatPage({
    super.key,
    required this.initialSuraNumber,
    required this.initialAyahNumber,
  });

  @override
  ConsumerState<TilawatPage> createState() => _TilawatPageState();
}

class _TilawatPageState extends ConsumerState<TilawatPage> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _findInitialPageIndex(List<QuranPage> surahPages) {
    for (int i = 0; i < surahPages.length; i++) {
      final page = surahPages[i];
      for (var content in page.content) {
        if (content.ayahs
            .any((ayah) => ayah.ayahNumber == widget.initialAyahNumber)) {
          return i;
        }
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final pagesAsync = ref.watch(quranPagesProvider(widget.initialSuraNumber));
    final suraName = 'সূরা ${suraNames[widget.initialSuraNumber - 1]}';
    final surahInfo = surahInfoList[widget.initialSuraNumber - 1];
    final subtitle =
        '${surahInfo.typeLabel} | আয়াত সংখ্যা: ${surahInfo.ayatCount.toBengaliDigit()}';
    final appBarForeground = Theme.of(context).appBarTheme.foregroundColor;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: appBarForeground),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              suraName,
              style: TextStyle(
                color: appBarForeground,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'bangla/solaimanlipi',
                wordSpacing: 3,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: appBarForeground?.withOpacity(0.7),
                fontSize: 12,
                fontFamily: 'bangla/solaimanlipi',
                wordSpacing: 3,
              ),
            ),
          ],
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: appBarForeground),
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: appBarForeground),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          IconButton(
            icon: Icon(Icons.text_fields_rounded, color: appBarForeground),
            tooltip: 'ফন্ট পরিবর্তন',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const FontChangeDialog(),
              );
            },
          ),
        ],
      ),
      drawer: TilawatSelectionDrawer(
        currentSuraNumber: widget.initialSuraNumber,
      ),
      body: pagesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            Center(child: Text('পৃষ্ঠা লোড করা যায়নি:\n$err')),
        data: (surahPages) {
          if (surahPages.isEmpty) {
            return const Center(child: Text('কোন পৃষ্ঠা পাওয়া যায়নি।'));
          }

          final initialIndex = _findInitialPageIndex(surahPages);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_itemScrollController.isAttached) {
              _itemScrollController.jumpTo(
                index: initialIndex,
                alignment: 0,
              );
            }
          });

          return ScrollablePositionedList.builder(
            itemScrollController: _itemScrollController,
            itemCount: surahPages.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: QuranPageWidget(page: surahPages[index]),
              );
            },
          );
        },
      ),
    );
  }
}
