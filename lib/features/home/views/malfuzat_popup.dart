import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      var locales = AppLocalizations.of(context)!;
      final preferences = await SharedPreferences.getInstance();
      int? timestamp = preferences.getInt('lastMalfuzatPopup');

      if (timestamp != null) {
        DateTime lastClosed = DateTime.fromMillisecondsSinceEpoch(timestamp);

        if (DateUtils.isSameDay(lastClosed, DateTime.now())) {
          return;
        }
      }

      final api = ref.read(malfuzatApiServiceProvider);
      final malfuzats = await api.fetchMalfuzat(
        perPage: 50,
        hasAudio: 'false',
        malfuzatAuthorId: '6842ab90-27d0-4ef9-b783-3b03388a2304',
        includeAuthor: true,
      );

      if (mounted && malfuzats.isNotEmpty) {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            var textTheme = Theme.of(context).textTheme;
            var item = malfuzats[Random().nextInt(malfuzats.length)];
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

        int timestamp = DateTime.now().millisecondsSinceEpoch;
        await preferences.setInt('lastMalfuzatPopup', timestamp);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
