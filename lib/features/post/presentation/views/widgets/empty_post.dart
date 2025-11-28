import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class EmptyPost extends StatelessWidget {
  const EmptyPost({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context)!;
    final space = Theme.of(context).extension<AppSpacing>()!;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: space.screenPadding * 3,
        horizontal: space.screenPadding * 2,
      ),
      child: Column(
        children: [
          Icon(Icons.recycling, size: 90, color: theme.primaryColor),
          const SizedBox(height: 20),
          Text(
            s.you_have_no_recycling_posts,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            s.start_sharing_recycling_posts,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: theme.dividerColor),
          ),
        ],
      ),
    );
  }
}
