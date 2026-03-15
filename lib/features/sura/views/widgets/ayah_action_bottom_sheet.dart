import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/core/utils/bengali_digit_extension.dart';
import 'package:native_app/features/quran/models/bookmark.dart';
import 'package:native_app/features/quran/providers/ayah_highlight_providers.dart';
import 'package:native_app/features/quran/providers/bookmark_providers.dart';
import 'package:native_app/features/sura/utils/navigation_routes.dart';
import 'package:native_app/features/sura/views/widgets/tafsir_view.dart';
import 'package:native_app/theme/app_theme_color.dart';
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
  String returnTo,
  WidgetRef ref,
) {
  final int selectedStartAyah = ayah.ayah;
  final int selectedEndAyah = ayah.ayah;

  showModalBottomSheet(
    context: context,
    backgroundColor: Theme.of(context).extension<AppThemeColors>()!.cardBg,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    ),
    builder: (BuildContext bottomSheetContext) {
      return Consumer(
        builder: (context, ref, child) {
          final colors = Theme.of(context).extension<AppThemeColors>()!;
          final actionIconColor = colors.active;
          ref.watch(bookmarkProvider);
          final bookmarkNotifier = ref.read(bookmarkProvider.notifier);
          final isBookmarked =
              bookmarkNotifier.isAyahBookmarked(suraNumber, ayah.ayah);

          final List<AyahActionItem> actions = [
            AyahActionItem(
              icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              label: isBookmarked ? 'বুকমার্ক সরান' : 'বুকমার্ক',
              onTap: () {
                final identifier = 'ayah-$suraNumber-${ayah.ayah}';
                if (isBookmarked) {
                  bookmarkNotifier.remove(identifier);
                } else {
                  final quranInfoService = ref.read(quranInfoServiceProvider);
                  bookmarkNotifier.add(
                    Bookmark(
                      type: 'ayah',
                      identifier: identifier,
                      sura: suraNumber,
                      ayah: ayah.ayah,
                      para: quranInfoService.getParaBySuraAyah(
                        suraNumber,
                        ayah.ayah,
                      ),
                      page: quranInfoService.getPageBySuraAyah(
                        suraNumber,
                        ayah.ayah,
                      ),
                    ),
                  );
                }
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
                GoRouter.of(context).push(
                  buildTilawatRoute(
                    suraNumber: suraNumber,
                    ayahNumber: ayah.ayah,
                    returnTo: returnTo,
                  ),
                );
              },
            ),
            AyahActionItem(
              icon: Icons.copy,
              label: 'কপি',
              onTap: () async {
                final messenger = ScaffoldMessenger.of(context);
                final navigator = Navigator.of(bottomSheetContext);
                await Clipboard.setData(ClipboardData(text: ayah.arabicText));
                navigator.pop();
                if (context.mounted) {
                  messenger.showSnackBar(
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
            decoration: BoxDecoration(
              color: colors.cardBg,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16.0)),
            ),
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
                    color: colors.primaryText,
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
                          Icon(item.icon, size: 36, color: actionIconColor),
                          const SizedBox(height: 8),
                          Text(
                            item.label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'bangla/solaimanlipi',
                              wordSpacing: 3,
                              fontSize: 14,
                              color: colors.primaryText,
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
