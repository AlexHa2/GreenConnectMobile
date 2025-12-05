import 'package:GreenConnectMobile/generated/l10n.dart';
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
              child: _buildPricingForm(context, theme, space),
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
          errorBuilder: (_, _, _) => Container(
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

  Widget _buildPricingForm(BuildContext context, ThemeData theme, double space) {
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
                s.price_per_unit,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.hintColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: space * 0.5),
              TextFormField(
                initialValue: totalPrice.toString(),
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
                initialValue: unit,
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
}
