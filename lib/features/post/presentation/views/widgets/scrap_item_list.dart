import 'package:GreenConnectMobile/features/post/domain/entities/scrap_item_data.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class ScrapItemList extends StatelessWidget {
  final List<ScrapItemData> items;
  final Function(int index, ScrapItemData data) onUpdate;
  final Function(ScrapItemData item) onDelete;

  const ScrapItemList({
    super.key,
    required this.items,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final theme = Theme.of(context);

    return Column(
      children: items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;

        return Container(
          margin: EdgeInsets.only(bottom: spacing.screenPadding),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(spacing.screenPadding),
            ),
            child: Padding(
              padding: EdgeInsets.all(spacing.screenPadding),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      spacing.screenPadding / 1.5,
                    ),
                    child: _buildImage(item, spacing, theme),
                  ),

                  SizedBox(width: spacing.screenPadding),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.categoryName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (item.amountDescription.isNotEmpty) ...[
                          SizedBox(height: spacing.screenPadding * 0.5),
                          Row(
                            children: [
                              Icon(
                                Icons.inventory_2_outlined,
                                size: 14,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              SizedBox(width: spacing.screenPadding * 0.5),
                              Expanded(
                                child: Text(
                                  item.amountDescription,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  Column(
                    children: [
                      InkWell(
                        onTap: () => onUpdate(index, item),
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.edit_outlined,
                            size: 20,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => onDelete(item),
                        borderRadius: BorderRadius.circular(
                          spacing.screenPadding,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(spacing.screenPadding),
                          child: const Icon(
                            Icons.delete_outline,
                            size: 20,
                            color: AppColors.danger,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildImage(ScrapItemData item, AppSpacing spacing, ThemeData theme) {
    final hasImage = item.imageFile != null || item.imageUrl != null;
    
    if (!hasImage) {
      return Container(
        width: spacing.screenPadding * 6,
        height: spacing.screenPadding * 6,
        color: theme.dividerColor.withValues(alpha: 0.6),
        child: Icon(
          Icons.image,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
        ),
      );
    }
    
    // If local File exists, display from File
    if (item.imageFile != null) {
      return Image.file(
        item.imageFile!,
        width: spacing.screenPadding * 6,
        height: spacing.screenPadding * 6,
        fit: BoxFit.cover,
      );
    }
    // If URL exists, display from network
    return Image.network(
      item.imageUrl!,
      width: spacing.screenPadding * 6,
      height: spacing.screenPadding * 6,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: spacing.screenPadding * 6,
          height: spacing.screenPadding * 6,
          color: theme.dividerColor.withValues(alpha: 0.6),
          child: Icon(
            Icons.broken_image,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
        );
      },
    );
  }

  // Widget _buildInfoTag(
  //   BuildContext context, {
  //   required IconData icon,
  //   required String text,
  //   required Color color,
  //   required Color bgColor,
  // }) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
  //     decoration: BoxDecoration(
  //       color: bgColor,
  //       borderRadius: BorderRadius.circular(4),
  //     ),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Icon(icon, size: 12, color: color),
  //         const SizedBox(width: 4),
  //         Text(
  //           text,
  //           style: TextStyle(
  //             fontSize: 12,
  //             fontWeight: FontWeight.w500,
  //             color: color,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
