import 'package:flutter/material.dart';
import 'error_page.dart';

class Page404 extends StatelessWidget {
  const Page404({super.key});

  @override
  Widget build(BuildContext context) {
    return const ErrorPage(
      title: 'Page Not Found',
      subtitle: 'We cannot seem to find the page you are looking for.',
    );
  }
}
