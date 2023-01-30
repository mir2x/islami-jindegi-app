import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';
import 'bismillah.dart';
import 'ayah.dart';

class AyahList extends ConsumerWidget {
  const AyahList({
    super.key,
    required this.chapter,
    required this.filterParams,
  });

  final dynamic chapter;
  final Map filterParams;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MyScaffold(
      title: Text(chapter.title),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Bismillah(
            chapter: chapter,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                bottom: 30,
              ),
              child: InfiniteList(
                resourceFetcher: (Map<String, dynamic> params) async {
                  AllModelsQuery query = AllModelsQuery(
                    repository: ref.ayahs,
                    params: {
                      ...params,
                      ...filterParams,
                    },
                  );

                  return await ref.read(allModelsProvider(query).future);
                },
                itemBuilder: (_, ayah, __) {
                  return Ayah(
                    ayah: ayah,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
