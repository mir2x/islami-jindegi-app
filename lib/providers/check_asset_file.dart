import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

final checkAssetFileProvider =
    FutureProvider.family<bool, String>((ref, String assetPath) async {
  final Uint8List encoded = const Utf8Codec()
      .encoder
      .convert(Uri(path: Uri.encodeFull('assets/$assetPath')).path);
  // returns null if an asset is not found
  final ByteData? asset = await ServicesBinding.instance.defaultBinaryMessenger
      .send('flutter/assets', encoded.buffer.asByteData());
  return asset != null;
});
