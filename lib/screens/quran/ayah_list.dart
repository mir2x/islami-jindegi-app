import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';
import 'package:flutter_svg/svg.dart';

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
    var textTheme = Theme.of(context).textTheme;

    return MyScaffold(
      title: Text(chapter.title),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (chapter.position != 9) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              child: Text(
                'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِیْمِ',
                textAlign: TextAlign.right,
                softWrap: false,
                style: textTheme.headlineLarge?.copyWith(
                  fontFamily: 'arabic/al-qalam',
                ),
              ),
            ),
          ] else
            ...[],
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
                  return Container(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            ayah.title,
                            textAlign: TextAlign.right,
                            style: textTheme.headlineMedium?.copyWith(
                              fontFamily: 'arabic/al-qalam',
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 15),
                          width: 50,
                          height: 42,
                          child: Stack(
                            children: [
                              SvgPicture.asset(
                                'assets/images/icons/ayah-symbol.svg',
                                fit: BoxFit.scaleDown,
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                  ayah.surahPosition.toString(),
                                  style: textTheme.titleMedium,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
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
