import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qlevar_router/qlevar_router.dart';
import '../../viewmodel/ayah_highlight_viewmodel.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final bool isLandscape;
  const CustomAppBar({super.key, this.isLandscape = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        iconSize: isLandscape ? 20.0 : 24.0,
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: Text(
        'কুরআন মাজীদ',
        style: TextStyle(
          fontFamily: 'bangla/solaimanlipi',
          wordSpacing: 3,
          fontSize: isLandscape ? 18.0 : 22.sp,
        ),
      ),
      centerTitle: true,
      actions: [
        Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            iconSize: isLandscape ? 20.0 : 24.0,
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.search),
          iconSize: isLandscape ? 20.0 : 24.0,
          onPressed: () {
            QR.to('/qurans/search');
          },
        ),
        IconButton(
          icon: const Icon(Icons.g_translate),
          iconSize: isLandscape ? 20.0 : 24.0,
          onPressed: () {
            final int suraNumber = ref.watch(currentSuraProvider);
            QR.to('/qurans/sura/$suraNumber');
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
