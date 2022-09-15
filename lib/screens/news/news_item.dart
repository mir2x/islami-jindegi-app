import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/widgets/repository/init_repository.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';
import 'package:native_app/styles/settings/theme_colors.dart';
import 'package:native_app/widgets/utils/html_text.dart';
import 'package:native_app/helpers/format_date.dart';
import 'package:native_app/screens/error_pages/page_404.dart';

class NewsItem extends ConsumerWidget {
  const NewsItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InitRepository(
      initializer: ref.watch(repositoryInitializerProvider),
      data: (_) {
        var state = ref.news.watchAll(
          params: { 'slug': QR.params['slug'], 'quantity': 1 },
          syncLocal: true
        );

        if (state.isLoading) {
          return const CircularProgressIndicator();
        }

        List resources = state.model ?? [];

        if (resources.isEmpty) {
          return const Page404();
        }

        var resource = resources.first;

        return MyScaffold(
          title: Text(resource.title),
          body: Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: 50
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      child: Text(
                        resource.title,
                        style: TextStyle(
                          color: ThemeColors().themeColor3,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      child: Text(
                        formatDate(resource.createdAt),
                        style: TextStyle(
                          color: ThemeColors().themeColor3,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 30),
                      child: HtmlText(
                        text: resource.body,
                      ),
                    ),
                  ],
                )
              ),
            ),
          ),
        );
      }
    );
  }
}
