import 'package:flutter/material.dart';
import 'page_404.dart';

class ModelExeptionHandler extends StatelessWidget {
  const ModelExeptionHandler({
    super.key,
    this.error,
  });

  final Object? error;

  @override
  Widget build(BuildContext context) {
    return const Page404();
  }
}
