import 'package:GreenConnectMobile/core/enum/offer_status.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:flutter/material.dart';

class OfferFilterChips extends StatelessWidget {
  final OfferStatus? selectedStatus;
  final ValueChanged<OfferStatus?> onFilterChanged;

  const OfferFilterChips({
    super.key,
    required this.selectedStatus,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context)!;
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip(
            context: context,
            label: s.all,
            isSelected: selectedStatus == null,
            onTap: () => onFilterChanged(null),
            color: theme.primaryColor,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            context: context,
            label: s.pending,
            isSelected: selectedStatus == OfferStatus.pending,
            onTap: () => onFilterChanged(OfferStatus.pending),
            color: AppColors.warningUpdate,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            context: context,
            label: s.accepted,
            isSelected: selectedStatus == OfferStatus.accepted,
            onTap: () => onFilterChanged(OfferStatus.accepted),
            color: theme.primaryColor,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            context: context,
            label: s.rejected,
            isSelected: selectedStatus == OfferStatus.rejected,
            onTap: () => onFilterChanged(OfferStatus.rejected),
            color: AppColors.danger,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            context: context,
            label: s.canceled,
            isSelected: selectedStatus == OfferStatus.canceled,
            onTap: () => onFilterChanged(OfferStatus.canceled),
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : theme.dividerColor,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? theme.scaffoldBackgroundColor
                : theme.textTheme.bodySmall?.color,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
