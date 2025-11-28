import 'package:GreenConnectMobile/core/enum/offer_status.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatusHeaderSection extends StatelessWidget {
  final OfferStatus status;
  final DateTime createdAt;
  final ThemeData theme;
  final double spacing;
  final S s;

  const StatusHeaderSection({
    super.key,
    required this.status,
    required this.createdAt,
    required this.theme,
    required this.spacing,
    required this.s,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacing),
      decoration: BoxDecoration(
        color: _getStatusColor(status, theme).withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color: _getStatusColor(status, theme).withValues(alpha: 0.3),
            width: 2,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: spacing,
              vertical: spacing / 2,
            ),
            decoration: BoxDecoration(
              color: _getStatusColor(status, theme),
              borderRadius: BorderRadius.circular(spacing),
            ),
            child: Text(
              OfferStatus.labelS(context, status).toUpperCase(),
              style: TextStyle(
                color: theme.scaffoldBackgroundColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                s.offer_created_at,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color,
                ),
              ),
              SizedBox(height: spacing / 4),
              Text(
                DateFormat('dd/MM/yyyy HH:mm').format(createdAt),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _getStatusColor(status, theme),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(OfferStatus status, ThemeData theme) {
    switch (status) {
      case OfferStatus.pending:
        return AppColors.warningUpdate;
      case OfferStatus.accepted:
        return theme.primaryColor;
      case OfferStatus.rejected:
        return AppColorsDark.danger;
      case OfferStatus.canceled:
        return theme.colorScheme.onSurface.withValues(alpha: 0.6);
    }
  }
}
