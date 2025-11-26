import 'package:GreenConnectMobile/core/enum/role.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class HeaderProfileSetting extends StatelessWidget {
  final String fullname;
  final List<String> roles;
  final String title;
  final String imageUrl;
  final VoidCallback? onTap;

  const HeaderProfileSetting({
    super.key,
    required this.fullname,
    required this.roles,
    required this.title,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final base = spacing.screenPadding;
    final bool isNetwork = imageUrl.startsWith('http');
    final String fallbackAsset = "assets/images/user_image.png";
    return Column(
      children: [
        // Avatar + camera button
        GestureDetector(
          onTap: onTap,
          child: Stack(
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
                child: ClipOval(
                  child: Container(
                    color: theme.primaryColor.withValues(alpha: 0.1),
                    child: isNetwork
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                Image.asset(fallbackAsset, fit: BoxFit.cover),
                          )
                        : Image.asset(
                            imageUrl.isNotEmpty ? imageUrl : fallbackAsset,
                            fit: BoxFit.cover,
                          ),
                  ),
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
        ),

        // SizedBox(height: base * 1.2),

        // // Fullname
        // Text(
        //   fullname,
        //   style: theme.textTheme.headlineSmall?.copyWith(
        //     fontWeight: FontWeight.bold,
        //     letterSpacing: 0.3,
        //   ),
        // ),

        // Title (badge)
        SizedBox(height: base * 0.5),
        _buildTitleBadge(title, theme, base),

        SizedBox(height: base),

        // Roles (UI badges)
        Wrap(
          alignment: WrapAlignment.center,
          spacing: base * 0.4,
          runSpacing: base * 0.4,
          children: roles.map((role) {
            final parsedRole = Role.fromJson(role);
            final label = _roleLabel(context, parsedRole);
            return _buildRoleBadge(label, theme, base);
          }).toList(),
        ),
      ],
    );
  }

  String _roleLabel(BuildContext context, Role role) {
    final s = S.of(context)!;
    switch (role) {
      case Role.individualCollector:
        return s.individual_collector;
      case Role.businessCollector:
        return s.business_collector;
      case Role.household:
        return s.household_role;
    }
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
