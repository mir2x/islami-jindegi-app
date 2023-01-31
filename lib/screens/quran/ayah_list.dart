import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';
import 'package:native_app/theme/colors.dart';
import 'bismillah.dart';
import 'ayah.dart';
import 'settings.dart';

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
      body: Stack(
        children: [
          Column(
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
                          'include': 'ayah-translations'
                        },
                      );

                      return await ref.read(allModelsProvider(query).future);
                    },
                    itemBuilder: (_, ayah, __) {
                      return Ayah(ayah: ayah, chapter: chapter);
                    },
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 30,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(
                top: 5,
                bottom: 5,
                left: 7,
                right: 2,
              ),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
                color: Colors.white,
              ),
              child: IconButton(
                iconSize: 40,
                icon: const Icon(Icons.settings),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      double screenWidth = MediaQuery.of(context).size.width;
                      double screenHeight = MediaQuery.of(context).size.height;

                      return Dialog(
                        backgroundColor: ThemeColors.color1,
                        child: Container(
                          width: screenWidth,
                          height: screenHeight * 0.6,
                          padding: const EdgeInsets.only(
                            top: 15,
                            bottom: 25,
                            left: 15,
                            right: 15,
                          ),
                          child: const QuranSettings(),
                        ),
                      );
                    },
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
