import 'package:flutter/material.dart';
import 'package:native_app/core/utils/arabic_digit_extension.dart';
import 'package:native_app/core/utils/bengali_digit_extension.dart';
import 'package:native_app/shared/quran_data.dart';
import 'package:native_app/theme/colors.dart';
import '../../model/tilawat_models.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodel/sura_viewmodel.dart';

class QuranPageWidget extends ConsumerStatefulWidget {
  final QuranPage page;

  const QuranPageWidget({super.key, required this.page});

  @override
  ConsumerState<QuranPageWidget> createState() => _QuranPageWidgetState();
}

class _QuranPageWidgetState extends ConsumerState<QuranPageWidget> {
  final List<GestureRecognizer> _recognizers = [];

  @override
  void dispose() {
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    super.dispose();
  }

  List<InlineSpan> _buildAyahOnlySpans() {
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    _recognizers.clear();

    final List<InlineSpan> spans = [];
    final textTheme = Theme.of(context).textTheme;

    for (var contentItem in widget.page.content) {
      for (var ayah in contentItem.ayahs) {
        final tapRecognizer = TapGestureRecognizer()
          ..onTap = () {
            _showAyahMenu(
              suraNumber: contentItem.suraNumber,
              ayahNumber: ayah.ayahNumber,
              suraNameBengali: suraNames[contentItem.suraNumber - 1],
            );
          };

        _recognizers.add(tapRecognizer);
        spans.add(
          TextSpan(
            text: '${ayah.text} ',
            recognizer: tapRecognizer,
            style: TextStyle(
              fontFamily: 'arabic/noorehuda',
              fontSize: 30,
              fontWeight: FontWeight.normal,
              height: 2.2,
              color: textTheme.bodyLarge?.color,
            ),
          ),
        );
        spans.add(
          TextSpan(
            text: '\u{FD3F}${ayah.ayahNumber.toArabicDigit()}\u{FD3E} ',
            recognizer: tapRecognizer,
            style: TextStyle(
              fontFamily: 'arabic/noorehuda',
              fontSize: 32,
              color: textTheme.bodyLarge?.color,
              fontWeight: FontWeight.normal,
              letterSpacing: 0,
              height: 2.2,
            ),
          ),
        );
      }
    }
    return spans;
  }

  void _showAyahMenu({
    required int suraNumber,
    required int ayahNumber,
    required String suraNameBengali,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final colorScheme = Theme.of(context).colorScheme;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
          title: Text(
            '$suraNameBengali ${suraNumber.toBengaliDigit()}ঃ${ayahNumber.toBengaliDigit()}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'bangla/solaimanlipi',
              wordSpacing: 3,
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Option 1: View Arabic & Translation
              _buildMenuOption(
                icon: Icons.chrome_reader_mode,
                label: 'আরবি ও তরজমা দেখুন',
                onTap: () {
                  Navigator.pop(dialogContext);
                  _navigateToSuraPage(suraNumber, ayahNumber);
                },
              ),
              const SizedBox(height: 12),
              // Option 2: View Tafsir
              _buildMenuOption(
                icon: Icons.menu_book,
                label: 'তাফসীর দেখুন',
                onTap: () {
                  Navigator.pop(dialogContext);
                  _navigateToSuraPageWithTafsir(suraNumber, ayahNumber);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: colorScheme.onSecondary, size: 22),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'bangla/solaimanlipi',
                wordSpacing: 3,
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: colorScheme.onSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToSuraPage(int suraNumber, int ayahNumber) {
    ref.read(suraScrollCommandProvider.notifier).state = ScrollCommand(
      suraNumber: suraNumber,
      scrollIndex: ayahNumber - 1,
    );
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  void _navigateToSuraPageWithTafsir(int suraNumber, int ayahNumber) {
    // Set scroll command
    ref.read(suraScrollCommandProvider.notifier).state = ScrollCommand(
      suraNumber: suraNumber,
      scrollIndex: ayahNumber - 1,
    );
    // Set tafsir command to open after navigation
    ref.read(openTafsirCommandProvider.notifier).state = OpenTafsirCommand(
      suraNumber: suraNumber,
      ayahNumber: ayahNumber,
    );
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  List<Widget> _buildHeaderWidgets() {
    final List<Widget> headers = [];

    for (var contentItem in widget.page.content) {
      if (contentItem.ayahs.first.ayahNumber == 1) {
        headers.add(_buildSurahHeader(contentItem.suraNameArabic));
        if (contentItem.suraNumber != 1 && contentItem.suraNumber != 9) {
          headers.add(_buildBismillah());
        }
      }
    }
    return headers;
  }

  @override
  Widget build(BuildContext context) {
    final headerWidgets = _buildHeaderWidgets();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header bar with para and page info
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor.withOpacity(0.5),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'পারা-${widget.page.paraNumber.toBengaliDigit()}',
                  style: TextStyle(
                    fontFamily: 'bangla/solaimanlipi',
                    wordSpacing: 3,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: textTheme.bodyLarge?.color,
                  ),
                ),
                Text(
                  'পৃষ্ঠা-${widget.page.pageNumberInSurah.toBengaliDigit()}',
                  style: TextStyle(
                    fontFamily: 'bangla/solaimanlipi',
                    wordSpacing: 3,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: textTheme.bodyLarge?.color,
                  ),
                ),
              ],
            ),
          ),
          // Surah headers (without ruled lines)
          ...headerWidgets,
          // Ayah content area with ruled lines
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
            child: _RuledTextWidget(
              textSpan: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: _buildAyahOnlySpans(),
              ),
              lineColor: textTheme.bodyLarge?.color?.withOpacity(0.5) ??
                  colorScheme.onSurface.withOpacity(0.5),
              lineThickness: 1.5,
              lineOffset: 20.0, // pixels below baseline
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSurahHeader(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'سُورَةُ $name',
              style: TextStyle(
                fontFamily: 'arabic/noorehuda',
                fontSize: 34,
                fontWeight: FontWeight.normal,
                letterSpacing: 0,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            // const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildBismillah() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
              style: TextStyle(
                fontFamily: 'arabic/noorehuda',
                fontWeight: FontWeight.normal,
                fontSize: 32,
                letterSpacing: 0,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A widget that renders text with ruled lines below each actual text line.
/// Uses TextPainter.computeLineMetrics() to get precise line positions.
class _RuledTextWidget extends StatelessWidget {
  final TextSpan textSpan;
  final Color lineColor;
  final double lineThickness;
  final double lineOffset; // pixels below baseline

  const _RuledTextWidget({
    required this.textSpan,
    required this.lineColor,
    required this.lineThickness,
    required this.lineOffset,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Create TextPainter to measure text
        final textPainter = TextPainter(
          text: textSpan,
          textAlign: TextAlign.justify,
          textDirection: TextDirection.rtl,
        );

        // Layout the text with the available width
        textPainter.layout(maxWidth: constraints.maxWidth);

        // Get actual line metrics
        final lineMetrics = textPainter.computeLineMetrics();

        return CustomPaint(
          painter: _LineMetricsPainter(
            lineMetrics: lineMetrics,
            lineColor: lineColor,
            lineThickness: lineThickness,
            lineOffset: lineOffset,
            width: constraints.maxWidth,
          ),
          child: RichText(
            textAlign: TextAlign.justify,
            textDirection: TextDirection.rtl,
            text: textSpan,
          ),
        );
      },
    );
  }
}

/// Custom painter that draws lines based on actual TextPainter line metrics
class _LineMetricsPainter extends CustomPainter {
  final List<LineMetrics> lineMetrics;
  final Color lineColor;
  final double lineThickness;
  final double lineOffset;
  final double width;

  _LineMetricsPainter({
    required this.lineMetrics,
    required this.lineColor,
    required this.lineThickness,
    required this.lineOffset,
    required this.width,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = lineThickness
      ..style = PaintingStyle.stroke;

    for (final metrics in lineMetrics) {
      // Position line at baseline + offset (below the descenders)
      final y = metrics.baseline + lineOffset;

      canvas.drawLine(
        Offset(0, y),
        Offset(width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LineMetricsPainter oldDelegate) {
    return oldDelegate.lineMetrics != lineMetrics ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.lineThickness != lineThickness ||
        oldDelegate.lineOffset != lineOffset;
  }
}
