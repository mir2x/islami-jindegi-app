import 'package:flutter/material.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/theme/app_theme.dart';

class PopupDialog extends StatelessWidget {
  const PopupDialog({
    super.key,
    required this.child,
    this.direction = 'ltr',
  });

  final Widget child;
  final String direction;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return WithPreferences(
      builder: (context, preferences) {
        String theme = preferences.getString('theme') ?? 'classic';

        dynamic dialogMargin = direction == 'ltr'
            ? const EdgeInsets.only(top: 12.0, right: 7.0)
            : const EdgeInsets.only(top: 12.0, left: 7.0);

        return Center(
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              width: screenWidth * 0.8,
              height: screenHeight * 0.5,
              margin: const EdgeInsets.only(left: 0.0, right: 0.0),
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: dialogMargin,
                    decoration: BoxDecoration(
                      color: AppTheme.dialogBgColor[theme],
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 0.0,
                          offset: Offset(0.0, 0.0),
                        ),
                      ],
                    ),
                    child: child,
                  ),
                  if (direction == 'ltr') ...[
                    Positioned(
                      right: 0,
                      child: CloseButton(preferences: preferences),
                    ),
                  ] else if (direction == 'rtl') ...[
                    Positioned(
                      left: 0,
                      child: CloseButton(preferences: preferences),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CloseButton extends StatelessWidget {
  const CloseButton({
    super.key,
    required this.preferences,
  });

  final dynamic preferences;

  @override
  Widget build(BuildContext context) {
    String theme = preferences.getString('theme') ?? 'classic';

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Align(
        alignment: Alignment.topRight,
        child: CircleAvatar(
          radius: 16.0,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.close,
            color: AppTheme.iconColor[theme],
          ),
        ),
      ),
    );
  }
}
