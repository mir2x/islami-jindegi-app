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
import '../../models/tafsir_source.dart';
import '../../providers/sura_reciter_providers.dart';
import '../../providers/tafsir_providers.dart';

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

void showShareOptionsBottomSheet(
  BuildContext context,
  int suraNumber,
  Ayah ayah,
  String suraName,
) {
  final colors = Theme.of(context).extension<AppThemeColors>()!;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: colors.cardBg,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    ),
    builder: (_) => _ShareOptionsSheet(
      suraNumber: suraNumber,
      ayah: ayah,
      suraName: suraName,
    ),
  );
}

class _ShareOptionsSheet extends ConsumerStatefulWidget {
  final int suraNumber;
  final Ayah ayah;
  final String suraName;

  const _ShareOptionsSheet({
    required this.suraNumber,
    required this.ayah,
    required this.suraName,
  });

  @override
  ConsumerState<_ShareOptionsSheet> createState() => _ShareOptionsSheetState();
}

class _ShareOptionsSheetState extends ConsumerState<_ShareOptionsSheet> {
  bool _includeArabic = true;
  final Set<int> _selectedTranslations = {};
  final Set<String> _selectedTafsirs = {};

  String _buildShareText(List<TafsirSource>? tafsirs) {
    final parts = <String>[
      '${widget.suraName}, আয়াত ${widget.ayah.ayah.toBengaliDigit()}',
    ];
    if (_includeArabic) parts.add(widget.ayah.arabicText);
    for (final i in _selectedTranslations) {
      final t = widget.ayah.translations[i];
      parts.add('— ${t.translatorName}\n${t.text}');
    }
    for (final id in _selectedTafsirs) {
      final tafsir = tafsirs?.where((t) => t.id == id).firstOrNull;
      if (tafsir?.content != null && tafsir!.content!.isNotEmpty) {
        parts.add('— ${tafsir.title}\n${tafsir.content}');
      }
    }
    return parts.join('\n\n');
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final ayahIdentifier =
        AyahIdentifier(sura: widget.suraNumber, ayah: widget.ayah.ayah);
    final tafsirAsync = ref.watch(tafsirProvider(ayahIdentifier));
    final tafsirs = tafsirAsync.value;
    final downloadedTafsirs =
        tafsirs?.where((t) => t.isDownloaded).toList() ?? [];

    final shareText = _buildShareText(tafsirs);

    return Container(
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Text(
              'শেয়ার: ${widget.suraName}, আয়াত ${widget.ayah.ayah.toBengaliDigit()}',
              style: TextStyle(
                fontFamily: 'bangla/solaimanlipi',
                wordSpacing: 3,
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: colors.primaryText,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Divider(height: 1, thickness: 1, color: colors.divider),

          // ── Arabic ───────────────────────────────────────────────
          _SectionHeader(label: 'আরবি', colors: colors),
          CheckboxListTile(
            title: Text(
              'আরবি পাঠ',
              style: TextStyle(
                fontFamily: 'bangla/solaimanlipi',
                wordSpacing: 3,
                fontSize: 15,
                color: colors.primaryText,
              ),
            ),
            value: _includeArabic,
            activeColor: colors.active,
            onChanged: (v) => setState(() => _includeArabic = v ?? true),
          ),

          // ── Translations ─────────────────────────────────────────
          if (widget.ayah.translations.isNotEmpty) ...[
            _SectionHeader(label: 'অনুবাদ', colors: colors),
            ...widget.ayah.translations.asMap().entries.map((entry) {
              final selected = _selectedTranslations.contains(entry.key);
              return CheckboxListTile(
                title: Text(
                  entry.value.translatorName,
                  style: TextStyle(
                    fontFamily: 'bangla/solaimanlipi',
                    wordSpacing: 3,
                    fontSize: 15,
                    color: colors.primaryText,
                  ),
                ),
                value: selected,
                activeColor: colors.active,
                onChanged: (v) => setState(() {
                  if (v == true) {
                    _selectedTranslations.add(entry.key);
                  } else {
                    _selectedTranslations.remove(entry.key);
                  }
                }),
              );
            }),
          ],

          // ── Tafsirs ──────────────────────────────────────────────
          if (tafsirAsync.isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (downloadedTafsirs.isNotEmpty) ...[
            _SectionHeader(label: 'তাফসীর', colors: colors),
            ...downloadedTafsirs.map((tafsir) {
              final selected = _selectedTafsirs.contains(tafsir.id);
              return CheckboxListTile(
                title: Text(
                  tafsir.title,
                  style: TextStyle(
                    fontFamily: 'bangla/solaimanlipi',
                    wordSpacing: 3,
                    fontSize: 15,
                    color: colors.primaryText,
                  ),
                ),
                value: selected,
                activeColor: colors.active,
                onChanged: (v) => setState(() {
                  if (v == true) {
                    _selectedTafsirs.add(tafsir.id);
                  } else {
                    _selectedTafsirs.remove(tafsir.id);
                  }
                }),
              );
            }),
          ],

          Divider(height: 1, thickness: 1, color: colors.divider),
          Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              12,
              16,
              16 + MediaQuery.of(context).viewPadding.bottom,
            ),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.share),
                label: const Text(
                  'শেয়ার করুন',
                  style: TextStyle(
                    fontFamily: 'bangla/solaimanlipi',
                    wordSpacing: 3,
                    fontSize: 16,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: colors.active,
                  foregroundColor: colors.appBarText,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: (!_includeArabic && _selectedTranslations.isEmpty && _selectedTafsirs.isEmpty)
                    ? null
                    : () {
                        Navigator.pop(context);
                        Share.share(shareText);
                      },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final AppThemeColors colors;

  const _SectionHeader({required this.label, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'bangla/solaimanlipi',
          wordSpacing: 3,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: colors.secondaryText,
        ),
      ),
    );
  }
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
                ref.read(selectedAudioSuraProvider.notifier).set(suraNumber);
                ref.read(selectedStartAyahProvider.notifier).set(selectedStartAyah);
                ref.read(selectedEndAyahProvider.notifier).set(selectedEndAyah);

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
              onTap: () {
                Navigator.pop(bottomSheetContext);
                showShareOptionsBottomSheet(
                  context,
                  suraNumber,
                  ayah,
                  suraName,
                );
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
