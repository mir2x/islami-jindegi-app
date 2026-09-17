import 'package:path/path.dart' as p;

/// Builds the on-disk path for a downloaded resource as `<category>/<slug>_<id><ext>`.
///
/// `url` should be the remote file's URL (the same one passed to the
/// downloader) so the saved file keeps its real extension (`.pdf`, `.mp3`,
/// …) — without it, apps that identify a file's format from its extension
/// (external PDF/audio viewers via `OpenFilex.open`, or a share sheet) can't
/// recognize the downloaded file. Every place that reconstructs this path
/// (to check if a file is downloaded, to open it, or to delete it) must pass
/// the same `title`, `path` and `url` used at download time, or the lookup
/// won't find the file.
String fileTitlePath(String title, String path, {String? url}) {
  List<String> parts = path.split('/');
  String slug = title
      .trim()
      .replaceAll(RegExp(r'[\s{2,}-\w_]'), ' ')
      .replaceAll(RegExp(r'\s+'), '-');

  String extension = '';
  if (url != null && url.isNotEmpty) {
    try {
      extension = p.extension(Uri.parse(url).path);
    } catch (_) {
      extension = '';
    }
  }

  parts[1] = '${slug}_${parts[1]}$extension';

  return parts.join('/');
}
