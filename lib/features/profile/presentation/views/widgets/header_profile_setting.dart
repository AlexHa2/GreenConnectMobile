// import 'package:GreenConnectMobile/shared/styles/padding.dart';
// import 'package:flutter/material.dart';

// class HeaderProfileSetting extends StatelessWidget {
//   final String fullname;
//   final List<String> roles;
//   final String title;
//   final String imageUrl;
//   const HeaderProfileSetting({
//     super.key,
//     required this.fullname,
//     required this.roles,
//     required this.title,
//     required this.imageUrl,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final spacing = theme.extension<AppSpacing>()!;
//     final baseSpacing = spacing.screenPadding;
//     return Column(
//       children: [
//         Stack(
//           alignment: Alignment.bottomRight,
//           children: [
//             CircleAvatar(
//               radius: baseSpacing * 4.5,
//               backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
//               backgroundImage: AssetImage(imageUrl),
//             ),
//             Positioned(
//               bottom: 0,
//               right: baseSpacing / 2,
//               child: Container(
//                 padding: EdgeInsets.all(baseSpacing / 2),
//                 decoration: BoxDecoration(
//                   color: theme.primaryColor,
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   Icons.camera_alt,
//                   color: theme.scaffoldBackgroundColor,
//                   size: baseSpacing * 1.5,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: baseSpacing),
//         Text(
//           fullname.toUpperCase(),
//           style: theme.textTheme.titleLarge?.copyWith(
//             fontWeight: FontWeight.bold,
//             color: theme.colorScheme.onSurface,
//           ),
//         ),
//         SizedBox(height: baseSpacing),
//         Wrap(
//           alignment: WrapAlignment.center,
//           spacing: baseSpacing / 2,
//           runSpacing: baseSpacing / 3,
//           children: [
//             ...roles.map(
//               (r) => Chip(
//                 label: Text(r),
//                 backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
//                 side: BorderSide(color: theme.primaryColor, width: 1.0),
//               ),
//             ),
//             Chip(
//               label: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(
//                     Icons.verified,
//                     color: theme.scaffoldBackgroundColor,
//                     size: 18,
//                   ),
//                   SizedBox(width: baseSpacing / 3),
//                   Text(
//                     title,
//                     style: TextStyle(color: theme.scaffoldBackgroundColor),
//                   ),
//                 ],
//               ),
//               backgroundColor: theme.primaryColor,
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
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
    final base = spacing.screenPadding;

    return Column(
      children: [
        // Avatar + camera button
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: base * 9,
              height: base * 9,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.primaryColor.withValues(alpha: 0.4),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.scaffoldBackgroundColor.withValues(
                      alpha: 0.06,
                    ),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: base * 4.5,
                backgroundImage: AssetImage(imageUrl),
                backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
              ),
            ),

            // Camera button
            Positioned(
              bottom: base * 0.4,
              right: base * 0.6,
              child: Container(
                padding: EdgeInsets.all(base * 0.5),
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: theme.primaryColor.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  size: base * 1.6,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: base * 1.2),

        // Fullname
        Text(
          fullname,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
          ),
        ),

        // Title (badge)
        SizedBox(height: base * 0.5),
        _buildTitleBadge(title, theme, base),

        SizedBox(height: base),

        // Roles (UI badges)
        Wrap(
          alignment: WrapAlignment.center,
          spacing: base * 0.4,
          runSpacing: base * 0.4,
          children: roles.map((r) => _buildRoleBadge(r, theme, base)).toList(),
        ),
      ],
    );
  }

  /// ===========================
  /// Custom badges
  /// ===========================

  Widget _buildRoleBadge(String role, ThemeData theme, double base) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: base * 0.8,
        vertical: base * 0.4,
      ),
      decoration: BoxDecoration(
        color: theme.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.primaryColor.withValues(alpha: 0.4)),
      ),
      child: Text(
        role,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.primaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTitleBadge(String title, ThemeData theme, double base) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: base * 1, vertical: base * 0.5),
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified, size: 18, color: theme.colorScheme.onPrimary),
          SizedBox(width: base * 0.3),
          Text(
            title,
            style: TextStyle(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
