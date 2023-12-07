import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'with_last_visited.dart';

class LastVisited extends ConsumerWidget {
  const LastVisited({
    super.key,
    required this.resourceKey,
    required this.resourceId,
  });

  final String resourceKey;
  final String resourceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WithLastVisited(
      builder: (context, settings) {
        if (settings.getString(resourceKey) == resourceId) {
          return Container(
            margin: const EdgeInsets.only(
              left: 10,
            ),
            child: SvgPicture.asset(
              'assets/images/icons/open-book.svg',
              fit: BoxFit.scaleDown,
              width: 25,
              height: 20,
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
