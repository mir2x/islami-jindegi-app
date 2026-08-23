import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;

/// Splits a stored HTML body into its top-level block elements so a long
/// document can be rendered lazily, one block per sliver, instead of building
/// the whole tree at once.
///
/// Editor output is flat — the longest article in the corpus is ~23,000
/// characters made of 66 sibling `<p>` elements — so top-level children are a
/// natural and safe split point. Each returned string is a complete element,
/// never a fragment, so per-block rendering cannot produce unbalanced markup.
///
/// Returns a single-element list when the body has no element children (or
/// cannot be parsed), which keeps callers on one code path.
List<String> splitHtmlTopLevelBlocks(String html) {
  if (html.trim().isEmpty) return const [];

  final dom.Element? body;
  try {
    body = html_parser.parse(html).body;
  } catch (_) {
    return [html];
  }
  if (body == null) return [html];

  final blocks = <String>[];
  for (final node in body.nodes) {
    if (node is dom.Element) {
      blocks.add(node.outerHtml);
    } else if (node is dom.Text && node.text.trim().isNotEmpty) {
      // Bare text between blocks — wrap it so it inherits paragraph styling
      // rather than rendering unstyled.
      blocks.add('<p>${node.text}</p>');
    }
  }

  return blocks.isEmpty ? [html] : blocks;
}
