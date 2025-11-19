import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class HeaderProfileSetting extends StatelessWidget {
  final String fullname;
  final List<String> roles;
  final String title;
  final String imageUrl;
  const HeaderProfileSetting({
    super.key,
    required this.fullname,
    required this.roles,
    required this.title,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final baseSpacing = spacing.screenPadding;
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: baseSpacing * 4.5,
              backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
              backgroundImage: AssetImage(imageUrl),
            ),
            Positioned(
              bottom: 0,
              right: baseSpacing / 2,
              child: Container(
                padding: EdgeInsets.all(baseSpacing / 2),
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: theme.scaffoldBackgroundColor,
                  size: baseSpacing * 1.5,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: baseSpacing * 1.5),
        Text(
          fullname.toUpperCase(),
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: baseSpacing),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: baseSpacing / 2,
          runSpacing: baseSpacing / 3,
          children: [
            ...roles.map(
              (r) => Chip(
                label: Text(r),
                backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
                side: BorderSide(color: theme.primaryColor, width: 1.0),
              ),
            ),
            Chip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified,
                    color: theme.scaffoldBackgroundColor,
                    size: 18,
                  ),
                  SizedBox(width: baseSpacing / 3),
                  Text(
                    title,
                    style: TextStyle(color: theme.scaffoldBackgroundColor),
                  ),
                ],
              ),
              backgroundColor: theme.primaryColor,
            ),
          ],
        ),
      ],
    );
  }
}
