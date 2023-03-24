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
    this.link,
  });

  final String? title;
  final String? subtitle;
  final dynamic body;
  final String? link;

  @override
  Widget build(BuildContext context) {
    const appLink =
        'https://play.google.com/store/apps/details?id=com.islami_jindegi';

    return IconButton(
      icon: const Icon(Icons.ios_share_rounded),
      onPressed: () async {
        String text = '';

        if (title != null) {
          text += '$title';
        }

        if (subtitle != null) {
          text += '\n\n$subtitle';
        }

        if (body != null) {
          final document = parse(body);
          List pList = document.querySelectorAll('p');

          if (pList.isNotEmpty) {
            text += '\n\n';
            for (var p in pList) {
              if (p.text != '') {
                text += '${p.text}\n';
              }
            }
          }
        }

        if (link != null) {
          text += '\n\nhttps://islamidars.com/$link';
        }

        text += '\n\n$appLink';

        await Clipboard.setData(ClipboardData(text: text));

        Share.share(
          text,
          subject: title,
        );
      },
    );
  }
}
