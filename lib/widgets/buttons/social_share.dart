import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';

class SocialShare extends StatelessWidget {
  const SocialShare({
    super.key,
    this.title,
    this.subtitle,
    this.body,
  });

  final String? title;
  final String? subtitle;
  final dynamic body;

  @override
  Widget build(BuildContext context) {
    const appLink =
        'https://play.google.com/store/apps/details?id=com.islami_jindegi';

    return IconButton(
      icon: const Icon(Icons.ios_share_rounded),
      onPressed: () async {
        String text = '';

        if (title != null) {
          text += '$title\n\n';
        }

        if (subtitle != null) {
          text += '$subtitle\n\n';
        }

        if (body != null) {
          final document = parse(body);
          List pList = document.querySelectorAll('p');

          if (pList.isNotEmpty) {
            for (var p in pList) {
              if (p.text != '') {
                text += '${p.text}\n';
              }
            }
          }
        }

        text += '\n$appLink';

        await Clipboard.setData(ClipboardData(text: text));

        Share.share(
          text,
          subject: title,
        );
      },
    );
  }
}
