// Stripped ranges — must stay in sync with strip_diacritics() in
// tools/strip_quran_diacritics.py:
//   U+0603              Arabic Sign Safha (Cf)
//   U+0610–U+061A       Arabic extended signs (Mn)
//   U+0640              Arabic Tatweel / Kashida (Lm)
//   U+064B–U+065F       Tashkeel: fathatan…various vowel marks (Mn)
//   U+066A, U+066D      Quranic end/pause marks ٪ ٭ (Po)
//   U+0670              Superscript Alef (Mn)
//   U+06D6–U+06DC       Quranic annotation signs (Mn)
//   U+06DF–U+06E4       More Quranic marks (Mn)
//   U+06E6              Arabic Small Yeh (Lm)
//   U+06E8–U+06ED       Arabic small high/low marks (Mn)
//   U+200C–U+200D       Zero-width non-joiner / joiner (Cf)
//   U+2009              Thin space used as verse-end marker
final _diacriticsRe = RegExp(
  '[؃ؐ-ؚـً-ٟ٪٭ٰ'
  'ۖ-ۜ۟-ۤۦۨ-ۭ'
  '‌‍ ]',
);

final _multiSpaceRe = RegExp(r' {2,}');

/// Strips Arabic diacritics (tashkeel), Quranic annotation marks, and format
/// characters from [text], leaving only base Arabic letters and spaces.
///
/// Apply to the user's search query before issuing a LIKE query against the
/// [arabic_text_plain] column in quran.db (which was pre-stripped by
/// tools/strip_quran_diacritics.py).
String stripArabicDiacritics(String text) {
  return text
      .replaceAll(_diacriticsRe, '')
      .replaceAll(_multiSpaceRe, ' ')
      .trim();
}
