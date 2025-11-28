import 'package:GreenConnectMobile/core/enum/offer_status.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:flutter/material.dart';

class ActionButtonsSection extends StatelessWidget {
  final OfferStatus status;
  final bool isCollectorView;
  final ThemeData theme;
  final double spacing;
  final S s;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onCancel;
  final VoidCallback? onRestore;

  const ActionButtonsSection({
    super.key,
    required this.status,
    required this.isCollectorView,
    required this.theme,
    required this.spacing,
    required this.s,
    this.onAccept,
    this.onReject,
    this.onCancel,
    this.onRestore,
  });

  @override
  Widget build(BuildContext context) {
    // Don't show buttons for accepted/rejected status
    if (status == OfferStatus.accepted || status == OfferStatus.rejected) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(spacing),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: isCollectorView
            ? _buildCollectorButtons()
            : _buildHouseholdButtons(),
      ),
    );
  }

  Widget _buildCollectorButtons() {
    if (status == OfferStatus.canceled) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onRestore,
          icon: const Icon(Icons.restore, size: 20),
          label: Text(
            s.restore_offer,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            foregroundColor: theme.scaffoldBackgroundColor,
            padding: EdgeInsets.symmetric(vertical: spacing),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(spacing),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onCancel,
        icon: const Icon(Icons.cancel_outlined, size: 20),
        label: Text(
          s.cancel_offer,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColorsDark.danger,
          foregroundColor: theme.scaffoldBackgroundColor,
          padding: EdgeInsets.symmetric(vertical: spacing),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(spacing),
          ),
        ),
      ),
    );
  }

  Widget _buildHouseholdButtons() {
    if (status == OfferStatus.canceled) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onReject,
            icon: const Icon(Icons.close, size: 20),
            label: Text(
              s.reject_offer,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColorsDark.danger,
              foregroundColor: theme.scaffoldBackgroundColor,
              padding: EdgeInsets.symmetric(vertical: spacing),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(spacing),
              ),
            ),
          ),
        ),
        SizedBox(width: spacing),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onAccept,
            icon: const Icon(Icons.check, size: 20),
            label: Text(
              s.accept_offer,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              foregroundColor: theme.scaffoldBackgroundColor,
              padding: EdgeInsets.symmetric(vertical: spacing),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(spacing),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
