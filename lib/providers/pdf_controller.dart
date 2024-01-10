import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfx/pdfx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:native_app/objects/pdf_source.dart';
import 'local_file.dart';

final pdfControllerProvider = FutureProvider.autoDispose
    .family<PdfController, PdfSource>((ref, PdfSource params) async {
  var localFile = await ref.watch(localFileProvider(params.filePath).future);
  dynamic pdfDoc = PdfDocument.openFile(localFile!.path);

  var prefs = await SharedPreferences.getInstance();
  int initialPage = prefs.getInt('pdfResource-${params.resourceId}') ?? 1;

  var pdfController = PdfController(document: pdfDoc, initialPage: initialPage);

  return pdfController;
});
