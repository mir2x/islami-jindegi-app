import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class PdfBuilders {
  const PdfBuilders({
    required this.locales,
    required this.textTheme,
  });

  final dynamic locales;
  final dynamic textTheme;

  PdfViewBuilders getViewBuilders() {
    return PdfViewBuilders<DefaultBuilderOptions>(
      options: const DefaultBuilderOptions(),
      documentLoaderBuilder: (_) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      pageLoaderBuilder: (_) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      errorBuilder: (_, __) {
        return AlertDialog(
          title: Text(locales.errorTitle),
          content: Text(
            locales.documentLoadErrorMsg,
            style: textTheme.labelMedium,
          ),
        );
      },
    );
  }
}
