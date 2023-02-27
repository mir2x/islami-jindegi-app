import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/single_model.dart';
import 'package:native_app/objects/single_model_query.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/presentation/description_item.dart';
import 'package:native_app/widgets/presentation/download_item.dart';
import 'package:native_app/widgets/audio/player.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/helpers/format_date.dart';
import 'package:native_app/helpers/file_size.dart';
import 'package:native_app/helpers/play_duration.dart';
import 'package:native_app/helpers/file_utils.dart';

class Bayan extends ConsumerWidget {
  const Bayan({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTheme = Theme.of(context).textTheme;

    var query = SingleModelQuery(
      repository: ref.bayans,
      id: QR.params['id'].toString(),
      params: const {'include': 'speaker'},
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
              if (resource.speaker.value != null) ...[
                Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: Text(
                    resource.speaker.value.name,
                    style: textTheme.labelMedium,
                  ),
                ),
              ],
              if (resource.audio != null) ...[
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: AudioPlayerWidget(
                    audio: resource.audio,
                  ),
                ),
              ],
              Container(
                margin: const EdgeInsets.only(top: 40),
                child: Column(
                  children: [
                    if (resource.location != null) ...[
                      DescriptionItem(
                        title: 'Location:',
                        description: Text(
                          resource.location,
                          style: textTheme.labelMedium,
                        ),
                      ),
                    ],
                    DescriptionItem(
                      title: 'Date:',
                      description: Text(
                        formatDate(resource.publishedAt),
                        style: textTheme.labelMedium,
                      ),
                    ),
                    if (resource.excerpt != null) ...[
                      DescriptionItem(
                        title: 'Topic:',
                        description: Text(
                          resource.excerpt,
                          style: textTheme.labelMedium,
                        ),
                      ),
                    ],
                    if (resource.audio?['metadata']?['duration'] != null) ...[
                      DescriptionItem(
                        title: 'Audio Duration:',
                        description: Text(
                          playDuration(resource.audio['metadata']['duration']),
                          style: textTheme.labelMedium,
                        ),
                      ),
                    ],
                    if (resource.audio?['metadata']?['size'] != null) ...[
                      DescriptionItem(
                        title: 'Audio Size:',
                        description: Text(
                          fileSize(resource.audio['metadata']['size']),
                          style: textTheme.labelMedium,
                        ),
                      ),
                    ],
                    if (resource.audio != null) ...[
                      DownloadItem(
                        filePath: resource.audio['id'],
                        fileUrl: fileSrcUrl(resource.audio),
                      ),
                    ],
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
