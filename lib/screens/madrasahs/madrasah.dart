import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
import 'package:native_app/widgets/responsive/image.dart';
import 'package:native_app/theme/colors.dart';

class Madrasah extends ConsumerWidget {
  const Madrasah({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var query = SingleModelQuery(
      repository: ref.madrasahs,
      id: QR.params['id'].toString(),
      params: const {'include': 'madrasah-infos,madrasah-photos'},
      remote: true,
    );

    var modelQuery = ref.watch(singleModelProvider(query));

    return modelQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resource) {
        return MyScaffold(
          title: Text(resource.title),
          body: StatefulMadrasah(madrasah: resource),
        );
      },
    );
  }
}

class StatefulMadrasah extends ConsumerStatefulWidget {
  const StatefulMadrasah({
    super.key,
    required this.madrasah,
  });

  final dynamic madrasah;

  @override
  MadrasahState createState() => MadrasahState();
}

class MadrasahState extends ConsumerState<StatefulMadrasah> {
  String? activeSection;
  dynamic activeInfo;
  final ScrollController sectionController = ScrollController();

  @override
  void initState() {
    super.initState();

    activeSection = 'introduction';
  }

  updateSection(String value) {
    setState(() {
      activeSection = value;
      activeInfo = null;
    });
  }

  updateInfo(dynamic info) {
    setState(() {
      activeInfo = info;
      activeSection = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    String currentLang = Localizations.localeOf(context).languageCode;
    var textTheme = Theme.of(context).textTheme;
    double screenHeight = MediaQuery.of(context).size.height;

    return ItemContent(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 10, bottom: 15),
          child: Text(locales.info, style: textTheme.labelLarge),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 30),
          constraints: BoxConstraints(
            maxHeight: screenHeight * 0.4,
          ),
          child: Scrollbar(
            thumbVisibility: true,
            controller: sectionController,
            child: SingleChildScrollView(
              controller: sectionController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MadrasahSection(
                    title: locales.introduction,
                    isSelected: activeSection == 'introduction',
                    onSelected: () => updateSection('introduction'),
                  ),
                  ...widget.madrasah.madrasahInfos.map((info) {
                    return MadrasahSection(
                      title: currentLang == 'bn' ? info.labelBn : info.label,
                      isSelected: activeInfo?.id == info.id,
                      onSelected: () => updateInfo(info),
                    );
                  }),
                  MadrasahSection(
                    title: locales.gallery,
                    isSelected: activeSection == 'gallery',
                    onSelected: () => updateSection('gallery'),
                  ),
                  MadrasahSection(
                    title: locales.document,
                    isSelected: activeSection == 'document',
                    onSelected: () => updateSection('document'),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Text(
            widget.madrasah.title,
            style: textTheme.headlineMedium,
          ),
        ),
        if (activeSection == 'introduction') ...[
          Text(locales.introduction, style: textTheme.labelMedium),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: HtmlText(
              text: widget.madrasah.introduction,
            ),
          ),
        ] else if (activeSection == 'gallery') ...[
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Text(locales.gallery, style: textTheme.labelMedium),
          ),
          ...widget.madrasah.madrasahPhotos.map((photo) {
            return Container(
              padding: const EdgeInsets.only(bottom: 20),
              child: ResponsiveImage(
                image: photo.image,
                model: 'madrasahPhoto',
              ),
            );
          }),
        ] else if (activeSection == 'document') ...[
          DescriptionItem(
            title: '${locales.download}:',
            description: const Align(
              alignment: Alignment.topLeft,
              child: Icon(
                Icons.download,
                size: 24,
              ),
            ),
          ),
        ] else if (activeInfo != null) ...[
          Text(
            currentLang == 'bn' ? activeInfo.labelBn : activeInfo.label,
            style: textTheme.labelMedium,
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: HtmlText(text: activeInfo.info),
          ),
        ],
      ],
    );
  }
}

class MadrasahSection extends StatelessWidget {
  const MadrasahSection({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onSelected,
  });

  final String title;
  final bool isSelected;
  final void Function() onSelected;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: onSelected,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: ThemeColors.color7,
          ),
          padding: const EdgeInsets.all(15),
          child: Text(
            title,
            style: textTheme.labelMedium?.copyWith(
              color: isSelected ? ThemeColors.color3 : ThemeColors.color4,
            ),
          ),
        ),
      ),
    );
  }
}
