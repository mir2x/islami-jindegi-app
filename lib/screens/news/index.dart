import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/styles/settings/theme_colors.dart';
import 'package:native_app/helpers/format_date.dart';

class News extends ConsumerWidget {
  const News({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MyScaffold(
      title: const Text('News'),
      body: Center(
        child: ref.watch(repositoryInitializerProvider).when(
          error: (error, _) => Text(error.toString()),
          loading: () => const CircularProgressIndicator(),
          data: (_) {
            final state = ref.news.watchAll(syncLocal: true);
            if (state.isLoading) {
              return const CircularProgressIndicator();
            }

            List resources = state.model ?? [];

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
              itemCount: resources.length,
              itemBuilder: (context, index) {
                return InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: ThemeColors().themeColor7,
                    ),
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.only(bottom: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          resources[index].title,
                          style: TextStyle(color: ThemeColors().themeColor4),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            formatDate(resources[index].createdAt),
                            style: TextStyle(color: ThemeColors().themeColor3),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () => QR.to('news/${resources[index].slug}'),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
