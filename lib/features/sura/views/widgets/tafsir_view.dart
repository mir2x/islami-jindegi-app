import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/core/utils/bengali_digit_extension.dart';
import 'package:native_app/theme/app_theme_color.dart';
import '../../../../core/services/static_asset_api.dart';
import '../../../../core/utils/adaptive_text.dart';
import '../../../downloader/views/show_download_dialog.dart';
import '../../../downloader/providers/download_providers.dart';
import '../../models/ayah.dart';
import '../../models/tafsir_source.dart';
import '../../providers/tafsir_providers.dart';

class TafsirView extends ConsumerStatefulWidget {
  final int suraNumber;
  final int ayahNumber;

  const TafsirView({
    super.key,
    required this.suraNumber,
    required this.ayahNumber,
  });

  @override
  ConsumerState<TafsirView> createState() => _TafsirViewState();
}

class _TafsirViewState extends ConsumerState<TafsirView> {
  int? _expandedPanelIndex;
  final Map<int, double> _fontSizes = {};

  static const double _defaultFontSize = 18.0;
  static const double _minFontSize = 11.0;
  static const double _maxFontSize = 26.0;
  static const double _fontStep = 1.0;

  double _fontSize(int index) => _fontSizes[index] ?? _defaultFontSize;

  void _zoomIn(int index) {
    setState(() {
      _fontSizes[index] = (_fontSize(index) + _fontStep).clamp(_minFontSize, _maxFontSize);
    });
  }

  void _zoomOut(int index) {
    setState(() {
      _fontSizes[index] = (_fontSize(index) - _fontStep).clamp(_minFontSize, _maxFontSize);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ayahIdentifier =
        AyahIdentifier(sura: widget.suraNumber, ayah: widget.ayahNumber);
    final tafsirAsyncValue = ref.watch(tafsirProvider(ayahIdentifier));

    return tafsirAsyncValue.when(
      data: (tafsirData) {
        return SingleChildScrollView(
          child: ExpansionPanelList(
            expansionCallback: (index, isExpanded) => setState(() {
              _expandedPanelIndex = _expandedPanelIndex == index ? null : index;
            }),
            animationDuration: const Duration(milliseconds: 300),
            elevation: 1,
            children: tafsirData.asMap().entries.map<ExpansionPanel>((entry) {
              int index = entry.key;
              var item = entry.value;

              final colors = Theme.of(context).extension<AppThemeColors>()!;

              return ExpansionPanel(
                canTapOnHeader: true,
                backgroundColor: colors.cardBg,
                isExpanded: _expandedPanelIndex == index,
                headerBuilder: (context, isExpanded) {
                  return ListTile(
                    title: Text(
                      item.title,
                      style: TextStyle(
                        fontFamily: 'bangla/solaimanlipi',
                        wordSpacing: 3,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colors.primaryText,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  );
                },
                body: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── Font size controls ──────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _FontSizeButton(
                            icon: Icons.remove,
                            enabled: _fontSize(index) > _minFontSize,
                            onTap: () => _zoomOut(index),
                            colors: colors,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              _fontSize(index).toStringAsFixed(0),
                              style: TextStyle(
                                fontSize: 13,
                                color: colors.secondaryText,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                          _FontSizeButton(
                            icon: Icons.add,
                            enabled: _fontSize(index) < _maxFontSize,
                            onTap: () => _zoomIn(index),
                            colors: colors,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // ── Content ─────────────────────────────────────
                      item.isDownloaded
                          ? AdaptiveText(
                              (item.content != null && item.content!.isNotEmpty)
                                  ? item.content!
                                  : "এই আয়াতের জন্য কোনো তাফসীর পাওয়া যায়নি।",
                              style: TextStyle(
                                fontFamily: 'bangla/solaimanlipi',
                                wordSpacing: 3,
                                fontSize: _fontSize(index),
                                height: 1.8,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color,
                              ),
                            )
                          : _buildDownloadButton(item, ayahIdentifier),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildDownloadButton(
      TafsirSource tafsir, AyahIdentifier ayahIdentifier) {
    final sizeInMB = (tafsir.sizeBytes / 1048576).toStringAsFixed(1);
    return Column(
      children: [
        const Text(
          "এই তাফসীরটি ডাউনলোড করা নেই।",
          style: TextStyle(
              fontFamily: 'bangla/solaimanlipi', wordSpacing: 3, fontSize: 15),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          icon: const Icon(Icons.download),
          label: Text("ডাউনলোড করুন ($sizeInMB MB)"),
          style: FilledButton.styleFrom(
            backgroundColor:
                Theme.of(context).extension<AppThemeColors>()!.active,
            foregroundColor:
                Theme.of(context).extension<AppThemeColors>()!.appBarText,
          ),
          onPressed: () async {
            final assetResponse =
                await StaticAssetApi().getTafsirUrl(tafsir.id);
            if (assetResponse == null) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'ডাউনলোড লিংক তৈরি করতে সমস্যা হয়েছে। আবার চেষ্টা করুন।',
                    ),
                  ),
                );
              }
              return;
            }

            final localPath = await ref
                .read(tafsirRepositoryProvider)
                .getLocalTafsirPath(tafsir.id);

            final tafsirDownloadTask = SingleFileDownloadTask(
              id: tafsir.id,
              displayName: tafsir.title,
              fileUrl: assetResponse.url,
              localPath: localPath,
              processingLabel: 'তাফসীর ইম্পোর্ট করা হচ্ছে...',
              afterDownload: (ref) async {
                final imported = await ref
                    .read(tafsirRepositoryProvider)
                    .ensureTafsirReady(tafsir.id);
                if (!imported) {
                  throw Exception('Failed to import tafsir into database');
                }
              },
            );

            if (!mounted) return;
            showDownloadDialog(context);

            final success = await ref
                .read(downloadManagerProvider)
                .startDownload(tafsirDownloadTask);

            if (success) {
              ref.invalidate(tafsirProvider(ayahIdentifier));
            }
          },
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  FONT SIZE BUTTON
// ─────────────────────────────────────────────────────────────────────────────

class _FontSizeButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;
  final AppThemeColors colors;

  const _FontSizeButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colors.highlight.withValues(alpha: 0.55),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: enabled ? onTap : null,
        child: SizedBox(
          width: 32,
          height: 32,
          child: Icon(
            icon,
            size: 16,
            color: enabled
                ? colors.primaryText
                : colors.primaryText.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }
}

void showTafsirBottomSheet(BuildContext context, String suraName, Ayah ayah) {
  final colors = Theme.of(context).extension<AppThemeColors>()!;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: colors.cardBg,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    ),
    builder: (BuildContext bc) {
      return DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: colors.cardBg,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16.0)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'তাফসীর: $suraName, আয়াত ${ayah.ayah.toBengaliDigit()}',
                    style: TextStyle(
                      fontFamily: 'bangla/solaimanlipi',
                      wordSpacing: 3,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colors.primaryText,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: colors.divider,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: TafsirView(
                      suraNumber: ayah.sura,
                      ayahNumber: ayah.ayah,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
