import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/core/utils/bengali_digit_extension.dart';
import 'package:native_app/features/sura/views/widgets/tafsir_view.dart';
import 'package:native_app/features/sura/views/widgets/tilawat_page.dart';
import 'package:native_app/features/sura_list/providers/bookmark_providers.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/ayah.dart';
import '../../providers/sura_reciter_providers.dart';

class AyahActionItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  AyahActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

void showAyahActionBottomSheet(
  BuildContext context,
  int suraNumber,
  Ayah ayah,
  String suraName,
  WidgetRef ref,
) {
  final int selectedStartAyah = ayah.ayah;
  final int selectedEndAyah = ayah.ayah;

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    ),
    builder: (BuildContext bottomSheetContext) {
      return Consumer(
        builder: (context, ref, child) {
          final isBookmarked = ref.watch(
              isAyahBookmarkedProvider((sura: suraNumber, ayah: ayah.ayah)));

          final List<AyahActionItem> actions = [
            AyahActionItem(
              icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              label: isBookmarked ? 'বুকমার্ক সরান' : 'বুকমার্ক',
              onTap: () {
                ref.read(bookmarkProvider.notifier).toggleBookmark(
                      suraNumber: suraNumber,
                      ayahNumber: ayah.ayah,
                      suraName: suraName,
                      arabicText: ayah.arabicText,
                    );
                Navigator.pop(bottomSheetContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isBookmarked
                          ? 'বুকমার্ক সরানো হয়েছে'
                          : 'বুকমার্ক যোগ হয়েছে',
                      style: const TextStyle(fontFamily: 'bangla/solaimanlipi'),
                    ),
                  ),
                );
              },
            ),
            AyahActionItem(
              icon: Icons.play_arrow,
              label: 'অডিও শুনুন',
              onTap: () async {
                final audioPlayer = ref.read(suraAudioPlayerProvider);
                ref.read(selectedAudioSuraProvider.notifier).state = suraNumber;
                ref.read(selectedStartAyahProvider.notifier).state =
                    selectedStartAyah;
                ref.read(selectedEndAyahProvider.notifier).state =
                    selectedEndAyah;

                if (!context.mounted) return;
                final bool playbackStarted = await audioPlayer.playAyahs(
                  selectedStartAyah,
                  selectedEndAyah,
                  context,
                );
                if (playbackStarted && bottomSheetContext.mounted) {
                  Navigator.pop(bottomSheetContext);
                }
              },
            ),
            AyahActionItem(
              icon: Icons.menu_book,
              label: 'তাফসীর',
              onTap: () {
                Navigator.pop(bottomSheetContext);
                showTafsirBottomSheet(context, suraName, ayah);
              },
            ),
            AyahActionItem(
              icon: Icons.chrome_reader_mode,
              label: 'তিলাওয়াত মোড',
              onTap: () {
                Navigator.pop(bottomSheetContext);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TilawatPage(
                      initialSuraNumber: suraNumber,
                      initialAyahNumber: ayah.ayah,
                    ),
                  ),
                );
              },
            ),
            AyahActionItem(
              icon: Icons.copy,
              label: 'কপি',
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: ayah.arabicText));
                Navigator.pop(bottomSheetContext);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'আয়াতটি কপি হয়েছে',
                        style: TextStyle(fontFamily: 'bangla/solaimanlipi'),
                      ),
                    ),
                  );
                }
              },
            ),
            AyahActionItem(
              icon: Icons.share,
              label: 'শেয়ার',
              onTap: () async {
                Navigator.pop(bottomSheetContext);
                await Share.share(ayah.arabicText);
              },
            ),
          ];

          return Container(
            padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '$suraName, আয়াত ${ayah.ayah.toBengaliDigit()}',
                  style: TextStyle(
                    fontFamily: 'bangla/solaimanlipi',
                    wordSpacing: 3,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
                const SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: actions.length,
                  itemBuilder: (context, index) {
                    final item = actions[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: item.onTap,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(item.icon,
                              size: 36,
                              color: Theme.of(context).colorScheme.primary),
                          const SizedBox(height: 8),
                          Text(
                            item.label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'bangla/solaimanlipi',
                              wordSpacing: 3,
                              fontSize: 14,
                              color:
                                  Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
