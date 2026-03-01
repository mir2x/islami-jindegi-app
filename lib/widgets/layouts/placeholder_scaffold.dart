import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:flutter_svg/svg.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';

class PlaceholderScaffold extends ConsumerWidget {
  const PlaceholderScaffold({
    super.key,
    required this.body,
    this.bottomBar,
    this.showPattern = false,
  });

  final Widget body;
  final Widget? bottomBar;
  final bool showPattern;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      body: WithPreferences(
        builder: (context, preferences) {
          String theme = preferences.getString('theme') ?? 'classic';
          String background = preferences.getString('background') ?? 'mosque';

          return Container(
            decoration: BoxDecoration(
              image: (showPattern && background != 'no-background')
                  ? DecorationImage(
                      image: AssetImage(
                        'assets/images/background/$background-$theme.png',
                      ),
                      repeat: background == 'pattern'
                          ? ImageRepeat.repeat
                          : ImageRepeat.noRepeat,
                    )
                  : null,
              color: Theme.of(context).colorScheme.surface,
            ),
            constraints: const BoxConstraints.expand(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 768) {
                  return body;
                } else {
                  double screenWidth = MediaQuery.of(context).size.width;

                  return Container(
                    padding: EdgeInsets.only(
                      left: screenWidth * 0.06,
                      right: screenWidth * 0.06,
                    ),
                    child: body,
                  );
                }
              },
            ),
          );
        },
      ),
      bottomNavigationBar: bottomBar,
    );
  }
}
