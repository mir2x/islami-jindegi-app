import 'package:flutter/material.dart';
import 'package:native_app/helpers/html_blocks.dart';
import 'package:native_app/objects/font_size_ratio.dart';
import 'package:native_app/theme/app_theme_color.dart';
import 'package:native_app/widgets/utils/html_text.dart';

/// A lazily-rendered variant of `ItemContent` for screens whose HTML body is
/// long enough that building it all at once is measurable.
///
/// `ItemContent` is a `SingleChildScrollView` wrapping a `Column`, so every
/// widget in the document exists at once. For a ~23,000-character article that
/// is thousands of live widgets, and unmounting them all when the route pops
/// lands on the UI thread during the transition — the visible hitch on back.
///
/// Here the scroll view *is* the lazy list: the body is split into top-level
/// blocks and each becomes its own sliver, so only blocks near the viewport
/// are built. Header widgets stay eager — there are only a handful.
///
/// A nested `ListView` inside `ItemContent` would not work: it needs
/// `shrinkWrap: true`, which builds every child to measure them and throws the
/// laziness away. The scrollable itself has to be the list.
class LazyItemContent extends StatefulWidget {
  const LazyItemContent({
    super.key,
    required this.header,
    required this.htmlBody,
    required this.fontSizeRatio,
    this.arabicFontScale = 1.0,
    this.footer = const [],
  });

  /// Title, byline, download button — anything above the body.
  final List<Widget> header;

  /// Raw HTML. Split once per value, not per build.
  final String htmlBody;

  final FontSizeRatio fontSizeRatio;
  final double arabicFontScale;

  /// Anything below the body.
  final List<Widget> footer;

  @override
  State<LazyItemContent> createState() => _LazyItemContentState();
}

class _LazyItemContentState extends State<LazyItemContent> {
  late List<String> _blocks;

  @override
  void initState() {
    super.initState();
    _blocks = splitHtmlTopLevelBlocks(widget.htmlBody);
  }

  @override
  void didUpdateWidget(covariant LazyItemContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Parsing 23k characters is not free — only redo it when the body changes.
    if (oldWidget.htmlBody != widget.htmlBody) {
      _blocks = splitHtmlTopLevelBlocks(widget.htmlBody);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppThemeColors>()!;
    final screenWidth = MediaQuery.of(context).size.width;
    final contentWidth = screenWidth > 900 ? 860.0 : double.infinity;

    // One shared selection area rather than one per block: nested areas break
    // drag selection, and this way the registrar only ever holds the blocks
    // that are actually built.
    return SelectionArea(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: contentWidth),
          child: ValueListenableBuilder<double>(
            valueListenable: widget.fontSizeRatio,
            builder: (context, ratio, _) => CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 20,
                    right: 20,
                    bottom: 50,
                  ),
                  sliver: DecoratedSliver(
                    decoration: BoxDecoration(
                      color: appColors.cardBg.withValues(alpha: 0.84),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: appColors.divider.withValues(alpha: 0.45),
                      ),
                    ),
                    sliver: SliverPadding(
                      padding: const EdgeInsets.all(18),
                      sliver: SliverMainAxisGroup(
                        slivers: [
                          SliverList(
                            delegate: SliverChildListDelegate(widget.header),
                          ),
                          SliverList.builder(
                            itemCount: _blocks.length,
                            itemBuilder: (context, index) => HtmlText(
                              text: _blocks[index],
                              fontSizeRatio: ratio,
                              arabicFontScale: widget.arabicFontScale,
                              // The ancestor SelectionArea above owns selection.
                              selectable: false,
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildListDelegate(widget.footer),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
