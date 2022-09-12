import 'package:flutter/material.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';
import 'package:native_app/styles/settings/theme_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/main.data.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:flutter_html/flutter_html.dart';


class NewsItem extends ConsumerWidget {
  const NewsItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MyScaffold(
      title: const Text('News'),
      body: Center(
        child: ref.watch(repositoryInitializerProvider).when(
          error: (error, _) => Text(error.toString()),
          loading: () => const CircularProgressIndicator(),
          data: (_) {
            final state = ref.news.watchAll(
              params: { 'slug': QR.params['slug'], 'quantity': 1 },
              syncLocal: true
            );

            if (state.isLoading) {
              return const CircularProgressIndicator();
            }

            List resources = state.model ?? [];
            var resource = resources.first;

            return SingleChildScrollView(
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
                    if (resource.excerpt?.isNotEmpty ?? false) ...[
                      Container(
                        margin: const EdgeInsets.only(bottom: 30),
                        child: Text(
                          resource.excerpt,
                          style: TextStyle(
                            color: ThemeColors().themeColor3,
                            fontSize: 16,
                          ),
                        ),
                      )
                    ],
                    Container(
                      margin: const EdgeInsets.only(bottom: 30),
                      child: Html(
                        data: resource.body,
                        style: {
                          'body': Style(
                            color: ThemeColors().themeColor3,
                            fontSize: const FontSize(16),
                            lineHeight: const LineHeight(1.4),
                            margin: EdgeInsets.zero,
                          ),
                        },
                      ),
                    ),
                  ],
                )
              ),
            );
          },
        ),
      ),
    );
  }
}
