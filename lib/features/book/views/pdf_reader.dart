import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/providers/local_file.dart';

import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' as pdf_lib;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:open_filex/open_filex.dart';
import 'package:native_app/helpers/file_fallback_path.dart';
import 'package:native_app/theme/app_theme_color.dart';

class PDFReader extends ConsumerStatefulWidget {
  const PDFReader({
    super.key,
    required this.bookId,
    required this.filePath,
    required this.preferences,
    required this.title,
    this.authors,
    this.fileLink,
    this.onPreviousPdf,
    this.onNextPdf,
  });

  final String bookId;
  final String filePath;
  final dynamic preferences;
  final String title;
  final String? authors;
  final String? fileLink;
  final Future? Function()? onPreviousPdf;
  final Future? Function()? onNextPdf;

  @override
  ConsumerState<PDFReader> createState() => _PDFReaderState();
}

class _PDFReaderState extends ConsumerState<PDFReader>
    with SingleTickerProviderStateMixin {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  PdfTextSearchResult _searchResult = PdfTextSearchResult();
  final TextEditingController _searchController = TextEditingController();

  int _currentPage = 1;
  int _totalPages = 0;
  bool _showToolbar = true;
  bool _showSearchBar = false;
  bool _isContinuousScroll = false;
  Set<int> _bookmarkedPages = {};

  // Store PDF document bookmarks (TOC) extracted on load
  List<PdfBookmarkEntry> _pdfTocEntries = [];

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pdfViewerController.dispose();
    super.dispose();
  }

  // --- Bookmarks persistence ---
  String get _bookmarkKey => 'pdfBookmarks-${widget.bookId}';

  void _loadBookmarks() {
    final raw = widget.preferences.getString(_bookmarkKey);
    if (raw != null) {
      final List<dynamic> list = json.decode(raw);
      _bookmarkedPages = list.map((e) => e as int).toSet();
    }
  }

  Future<void> _saveBookmarks() async {
    await widget.preferences.setString(
      _bookmarkKey,
      json.encode(_bookmarkedPages.toList()..sort()),
    );
  }

  void _toggleBookmark() {
    setState(() {
      if (_bookmarkedPages.contains(_currentPage)) {
        _bookmarkedPages.remove(_currentPage);
      } else {
        _bookmarkedPages.add(_currentPage);
      }
    });
    _saveBookmarks();

    final isNowBookmarked = _bookmarkedPages.contains(_currentPage);
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isNowBookmarked
              ? 'Page $_currentPage bookmarked'
              : 'Bookmark removed from page $_currentPage',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // --- Extract PDF TOC from document ---
  void _extractToc(pdf_lib.PdfDocument document) {
    _pdfTocEntries = [];
    try {
      final bookmarks = document.bookmarks;
      for (int i = 0; i < bookmarks.count; i++) {
        final bookmark = bookmarks[i];
        _pdfTocEntries.add(PdfBookmarkEntry(
          title: bookmark.title,
          bookmark: bookmark,
        ));
        // Also extract 1 level of children
        for (int j = 0; j < bookmark.count; j++) {
          final child = bookmark[j];
          _pdfTocEntries.add(PdfBookmarkEntry(
            title: child.title,
            bookmark: child,
            isChild: true,
          ));
        }
      }
    } catch (_) {
      // PDF may not have bookmarks
    }
  }

  // --- Search ---
  void _performSearch(String query) {
    if (query.isEmpty) return;
    _searchResult = _pdfViewerController.searchText(query);
    setState(() {});
  }

  void _clearSearch() {
    setState(() {
      _showSearchBar = false;
      _searchResult.clear();
      _searchController.clear();
    });
  }

  void _openSearchBar() {
    setState(() {
      _showSearchBar = true;
      _showToolbar = true;
    });
  }

  // --- Share ---
  void _shareBook() {
    String text = widget.title;
    if (widget.authors != null && widget.authors!.isNotEmpty) {
      text += '\n\n${widget.authors}';
    }
    if (widget.fileLink != null) {
      text += '\n\n${widget.fileLink}';
    }
    text +=
        '\n\nhttps://play.google.com/store/apps/details?id=com.islami_jindegi';
    Share.share(text, subject: widget.title);
  }

  // --- Open in external app ---
  Future<void> _openInExternalApp() async {
    var path = await fileFallbackPath(widget.filePath);
    var downloadDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory();
    if (downloadDir != null && path != null) {
      await OpenFilex.open(p.join(downloadDir.path, path));
    }
  }

  // --- Combined TOC & Bookmarks bottom sheet ---
  void _showTocAndBookmarks() {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final iconClr = colors.secondaryText;
    final barBg = colors.cardBg;

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.cardBg,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return DefaultTabController(
          length: 2,
          child: SafeArea(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                children: [
                  // Drag handle
                  const SizedBox(height: 8),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: iconClr.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Tab bar
                  TabBar(
                    labelColor: iconClr,
                    unselectedLabelColor:
                        (textTheme.bodyMedium?.color ?? colors.secondaryText)
                            .withValues(alpha: 0.5),
                    indicatorColor: iconClr,
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: const [
                      Tab(
                        icon: Icon(Icons.list_rounded),
                        text: 'Contents',
                      ),
                      Tab(
                        icon: Icon(Icons.bookmark_rounded),
                        text: 'Bookmarks',
                      ),
                    ],
                  ),
                  // Tab views
                  Expanded(
                    child: TabBarView(
                      children: [
                        // ── Tab 1: Table of Contents ──
                        _buildTocTab(sheetContext, textTheme, iconClr, barBg),
                        // ── Tab 2: User Bookmarks ──
                        _buildBookmarksTab(
                            sheetContext, textTheme, iconClr, barBg, colors),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTocTab(BuildContext sheetContext, TextTheme textTheme,
      Color iconClr, Color barBg) {
    if (_pdfTocEntries.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.menu_book_rounded,
                  size: 48, color: iconClr.withValues(alpha: 0.4)),
              const SizedBox(height: 16),
              Text(
                'No table of contents',
                style: textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'This PDF does not contain a table of contents.',
                style: textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _pdfTocEntries.length,
      itemBuilder: (context, index) {
        final entry = _pdfTocEntries[index];
        return ListTile(
          contentPadding: EdgeInsets.only(
            left: entry.isChild ? 40 : 16,
            right: 16,
          ),
          leading: Icon(
            entry.isChild
                ? Icons.subdirectory_arrow_right_rounded
                : Icons.article_rounded,
            color: iconClr,
            size: entry.isChild ? 18 : 22,
          ),
          title: Text(
            entry.title,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: entry.isChild ? FontWeight.normal : FontWeight.w600,
            ),
          ),
          onTap: () {
            Navigator.pop(sheetContext);
            _pdfViewerController.jumpToBookmark(entry.bookmark);
          },
        );
      },
    );
  }

  Widget _buildBookmarksTab(BuildContext sheetContext, TextTheme textTheme,
      Color iconClr, Color barBg, AppThemeColors colors) {
    if (_bookmarkedPages.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.bookmark_border_rounded,
                  size: 48, color: iconClr.withValues(alpha: 0.4)),
              const SizedBox(height: 16),
              Text(
                'No bookmarks yet',
                style: textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Tap the bookmark icon in the bottom bar to save pages.',
                style: textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final sortedPages = _bookmarkedPages.toList()..sort();
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: sortedPages.length,
      itemBuilder: (context, index) {
        final page = sortedPages[index];
        final isCurrentPage = page == _currentPage;
        return ListTile(
          leading: Icon(
            Icons.bookmark_rounded,
            color: isCurrentPage ? iconClr : iconClr.withValues(alpha: 0.5),
          ),
          title: Text(
            'Page $page',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: isCurrentPage ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          tileColor: isCurrentPage ? colors.highlight : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete_outline_rounded,
                color: iconClr.withValues(alpha: 0.5), size: 20),
            onPressed: () {
              setState(() {
                _bookmarkedPages.remove(page);
              });
              _saveBookmarks();
              // Close and reopen to refresh
              Navigator.pop(sheetContext);
              Future.microtask(() => _showTocAndBookmarks());
            },
          ),
          onTap: () {
            Navigator.pop(sheetContext);
            _pdfViewerController.jumpToPage(page);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var pdfFile = ref.watch(localFileProvider(widget.filePath));

    return _buildWithTheme(context, pdfFile);
  }

  Widget _buildWithTheme(BuildContext context, AsyncValue pdfFile) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;
    final bottomPadding = mediaQuery.padding.bottom;

    final barBg = colors.cardBg;
    final iconClr = colors.secondaryText;
    final sliderFg = colors.active;
    final sliderBg = colors.highlight;
    final pdfBg = colors.surfaceBg;

    return Scaffold(
      backgroundColor: pdfBg,
      body: Stack(
        children: [
          // ─── PDF Viewer ─────────────────────────────
          pdfFile.when(
            loading: () => Center(
              child: CircularProgressIndicator(color: iconClr),
            ),
            error: (error, stackTrace) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: iconClr),
                    const SizedBox(height: 16),
                    Text('Error loading PDF', style: textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    Text('$error', style: textTheme.bodySmall),
                  ],
                ),
              ),
            ),
            data: (localFile) {
              if (localFile == null) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.picture_as_pdf, size: 48, color: iconClr),
                      const SizedBox(height: 16),
                      Text('File not found', style: textTheme.headlineSmall),
                    ],
                  ),
                );
              }

              int initialPage =
                  widget.preferences.getInt('pdfResource-${widget.bookId}') ??
                      1;

              return SfPdfViewerTheme(
                data: SfPdfViewerThemeData(backgroundColor: pdfBg),
                child: SfPdfViewer.file(
                  localFile,
                  key: _pdfViewerKey,
                  controller: _pdfViewerController,
                  initialPageNumber: initialPage,
                  scrollDirection: _isContinuousScroll
                      ? PdfScrollDirection.vertical
                      : PdfScrollDirection.horizontal,
                  pageLayoutMode: _isContinuousScroll
                      ? PdfPageLayoutMode.continuous
                      : PdfPageLayoutMode.single,
                  currentSearchTextHighlightColor:
                      colors.active.withValues(alpha: 0.32),
                  otherSearchTextHighlightColor:
                      colors.highlightBorder.withValues(alpha: 0.42),
                  onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                    final doc = details.document;
                    setState(() => _totalPages = doc.pages.count);
                    Future.microtask(() => _extractToc(doc));
                  },
                  onPageChanged: (PdfPageChangedDetails details) {
                    setState(() {
                      _currentPage = details.newPageNumber;
                    });
                    if (mounted) {
                      EasyDebounce.debounce(
                        'book-page-${widget.bookId}',
                        const Duration(milliseconds: 500),
                        () async {
                          await widget.preferences.setInt(
                            'pdfResource-${widget.bookId}',
                            details.newPageNumber,
                          );
                        },
                      );
                    }
                  },
                  onTap: (PdfGestureDetails details) {
                    if (_showSearchBar) {
                      _clearSearch();
                    } else {
                      setState(() => _showToolbar = !_showToolbar);
                    }
                  },
                  enableDoubleTapZooming: true,
                ),
              );
            },
          ),

          // ─── Top Bar ────────────────────────────────
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            top: _showToolbar ? 0 : -(kToolbarHeight + topPadding + 20),
            left: 0,
            right: 0,
            child: _showSearchBar
                ? _buildSearchBar(topPadding, barBg, iconClr, textTheme, colors)
                : _buildTopBar(topPadding, barBg, iconClr, textTheme, colors),
          ),

          // ─── Bottom Bar ─────────────────────────────
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            bottom: _showToolbar ? 0 : -(120 + bottomPadding),
            left: 0,
            right: 0,
            child: _buildBottomBar(
              bottomPadding,
              barBg,
              iconClr,
              sliderFg,
              sliderBg,
              textTheme,
              colors,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  //  TOP BAR
  // ═══════════════════════════════════════════════════
  Widget _buildTopBar(double topPadding, Color barBg, Color iconClr,
      TextTheme textTheme, AppThemeColors colors) {
    return Container(
      decoration: BoxDecoration(
        color: barBg,
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: SizedBox(
          height: kToolbarHeight,
          child: Row(
            children: [
              // Back
              IconButton(
                icon: Icon(Icons.arrow_back_rounded, color: iconClr),
                onPressed: () => Navigator.of(context).pop(),
                tooltip: 'Back',
              ),
              const SizedBox(width: 4),
              // Title
              Expanded(
                child: Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium?.copyWith(
                    color: colors.primaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              // Search
              IconButton(
                icon: Icon(Icons.search_rounded, color: iconClr),
                onPressed: _openSearchBar,
                tooltip: 'Search',
              ),
              // Table of Contents & Bookmarks
              IconButton(
                icon: Icon(Icons.menu_book_rounded, color: iconClr),
                onPressed: () => _showTocAndBookmarks(),
                tooltip: 'Contents & Bookmarks',
              ),
              // More menu
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert_rounded, color: iconClr),
                color: colors.dropdownBg,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                itemBuilder: (context) => [
                  _buildMenuItem(
                    'share',
                    Icons.share_rounded,
                    'Share',
                    textTheme,
                    iconClr,
                    colors,
                  ),
                  _buildMenuItem(
                    'open',
                    Icons.open_in_new_rounded,
                    'Open in App',
                    textTheme,
                    iconClr,
                    colors,
                  ),
                ],
                onSelected: (value) {
                  if (value == 'share') _shareBook();
                  if (value == 'open') _openInExternalApp();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem(String value, IconData icon,
      String label, TextTheme textTheme, Color iconClr, AppThemeColors colors) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: iconClr, size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: colors.primaryText,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  //  SEARCH BAR
  // ═══════════════════════════════════════════════════
  Widget _buildSearchBar(double topPadding, Color barBg, Color iconClr,
      TextTheme textTheme, AppThemeColors colors) {
    return Container(
      decoration: BoxDecoration(
        color: barBg,
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: SizedBox(
          height: kToolbarHeight,
          child: Row(
            children: [
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: colors.surfaceBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: colors.divider),
                  ),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: textTheme.bodyMedium,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      hintText: 'ডকুমেন্টে সার্চ করুন...',
                      hintStyle: textTheme.bodySmall?.copyWith(
                        color:
                            (textTheme.bodySmall?.color ?? colors.secondaryText)
                                .withValues(alpha: 0.5),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      isCollapsed: true,
                      prefixIcon: Icon(Icons.search, color: iconClr, size: 20),
                    ),
                    onSubmitted: _performSearch,
                  ),
                ),
              ),
              if (_searchResult.hasResult) ...[
                const SizedBox(width: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: iconClr.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_searchResult.currentInstanceIndex}/${_searchResult.totalInstanceCount}',
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.primaryText,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_up_rounded,
                      color: iconClr, size: 22),
                  onPressed: () {
                    _searchResult.previousInstance();
                    setState(() {});
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(maxWidth: 32),
                ),
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_down_rounded,
                      color: iconClr, size: 22),
                  onPressed: () {
                    _searchResult.nextInstance();
                    setState(() {});
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(maxWidth: 32),
                ),
              ],
              IconButton(
                icon: Icon(Icons.close_rounded, color: iconClr),
                onPressed: _clearSearch,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  //  BOTTOM BAR
  // ═══════════════════════════════════════════════════
  Widget _buildBottomBar(
    double bottomPadding,
    Color barBg,
    Color iconClr,
    Color sliderFg,
    Color sliderBg,
    TextTheme textTheme,
    AppThemeColors colors,
  ) {
    final isBookmarked = _bookmarkedPages.contains(_currentPage);

    return Container(
      decoration: BoxDecoration(
        color: barBg,
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Page slider row ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    // Page indicator chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: iconClr.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$_currentPage / $_totalPages',
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.primaryText,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    // Slider
                    Expanded(
                      child: SliderTheme(
                        data: SliderThemeData(
                          activeTrackColor: sliderFg,
                          inactiveTrackColor: sliderBg.withValues(alpha: 0.3),
                          thumbColor: sliderFg,
                          overlayColor: sliderFg.withValues(alpha: 0.15),
                          trackHeight: 3,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 6,
                          ),
                        ),
                        child: Slider(
                          value: _currentPage.toDouble().clamp(1.0,
                              _totalPages > 0 ? _totalPages.toDouble() : 1.0),
                          min: 1.0,
                          max: _totalPages > 0 ? _totalPages.toDouble() : 1.0,
                          onChanged: (value) {
                            setState(() {
                              _currentPage = value.toInt();
                            });
                          },
                          onChangeEnd: (value) {
                            _pdfViewerController.jumpToPage(value.toInt());
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Action buttons row ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Previous PDF
                  _BottomAction(
                    icon: Icons.skip_previous_rounded,
                    label: 'Prev',
                    color: iconClr,
                    labelColor: colors.primaryText,
                    onTap: widget.onPreviousPdf,
                  ),
                  // Layout toggle
                  _BottomAction(
                    icon: _isContinuousScroll
                        ? Icons.view_carousel_rounded
                        : Icons.view_day_rounded,
                    label: _isContinuousScroll ? 'Single' : 'Scroll',
                    color: iconClr,
                    labelColor: colors.primaryText,
                    onTap: () {
                      setState(() {
                        _isContinuousScroll = !_isContinuousScroll;
                      });
                    },
                  ),
                  // Bookmark current page
                  _BottomAction(
                    icon: isBookmarked
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    label: isBookmarked ? 'Saved' : 'Bookmark',
                    color: iconClr,
                    labelColor: colors.primaryText,
                    onTap: _toggleBookmark,
                  ),
                  // Next PDF
                  _BottomAction(
                    icon: Icons.skip_next_rounded,
                    label: 'Next',
                    color: iconClr,
                    labelColor: colors.primaryText,
                    onTap: widget.onNextPdf,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
//  Helper data class for PDF TOC entries
// ═══════════════════════════════════════════════════════
class PdfBookmarkEntry {
  final String title;
  final pdf_lib.PdfBookmark bookmark;
  final bool isChild;

  PdfBookmarkEntry({
    required this.title,
    required this.bookmark,
    this.isChild = false,
  });
}

// ═══════════════════════════════════════════════════════
//  Bottom action button widget
// ═══════════════════════════════════════════════════════
class _BottomAction extends StatelessWidget {
  const _BottomAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.labelColor,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color labelColor;
  final dynamic onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap != null ? () => onTap!() : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: labelColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
