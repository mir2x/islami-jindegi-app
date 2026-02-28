import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/static_asset_api.dart';
import '../../core/utils/offline_database_helper.dart';

/// A widget that checks if the offline DB for a feature is downloaded.
/// If not, shows a prompt to the user with options:
/// - Download Now (downloads in background)
/// - Later (proceeds to page, shows prompt again next time)
/// - Never Show (saves preference, never shows again)
///
/// Usage: Wrap your feature screen's body with this widget.
/// ```dart
/// OfflineDbPrompt(
///   feature: 'bayans',
///   child: YourActualContent(),
/// )
/// ```
class OfflineDbPrompt extends StatefulWidget {
  final String feature;
  final Widget child;

  const OfflineDbPrompt({
    super.key,
    required this.feature,
    required this.child,
  });

  @override
  State<OfflineDbPrompt> createState() => _OfflineDbPromptState();
}

class _OfflineDbPromptState extends State<OfflineDbPrompt> {
  bool _downloading = false;
  double _downloadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _checkAndPrompt();
  }

  Future<void> _checkAndPrompt() async {
    final isAvailable = await OfflineDatabaseHelper.isAvailable(widget.feature);
    if (isAvailable) return;

    final prefs = await SharedPreferences.getInstance();
    final neverShow =
        prefs.getBool('offline_db_never_show_${widget.feature}') ?? false;

    if (neverShow) return;

    if (!mounted) return;

    // Show the prompt after frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _showPromptDialog();
    });
  }

  void _showPromptDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'অফলাইন ডাটা ডাউনলোড',
          style: TextStyle(
            fontFamily: 'bangla/solaimanlipi',
            fontWeight: FontWeight.bold,
            wordSpacing: 3,
          ),
        ),
        content: const Text(
          'অফলাইন ডাটা ডাউনলোড করলে ইন্টারনেট ছাড়াও এই বিভাগের তথ্য দেখতে পারবেন।',
          style: TextStyle(
            fontFamily: 'bangla/solaimanlipi',
            wordSpacing: 3,
            fontSize: 15,
            height: 1.6,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool(
                  'offline_db_never_show_${widget.feature}', true);
              if (ctx.mounted) Navigator.of(ctx).pop();
            },
            child: const Text(
              'আর দেখাবেন না',
              style: TextStyle(
                fontFamily: 'bangla/solaimanlipi',
                wordSpacing: 3,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text(
              'পরে',
              style: TextStyle(
                fontFamily: 'bangla/solaimanlipi',
                wordSpacing: 3,
              ),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _startBackgroundDownload();
            },
            child: const Text(
              'ডাউনলোড',
              style: TextStyle(
                fontFamily: 'bangla/solaimanlipi',
                wordSpacing: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _startBackgroundDownload() async {
    setState(() {
      _downloading = true;
      _downloadProgress = 0.0;
    });

    try {
      final assetResponse = await StaticAssetApi().getDbUrl(widget.feature);
      if (assetResponse == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'ডাউনলোড লিংক তৈরি করতে সমস্যা হয়েছে।',
                style: TextStyle(fontFamily: 'bangla/solaimanlipi'),
              ),
            ),
          );
        }
        setState(() => _downloading = false);
        return;
      }

      final dbPath = await OfflineDatabaseHelper.getDbPath(widget.feature);

      // Ensure directory exists
      try {
        await Directory(p.dirname(dbPath)).create(recursive: true);
      } catch (_) {}

      final dio = Dio();
      await dio.download(
        assetResponse.url,
        dbPath,
        onReceiveProgress: (received, total) {
          if (total > 0 && mounted) {
            setState(() {
              _downloadProgress = received / total;
            });
          }
        },
      );

      // Mark version so OfflineDatabaseHelper knows it's current
      await OfflineDatabaseHelper.markVersion(widget.feature, 1);

      if (mounted) {
        setState(() => _downloading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'অফলাইন ডাটা সফলভাবে ডাউনলোড হয়েছে ✓',
              style: TextStyle(fontFamily: 'bangla/solaimanlipi'),
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error downloading DB for ${widget.feature}: $e');
      if (mounted) {
        setState(() => _downloading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'ডাউনলোড করতে সমস্যা হয়েছে। আবার চেষ্টা করুন।',
              style: TextStyle(fontFamily: 'bangla/solaimanlipi'),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_downloading)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      value: _downloadProgress > 0 ? _downloadProgress : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'অফলাইন ডাটা ডাউনলোড হচ্ছে... ${(_downloadProgress * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontFamily: 'bangla/solaimanlipi',
                        wordSpacing: 3,
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
