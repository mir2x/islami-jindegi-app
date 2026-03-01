import 'package:flutter/material.dart';

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
                  color: Theme.of(context).colorScheme.surface,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .shadow
                          .withValues(alpha: 0.26),
                      blurRadius: 0.0,
                      offset: Offset(0.0, 0.0),
                    ),
                  ],
                ),
                child: child,
              ),
              if (direction == 'ltr') ...[
                const Positioned(
                  right: 0,
                  child: CustomCloseButton(),
                ),
              ] else if (direction == 'rtl') ...[
                const Positioned(
                  left: 0,
                  child: CustomCloseButton(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCloseButton extends StatelessWidget {
  const CustomCloseButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Align(
        alignment: Alignment.topRight,
        child: CircleAvatar(
          radius: 16.0,
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: Icon(
            Icons.close,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
