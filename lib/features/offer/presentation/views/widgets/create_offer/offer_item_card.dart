import 'package:GreenConnectMobile/core/enum/scrap_post_detail_type.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class OfferItemCard extends StatelessWidget {
  final String categoryName;
  final String amountDescription;
  final String? imageUrl;
  final bool isSelected;
  final bool canToggle;
  final double totalPrice;
  final String unit;
  final ScrapPostDetailType detailType;
  final VoidCallback onToggle;
  final ValueChanged<double> onPriceChanged;
  final ValueChanged<String> onUnitChanged;

  const OfferItemCard({
    super.key,
    required this.categoryName,
    required this.amountDescription,
    this.imageUrl,
    required this.isSelected,
    required this.canToggle,
    required this.totalPrice,
    required this.unit,
    required this.detailType,
    required this.onToggle,
    required this.onPriceChanged,
    required this.onUnitChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final space = theme.extension<AppSpacing>()!.screenPadding;

    return Container(
      margin: EdgeInsets.only(bottom: space),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected
              ? theme.primaryColor
              : theme.dividerColor.withValues(alpha: 0.5),
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(space),
        color: isSelected
            ? theme.primaryColor.withValues(alpha: 0.05)
            : theme.cardColor,
      ),
      child: Column(
        children: [
          InkWell(
            onTap: canToggle ? onToggle : null,
            borderRadius: BorderRadius.circular(space),
            child: Padding(
              padding: EdgeInsets.all(space),
              child: Row(
                children: [
                  _buildImage(context, theme, space),
                  SizedBox(width: space),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          categoryName,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: space * 0.25),
                        Text(
                          amountDescription,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.hintColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildSelectionIndicator(theme),
                ],
              ),
            ),
          ),
          if (isSelected) ...[
            const Divider(height: 1),
            Padding(
              padding: EdgeInsets.all(space),
              child: _buildPricingSection(context, theme, space),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context, ThemeData theme, double space) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(space * 0.5),
        child: Image.network(
          imageUrl!,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            width: 60,
            height: 60,
            color: theme.primaryColor.withValues(alpha: 0.1),
            child: Icon(
              Icons.image_not_supported,
              color: theme.hintColor,
            ),
          ),
        ),
      );
    }

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: theme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(space * 0.5),
      ),
      child: Icon(
        Icons.recycling_rounded,
        color: theme.primaryColor,
      ),
    );
  }

  Widget _buildSelectionIndicator(ThemeData theme) {
    if (canToggle) {
      return Checkbox(
        value: isSelected,
        onChanged: (_) => onToggle(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      );
    }

    return Icon(Icons.check_circle_rounded, color: theme.primaryColor);
  }

  Widget _buildPricingSection(
      BuildContext context, ThemeData theme, double space) {
    // Handle different types
    switch (detailType) {
      case ScrapPostDetailType.donation:
        return _buildDonationSection(context, theme, space);
      case ScrapPostDetailType.service:
        return _buildServicePricingForm(context, theme, space);
      case ScrapPostDetailType.sale:
        return _buildSalePricingForm(context, theme, space);
    }
  }

  Widget _buildDonationSection(
      BuildContext context, ThemeData theme, double space) {
    final s = S.of(context)!;

    return Container(
      padding: EdgeInsets.all(space),
      decoration: BoxDecoration(
        color: theme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(space * 0.75),
        border: Border.all(
          color: theme.primaryColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.card_giftcard_rounded,
            color: theme.primaryColor,
            size: 24,
          ),
          SizedBox(width: space * 0.75),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.price_label_donation,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
                SizedBox(height: space * 0.25),
                Text(
                  s.donation_info_text,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalePricingForm(
      BuildContext context, ThemeData theme, double space) {
    final s = S.of(context)!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                s.price_label_sale,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.hintColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: space * 0.5),
              TextFormField(
                key: ValueKey('sale_price_$categoryName'),
                initialValue: totalPrice == 0.0 ? '' : totalPrice.toString(),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '0',
                  prefixText: 'VND ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(space * 0.75),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: space,
                    vertical: space * 0.75,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return s.please_enter_price;
                  }
                  if (double.tryParse(value) == null) {
                    return s.invalid_price;
                  }
                  final price = double.tryParse(value)!;
                  if (price <= 0) {
                    return s.price_must_be_greater_than_zero;
                  }
                  return null;
                },
                onChanged: (value) {
                  final price = double.tryParse(value) ?? 0.0;
                  onPriceChanged(price);
                },
              ),
            ],
          ),
        ),
        SizedBox(width: space * 0.75),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                s.unit,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.hintColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: space * 0.5),
              DropdownButtonFormField<String>(
                value: unit,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(space * 0.75),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: space,
                    vertical: space * 0.75,
                  ),
                ),
                items: [
                  DropdownMenuItem(value: s.kg, child: Text(s.kg)),
                  DropdownMenuItem(value: s.g, child: Text(s.g)),
                  DropdownMenuItem(value: s.ton, child: Text(s.ton)),
                  DropdownMenuItem(value: s.piece, child: Text(s.piece)),
                ],
                onChanged: (value) {
                  if (value != null) onUnitChanged(value);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServicePricingForm(
      BuildContext context, ThemeData theme, double space) {
    final s = S.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Info text
        Container(
          padding: EdgeInsets.all(space * 0.75),
          margin: EdgeInsets.only(bottom: space),
          decoration: BoxDecoration(
            color: AppColors.info.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(space * 0.75),
            border: Border.all(
              color: AppColors.info.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: AppColors.info,
                size: 20,
              ),
              SizedBox(width: space * 0.5),
              Expanded(
                child: Text(
                  s.service_info_text,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.info,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Price form
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.price_label_service,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: space * 0.5),
                  TextFormField(
                    key: ValueKey('service_price_$categoryName'),
                    initialValue:
                        totalPrice == 0.0 ? '' : totalPrice.toString(),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '0',
                      prefixText: 'VND ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(space * 0.75),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: space,
                        vertical: space * 0.75,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return s.please_enter_price;
                      }
                      if (double.tryParse(value) == null) {
                        return s.invalid_price;
                      }
                      final price = double.tryParse(value)!;
                      if (price <= 0) {
                        return s.price_must_be_greater_than_zero;
                      }
                      return null;
                    },
                    onChanged: (value) {
                      final price = double.tryParse(value) ?? 0.0;
                      onPriceChanged(price);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(width: space * 0.75),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.unit,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: space * 0.5),
                  DropdownButtonFormField<String>(
                    value: unit,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(space * 0.75),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: space,
                        vertical: space * 0.75,
                      ),
                    ),
                    items: [
                      DropdownMenuItem(value: s.kg, child: Text(s.kg)),
                      DropdownMenuItem(value: s.g, child: Text(s.g)),
                      DropdownMenuItem(value: s.ton, child: Text(s.ton)),
                      DropdownMenuItem(value: s.piece, child: Text(s.piece)),
                    ],
                    onChanged: (value) {
                      if (value != null) onUnitChanged(value);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
