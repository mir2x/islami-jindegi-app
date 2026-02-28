import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/core/utils/bengali_digit_extension.dart';
import 'package:native_app/theme/colors.dart';
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

              final colorScheme = Theme.of(context).colorScheme;
              final textTheme = Theme.of(context).textTheme;

              return ExpansionPanel(
                canTapOnHeader: true,
                backgroundColor: colorScheme.surfaceVariant.withOpacity(0.5),
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
                        color: colorScheme.primary,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  );
                },
                body: Container(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                  alignment: Alignment.centerLeft,
                  child: item.isDownloaded
                      ? AdaptiveText(
                          (item.content != null && item.content!.isNotEmpty)
                              ? item.content!
                              : "এই আয়াতের জন্য কোনো তাফসীর পাওয়া যায়নি।",
                          style: TextStyle(
                            fontFamily: 'bangla/solaimanlipi',
                            wordSpacing: 3,
                            fontSize: 15,
                            height: 1.8,
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                        )
                      : _buildDownloadButton(item, ayahIdentifier),
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
        ElevatedButton.icon(
          icon: const Icon(Icons.download),
          label: Text("ডাউনলোড করুন ($sizeInMB MB)"),
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

void showTafsirBottomSheet(BuildContext context, String suraName, Ayah ayah) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
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
              color: Theme.of(context).scaffoldBackgroundColor,
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
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Divider(
                    height: 1,
                    thickness: 1,
                    color: Theme.of(context).dividerColor),
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
