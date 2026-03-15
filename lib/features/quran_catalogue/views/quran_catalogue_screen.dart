import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/static_asset_api.dart';
import '../../downloader/views/show_download_dialog.dart';
import '../../downloader/views/show_download_permission_dialog.dart';
import '../../downloader/providers/download_providers.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/features/sura/utils/navigation_routes.dart';
import 'package:native_app/theme/app_theme_color.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import '../models/quran_edition.dart';
import '../providers/quran_catalogue_providers.dart';

class QuranCatalogueScreen extends ConsumerWidget {
  const QuranCatalogueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quranEditions = ref.watch(quranEditionProvider);
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    return AppScaffold(
      onBackPressed: () async => context.go('/'),
      title: const Text('কুরআন'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                final int? lastSura = prefs.getInt('last_read_sura');
                final int? lastAyahIndex = prefs.getInt('last_read_ayah_index');

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
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colors.primary,
                      colors.secondary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: colors.shadow.withValues(alpha: 0.18),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.menu_book_rounded,
                      color: colors.appBarText,
                      size: 28.r,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'তাফসীর',
                      style: TextStyle(
                        wordSpacing: 3,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                        color: colors.appBarText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: quranEditions.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.r,
                mainAxisSpacing: 16.r,
                childAspectRatio: 0.5,
              ),
              itemBuilder: (context, index) {
                return _QuranEditionGridItem(edition: quranEditions[index]);
              },
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}

class _QuranEditionGridItem extends ConsumerWidget {
  final QuranEdition edition;

  const _QuranEditionGridItem({required this.edition});

  bool get hasCheckmark => edition.isDownloaded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(8.r),
          onTap: () async {
            if (!edition.isDownloaded) {
              final confirmed = await showDownloadPermissionDialog(
                context,
                assetName: edition.title,
                sizeInfo:
                    '(${(edition.sizeBytes / 1048576).toStringAsFixed(1)} MB)',
              );
              if (!confirmed || !context.mounted) return;

              final assetResponse =
                  await StaticAssetApi().getMushafUrl(edition.id);
              if (assetResponse == null) {
                if (context.mounted) {
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

              final mushafDownloadTask = ZipDownloadTask(
                id: edition.id,
                displayName: edition.title,
                zipUrl: assetResponse.url,
              );

              if (!context.mounted) return;
              showDownloadDialog(context);
              ref
                  .read(downloadManagerProvider)
                  .startDownload(mushafDownloadTask);
            } else {
              final dirPath = await getLocalPath(edition.id);
              final editionDirectory = Directory(dirPath);
              if (await editionDirectory.exists() && context.mounted) {
                context.push(
                  '/qurans/quran?path=${Uri.encodeComponent(dirPath)}&width=${edition.imageWidth}&height=${edition.imageHeight}&ext=${edition.imageExt}',
                );
              } else if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Error: Mushaf files not found. Please try downloading again.',
                    ),
                  ),
                );
              }
            }
          },
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              SizedBox(
                width: double.infinity,
                child: ClipRRect(
                  child: Image.asset(
                    edition.coverImagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (hasCheckmark)
                Positioned(
                  top: -12.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: BoxDecoration(
                        color: colors.active,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        size: 16.r,
                        color: colors.appBarText,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: Text(
            edition.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: textTheme.bodyLarge?.color,
              wordSpacing: 3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
