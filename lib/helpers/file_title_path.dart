String fileTitlePath(String title, String path) {
  List<String> parts = path.split('/');
  String slug = title
      .trim()
      .replaceAll(RegExp(r'[\s{2,}-\w_]'), ' ')
      .replaceAll(RegExp(r'\s+'), '-');

  parts[1] = '${slug}_${parts[1]}';

  return parts.join('/');
}
