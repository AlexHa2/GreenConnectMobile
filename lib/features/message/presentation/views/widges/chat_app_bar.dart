import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:flutter/material.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final String avatar;

  const ChatAppBar({super.key, required this.name, required this.avatar});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context)!;
    return AppBar(
      title: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          backgroundImage: avatar.isNotEmpty ? NetworkImage(avatar) : null,
          child: avatar.isEmpty ? const Icon(Icons.person) : null,
        ),
        title: Text(name, style: theme.appBarTheme.titleTextStyle),
        subtitle: Text(
          s.online,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.primaryColor,
          ),
        ),
      ),
      // actions: [
      //   IconButton(icon: const Icon(Icons.call_outlined), onPressed: () {}),
      //   IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
      // ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
