import 'package:GreenConnectMobile/core/enum/offer_status.dart';
import 'package:GreenConnectMobile/core/enum/role.dart';
import 'package:GreenConnectMobile/core/enum/scrap_post_detail_type.dart';
import 'package:GreenConnectMobile/features/offer/domain/entities/offer_detail_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/type_badge.dart';
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
  final Role? userRole;
  final ScrapPostEntity? scrapPost;
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
    this.userRole,
    this.scrapPost,
    this.onUpdate,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###', 'vi_VN');
    double totalEstimated = 0;
    for (final detail in offerDetails) {
      // Get the type from scrapPost details
      ScrapPostDetailType? detailType;
      final post = scrapPost;
      if (post != null && post.scrapPostDetails.isNotEmpty) {
        final postDetail = post.scrapPostDetails.firstWhere(
          (pd) => pd.scrapCategoryId == detail.scrapCategoryId,
          orElse: () => post.scrapPostDetails.first,
        );
        detailType = ScrapPostDetailType.parseType(postDetail.type);
      }

      // For service type, subtract from total (household pays collector)
      // For sale and donation, add to total
      if (detailType == ScrapPostDetailType.service) {
        totalEstimated -= detail.pricePerUnit;
      } else {
        totalEstimated += detail.pricePerUnit;
      }
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
                        // Get the type from scrapPost details
                        ScrapPostDetailType? detailType;
                        final post = scrapPost;
                        if (post != null && post.scrapPostDetails.isNotEmpty) {
                          final postDetail = post.scrapPostDetails.firstWhere(
                            (pd) =>
                                pd.scrapCategoryId == detail.scrapCategoryId,
                            orElse: () => post.scrapPostDetails.first,
                          );
                          detailType =
                              ScrapPostDetailType.parseType(postDetail.type);
                        }

                        // Only allow edit/delete for collector users (not household)
                        final isCollector =
                            userRole != null && userRole != Role.household;
                        final isDonation =
                            detailType == ScrapPostDetailType.donation;
                        final canEdit = isCollector &&
                            offerStatus != null &&
                            offerStatus != OfferStatus.accepted &&
                            !isDonation; // Don't allow edit for donation
                        final canDelete = canEdit &&
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
                                onTap: detail.imageUrl != null &&
                                        detail.imageUrl!.isNotEmpty
                                    ? () => _showFullImage(
                                          context,
                                          detail.imageUrl!,
                                        )
                                    : null,
                                child: Container(
                                  width: spacing * 5,
                                  height: spacing * 5,
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
                                    child: detail.imageUrl != null &&
                                            detail.imageUrl!.isNotEmpty
                                        ? Image.network(
                                            detail.imageUrl!,
                                            width: 40,
                                            height: 40,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Center(
                                                child: SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: theme.primaryColor,
                                                    value: loadingProgress
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
                                            errorBuilder: (_, __, ___) =>
                                                Image.asset(
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
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: spacing / 4),
                                    Text(
                                      detail.unit,
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color: theme.textTheme.bodySmall?.color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Type badge and Price (aligned to the right)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // Type badge
                                  if (detailType != null) ...[
                                    TypeBadge(type: detailType.name),
                                    SizedBox(height: spacing / 4),
                                  ],
                                  // Price comparison: Collector's offer vs System reference
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      // Collector's suggested price (pricePerUnit)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          // Price value
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                '${numberFormat.format(detail.pricePerUnit)} ${s.per_unit} ',
                                                style: theme
                                                    .textTheme.titleMedium
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: theme.primaryColor,
                                                ),
                                              ),
                                              Text(
                                                '/${detail.unit}',
                                                style: theme.textTheme.bodySmall
                                                    ?.copyWith(
                                                  color: theme.textTheme
                                                      .bodySmall?.color,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      // System reference price (pricePerKg) - if available
                                      if (detail.pricePerKg != null &&
                                          detail.pricePerKg! > 0)
                                        Padding(
                                          padding:
                                              EdgeInsets.only(top: spacing / 4),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: spacing / 3,
                                              vertical: spacing / 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: theme.canvasColor,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                spacing / 4,
                                              ),
                                              border: Border.all(
                                                color: theme.colorScheme
                                                    .onSurfaceVariant
                                                    .withValues(alpha: 0.2),
                                                width: 1,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.info_outline,
                                                  size: 12,
                                                  color: theme.colorScheme
                                                      .onSurfaceVariant,
                                                ),
                                                SizedBox(width: spacing / 6),
                                                Flexible(
                                                  child: Text(
                                                    '${s.system_reference_price}: ${numberFormat.format(detail.pricePerKg!)} ${s.per_unit}/kg',
                                                    style: theme
                                                        .textTheme.bodySmall
                                                        ?.copyWith(
                                                      color: theme.colorScheme
                                                          .onSurfaceVariant,
                                                      fontSize: 11,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                    textAlign: TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                    ],
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
                                    totalEstimated > 0 ? s.total_will_receive : s.total_will_pay,  

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
                              '${numberFormat.format(totalEstimated.abs())} ${s.per_unit}',
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

    // Get the type from scrapPost details
    ScrapPostDetailType? detailType;
    final post = scrapPost;
    if (post != null && post.scrapPostDetails.isNotEmpty) {
      final postDetail = post.scrapPostDetails.firstWhere(
        (pd) => pd.scrapCategoryId == detail.scrapCategoryId,
        orElse: () => post.scrapPostDetails.first,
      );
      detailType = ScrapPostDetailType.parseType(postDetail.type);
    }

    final priceController = TextEditingController(
      text: detail.pricePerUnit.toString(),
    );
    final unitController = TextEditingController(text: detail.unit);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
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
                        onTap: detail.imageUrl != null &&
                                detail.imageUrl!.isNotEmpty
                            ? () => _showFullImage(context, detail.imageUrl!)
                            : null,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(spacing / 2),
                          child: detail.imageUrl != null &&
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
                  enabled: detailType != ScrapPostDetailType.donation,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(spacing / 2),
                    ),
                    hintText: detailType == ScrapPostDetailType.donation
                        ? '0 (Donation)'
                        : null,
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
                DropdownButtonFormField<String>(
                  initialValue: unitController.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(spacing / 2),
                    ),
                  ),
                  items: [
                    DropdownMenuItem(value: s.kg, child: Text(s.kg)),
                    DropdownMenuItem(value: s.g, child: Text(s.g)),
                    DropdownMenuItem(value: s.ton, child: Text(s.ton)),
                    DropdownMenuItem(value: s.piece, child: Text(s.piece)),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() {
                        unitController.text = value;
                      });
                    }
                  },
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

                // Validation based on type
                if (detailType == ScrapPostDetailType.donation) {
                  // For donation, always set price to 0
                  onUpdate!(detail.offerDetailId, 0.0, unit);
                  Navigator.pop(dialogContext);
                  return;
                }

                // For sale and service, price must be > 0
                if (price == null || price <= 0) {
                  if (detailType == ScrapPostDetailType.sale ||
                      detailType == ScrapPostDetailType.service) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                        SnackBar(content: Text(s.please_enter_price)));
                    return;
                  }
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
      barrierColor: theme.colorScheme.onSurface.withValues(alpha: 0.5),
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
                            color: theme.scaffoldBackgroundColor,
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
                            style:
                                TextStyle(color: theme.scaffoldBackgroundColor),
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
                          color: theme.scaffoldBackgroundColor,
                          size: 48,
                        ),
                        SizedBox(height: spacing),
                        Text(
                          'Cannot load image',
                          style:
                              TextStyle(color: theme.scaffoldBackgroundColor),
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
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child:
                      Icon(Icons.close, color: theme.scaffoldBackgroundColor),
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
