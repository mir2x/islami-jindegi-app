import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/widgets/filter/switch_button.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/widgets/presentation/list_item.dart';

class Quran extends ConsumerStatefulWidget {
  const Quran({super.key});

  @override
  QuranState createState() => QuranState();
}

class QuranState extends ConsumerState<Quran> {
  bool isSurahSelected = true;

  void loadSurah() {
    setState(() {
      isSurahSelected = true;
    });
  }

  void loadPara() {
    setState(() {
      isSurahSelected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return MyScaffold(
      title: const Text('Quran'),
      body: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 5),
            child: SwitchButton(
              firstLabel: 'SURAH',
              secondLabel: 'PARA',
              activateFirst: loadSurah,
              activateSecond: loadPara,
              isFirstActive: isSurahSelected,
              isSecondActive: !isSurahSelected,
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: isSurahSelected
                  ? InfiniteList(
                      resourceFetcher: (Map<String, dynamic> params) async {
                        AllModelsQuery query = AllModelsQuery(
                          repository: ref.surahs,
                          params: params,
                        );

                        return await ref.read(allModelsProvider(query).future);
                      },
                      itemBuilder: (_, item, __) {
                        return InkWell(
                          onTap: () => QR.to('quran/surah/${item.id}'),
                          child: ListItem(
                            item: Text(
                              item.title,
                              style: textTheme.titleMedium,
                            ),
                          ),
                        );
                      },
                    )
                  : InfiniteList(
                      resourceFetcher: (Map<String, dynamic> params) async {
                        AllModelsQuery query = AllModelsQuery(
                          repository: ref.paras,
                          params: params,
                        );

                        return await ref.read(allModelsProvider(query).future);
                      },
                      itemBuilder: (_, item, __) {
                        return InkWell(
                          onTap: () => QR.to('quran/para/${item.id}'),
                          child: ListItem(
                            item: Text(
                              item.title,
                              style: textTheme.titleMedium,
                            ),
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
