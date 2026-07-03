class Ayah {
  final int sura;
  final int ayah;
  final String arabicText;
  final List<Translation> translations;
  final List<WordByWord> words;

  Ayah.fromDb(Map<String, dynamic> map,
      {required this.translations, required this.words})
      : sura = map['sura'],
        ayah = map['ayah'],
        arabicText = map['arabic_text'];

  Ayah({
    required this.sura,
    required this.ayah,
    required this.arabicText,
    required this.translations,
    required this.words,
  });
}

class Translation {
  final String translatorName;
  final String text;

  Translation.fromDb(Map<String, dynamic> map)
      : translatorName = map['translator_name'],
        text = map['translation_text'];

  Translation({
    required this.translatorName,
    required this.text,
  });
}

class WordByWord {
  final int sura;
  final int ayah;
  final int wordId;
  final String arabic;
  final String bengali;

  WordByWord.fromDb(Map<String, dynamic> map)
      : sura = map['sura'],
        ayah = map['ayah'],
        wordId = map['word_id'],
        arabic = map['arabic_word'],
        bengali = map['bengali_word'];

  WordByWord({
    required this.sura,
    required this.ayah,
    required this.wordId,
    required this.arabic,
    required this.bengali,
  });
}

/// Lightweight result used only by the search UI — does not carry word-by-word
/// data.  [matchedTranslation] is non-null when the ayah was found via a
/// translation match and carries the matching translation text for display.
class SearchResult {
  final int sura;
  final int ayah;
  final String arabicText;
  final String? matchedTranslation;

  const SearchResult({
    required this.sura,
    required this.ayah,
    required this.arabicText,
    this.matchedTranslation,
  });
}

