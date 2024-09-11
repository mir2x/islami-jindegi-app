import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/main.data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:native_app/widgets/presentation/popup_dialog.dart';
import 'package:native_app/widgets/utils/html_text.dart';
import 'package:native_app/theme/app_theme.dart';

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
      String theme = preferences.getString('theme') ?? 'classic';
      int? timestamp = preferences.getInt('lastMalfuzatPopup');

      if (timestamp != null) {
        DateTime lastClosed = DateTime.fromMillisecondsSinceEpoch(timestamp);

        if (DateUtils.isSameDay(lastClosed, DateTime.now())) {
          return;
        }
      }

      var malfuzats = await ref.malfuzats.findAll(
        params: const {
          'include': 'malfuzat-author',
          'hasAudio': 'false',
          'random': true,
          'quantity': 1,
        },
      );

      if (mounted) {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            var textTheme = Theme.of(context).textTheme;
            var item = malfuzats.first;
            String? author = item.malfuzatAuthor?.value?.name;

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
                      color: AppTheme.popupBarColor[theme],
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      locales.malfuzat,
                      style: textTheme.labelLarge?.copyWith(
                        color: AppTheme.labelOppsititeColor[theme],
                        fontFamily: 'bangla/ben-sen-handwriting',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                item.title,
                                style: textTheme.headlineLarge?.copyWith(
                                  fontFamily: 'bangla/ben-sen-handwriting',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            if (author != null) ...[
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  author,
                                  style: textTheme.labelMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                            if (item.body != null) ...[
                              Container(
                                margin: const EdgeInsets.only(bottom: 25),
                                child: HtmlText(text: item.body!),
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
