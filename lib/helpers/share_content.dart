import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

const _androidStoreUrl =
    'https://play.google.com/store/apps/details?id=com.islami_jindegi';
const _iosStoreUrl = 'https://apps.apple.com/app/islami-jindegi/id1271205014';

String get appStoreShareUrl => Platform.isIOS ? _iosStoreUrl : _androidStoreUrl;

/// Opens the native share sheet with an iPad-safe anchor and a visible failure
/// message. Every share entry point should go through this function.
Future<void> shareContent(
  BuildContext context, {
  required String text,
  String? subject,
}) async {
  final renderBox = context.findRenderObject() as RenderBox?;
  final origin = renderBox == null
      ? null
      : renderBox.localToGlobal(Offset.zero) & renderBox.size;

  try {
    await SharePlus.instance.share(
      ShareParams(
        text: text,
        subject: subject,
        sharePositionOrigin: origin,
      ),
    );
  } catch (_) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('শেয়ার করা যায়নি। আবার চেষ্টা করুন।')),
    );
  }
}
