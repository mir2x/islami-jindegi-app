import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/static_asset_api.dart';
import '../../../theme/app_theme_color.dart';
import '../../../widgets/layouts/app_scaffold.dart';
import '../../downloader/providers/download_providers.dart';
import '../../downloader/views/show_download_dialog.dart';
import '../../downloader/views/show_download_permission_dialog.dart';
import '../../sura/utils/navigation_routes.dart';
import '../models/quran_edition.dart';
import '../providers/quran_catalogue_providers.dart';

class QuranCatalogueScreen extends ConsumerWidget {
  const QuranCatalogueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locales = AppLocalizations.of(context)!;
    final quranEditions = ref.watch(quranEditionProvider);
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isClassic = colors.primary == AppThemeColors.classic.primary &&
        colors.appBarBg == AppThemeColors.classic.appBarBg;
    final heroBase = isClassic
        ? colors.secondary
        : isDark
            ? Color.alphaBlend(colors.primary.withValues(alpha: 0.22), colors.scaffoldBg)
            : colors.primary;
    final heroAccent = isClassic
        ? Color.alphaBlend(
            colors.accent.withValues(alpha: 0.26),
            colors.appBarBg,
          )
        : isDark
            ? Color.alphaBlend(
                colors.secondary.withValues(alpha: 0.12),
                colors.cardBg,
              )
            : Color.alphaBlend(
                colors.secondary.withValues(alpha: 0.18),
                colors.primary,
              );
    final heroForeground = isClassic
        ? colors.appBarText
        : isDark
            ? colors.primaryText
            : const Color(0xFFF7F4EC);
    final heroMutedForeground = isDark
        ? colors.secondaryText
        : heroForeground.withValues(alpha: 0.82);
    final heroPanelColor = isClassic
        ? colors.highlight.withValues(alpha: 0.18)
        : isDark
            ? colors.highlight.withValues(alpha: 0.6)
            : Colors.white.withValues(alpha: 0.12);
    final heroPanelBorder = isClassic
        ? colors.highlight.withValues(alpha: 0.34)
        : isDark
            ? colors.highlightBorder.withValues(alpha: 0.8)
            : Colors.white.withValues(alpha: 0.16);
    final heroPanelIconBg = isClassic
        ? colors.highlight.withValues(alpha: 0.26)
        : isDark
            ? colors.highlight
            : Colors.white.withValues(alpha: 0.14);

    return AppScaffold(
      onBackPressed: () async {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/');
        }
      },
      title: Text(locales.quranCatalogueEyebrow),
      extraActions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => context.push(
            buildSearchRoute(returnTo: '/qurans'),
          ),
        ),
      ],
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 28.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 0),
              padding: EdgeInsets.fromLTRB(22.w, 22.h, 22.w, 26.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    heroBase,
                    heroAccent,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28.r),
                  bottomRight: Radius.circular(28.r),
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: colors.shadow.withValues(alpha: 0.12),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locales.quranCatalogueEyebrow,
                    style: textTheme.headlineMedium?.copyWith(
                      color: heroForeground,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 18.h),
                  InkWell(
                    borderRadius: BorderRadius.circular(28.r),
                    onTap: () => _handleContinueReading(context),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(18.r),
                      decoration: BoxDecoration(
                        color: heroPanelColor,
                        borderRadius: BorderRadius.circular(28.r),
                        border: Border.all(
                          color: heroPanelBorder,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 52.r,
                            height: 52.r,
                            decoration: BoxDecoration(
                              color: heroPanelIconBg,
                              borderRadius: BorderRadius.circular(18.r),
                            ),
                            child: Icon(
                              Icons.auto_stories_rounded,
                              color: heroForeground,
                              size: 28.r,
                            ),
                          ),
                          SizedBox(width: 14.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  locales.continueReading,
                                  style: textTheme.titleMedium?.copyWith(
                                    color: heroForeground,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  locales.continueReadingDescription,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: heroMutedForeground,
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: heroForeground.withValues(alpha: 0.84),
                            size: 18.r,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(18.w, 22.h, 18.w, 0),
              child: Row(
                children: [
                  Icon(
                    Icons.library_books_rounded,
                    color: colors.secondary,
                    size: 22.r,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      locales.mushafLibrary,
                      style: textTheme.titleLarge?.copyWith(
                        color: colors.primaryText,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),
            if (quranEditions.isEmpty)
              Padding(
                padding: EdgeInsets.only(top: 80.h),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: Column(
                  children: [
                    for (final edition in quranEditions) ...[
                      _QuranEditionListItem(edition: edition),
                      SizedBox(height: 14.h),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleContinueReading(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final lastSura = prefs.getInt('last_read_sura');
    final lastAyahIndex = prefs.getInt('last_read_ayah_index');

    if (!context.mounted) return;

    if (lastSura != null && lastAyahIndex != null) {
      context.push(
        buildSuraRoute(
          suraNumber: lastSura,
          scrollIndex: lastAyahIndex,
        ),
      );
    } else {
      context.push('/qurans/sura-list');
    }
  }
}

class _QuranEditionListItem extends ConsumerWidget {
  const _QuranEditionListItem({required this.edition});

  final QuranEdition edition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locales = AppLocalizations.of(context)!;
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final isClassic = colors.primary == AppThemeColors.classic.primary &&
        colors.appBarBg == AppThemeColors.classic.appBarBg;
    final actionBackground = edition.isDownloaded
        ? (isClassic ? colors.secondary : colors.primary)
        : colors.highlight;
    final actionForegroundBrightness =
        ThemeData.estimateBrightnessForColor(actionBackground);
    final actionForeground = edition.isDownloaded
        ? (actionForegroundBrightness == Brightness.dark
            ? const Color(0xFFF8F4EA)
            : colors.primaryText)
        : (isClassic ? colors.appBarBg : colors.primaryText);
    final cardBorderColor = isClassic
        ? colors.secondary.withValues(alpha: 0.18)
        : colors.highlightBorder.withValues(alpha: 0.32);
    final downloadedChipForeground =
        isClassic ? colors.appBarBg : colors.active;
    final chipForeground = isClassic ? colors.appBarBg : colors.secondaryText;

    return InkWell(
      borderRadius: BorderRadius.circular(26.r),
      onTap: () => _handleEditionTap(context, ref),
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: colors.cardBg,
          borderRadius: BorderRadius.circular(26.r),
          border: Border.all(
            color: cardBorderColor,
          ),
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withValues(alpha: 0.06),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18.r),
              child: SizedBox(
                width: 88.w,
                height: 126.h,
                child: Image.asset(
                  edition.coverImagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    edition.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleMedium?.copyWith(
                      color: colors.primaryText,
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    _editionSubtitle(locales, edition.id),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.secondaryText,
                      height: 1.35,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      _MetaChip(
                        label: edition.isDownloaded
                            ? locales.downloaded
                            : locales.download,
                        background: edition.isDownloaded
                            ? colors.highlight
                            : colors.surfaceBg,
                        foreground: edition.isDownloaded
                            ? downloadedChipForeground
                            : chipForeground,
                      ),
                      _MetaChip(
                        label:
                            '${(edition.sizeBytes / 1048576).toStringAsFixed(1)} MB',
                        background: colors.surfaceBg,
                        foreground: chipForeground,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: actionBackground,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                edition.isDownloaded
                    ? Icons.play_arrow_rounded
                    : Icons.file_download_outlined,
                color: actionForeground,
                size: 24.r,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _editionSubtitle(AppLocalizations locales, String editionId) {
    return switch (editionId) {
      'imdadia_hafezi' => locales.mushafSubtitleImdadiaHafezi,
      'hafezi' => locales.mushafSubtitleHafezi,
      'colorful_tajweed' => locales.mushafSubtitleColorfulTajweed,
      'madani' => locales.mushafSubtitleMadani,
      'nurani' => locales.mushafSubtitleNurani,
      'colorful_hafezi' => locales.mushafSubtitleColorfulHafezi,
      _ => locales.quran,
    };
  }

  Future<void> _handleEditionTap(BuildContext context, WidgetRef ref) async {
    final locales = AppLocalizations.of(context)!;

    if (!edition.isDownloaded) {
      final confirmed = await showDownloadPermissionDialog(
        context,
        assetName: edition.title,
        sizeInfo: '(${(edition.sizeBytes / 1048576).toStringAsFixed(1)} MB)',
      );
      if (!confirmed || !context.mounted) return;

      final assetResponse = await StaticAssetApi().getMushafUrl(edition.id);
      if (assetResponse == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(locales.mushafDownloadLinkError),
            ),
          );
        }
        return;
      }

      final mushafDownloadTask = ZipDownloadTask(
        id: edition.id,
        displayName: edition.title,
        zipUrl: assetResponse.url,
      );

      if (!context.mounted) return;
      showDownloadDialog(context);
      ref.read(downloadManagerProvider).startDownload(mushafDownloadTask);
      return;
    }

    final dirPath = await getLocalPath(edition.id);
    final editionDirectory = Directory(dirPath);
    if (await editionDirectory.exists() && context.mounted) {
      context.push(
        '/qurans/quran?path=${Uri.encodeComponent(dirPath)}&width=${edition.imageWidth}&height=${edition.imageHeight}&ext=${edition.imageExt}',
      );
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(locales.mushafFilesMissingError),
        ),
      );
    }
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
