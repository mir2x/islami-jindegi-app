import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/providers/downloaded_books.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/buttons/social_share.dart';
import 'package:native_app/widgets/buttons/bookmark.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/widgets/utils/pdf_menu.dart';
import 'package:native_app/helpers/file_title_path.dart';
import 'package:native_app/helpers/file_utils.dart';
import 'pdf_reader.dart';

class DownloadedBook extends ConsumerStatefulWidget {
  const DownloadedBook({super.key});

  @override
  ConsumerState<DownloadedBook> createState() => _DownloadedBookState();
}

class _DownloadedBookState extends ConsumerState<DownloadedBook> {
  bool isFullScreen = false;
  bool darkMode = false;
  bool landscape = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  void toggleFullScreen() {
    setState(() {
      isFullScreen = !isFullScreen;

      isFullScreen
          ? SystemChrome.setEnabledSystemUIMode(
              SystemUiMode.manual,
              overlays: [],
            )
          : SystemChrome.setEnabledSystemUIMode(
              SystemUiMode.manual,
              overlays: SystemUiOverlay.values,
            );
    });
  }

  void toggleMode() {
    setState(() {
      darkMode = !darkMode;
    });
  }

  void toggleOrientation() {
    setState(() {
      landscape = !landscape;
    });
  }

  @override
  Widget build(BuildContext context) {
    int id = int.parse(QR.params['id'].toString());
    var modelQuery = ref.watch(getDownloadedBookProvider(id));

    return modelQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (book) {
        Map document = json.decode(book.document);
        String filePath = fileTitlePath(book.title, document['id']);

        return AppScaffold(
          showPattern: false,
          showAppBar: !isFullScreen,
          showBottomBar: !isFullScreen,
          tabletBodyPadding: false,
          title: Text(book.title),
          body: WithPreferences(
            builder: (context, preferences) {
              return PDFReader(
                bookId: book.bookId,
                filePath: filePath,
                preferences: preferences,
                isFullScreen: isFullScreen,
                darkMode: darkMode,
                landscape: landscape,
                toggleFullScreen: toggleFullScreen,
              );
            },
          ),
          bottomBar: BottomBar(
            alignment: MainAxisAlignment.center,
            children: [
              SocialShare(
                title: book.title,
                subtitle: book.authors,
                link: 'books/${book.bookId}',
                fileLink: fileSrcUrl(document),
              ),
              BookmarkButton(
                type: 'Book',
                title: book.title,
                link: 'books/${book.bookId}',
              ),
              PDFMenu(
                filePath: filePath,
                darkMode: darkMode,
                landscape: landscape,
                toggleMode: toggleMode,
                toggleOrientation: toggleOrientation,
                deleteCallback: () async {
                  await ref
                      .watch(downloadedBooksProvider.notifier)
                      .deleteItem(book.bookId);

                  await QR.to('books/downloads');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
