import 'dart:io';

import 'package:GreenConnectMobile/core/enum/scrap_post_detail_type.dart';
import 'package:GreenConnectMobile/core/helper/scrap_post_detail_type_helper.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_category_entity.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/amount_description_field.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/dashed_border_container.dart';
import 'package:flutter/material.dart';

class AddScrapItemSection extends StatelessWidget {
  final String? selectedCategoryId;
  final List<ScrapCategoryEntity> categories;
  final TextEditingController amountDescriptionController;
  final String? aiSuggestedDescription;
  final ScrapPostDetailType? selectedType;
  final Function(ScrapPostDetailType?) onTypeChange;
  final File? image;
  final String? recognizedImageUrl;
  final VoidCallback onPickImage;
  final Function(String?) onCategoryChange;
  final VoidCallback onAddItem;
  final GlobalKey<FormState> itemFormKey;
  final bool isAnalyzing;
  final VoidCallback? onAcceptAISuggestion;
  final VoidCallback? onRejectAISuggestion;

  const AddScrapItemSection({
    super.key,
    this.selectedCategoryId,
    required this.categories,
    required this.amountDescriptionController,
    this.aiSuggestedDescription,
    this.selectedType,
    required this.onTypeChange,
    this.image,
    this.recognizedImageUrl,
    required this.onPickImage,
    required this.onCategoryChange,
    required this.onAddItem,
    required this.itemFormKey,
    this.isAnalyzing = false,
    this.onAcceptAISuggestion,
    this.onRejectAISuggestion,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    // final s = S.of(context)!;

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
              DropdownButtonFormField<String>(
                initialValue: selectedCategoryId,
                decoration: InputDecoration(
                  hintText: S.of(context)!.category,
                  helperText: S.of(context)!.ai_will_auto_recognize,
                  helperStyle: TextStyle(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    color: theme.disabledColor,
                  ),
                ),
                items: categories
                    .map(
                      (item) => DropdownMenuItem<String>(
                        value: item.scrapCategoryId,
                        child: Text(item.categoryName),
                      ),
                    )
                    .toList(),
                onChanged: onCategoryChange,
                validator: (value) => value == null
                    ? S.of(context)!.please_select_category
                    : null,
              ),

              SizedBox(height: spacing.screenPadding * 1.5),

              // Type Dropdown
              SizedBox(height: spacing.screenPadding * 1.5),
              Text(
                'Loại hình',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: spacing.screenPadding / 2),
              DropdownButtonFormField<ScrapPostDetailType>(
                initialValue: selectedType,
                decoration: InputDecoration(
                  hintText: S.of(context)!.scrap_type_hint,
                ),
                items: ScrapPostDetailType.values
                    .map((type) => DropdownMenuItem<ScrapPostDetailType>(
                          value: type,
                          child: Text(
                              ScrapPostDetailTypeHelper.getLocalizedType(
                                  context, type,),),
                        ),)
                    .toList(),
                onChanged: onTypeChange,
                validator: (value) =>
                    value == null ? S.of(context)!.scrap_type_required : null,
              ),

              AmountDescriptionField(
                controller: amountDescriptionController,
                aiSuggestion: aiSuggestedDescription,
                isAIAnalyzing: isAnalyzing,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return S.of(context)!.please_enter_description;
                  }
                  if (value.trim().length < 5) {
                    return S.of(context)!.description_too_short;
                  }
                  return null;
                },
              ),

              SizedBox(height: spacing.screenPadding * 1.5),
              Text(
                "${S.of(context)!.update} ${S.of(context)!.image}",
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: spacing.screenPadding / 2),

              if (image == null && recognizedImageUrl == null)
                GestureDetector(
                  onTap: onPickImage,
                  child: SizedBox(
                    width: double.infinity,
                    child: DashedBorderContainer(
                      color: theme.primaryColor,
                      padding: EdgeInsets.all(spacing.screenPadding * 2),
                      child: Column(
                        children: [
                          Icon(
                            Icons.cloud_upload_outlined,
                            size: 48,
                            color: theme.primaryColor,
                          ),
                          SizedBox(height: spacing.screenPadding / 2),
                          Text(
                            S.of(context)!.upload,
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: spacing.screenPadding / 3),
                          Text(
                            S.of(context)!.ai_will_auto_analyze,
                            style: TextStyle(
                              fontSize: 11,
                              color: theme.disabledColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              if (image != null || recognizedImageUrl != null) ...[
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: image != null
                          ? Image.file(
                              image!,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              recognizedImageUrl!,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  height: 200,
                                  width: double.infinity,
                                  color: theme.dividerColor.withValues(
                                    alpha: 0.2,
                                  ),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
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
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 200,
                                  width: double.infinity,
                                  color: theme.dividerColor.withValues(
                                    alpha: 0.2,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.broken_image,
                                        size: 48,
                                        color: theme.disabledColor,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Failed to load image',
                                        style: TextStyle(
                                          color: theme.disabledColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: onPickImage,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.7,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.edit,
                            color: theme.scaffoldBackgroundColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              SizedBox(height: spacing.screenPadding),

              if (isAnalyzing) ...[
                Container(
                  padding: EdgeInsets.all(spacing.screenPadding),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: spacing.screenPadding),
                      Expanded(
                        child: Text(
                          S.of(context)!.ai_analyzing,
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: spacing.screenPadding),
              ],

              // Show info if image exists but AI failed (fallback to manual)
              if (image != null && !isAnalyzing) ...[
                Container(
                  padding: EdgeInsets.all(spacing.screenPadding),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.warning.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 20,
                        color: AppColors.warningUpdate,
                      ),
                      SizedBox(width: spacing.screenPadding),
                      Expanded(
                        child: Text(
                          S.of(context)!.image_will_upload,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.warningUpdate,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: spacing.screenPadding),
              ],

              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: isAnalyzing ? null : onAddItem,
                  icon: Icon(isAnalyzing ? Icons.hourglass_empty : Icons.add),
                  label: Text(
                    isAnalyzing ? S.of(context)!.analyzing : S.of(context)!.add,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    foregroundColor: theme.scaffoldBackgroundColor,
                    disabledBackgroundColor: theme.disabledColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: spacing.screenPadding * 2,
                      vertical: spacing.screenPadding,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
