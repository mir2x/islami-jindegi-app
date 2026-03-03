import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/core/utils/bengali_digit_extension.dart';
import 'package:qlevar_router/qlevar_router.dart';
import '../../../../shared/quran_data.dart';
import '../../providers/search_providers.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider);
    final searchResults = ref.watch(searchResultsProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'আরবি বা বাংলায় খুঁজুন...',
            hintStyle: TextStyle(

                wordSpacing: 3,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
            border: InputBorder.none,
          ),
          style: TextStyle(
              fontFamily: 'bangla/solaimanlipi',
              wordSpacing: 3,
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 18),
          onChanged: (value) {
            ref.read(searchQueryProvider.notifier).state = value;
          },
        ),
      ),
      body: searchResults.when(
        data: (ayahs) {
          if (searchQuery.isEmpty) {
            return const Center(
              child: Text('আয়াত বা অনুবাদ খুঁজতে টাইপ করুন।',
                  style: TextStyle(fontFamily: 'bangla/solaimanlipi')),
            );
          }
          if (ayahs.isEmpty) {
            return const Center(
              child: Text('কোন ফলাফল পাওয়া যায়নি।',
                  style: TextStyle(fontFamily: 'bangla/solaimanlipi')),
            );
          }
          return ListView.builder(
            itemCount: ayahs.length,
            itemBuilder: (context, index) {
              final ayah = ayahs[index];
              return ListTile(
                title: Text(
                  'সূরা ${suraNames[ayah.sura - 1] ?? ayah.sura}: আয়াত ${ayah.ayah.toBengaliDigit()}',
                  style: TextStyle(
      
                      wordSpacing: 3,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: HighlightedText(
                  text: ayah.arabicText,
                  query: searchQuery,
                  style: TextStyle(
                      fontFamily: 'arabic/noorehuda',
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onSurface),
                ),
                onTap: () {
                  Future.delayed(Duration.zero, () {
                    if (!context.mounted) return;

                    final targetSura = ayah.sura;
                    final targetIndex = ayah.ayah - 1;

                    QR.to('/qurans/sura/$targetSura?scroll=$targetIndex');
                  });
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class HighlightedText extends StatelessWidget {
  final String text;
  final String query;
  final TextStyle style;

  const HighlightedText({
    super.key,
    required this.text,
    required this.query,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return Text(text, style: style);
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();

    final spans = <TextSpan>[];
    int start = 0;

    while (start < text.length) {
      final startIndex = lowerText.indexOf(lowerQuery, start);
      if (startIndex == -1) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }

      if (startIndex > start) {
        spans.add(TextSpan(text: text.substring(start, startIndex)));
      }

      final endIndex = startIndex + query.length;
      spans.add(TextSpan(
        text: text.substring(startIndex, endIndex),
        style: style.copyWith(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            color: Theme.of(context).colorScheme.onPrimaryContainer),
      ));

      start = endIndex;
    }

    return RichText(
      textAlign: TextAlign.start,
      textDirection: TextDirection.rtl,
      text: TextSpan(style: style, children: spans),
    );
  }
}
