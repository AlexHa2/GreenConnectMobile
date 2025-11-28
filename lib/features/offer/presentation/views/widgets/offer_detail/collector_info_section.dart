import 'package:GreenConnectMobile/features/offer/domain/entities/collector_entity.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:flutter/material.dart';

class CollectorInfoSection extends StatelessWidget {
  final CollectorEntity collector;
  final ThemeData theme;
  final double spacing;
  final S s;

  const CollectorInfoSection({
    super.key,
    required this.collector,
    required this.theme,
    required this.spacing,
    required this.s,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(spacing),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(spacing),
            child: Row(
              children: [
                Icon(Icons.person_outline, color: theme.primaryColor, size: 24),
                SizedBox(width: spacing / 2),
                Text(
                  s.collector_information,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: theme.dividerColor),

          // Content
          Padding(
            padding: EdgeInsets.all(spacing),
            child: Column(
              children: [
                // Avatar and basic info
                Row(
                  children: [
                    CircleAvatar(
                      radius: spacing * 3,
                      backgroundColor: theme.primaryColor.withValues(
                        alpha: 0.1,
                      ),
                      backgroundImage: collector.avatarUrl != null
                          ? NetworkImage(collector.avatarUrl!)
                          : null,
                      child: collector.avatarUrl == null
                          ? Icon(
                              Icons.person,
                              color: theme.primaryColor,
                              size: 32,
                            )
                          : null,
                    ),
                    SizedBox(width: spacing),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            collector.fullName ?? s.unknown,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: spacing / 3),
                          // Rank badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: spacing * 0.75,
                              vertical: spacing / 3,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  theme.primaryColor,
                                  theme.primaryColor.withValues(alpha: 0.7),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.stars,
                                  size: 14,
                                  color: theme.scaffoldBackgroundColor,
                                ),
                                SizedBox(width: spacing / 3),
                                Text(
                                  collector.rank,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: theme.scaffoldBackgroundColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacing),

                // Contact info
                _buildInfoRow(
                  Icons.phone_outlined,
                  s.phone_number,
                  collector.phoneNumber ?? 'N/A',
                ),
                SizedBox(height: spacing * 0.75),
                _buildInfoRow(Icons.star_outlined, 'Rank', collector.rank),

                // Contact button
                SizedBox(height: spacing),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: collector.phoneNumber != null ? () {} : null,
                    icon: const Icon(Icons.phone, size: 20),
                    label: Text(s.contact_collector),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      foregroundColor: theme.scaffoldBackgroundColor,
                      padding: EdgeInsets.symmetric(vertical: spacing * 0.75),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(spacing / 2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(spacing * 0.75),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(spacing / 2),
          border: Border.all(color: theme.dividerColor, width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: theme.primaryColor),
            SizedBox(width: spacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                  SizedBox(height: spacing / 4),
                  Text(
                    value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: theme.textTheme.bodySmall?.color,
              ),
          ],
        ),
      ),
    );
  }
}
