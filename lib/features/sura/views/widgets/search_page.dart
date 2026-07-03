import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/core/utils/arabic_utils.dart';
import 'package:native_app/core/utils/bengali_digit_extension.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/features/sura/models/ayah.dart';
import 'package:native_app/features/sura/utils/navigation_routes.dart';
import 'package:native_app/theme/app_theme_color.dart';
import '../../../../shared/quran_data.dart';
import '../../providers/search_providers.dart';

class SearchPage extends ConsumerWidget {
  final String returnTo;

  const SearchPage({super.key, required this.returnTo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider);
    final searchResults = ref.watch(searchResultsProvider);
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final appBarBg = colors.appBarBg;
    final appBarFg = colors.appBarText;
    final highlightBg = colors.highlight;
    final highlightFg = colors.primaryText;

    return Scaffold(
      backgroundColor: colors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: appBarBg,
        foregroundColor: appBarFg,
        title: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'আরবি বা বাংলায় খুঁজুন...',
            hintStyle: TextStyle(
              wordSpacing: 3,
              color: appBarFg.withValues(alpha: 0.72),
            ),
            border: InputBorder.none,
          ),
          style: TextStyle(
            fontFamily: 'bangla/solaimanlipi',
            wordSpacing: 3,
            color: appBarFg,
            fontSize: 18,
          ),
          onChanged: (value) {
            ref.read(searchQueryProvider.notifier).state = value;
          },
        ),
      ),
      body: searchResults.when(
        data: (page) {
          if (searchQuery.isEmpty) {
            return const Center(
              child: Text(
                'আয়াত বা অনুবাদ খুঁজতে টাইপ করুন।',
                style: TextStyle(fontFamily: 'bangla/solaimanlipi'),
              ),
            );
          }
          if (page.results.isEmpty) {
            return const Center(
              child: Text(
                'কোন ফলাফল পাওয়া যায়নি।',
                style: TextStyle(fontFamily: 'bangla/solaimanlipi'),
              ),
            );
          }
          return Column(
            children: [
              if (page.totalCount > page.results.length)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'প্রথম ${page.results.length} টি ফলাফল দেখানো হচ্ছে'
                    ' (মোট ${page.totalCount} টি) — অনুসন্ধান সীমিত করুন।',
                    style: TextStyle(
                      fontFamily: 'bangla/solaimanlipi',
                      fontSize: 13,
                      color: colors.secondaryText,
                    ),
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: page.results.length,
                  itemBuilder: (context, index) {
                    final result = page.results[index];
                    return _SearchResultCard(
                      result: result,
                      searchQuery: searchQuery,
                      highlightBg: highlightBg,
                      highlightFg: highlightFg,
                      colors: colors,
                      returnTo: returnTo,
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text(
            'Error: $err',
            style: TextStyle(color: colors.primaryText),
          ),
        ),
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final SearchResult result;
  final String searchQuery;
  final Color highlightBg;
  final Color highlightFg;
  final AppThemeColors colors;
  final String returnTo;

  const _SearchResultCard({
    required this.result,
    required this.searchQuery,
    required this.highlightBg,
    required this.highlightFg,
    required this.colors,
    required this.returnTo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.divider),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          final route = buildSuraRoute(
            suraNumber: result.sura,
            scrollIndex: result.ayah - 1,
            returnTo: returnTo,
          );
          Navigator.of(context).pop();
          context.push(route);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'সূরা ${suraNames[result.sura - 1]}: আয়াত ${result.ayah.toBengaliDigit()}',
                style: TextStyle(
                  wordSpacing: 3,
                  fontWeight: FontWeight.bold,
                  color: colors.primaryText,
                ),
              ),
              const SizedBox(height: 6),
              HighlightedText(
                text: result.arabicText,
                query: searchQuery,
                highlightBackground: highlightBg,
                highlightForeground: highlightFg,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontFamily: 'arabic/noorehuda',
                  fontSize: 20,
                  color: colors.arabicText,
                ),
              ),
              if (result.matchedTranslation != null) ...[
                const SizedBox(height: 6),
                HighlightedText(
                  text: result.matchedTranslation!,
                  query: searchQuery,
                  highlightBackground: highlightBg,
                  highlightForeground: highlightFg,
                  style: TextStyle(
                    fontFamily: 'bangla/solaimanlipi',
                    fontSize: 14,
                    color: colors.secondaryText,
                    wordSpacing: 3,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class HighlightedText extends StatelessWidget {
  final String text;
  final String query;
  final TextStyle style;
  final Color highlightBackground;
  final Color highlightForeground;
  final TextDirection textDirection;

  const HighlightedText({
    super.key,
    required this.text,
    required this.query,
    required this.style,
    required this.highlightBackground,
    required this.highlightForeground,
    this.textDirection = TextDirection.ltr,
  });

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) return Text(text, style: style);

    // Strip diacritics from both sides so Arabic diacritic-insensitive
    // matching works even though `text` is the original (with diacritics).
    final plainText = stripArabicDiacritics(text);
    final strippedQuery = stripArabicDiacritics(query).toLowerCase();
    final lowerPlain = plainText.toLowerCase();

    if (strippedQuery.isEmpty) return Text(text, style: style);

    // Build a mapping: plainToOrig[i] = index in `text` of the i-th kept
    // character.  Characters are "kept" if they survive diacritic stripping,
    // i.e. text[j] == plainText[pi] at the same relative position.
    final plainToOrig = <int>[];
    var pi = 0;
    for (var i = 0; i < text.length && pi < plainText.length; i++) {
      if (text[i] == plainText[pi]) {
        plainToOrig.add(i);
        pi++;
      }
    }

    final spans = <TextSpan>[];
    var plainStart = 0;
    var origStart = 0;

    while (plainStart < lowerPlain.length) {
      final matchAt = lowerPlain.indexOf(strippedQuery, plainStart);
      if (matchAt == -1) {
        spans.add(TextSpan(text: text.substring(origStart)));
        break;
      }

      final origMatchStart =
          matchAt < plainToOrig.length ? plainToOrig[matchAt] : text.length;
      final plainMatchEnd = matchAt + strippedQuery.length;
      final origMatchEnd = plainMatchEnd < plainToOrig.length
          ? plainToOrig[plainMatchEnd]
          : text.length;

      if (origMatchStart > origStart) {
        spans.add(TextSpan(text: text.substring(origStart, origMatchStart)));
      }
      spans.add(TextSpan(
        text: text.substring(origMatchStart, origMatchEnd),
        style: style.copyWith(
          backgroundColor: highlightBackground,
          color: highlightForeground,
        ),
      ));

      origStart = origMatchEnd;
      plainStart = plainMatchEnd;
    }

    if (spans.isEmpty) spans.add(TextSpan(text: text));

    return RichText(
      textAlign: TextAlign.start,
      textDirection: textDirection,
      text: TextSpan(style: style, children: spans),
    );
  }
}
