/// Which slice of a module's corpus the reader is currently moving through.
///
/// Malfuzat and masail are split by a permanent Text/Audio partition, and the
/// reader expects Next to stay inside the tab they chose. The scope therefore
/// has to travel with the navigation rather than live in list-screen state —
/// query-param providers are `autoDispose` and die the moment the list route is
/// torn down, which is exactly what `context.go` does on every Next/Prev.
///
/// So it rides in the URL (`/malfuzat/{id}?scope=audio`) and is the single
/// source of truth for two things: which neighbours to seek, and which tab's
/// reading progress to record.
enum ContentScope {
  all,
  text,
  audio;

  /// Parses the `scope` query parameter. Anything unrecognised — including a
  /// missing value, a share link, or a bookmark — means the corpus-wide All
  /// sequence, which is the safe default.
  static ContentScope fromQuery(String? value) => switch (value) {
        'audio' => ContentScope.audio,
        'text' => ContentScope.text,
        _ => ContentScope.all,
      };

  /// The value to put back on a URL, or null for [ContentScope.all] so the
  /// common case stays a clean path with no query string.
  String? get queryValue => switch (this) {
        ContentScope.audio => 'audio',
        ContentScope.text => 'text',
        ContentScope.all => null,
      };

  /// `true` for audio-only, `false` for text-only, null for the whole corpus —
  /// matching the API's `hasAudio` filter and the SQLite `has_audio` column.
  bool? get hasAudio => switch (this) {
        ContentScope.audio => true,
        ContentScope.text => false,
        ContentScope.all => null,
      };

  /// Appends the scope to [path], omitting it entirely for [ContentScope.all].
  String applyTo(String path) =>
      queryValue == null ? path : '$path?scope=$queryValue';

  /// Derives the scope from a list screen's `hasAudio` query param.
  static ContentScope fromQueryParams(Map<String, dynamic> params) =>
      switch (params['hasAudio']) {
        'true' => ContentScope.audio,
        'false' => ContentScope.text,
        _ => ContentScope.all,
      };
}
