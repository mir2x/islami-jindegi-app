import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/utils/html_text.dart';

class MalfuzatPopup extends ConsumerStatefulWidget {
  const MalfuzatPopup({super.key});

  @override
  MalfuzatPopupState createState() => MalfuzatPopupState();
}

class MalfuzatPopupState extends ConsumerState<MalfuzatPopup> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var malfuzats = await ref.malfuzats.findAll(
        params: const {
          'include': 'malfuzat-author',
          'quantity': 1,
        },
      );

      if (mounted) {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            double screenWidth = MediaQuery.of(context).size.width;
            double screenHeight = MediaQuery.of(context).size.height;
            var textTheme = Theme.of(context).textTheme;
            var item = malfuzats.first;
            String? author = item.malfuzatAuthor?.value?.name;

            return Center(
              child: Dialog(
                child: Container(
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.3,
                  padding: const EdgeInsets.only(
                    top: 20,
                    bottom: 20,
                    left: 20,
                    right: 20,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          child: Text(
                            item.title,
                            style: textTheme.headlineMedium,
                          ),
                        ),
                        if (author != null) ...[
                          Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            child: Text(
                              author,
                              style: textTheme.labelMedium,
                            ),
                          ),
                        ],
                        if (item.body != null) ...[
                          Container(
                            margin: const EdgeInsets.only(bottom: 30),
                            child: HtmlText(text: item.body!),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
