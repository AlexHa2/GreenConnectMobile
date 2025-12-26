import 'package:GreenConnectMobile/features/post/presentation/views/widgets/type_badge.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class InputScrapQuantityDialog extends StatefulWidget {
  final TransactionEntity transaction;

  const InputScrapQuantityDialog({super.key, required this.transaction});

  @override
  State<InputScrapQuantityDialog> createState() =>
      _InputScrapQuantityDialogState();
}

class _InputScrapQuantityDialogState extends State<InputScrapQuantityDialog> {
  final Map<String, TextEditingController> _quantityControllers = {};
  final bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers for each offer detail
    final offerDetails = widget.transaction.offer?.offerDetails ?? [];
    for (final detail in offerDetails) {
      // Pre-fill with existing quantity if available
      final existingDetail = widget.transaction.transactionDetails
          .where((td) => td.scrapCategoryId == detail.scrapCategoryId)
          .firstOrNull;
      _quantityControllers[detail.scrapCategoryId] = TextEditingController(
        text: existingDetail?.quantity.toString() ?? '',
      );
    }
  }

  @override
  void dispose() {
    for (final controller in _quantityControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  List<Map<String, dynamic>> _getDetails() {
    final offerDetails = widget.transaction.offer?.offerDetails ?? [];
    final details = <Map<String, dynamic>>[];

    for (final detail in offerDetails) {
      final controller = _quantityControllers[detail.scrapCategoryId];
      if (controller != null && controller.text.isNotEmpty) {
        final quantity = double.tryParse(controller.text);
        if (quantity != null && quantity > 0) {
          details.add({
            'scrapCategoryId': detail.scrapCategoryId,
            'pricePerUnit': detail.pricePerUnit,
            'unit': detail.unit,
            'quantity': quantity,
          });
        }
      }
    }

    return details;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!.screenPadding;
    final s = S.of(context)!;
    final offerDetails = widget.transaction.offer?.offerDetails ?? [];

    if (offerDetails.isEmpty) {
      return AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(spacing),
        ),
        title: Text(s.no_data_found),
        content: Text(s.no_scrap_items_to_input),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(s.cancel),
          ),
        ],
      );
    }

    return AlertDialog(
      backgroundColor: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(spacing),
      ),
      title: Row(
        children: [
          Icon(Icons.edit, color: theme.primaryColor),
          SizedBox(width: spacing),
          Expanded(
            child: Text(
              s.enter_actual_quantity,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(spacing),
                decoration: BoxDecoration(
                  color: AppColors.warningUpdate.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(spacing / 2),
                  border: Border.all(
                    color: AppColors.warningUpdate.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.warningUpdate,
                      size: spacing * 1.5,
                    ),
                    SizedBox(width: spacing),
                    Expanded(
                      child: Text(
                        s.weighing_instruction,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.warningUpdate,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: spacing),
              ...offerDetails.map((detail) {
                final controller = _quantityControllers[detail.scrapCategoryId];
                if (controller == null) return const SizedBox.shrink();

                // Get type from scrapPost details (for badge)
                String? detailType;
                final scrapPost = widget.transaction.offer?.scrapPost;
                if (scrapPost != null) {
                  final postDetail = scrapPost.scrapPostDetails
                      .where(
                          (pd) => pd.scrapCategoryId == detail.scrapCategoryId)
                      .firstOrNull;
                  if (postDetail != null && postDetail.type.isNotEmpty) {
                    detailType = postDetail.type;
                  }
                }

                return Padding(
                  padding: EdgeInsets.only(bottom: spacing),
                  child: Container(
                    padding: EdgeInsets.all(spacing),
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(spacing / 2),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// ===== HEADER =====
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Image / Icon
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(spacing / 2),
                                color: theme.cardColor,
                              ),
                              child: detail.imageUrl != null &&
                                      detail.imageUrl!.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(spacing / 2),
                                      child: Image.network(
                                        detail.imageUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Icon(
                                          Icons.recycling,
                                          color: theme.primaryColor,
                                        ),
                                      ),
                                    )
                                  : Icon(
                                      Icons.recycling,
                                      color: theme.primaryColor,
                                    ),
                            ),
                            SizedBox(width: spacing * 0.75),

                            // Category name
                            Expanded(
                              child: Text(
                                detail.scrapCategory?.categoryName ??
                                    '${s.unknown} (${detail.scrapCategoryId})',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            // Type badge
                            if (detailType != null && detailType.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(left: spacing / 2),
                                child: TypeBadge(type: detailType),
                              ),
                          ],
                        ),

                        SizedBox(height: spacing),

                        /// ===== INFO SECTION =====
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: spacing * 0.75,
                            vertical: spacing * 0.6,
                          ),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(spacing / 2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.price_display(
                                  detail.pricePerUnit.toStringAsFixed(0),
                                  s.per_unit,
                                  detail.unit,
                                ),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.hintColor,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: spacing),

                        /// ===== INPUT =====
                        TextFormField(
                          controller: controller,
                          decoration: InputDecoration(
                            hintText: s.enter_actual_quantity_hint,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(spacing / 2),
                            ),
                            suffixText: detail.unit,
                            filled: true,
                            fillColor: theme.cardColor,
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return s.please_enter_quantity;
                            }
                            final quantity = double.tryParse(value);
                            if (quantity == null || quantity < 0) {
                              return s.invalid_quantity;
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text(s.cancel),
        ),
        ElevatedButton(
          onPressed: _isLoading
              ? null
              : () {
                  final details = _getDetails();
                  if (details.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(s.enter_at_least_one_item_toast),
                        backgroundColor: AppColors.danger,
                      ),
                    );
                    return;
                  }
                  Navigator.of(context).pop(details);
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            foregroundColor: theme.scaffoldBackgroundColor,
          ),
          child: _isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.scaffoldBackgroundColor,
                    ),
                  ),
                )
              : Text(s.save),
        ),
      ],
    );
  }
}
