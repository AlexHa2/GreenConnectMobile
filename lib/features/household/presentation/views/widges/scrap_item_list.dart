import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class ScrapItemList extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final Function(int index, Map<String, dynamic> data) onUpdate;
  final Function(Map<String, dynamic> item) onDelete;

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
                    child: item['image'] != null
                        ? Image.file(
                            item['image'],
                            width: spacing.screenPadding * 6,
                            height: spacing.screenPadding * 6,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: spacing.screenPadding * 6,
                            height: spacing.screenPadding * 6,
                            color: theme.dividerColor.withValues(alpha: 0.6),
                            child: Icon(
                              Icons.image,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                  ),

                  SizedBox(width: spacing.screenPadding),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${item['category']}",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: spacing.screenPadding / 2),
                        Wrap(
                          spacing: spacing.screenPadding,
                          children: [
                            _buildInfoTag(
                              context,
                              icon: Icons.scale,
                              text: "${item['weight']} kg",
                              color: Colors.blue.shade700,
                              bgColor: Colors.blue.shade50,
                            ),
                            _buildInfoTag(
                              context,
                              icon: Icons.inventory_2,
                              text: "SL: ${item['quantity']}",
                              color: Colors.orange.shade800,
                              bgColor: Colors.orange.shade50,
                            ),
                          ],
                        ),
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

  Widget _buildInfoTag(
    BuildContext context, {
    required IconData icon,
    required String text,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
