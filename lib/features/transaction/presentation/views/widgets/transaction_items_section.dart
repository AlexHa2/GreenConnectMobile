import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_detail_entity.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:flutter/material.dart';

class TransactionItemsSection extends StatelessWidget {
  final List<TransactionDetailEntity> transactionDetails;
  final TransactionEntity transaction;
  final ThemeData theme;
  final double space;
  final S s;

  const TransactionItemsSection({
    super.key,
    required this.transactionDetails,
    required this.transaction,
    required this.theme,
    required this.space,
    required this.s,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(space),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(space / 2),
        border: Border.all(color: theme.dividerColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.inventory_2_outlined,
                color: theme.primaryColor,
                size: space * 2,
              ),
              SizedBox(width: space),
              Text(
                s.transaction_items,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          SizedBox(height: space),
          Divider(height: 1, color: theme.dividerColor),
          SizedBox(height: space),

          // Items List
          ...transactionDetails.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final imageUrl = _getImageUrlForItem(item);
            return Column(
              children: [
                _buildItemRow(item, imageUrl, s),
                if (index < transactionDetails.length - 1)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: space),
                    child: Divider(height: 1, color: theme.dividerColor),
                  ),
              ],
            );
          }),

          SizedBox(height: space),

          // Total
          Container(
            padding: EdgeInsets.all(space),
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(space / 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  s.total_price,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_calculateTotal().toStringAsFixed(2)} ${s.per_unit}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(TransactionDetailEntity item, String? imageUrl, S s) {
    return Row(
      children: [
        // Image or Icon
        ClipRRect(
          borderRadius: BorderRadius.circular(space / 2),
          child: imageUrl != null && imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  width: space * 4,
                  height: space * 4,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: space * 4,
                      height: space * 4,
                      padding: EdgeInsets.all(space * 0.75),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(space / 2),
                      ),
                      child: Icon(
                        Icons.recycling,
                        size: space * 1.5,
                        color: theme.primaryColor,
                      ),
                    );
                  },
                )
              : Container(
                  width: space * 4,
                  height: space * 4,
                  padding: EdgeInsets.all(space * 0.75),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(space / 2),
                  ),
                  child: Icon(
                    Icons.recycling,
                    size: space * 1.5,
                    color: theme.primaryColor,
                  ),
                ),
        ),

        SizedBox(width: space),

        // Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.scrapCategory.categoryName,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: space / 4),
              Text(
                item.quantity > 0
                    ? '${item.quantity} × ${item.pricePerUnit.toStringAsFixed(2)}/${item.unit}'
                    : '${item.pricePerUnit.toStringAsFixed(2)}/${item.unit} (Chưa nhập số lượng)',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withValues(
                    alpha: 0.7,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Price
        Text(
          item.quantity > 0
              ? '${item.finalPrice.toStringAsFixed(2)} ${s.per_unit}'
              : '${item.pricePerUnit.toStringAsFixed(2)}/${item.unit}',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          ),
        ),
      ],
    );
  }

  double _calculateTotal() {
    return transactionDetails.fold(0.0, (sum, item) => sum + item.finalPrice);
  }

  /// Get imageUrl for a transaction item by matching scrapCategoryId with scrapPostDetails
  String? _getImageUrlForItem(TransactionDetailEntity item) {
    final scrapPost = transaction.offer?.scrapPost;
    if (scrapPost == null || scrapPost.scrapPostDetails.isEmpty) {
      return null;
    }

    // Find matching scrap post detail by scrapCategoryId
    try {
      final matchingDetail = scrapPost.scrapPostDetails.firstWhere(
        (detail) => detail.scrapCategoryId == item.scrapCategoryId,
      );
      return matchingDetail.imageUrl;
    } catch (e) {
      return null;
    }
  }
}
