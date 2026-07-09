import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:native_app/features/malfuzat/models/malfuzat.dart';
import 'package:native_app/widgets/presentation/popup_dialog.dart';
import 'package:native_app/widgets/utils/html_text.dart';
import 'package:native_app/features/malfuzat/providers/malfuzat_providers.dart';
import 'package:native_app/theme/app_theme_color.dart';

class MalfuzatPopup extends ConsumerStatefulWidget {
  const MalfuzatPopup({super.key});

  @override
  MalfuzatPopupState createState() => MalfuzatPopupState();
}

class MalfuzatPopupState extends ConsumerState<MalfuzatPopup> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Small delay so the app fully settles (permissions, navigation, etc.)
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) {
        debugPrint('[MalfuzatPopup] not mounted after initial delay — aborting');
        return;
      }

      var locales = AppLocalizations.of(context)!;

      late final SharedPreferences preferences;
      try {
        preferences = await SharedPreferences.getInstance();
      } catch (e) {
        debugPrint('[MalfuzatPopup] failed to get SharedPreferences: $e');
        return;
      }

      final int? timestamp = preferences.getInt('lastMalfuzatPopup');
      debugPrint('[MalfuzatPopup] lastMalfuzatPopup timestamp: $timestamp');

      if (timestamp != null) {
        final DateTime lastClosed =
            DateTime.fromMillisecondsSinceEpoch(timestamp);
        if (DateUtils.isSameDay(lastClosed, DateTime.now())) {
          debugPrint('[MalfuzatPopup] already shown today — skipping');
          return;
        }
      } else {
        debugPrint('[MalfuzatPopup] no prior timestamp — first run or cache cleared');
      }

      if (!mounted) {
        debugPrint('[MalfuzatPopup] not mounted before API call — aborting');
        return;
      }

      debugPrint('[MalfuzatPopup] fetching malfuzat from API...');
      MalfuzatItem? randomMalfuzat;
      try {
        final api = ref.read(malfuzatApiServiceProvider);
        randomMalfuzat = await api.fetchRandomMalfuzat(
          authorId: '6842ab90-27d0-4ef9-b783-3b03388a2304',
          hasAudio: false,
        );
        debugPrint('[MalfuzatPopup] API returned random item: $randomMalfuzat');
      } catch (e, stack) {
        debugPrint('[MalfuzatPopup] API error: $e');
        debugPrint('[MalfuzatPopup] Stack: $stack');
        return;
      }

      if (randomMalfuzat == null) {
        debugPrint('[MalfuzatPopup] empty result — not showing popup');
        return;
      }

      if (!mounted) {
        debugPrint('[MalfuzatPopup] not mounted after API call — aborting');
        return;
      }

      debugPrint('[MalfuzatPopup] showing popup...');
      try {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            var textTheme = Theme.of(context).textTheme;
            final item = randomMalfuzat!;
            String? author = item.authorName;
            final appColors = Theme.of(context).extension<AppThemeColors>()!;

            return PopupDialog(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      color: appColors.appBarBg,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: appColors.appBarText.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            Icons.menu_book_rounded,
                            color: appColors.appBarText,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            locales.malfuzat,
                            style: textTheme.headlineSmall?.copyWith(
                              color: appColors.appBarText,
                              fontFamily: 'bangla/solaimanlipi',
                              wordSpacing: 3,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: appColors.cardBg,
                      padding: const EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 14),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: appColors.surfaceBg.withValues(
                                  alpha: 0.9,
                                ),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: appColors.divider.withValues(
                                    alpha: 0.45,
                                  ),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    item.title,
                                    style: textTheme.headlineSmall?.copyWith(
                                      fontFamily: 'bangla/solaimanlipi',
                                      wordSpacing: 3,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  if (author != null) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      author,
                                      style: textTheme.labelLarge?.copyWith(
                                        fontFamily: 'bangla/solaimanlipi',
                                        wordSpacing: 3,
                                        color: appColors.secondaryText,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            if (item.body != null) ...[
                              HtmlText(
                                text: item.body!,
                                fontSizeRatio: 1.1,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );

        final int now = DateTime.now().millisecondsSinceEpoch;
        await preferences.setInt('lastMalfuzatPopup', now);
        debugPrint('[MalfuzatPopup] popup shown and timestamp saved');
      } catch (e, stack) {
        debugPrint('[MalfuzatPopup] showDialog error: $e');
        debugPrint('[MalfuzatPopup] Stack: $stack');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
