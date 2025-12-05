import 'package:GreenConnectMobile/core/enum/offer_status.dart';
import 'package:GreenConnectMobile/features/offer/domain/entities/offer_detail_entity.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class PricingInfoSection extends StatelessWidget {
  final List<OfferDetailEntity> offerDetails;
  final ThemeData theme;
  final double spacing;
  final S s;
  final OfferStatus? offerStatus;
  final bool? mustTakeAll;
  final Function(String detailId, double price, String unit)? onUpdate;
  final Function(String detailId)? onDelete;

  const PricingInfoSection({
    super.key,
    required this.offerDetails,
    required this.theme,
    required this.spacing,
    required this.s,
    this.offerStatus,
    this.mustTakeAll,
    this.onUpdate,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###', 'vi_VN');
    double totalEstimated = 0;
    for (final detail in offerDetails) {
      totalEstimated += detail.pricePerUnit;
    }
    final s = S.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(spacing),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(spacing),
            child: Row(
              children: [
                Icon(
                  Icons.attach_money_outlined,
                  color: theme.primaryColor,
                  size: 24,
                ),
                SizedBox(width: spacing / 2),
                Text(
                  s.pricing_information,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: theme.dividerColor),

          // Content
          Padding(
            padding: EdgeInsets.all(spacing),
            child: offerDetails.isEmpty
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(spacing),
                      child: Text(
                        s.no_pricing_info,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodySmall?.color,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  )
                : Column(
                    children: [
                      // Pricing items
                      ...offerDetails.map((detail) {
                        final canEdit =
                            offerStatus != null &&
                            offerStatus != OfferStatus.accepted;
                        final canDelete =
                            canEdit &&
                            (mustTakeAll == null || mustTakeAll == false) &&
                            offerDetails.length >
                                1; // Can't delete if only 1 item left

                        return Container(
                          margin: EdgeInsets.only(bottom: spacing * 0.75),
                          padding: EdgeInsets.all(spacing * 0.75),
                          decoration: BoxDecoration(
                            color: theme.scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(spacing / 2),
                            border: Border.all(
                              color: theme.dividerColor,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              // Category icon
                              GestureDetector(
                                onTap:
                                    detail.imageUrl != null &&
                                        detail.imageUrl!.isNotEmpty
                                    ? () => _showFullImage(
                                        context,
                                        detail.imageUrl!,
                                      )
                                    : null,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: theme.primaryColor.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      spacing / 2,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      spacing / 2,
                                    ),
                                    child:
                                        detail.imageUrl != null &&
                                            detail.imageUrl!.isNotEmpty
                                        ? Image.network(
                                            detail.imageUrl!,
                                            width: 40,
                                            height: 40,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child, loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Center(
                                                child: SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: theme.primaryColor,
                                                    value:
                                                        loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                  .cumulativeBytesLoaded /
                                                              loadingProgress
                                                                  .expectedTotalBytes!
                                                        : null,
                                                  ),
                                                ),
                                              );
                                            },
                                            errorBuilder: (_, _, _) => Image.asset(
                                              'assets/images/green_connect_logo.png',
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Image.asset(
                                            'assets/images/green_connect_logo.png',
                                            width: 40,
                                            height: 40,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                              ),
                              SizedBox(width: spacing),
                              // Category info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      detail.scrapCategory!.categoryName,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    SizedBox(height: spacing / 4),
                                    Text(
                                      detail.unit,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: theme
                                                .textTheme
                                                .bodySmall
                                                ?.color,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              // Price and Unit
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${numberFormat.format(detail.pricePerUnit)} ${s.per_unit} ',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: theme.primaryColor,
                                        ),
                                  ),
                                  // SizedBox(height: spacing / 4),
                                  Text(
                                    '/${detail.unit}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.textTheme.bodySmall?.color,
                                    ),
                                  ),
                                ],
                              ),
                              // Action buttons
                              if (canEdit || canDelete) ...[
                                SizedBox(width: spacing / 2),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (canEdit)
                                      InkWell(
                                        onTap: () =>
                                            _showUpdateDialog(context, detail),
                                        borderRadius: BorderRadius.circular(
                                          spacing / 2,
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.all(spacing / 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.warning.withValues(
                                              alpha: 0.1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              spacing / 2,
                                            ),
                                            border: Border.all(
                                              color: AppColors.warning
                                                  .withValues(alpha: 0.3),
                                              width: 1,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.edit_outlined,
                                            size: 18,
                                            color: AppColors.warning,
                                          ),
                                        ),
                                      ),
                                    if (canEdit && canDelete)
                                      SizedBox(width: spacing / 3),
                                    if (canDelete)
                                      InkWell(
                                        onTap: () =>
                                            _showDeleteDialog(context, detail),
                                        borderRadius: BorderRadius.circular(
                                          spacing / 2,
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.all(spacing / 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.danger.withValues(
                                              alpha: 0.1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              spacing / 2,
                                            ),
                                            border: Border.all(
                                              color: AppColors.danger
                                                  .withValues(alpha: 0.3),
                                              width: 1,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.delete_outline,
                                            size: 18,
                                            color: AppColors.danger,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        );
                      }),

                      // Total
                      Container(
                        padding: EdgeInsets.all(spacing),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.primaryColor.withValues(alpha: 0.1),
                              theme.primaryColor.withValues(alpha: 0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(spacing / 2),
                          border: Border.all(
                            color: theme.primaryColor.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calculate_rounded,
                              color: theme.primaryColor,
                              size: 20,
                            ),
                            SizedBox(width: spacing),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    s.total_amount,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  // SizedBox(height: spacing / 4),
                                  // Text(
                                  //   s.estimated_total(
                                  //     numberFormat.format(totalEstimated),
                                  //   ),
                                  //   style: theme.textTheme.bodySmall?.copyWith(
                                  //     color: theme.textTheme.bodySmall?.color,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            Text(
                              '${numberFormat.format(totalEstimated)} ${s.per_unit}',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  void _showUpdateDialog(BuildContext context, OfferDetailEntity detail) {
    if (onUpdate == null) return;

    final priceController = TextEditingController(
      text: detail.pricePerUnit.toString(),
    );
    final unitController = TextEditingController(text: detail.unit);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(spacing / 2),
        ),
        title: Row(
          children: [
            Icon(Icons.edit_outlined, color: theme.primaryColor),
            SizedBox(width: spacing / 2),
            Expanded(
              child: Text(
                s.update_pricing,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category name (readonly)
              Container(
                padding: EdgeInsets.all(spacing),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(spacing / 2),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap:
                          detail.imageUrl != null && detail.imageUrl!.isNotEmpty
                          ? () => _showFullImage(context, detail.imageUrl!)
                          : null,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(spacing / 2),
                        child:
                            detail.imageUrl != null &&
                                detail.imageUrl!.isNotEmpty
                            ? Image.network(
                                detail.imageUrl!,
                                width: 20,
                                height: 20,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: Center(
                                          child: SizedBox(
                                            width: 12,
                                            height: 12,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 1.5,
                                              color: theme.primaryColor,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                errorBuilder: (_, __, ___) => Image.asset(
                                  'assets/images/green_connect_logo.png',
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Image.asset(
                                'assets/images/green_connect_logo.png',
                                width: 20,
                                height: 20,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    SizedBox(width: spacing / 2),
                    Expanded(
                      child: Text(
                        detail.scrapCategory!.categoryName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: spacing),
              Text(s.price_per_unit, style: theme.textTheme.bodyMedium),
              SizedBox(height: spacing / 2),
              // Price input
              TextField(
                controller: priceController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(spacing / 2),
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
              ),
              SizedBox(height: spacing),
              // Unit input
              Text(s.unit, style: theme.textTheme.bodyMedium),
              SizedBox(height: spacing / 2),
              TextField(
                controller: unitController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(spacing / 2),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(s.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final price = double.tryParse(priceController.text);
              final unit = unitController.text.trim();

              if (price == null || price <= 0) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(s.invalid_price)));
                return;
              }

              if (unit.isEmpty) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(s.unit_is_required)));
                return;
              }

              onUpdate!(detail.offerDetailId, price, unit);
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warningUpdate,
              foregroundColor: theme.scaffoldBackgroundColor,
            ),
            child: Text(s.update),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, OfferDetailEntity detail) {
    if (onDelete == null) return;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.danger),
            SizedBox(width: spacing / 2),
            Expanded(
              child: Text(
                s.confirm_delete,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(s.are_you_sure_delete_pricing),
            SizedBox(height: spacing),
            Container(
              padding: EdgeInsets.all(spacing * 0.75),
              decoration: BoxDecoration(
                color: AppColors.danger.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(spacing / 2),
                border: Border.all(
                  color: AppColors.danger.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap:
                        detail.imageUrl != null && detail.imageUrl!.isNotEmpty
                        ? () => _showFullImage(context, detail.imageUrl!)
                        : null,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(spacing / 4),
                      child:
                          detail.imageUrl != null && detail.imageUrl!.isNotEmpty
                          ? Image.network(
                              detail.imageUrl!,
                              width: 20,
                              height: 20,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: Center(
                                        child: SizedBox(
                                          width: 12,
                                          height: 12,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 1.5,
                                            color: theme.primaryColor,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                              errorBuilder: (_, __, ___) => Image.asset(
                                'assets/images/green_connect_logo.png',
                                width: 20,
                                height: 20,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              'assets/images/green_connect_logo.png',
                              width: 20,
                              height: 20,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  SizedBox(width: spacing / 2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          detail.scrapCategory!.categoryName,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: spacing / 4),
                        Text(
                          '${detail.pricePerUnit} ${detail.unit}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.danger,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(s.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              onDelete!(detail.offerDetailId);
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: theme.scaffoldBackgroundColor,
            ),
            child: Text(s.delete),
          ),
        ],
      ),
    );
  }

  void _showFullImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(spacing),
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            color: Colors.white,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                          SizedBox(height: spacing),
                          Text(
                            loadingProgress.expectedTotalBytes != null
                                ? '${(loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! * 100).toStringAsFixed(0)}%'
                                : 'Loading...',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.white,
                          size: 48,
                        ),
                        SizedBox(height: spacing),
                        Text(
                          'Cannot load image',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: Container(
                  padding: EdgeInsets.all(spacing / 2),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, color: Colors.white),
                ),
                onPressed: () => Navigator.pop(dialogContext),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
