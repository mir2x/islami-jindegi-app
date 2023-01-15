import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/single_model.dart';
import 'package:native_app/objects/single_model_query.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/presentation/description_item.dart';
import 'package:native_app/widgets/utils/html_text.dart';
import 'package:native_app/widgets/audio/player.dart';
import 'package:native_app/helpers/file_size.dart';
import 'package:native_app/helpers/play_duration.dart';

class MalfuzatItem extends ConsumerWidget {
  const MalfuzatItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTheme = Theme.of(context).textTheme;

    var query = SingleModelQuery(
      repository: ref.malfuzats,
      id: QR.params['id'].toString(),
      params: const {'include': 'malfuzat-author'},
      remote: true,
    );

    var modelQuery = ref.watch(singleModelProvider(query));

    return modelQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resource) {
        return MyScaffold(
          title: Text(resource.title),
          body: ItemContent(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: Text(
                  resource.title,
                  style: textTheme.headlineMedium,
                ),
              ),
              if (resource.malfuzatAuthor.value != null) ...[
                Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: Text(
                    resource.malfuzatAuthor.value.name,
                    style: textTheme.labelMedium,
                  ),
                ),
              ] else
                ...[],
              if (resource.body != null) ...[
                Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  child: HtmlText(
                    text: resource.body,
                  ),
                ),
              ] else
                ...[],
              if (resource.audio != null) ...[
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: AudioPlayerWidget(
                    audio: resource.audio,
                  ),
                ),
              ] else
                ...[],
              Container(
                margin: const EdgeInsets.only(top: 40),
                child: Column(
                  children: [
                    if (resource.audio?['metadata']?['duration'] != null) ...[
                      DescriptionItem(
                        title: 'Audio Duration:',
                        description: Text(
                          playDuration(resource.audio['metadata']['duration']),
                          style: textTheme.labelMedium,
                        ),
                      ),
                    ] else
                      ...[],
                    if (resource.audio?['metadata']?['size'] != null) ...[
                      DescriptionItem(
                        title: 'Audio Size:',
                        description: Text(
                          fileSize(resource.audio['metadata']['size']),
                          style: textTheme.labelMedium,
                        ),
                      ),
                    ] else
                      ...[],
                    if (resource.audio != null) ...[
                      const DescriptionItem(
                        title: 'Download:',
                        description: Align(
                          alignment: Alignment.topLeft,
                          child: Icon(
                            Icons.download,
                            size: 24,
                          ),
                        ),
                      ),
                    ] else
                      ...[],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
