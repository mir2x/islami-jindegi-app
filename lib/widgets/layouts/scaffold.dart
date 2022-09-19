import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:flutter_svg/svg.dart';
import 'package:native_app/styles/settings/theme_colors.dart';

class MyScaffold extends StatelessWidget {
  const MyScaffold({
    super.key,
    required this.title,
    required this.body
  });

  final Text title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: QR.navigator.currentRoute.path == '/' ? SvgPicture.asset(
            'assets/images/logos/logo.svg',
            fit: BoxFit.scaleDown,
            width: 40,
            height: 35,
          ) : IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: QR.back,
          ),
        ),
        title: title,
        backgroundColor: ThemeColors().themeColor5,
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => QR.to('settings'),
              child: SvgPicture.asset(
                'assets/images/icons/settings-icon.svg',
                fit: BoxFit.scaleDown,
                width: 40,
                height: 40,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        constraints: const BoxConstraints(
          minWidth: double.infinity,
          minHeight: double.infinity,
        ),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage('assets/images/icons/background-pattern-dark.png'),
            repeat: ImageRepeat.repeat,
          ),
        ),
        child: body,
      ),
    );
  }
}
