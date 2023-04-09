import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfx/pdfx.dart';
import 'package:internet_file/internet_file.dart';
import 'package:native_app/helpers/file_utils.dart';
import 'local_file.dart';

final pdfControllerProvider =
    FutureProvider.autoDispose.family((ref, Map document) async {
  var documentPath = document['id'];
  var localFile = await ref.watch(localFileProvider(documentPath).future);

  dynamic pdfDoc;

  if (localFile != null) {
    pdfDoc = PdfDocument.openFile(localFile.path);
  } else {
    pdfDoc = PdfDocument.openData(
      InternetFile.get(fileSrcUrl(document)),
    );
  }

  var pdfController = PdfController(document: pdfDoc);

  return pdfController;
});
