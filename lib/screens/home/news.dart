import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/styles/settings/theme_colors.dart';

class News extends ConsumerWidget {
  const News({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AllModelsQuery query = const AllModelsQuery(
      repository: 'news',
      params: { 'quantity': 1 }
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: ThemeColors().themeColor3,
      ),
      margin: const EdgeInsets.only(top: 30, bottom: 50, left: 30, right: 30),
      child: Row(
        children: [
          Container(
            width: 100,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Text(
              'News & Updates',
              style: TextStyle(
                fontSize: 16,
                color: ThemeColors().themeColor2,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                color: ThemeColors().themeColor4,
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: ref.watch(allModelsProvider(query)).when(
                loading: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
                error: (error, _) => Text(error.toString()),
                data: (resources) {
                  var newsItem = resources[0];

                  return InkWell(
                    onTap: () => QR.to('news/${newsItem.id}'),
                    child: Center(
                      child: Text(
                        newsItem.title,
                        style: TextStyle(
                          fontSize: 16,
                          color: ThemeColors().themeColor2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                }
              ),
            ),
          ),
        ],
      )
    );
  }
}
