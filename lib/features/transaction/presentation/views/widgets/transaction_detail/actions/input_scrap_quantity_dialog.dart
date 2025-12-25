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
              SizedBox(height: spacing * 1.5),
              ...offerDetails.map((detail) {
                final controller = _quantityControllers[detail.scrapCategoryId];
                if (controller == null) return const SizedBox.shrink();

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
                        Row(
                          children: [
                            Icon(
                              Icons.recycling,
                              color: theme.primaryColor,
                              size: spacing * 1.5,
                            ),
                            SizedBox(width: spacing / 2),
                            Expanded(
                              child: Text(
                                detail.scrapCategory?.categoryName ??
                                    '${s.unknown} (${detail.scrapCategoryId})',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: spacing / 2),
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
                        SizedBox(height: spacing),
                        TextFormField(
                          controller: controller,
                          decoration: InputDecoration(
                            labelText: s.quantity_with_unit(detail.unit),
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
