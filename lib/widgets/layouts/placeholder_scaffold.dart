import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:flutter_svg/svg.dart';
import 'package:native_app/providers/preferences.dart';

class PlaceholderScaffold extends ConsumerWidget {
  const PlaceholderScaffold({
    super.key,
    required this.body,
    this.bottomBar,
  });

  final Widget body;
  final Widget? bottomBar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var prefs = ref.watch(preferencesProvider);

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              try {
                await QR.back();
              } catch (error) {
                await QR.navigator.replaceAll('/');
              }
            },
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: SvgPicture.asset(
              'assets/images/icons/menu.svg',
              fit: BoxFit.scaleDown,
              width: 30,
              height: 30,
            ),
          ),
        ],
      ),
      body: prefs.when(
        loading: () => const SizedBox.shrink(),
        error: (error, _) => Text(error.toString()),
        data: (preferences) {
          String theme = preferences.getString('theme') ?? 'dark';

          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: theme == 'dark'
                    ? const AssetImage(
                        'assets/images/icons/background-pattern-dark.png',
                      )
                    : const AssetImage(
                        'assets/images/icons/background-pattern-light.png',
                      ),
                repeat: ImageRepeat.repeat,
              ),
            ),
            constraints: const BoxConstraints.expand(),
            child: body,
          );
        },
      ),
      bottomNavigationBar: bottomBar,
    );
  }
}
