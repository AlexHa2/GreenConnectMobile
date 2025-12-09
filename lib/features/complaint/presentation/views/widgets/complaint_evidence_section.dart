import 'dart:typed_data';

import 'package:GreenConnectMobile/features/complaint/presentation/views/widgets/complaint_image_empty_state.dart';
import 'package:GreenConnectMobile/features/complaint/presentation/views/widgets/complaint_image_preview.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class ComplaintEvidenceSection extends StatelessWidget {
  final String label;
  final Uint8List? selectedImageBytes;
  final String? networkImageUrl;
  final bool isRequired;
  final bool hasImageAttached;
  final VoidCallback onPickImage;
  final VoidCallback? onRemoveImage;
  final String? attachedBadgeText;
  final String emptyStateTitle;
  final String? emptyStateSubtitle;
  final String pickButtonText;
  final String changeButtonText;
  final bool enabled;

  const ComplaintEvidenceSection({
    super.key,
    required this.label,
    this.selectedImageBytes,
    this.networkImageUrl,
    this.isRequired = false,
    required this.hasImageAttached,
    required this.onPickImage,
    this.onRemoveImage,
    this.attachedBadgeText,
    required this.emptyStateTitle,
    this.emptyStateSubtitle,
    required this.pickButtonText,
    required this.changeButtonText,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;

    return Container(
      padding: EdgeInsets.all(space * 1.5),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(space * 1.5),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.image_outlined,
                color: theme.primaryColor,
                size: 20,
              ),
              SizedBox(width: space * 0.5),
              Text(
                label,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isRequired)
                const Text(
                  ' *',
                  style: TextStyle(
                    color: AppColors.danger,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const Spacer(),
              if (hasImageAttached && attachedBadgeText != null)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: space * 0.75,
                    vertical: space * 0.25,
                  ),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(space * 0.5),
                  ),
                  child: Text(
                    attachedBadgeText!,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: space),
          if (selectedImageBytes != null || networkImageUrl != null)
            ComplaintImagePreview(
              imageBytes: selectedImageBytes,
              networkImageUrl: networkImageUrl,
              onRemove: enabled ? onRemoveImage : null,
              badgeText: selectedImageBytes != null
                  ? (networkImageUrl != null ? 'Updated image' : 'New image')
                  : null,
            )
          else
            ComplaintImageEmptyState(
              title: emptyStateTitle,
              subtitle: emptyStateSubtitle,
            ),
          SizedBox(height: space),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: enabled ? onPickImage : null,
              icon: Icon(
                selectedImageBytes != null
                    ? Icons.swap_horiz
                    : Icons.add_photo_alternate_outlined,
              ),
              label: Text(
                selectedImageBytes != null ? changeButtonText : pickButtonText,
              ),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: space),
                side: BorderSide(
                  color: theme.primaryColor,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(space),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
