import 'package:flutter/material.dart';
import 'package:native_app/core/utils/arabic_digit_extension.dart';
import 'package:native_app/core/utils/bengali_digit_extension.dart';
import 'package:native_app/shared/quran_data.dart';
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
    // Clear old recognizers before building new ones to avoid leaks on rebuilds
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    _recognizers.clear();

    final List<InlineSpan> spans = [];

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

        // Text first, then ayah number (standard Quran format)
        spans.add(
          TextSpan(
            text: '${ayah.text} ',
            recognizer: tapRecognizer,
            style: const TextStyle(
              fontFamily: 'Al Qalam Quran Majeed',
              fontSize: 30,
              fontWeight: FontWeight.bold,
              height: 2.2,
              color: Color(0xFF2D2D2D),
              letterSpacing: 0,
            ),
          ),
        );
        spans.add(
          TextSpan(
            text: '\u{FD3F}${ayah.ayahNumber.toArabicDigit()}\u{FD3E} ',
            recognizer: tapRecognizer,
            style: const TextStyle(
              fontFamily: 'Al Qalam Quran Majeed',
              fontSize: 32,
              color: Color(0xFF2D2D2D),
              fontWeight: FontWeight.bold,
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
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: const Color(0xFFF0F5F0),
          title: Text(
            '$suraNameBengali ${suraNumber.toBengaliDigit()}ঃ${ayahNumber.toBengaliDigit()}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'SolaimanLipi',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E4D2B),
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E4D2B),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'SolaimanLipi',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
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

    return Container(
      color: const Color(0xFFF1FCFE),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header bar with para and page info
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            decoration: BoxDecoration(
              color: const Color(0xFFE8DFC8),
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xFFD4AF37).withOpacity(0.5),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'পারা-${widget.page.paraNumber.toBengaliDigit()}',
                  style: const TextStyle(
                    fontFamily: 'SolaimanLipi',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D2D2D),
                  ),
                ),
                Text(
                  'পৃষ্ঠা-${widget.page.pageNumberInSurah.toBengaliDigit()}',
                  style: const TextStyle(
                    fontFamily: 'SolaimanLipi',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D2D2D),
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
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: _RuledTextWidget(
              textSpan: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: _buildAyahOnlySpans(),
              ),
              lineColor: const Color(0xFF2D2D2D),
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
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'سُورَةُ $name',
              style: const TextStyle(
                fontFamily: 'Al Qalam Quran Majeed',
                fontSize: 34,
                fontWeight: FontWeight.bold,
                letterSpacing: 0,
                color: Color(0xFF2D2D2D),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 200,
              height: 2,
              color: const Color(0xFF2D2D2D),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBismillah() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
              style: TextStyle(
                fontFamily: 'Al Qalam Quran Majeed',
                fontSize: 32,
                letterSpacing: 0,
                color: Color(0xFF2D2D2D),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 280,
              height: 2,
              color: const Color(0xFF2D2D2D),
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
