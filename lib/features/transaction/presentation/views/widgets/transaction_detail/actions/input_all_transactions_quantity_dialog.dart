import 'package:GreenConnectMobile/features/offer/domain/entities/offer_detail_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/transaction_entity.dart'
    as post_entity;
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/type_badge.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_detail_request.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/providers/transaction_providers.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InputAllTransactionsQuantityDialog extends ConsumerStatefulWidget {
  final post_entity.PostTransactionsResponseEntity transactionsData;
  final TransactionEntity transaction;
  final VoidCallback onActionCompleted;

  const InputAllTransactionsQuantityDialog({
    super.key,
    required this.transactionsData,
    required this.transaction,
    required this.onActionCompleted,
  });

  @override
  ConsumerState<InputAllTransactionsQuantityDialog> createState() =>
      _InputAllTransactionsQuantityDialogState();
}

class _InputAllTransactionsQuantityDialogState
    extends ConsumerState<InputAllTransactionsQuantityDialog> {
  final Map<String, TextEditingController> _quantityControllers = {};
  final Map<String, _ItemInfo> _itemInfoMap = {};
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    // Collect ALL items from ALL transactions
    // Priority: offerDetails first (to ensure ALL items from offer are included),
    // then transactionDetails (to catch any additional items)
    // Group by scrapCategoryId + pricePerUnit + unit to handle different prices
    final itemMap = <String, _ItemInfo>{};

    // Step 1: Collect ALL items from offerDetails of all transactions (PRIORITY)
    // This ensures we have ALL items from the original offer
    final allOfferDetails = <String, OfferDetailEntity>{};

    for (final transaction in widget.transactionsData.transactions) {
      final offerDetails = transaction.offer?.offerDetails ?? [];

      // Collect all offerDetails with their unique keys
      for (final detail in offerDetails) {
        final key =
            '${detail.scrapCategoryId}_${detail.pricePerUnit}_${detail.unit}';
        if (!allOfferDetails.containsKey(key)) {
          allOfferDetails[key] = detail;
        }
      }
    }

    // Step 2: Add all offerDetails items FIRST (this ensures we have ALL items from offer)
    for (final entry in allOfferDetails.entries) {
      final detail = entry.value;
      final key = entry.key;

      // Get existing quantity from transaction details if available
      double? existingQuantity;
      for (final transaction in widget.transactionsData.transactions) {
        final existingDetail = transaction.transactionDetails
            .where((td) =>
                td.scrapCategoryId == detail.scrapCategoryId &&
                td.pricePerUnit == detail.pricePerUnit &&
                td.unit == detail.unit)
            .firstOrNull;
        if (existingDetail != null && existingDetail.quantity > 0) {
          existingQuantity = existingDetail.quantity;
          break;
        }
      }

      // Get type from scrapPost details
      String? itemType;
      for (final transaction in widget.transactionsData.transactions) {
        final scrapPost = transaction.offer?.scrapPost;
        if (scrapPost != null) {
          final postDetail = scrapPost.scrapPostDetails
              .where((pd) => pd.scrapCategoryId == detail.scrapCategoryId)
              .firstOrNull;
          if (postDetail != null) {
            itemType = postDetail.type;
            break;
          }
        }
      }

      itemMap[key] = _ItemInfo(
        scrapCategoryId: detail.scrapCategoryId,
        categoryName:
            detail.scrapCategory?.categoryName ?? detail.scrapCategoryId,
        pricePerUnit: detail.pricePerUnit,
        unit: detail.unit,
        imageUrl: detail.imageUrl,
        existingQuantity: existingQuantity,
        type: itemType,
        key: key,
      );
    }

    // Step 3: Also collect items from transactionDetails (to catch any items not in offerDetails)
    for (final transaction in widget.transactionsData.transactions) {
      final transactionDetails = transaction.transactionDetails;

      for (final detail in transactionDetails) {
        final key =
            '${detail.scrapCategoryId}_${detail.pricePerUnit}_${detail.unit}';

        // Only add if not already in itemMap (offerDetails takes priority)
        if (!itemMap.containsKey(key)) {
          // Get type from scrapPost details
          String? itemType;
          for (final transaction in widget.transactionsData.transactions) {
            final scrapPost = transaction.offer?.scrapPost;
            if (scrapPost != null) {
              final postDetail = scrapPost.scrapPostDetails
                  .where((pd) => pd.scrapCategoryId == detail.scrapCategoryId)
                  .firstOrNull;
              if (postDetail != null) {
                itemType = postDetail.type;
                break;
              }
            }
          }

          itemMap[key] = _ItemInfo(
            scrapCategoryId: detail.scrapCategoryId,
            categoryName: detail.scrapCategory?.name ?? detail.scrapCategoryId,
            pricePerUnit: detail.pricePerUnit,
            unit: detail.unit,
            existingQuantity: detail.quantity > 0 ? detail.quantity : null,
            type: itemType,
            key: key,
          );
        } else {
          // Update existing quantity if transactionDetails has a value
          final existingItem = itemMap[key]!;
          if (existingItem.existingQuantity == null && detail.quantity > 0) {
            itemMap[key] = _ItemInfo(
              scrapCategoryId: existingItem.scrapCategoryId,
              categoryName: existingItem.categoryName,
              pricePerUnit: existingItem.pricePerUnit,
              unit: existingItem.unit,
              imageUrl: existingItem.imageUrl,
              existingQuantity: detail.quantity,
              type: existingItem.type,
              key: existingItem.key,
            );
          }
        }
      }
    }

    // Initialize controllers
    for (final entry in itemMap.entries) {
      _itemInfoMap[entry.key] = entry.value;
      _quantityControllers[entry.key] = TextEditingController(
        text: entry.value.existingQuantity?.toString() ?? '',
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
    final details = <Map<String, dynamic>>[];

    for (final entry in _quantityControllers.entries) {
      final controller = entry.value;
      if (controller.text.isNotEmpty) {
        final quantity = double.tryParse(controller.text);
        if (quantity != null && quantity > 0) {
          final itemInfo = _itemInfoMap[entry.key];
          if (itemInfo != null) {
            details.add({
              'scrapCategoryId': itemInfo.scrapCategoryId,
              'pricePerUnit': itemInfo.pricePerUnit,
              'unit': itemInfo.unit,
              'quantity': quantity,
            });
          }
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
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(spacing)),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            spacing,
            spacing,
            spacing,
            spacing,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(bottom: spacing),
                decoration: BoxDecoration(
                  color: theme.dividerColor.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Title
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(spacing * 0.6),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(spacing * 0.8),
                    ),
                    child: Icon(
                      Icons.edit,
                      color: theme.primaryColor,
                      size: 18,
                    ),
                  ),
                  SizedBox(width: spacing),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.enter_actual_quantity,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: spacing * 0.2),
                        Text(
                          '${widget.transactionsData.transactions.length} ${s.transactions}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.hintColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing),
              // Info banner
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(spacing),
                decoration: BoxDecoration(
                  color: AppColors.warningUpdate.withValues(alpha: 0.08),
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
                    SizedBox(width: spacing * 0.7),
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
              // Items list
              Flexible(
                child: _itemInfoMap.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(spacing * 2),
                          child: Text(
                            s.no_scrap_items_to_input,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.hintColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : Form(
                        key: _formKey,
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(bottom: spacing),
                          itemCount: _itemInfoMap.values.length,
                          itemBuilder: (context, index) {
                            final itemInfo =
                                _itemInfoMap.values.elementAt(index);
                            final controller =
                                _quantityControllers[itemInfo.key];
                            if (controller == null) {
                              return const SizedBox.shrink();
                            }

                            return Padding(
                              padding: EdgeInsets.only(bottom: spacing),
                              child: Container(
                                padding: EdgeInsets.all(spacing),
                                decoration: BoxDecoration(
                                  color: theme.scaffoldBackgroundColor,
                                  borderRadius:
                                      BorderRadius.circular(spacing / 2),
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
                                          child: itemInfo.imageUrl != null &&
                                                  itemInfo.imageUrl!.isNotEmpty
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(spacing / 2),
                                                  child: Image.network(
                                                    itemInfo.imageUrl!,
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
                                            itemInfo.categoryName,
                                            style: theme.textTheme.titleSmall?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),

                                        // Type badge
                                        if (itemInfo.type != null &&
                                            itemInfo.type!.isNotEmpty)
                                          Padding(
                                            padding: EdgeInsets.only(left: spacing / 2),
                                            child: TypeBadge(type: itemInfo.type!),
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
                                              itemInfo.pricePerUnit.toStringAsFixed(0),
                                              s.per_unit,
                                              itemInfo.unit,
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
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      decoration: InputDecoration(
                                        hintText: s.enter_actual_quantity_hint,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            spacing / 2,
                                          ),
                                        ),
                                        suffixText: itemInfo.unit,
                                        filled: true,
                                        fillColor: theme.cardColor,
                                      ),
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
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
                          },
                        ),
                      ),
              ),
              SizedBox(height: spacing),
              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed:
                          _isLoading ? null : () => Navigator.of(context).pop(),
                      child: Text(s.cancel),
                    ),
                  ),
                  SizedBox(width: spacing),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              // Validate all form fields first
                              if (!_formKey.currentState!.validate()) {
                                // Validation failed, errors will be shown under each field
                                return;
                              }

                              // Get all items that user has entered quantity for
                              final detailsMap = _getDetails();

                              // Check if at least one item has quantity
                              if (detailsMap.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(s.enter_at_least_one_item_toast),
                                    backgroundColor: AppColors.danger,
                                  ),
                                );
                                return;
                              }

                              // Convert to TransactionDetailRequest list
                              final details = detailsMap.map((item) {
                                return TransactionDetailRequest(
                                  scrapCategoryId: item['scrapCategoryId'] as String,
                                  pricePerUnit: item['pricePerUnit'] as double,
                                  unit: item['unit'] as String,
                                  quantity: item['quantity'] as double,
                                );
                              }).toList();

                              // Get scrapPostId and slotId from transaction
                              // Note: API endpoint is shared for all transactions in the same scrapPost and slot
                              final scrapPostId = widget.transaction.offer?.scrapPostId ?? '';
                              final slotId =
                                  widget.transaction.timeSlotId ?? widget.transaction.offer?.timeSlotId ?? '';

                              if (scrapPostId.isEmpty || slotId.isEmpty) {
                                CustomToast.show(
                                  context,
                                  s.operation_failed,
                                  type: ToastType.error,
                                );
                                return;
                              }

                              // API endpoint /v1/transactions/details?scrapPostId=...&slotId=...
                              // is a shared endpoint for ALL transactions in the same scrapPost and slot
                              // So we need to send ALL items in ONE request, not split by transaction
                              // Use the first transaction's ID for refresh
                              final firstTransactionId =
                                  widget.transactionsData.transactions.first.transactionId;

                              // Set loading state
                              setState(() {
                                _isLoading = true;
                              });

                              try {
                                final success = await ref
                                    .read(transactionViewModelProvider.notifier)
                                    .updateTransactionDetails(
                                      scrapPostId: scrapPostId,
                                      slotId: slotId,
                                      transactionId: firstTransactionId,
                                      details: details, // Send ALL items in one request
                                    );

                                if (!mounted) return;

                                setState(() {
                                  _isLoading = false;
                                });

                                if (success) {
                                  CustomToast.show(
                                    context,
                                    s.quantity_updated_successfully,
                                    type: ToastType.success,
                                  );

                                  // Notify parent to refresh detail page
                                  widget.onActionCompleted();
                                  // Close the bottom sheet/dialog
                                  Navigator.of(context).pop();
                                } else {
                                  final state = ref.read(transactionViewModelProvider);
                                  final errorMsg = state.errorMessage;

                                  if (errorMsg != null &&
                                      (errorMsg.contains('Check-in') ||
                                          errorMsg.contains('check-in') ||
                                          errorMsg.contains('chưa Check-in'))) {
                                    CustomToast.show(
                                      context,
                                      s.check_in_first_error,
                                      type: ToastType.error,
                                    );
                                  } else if (errorMsg != null &&
                                      (errorMsg.contains('loại ve chai') ||
                                          errorMsg.contains('scrap category'))) {
                                    CustomToast.show(
                                      context,
                                      s.invalid_scrap_category_error,
                                      type: ToastType.error,
                                    );
                                  } else {
                                    CustomToast.show(
                                      context,
                                      s.operation_failed,
                                      type: ToastType.error,
                                    );
                                  }
                                }
                              } catch (e) {
                                if (mounted) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  CustomToast.show(context, s.operation_failed, type: ToastType.error);
                                }
                              }
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemInfo {
  final String scrapCategoryId;
  final String categoryName;
  final double pricePerUnit;
  final String unit;
  final String? imageUrl;
  final double? existingQuantity;
  final String? type; // Type from scrapPost detail (sale/donation/service)
  final String key; // Store the key for controller lookup

  _ItemInfo({
    required this.scrapCategoryId,
    required this.categoryName,
    required this.pricePerUnit,
    required this.unit,
    this.imageUrl,
    this.existingQuantity,
    this.type,
    required this.key,
  });
}
