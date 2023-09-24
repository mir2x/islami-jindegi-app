import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfx/pdfx.dart';
import 'local_file.dart';

final pdfControllerProvider =
    FutureProvider.autoDispose.family((ref, Map document) async {
  var documentPath = document['id'];
  var localFile = await ref.read(localFileProvider(documentPath).future);

  dynamic pdfDoc = PdfDocument.openFile(localFile!.path);

  var pdfController = PdfController(document: pdfDoc);

  return pdfController;
});
