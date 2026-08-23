import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ContinueReadingCard extends StatelessWidget {
  const ContinueReadingCard(
      {super.key,
      required this.title,
      required this.destination,
      required this.icon});
  final String title;
  final String destination;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.fromLTRB(15, 6, 15, 2),
      child: Card(
          child: ListTile(
              leading: Icon(icon),
              title: Text(title.isEmpty ? 'Continue reading' : title,
                  maxLines: 2, overflow: TextOverflow.ellipsis),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(destination))));
}
