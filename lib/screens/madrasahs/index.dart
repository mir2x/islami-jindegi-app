import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/widgets/presentation/list_item.dart';
import 'package:native_app/styles/settings/theme_colors.dart';

class Madrasahs extends ConsumerWidget {
  const Madrasahs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AllModelsQuery query = const AllModelsQuery(repository: 'madrasahs');

    return MyScaffold(
      title: const Text('Madrasahs'),
      body: Center(
        child: ref.watch(allModelsProvider(query)).when(
          loading: () => const CircularProgressIndicator(),
          error: (error, _) => Text(error.toString()),
          data: (resources) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
              itemCount: resources.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => QR.to('madrasahs/${resources[index].id}'),
                  child: ListItem(
                    item: Text(
                      resources[index].title,
                      style: TextStyle(color: ThemeColors().themeColor4),
                    ),
                  ),
                );
              },
            );
          }
        ),
      ),
    );
  }
}
