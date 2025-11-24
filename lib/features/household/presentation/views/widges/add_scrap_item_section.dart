import 'dart:io';

import 'package:GreenConnectMobile/features/household/domain/entities/scrap_category_entity.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/dashed_border_container.dart';
import 'package:flutter/material.dart';

class AddScrapItemSection extends StatelessWidget {
  final int? selectedCategoryId;
  final List<ScrapCategoryEntity> categories;
  final TextEditingController quantityController;
  final TextEditingController weightController;
  final File? image;
  final VoidCallback onPickImage;
  final Function(int?) onCategoryChange;
  final VoidCallback onAddItem;
  final GlobalKey<FormState> itemFormKey;

  const AddScrapItemSection({
    super.key,
    this.selectedCategoryId,
    required this.categories,
    required this.quantityController,
    required this.weightController,
    this.image,
    required this.onPickImage,
    required this.onCategoryChange,
    required this.onAddItem,
    required this.itemFormKey,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(spacing.screenPadding * 2),
        child: Form(
          key: itemFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context)!.category,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: spacing.screenPadding / 2),
              DropdownButtonFormField<int>(
                initialValue: selectedCategoryId,
                decoration: InputDecoration(hintText: S.of(context)!.category),
                items: categories
                    .map(
                      (item) => DropdownMenuItem(
                        value: item.scrapCategoryId,
                        child: Text(item.categoryName),
                      ),
                    )
                    .toList(),
                onChanged: onCategoryChange,
                validator: (value) =>
                    value == null ? S.of(context)!.error_select_category : null,
              ),

              SizedBox(height: spacing.screenPadding),
              Row(
                children: [
                  Expanded(
                    child: _buildNumberField(
                      context,
                      label: S.of(context)!.quantity,
                      controller: quantityController,
                      unit: "",
                    ),
                  ),
                  SizedBox(width: spacing.screenPadding),
                  Expanded(
                    child: _buildNumberField(
                      context,
                      label: S.of(context)!.weight,
                      controller: weightController,
                      unit: "kg",
                    ),
                  ),
                ],
              ),

              SizedBox(height: spacing.screenPadding),
              Text(
                "${S.of(context)!.update} ${S.of(context)!.image}",
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: spacing.screenPadding / 2),
              GestureDetector(
                onTap: onPickImage,
                child: DashedBorderContainer(
                  color: theme.primaryColor,
                  padding: EdgeInsets.all(spacing.screenPadding * 2),
                  child: Center(child: Text(S.of(context)!.upload)),
                ),
              ),

              if (image != null) ...[
                SizedBox(height: spacing.screenPadding),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(image!, height: 150, fit: BoxFit.cover),
                ),
              ],

              SizedBox(height: spacing.screenPadding),
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  onPressed: onAddItem,
                  child: Text(S.of(context)!.add),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberField(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    required String unit,
  }) {
    final theme = Theme.of(context);
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: spacing.screenPadding / 2),

        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return S.of(context)!.error_required;
                  }
                  final num? val = num.tryParse(v);
                  if (val == null || val <= 0) {
                    return S.of(context)!.error_invalid_number;
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
