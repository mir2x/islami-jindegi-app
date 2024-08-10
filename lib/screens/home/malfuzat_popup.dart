import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/main.data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:native_app/widgets/presentation/popup_dialog.dart';
import 'package:native_app/widgets/utils/html_text.dart';

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
      final preferences = await SharedPreferences.getInstance();
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      child: Text(
                        item.title,
                        style: textTheme.headlineMedium,
                      ),
                    ),
                    if (author != null) ...[
                      Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        child: Text(
                          author,
                          style: textTheme.labelMedium,
                        ),
                      ),
                    ],
                    if (item.body != null) ...[
                      Container(
                        margin: const EdgeInsets.only(bottom: 30),
                        child: HtmlText(text: item.body!),
                      ),
                    ],
                  ],
                ),
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
