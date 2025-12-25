import 'dart:io';

import 'package:GreenConnectMobile/core/enum/scrap_post_detail_type.dart';
import 'package:GreenConnectMobile/core/helper/scrap_post_detail_type_helper.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_category_entity.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddItemBottomSheet extends StatefulWidget {
  const AddItemBottomSheet({
    super.key,
    required this.categories,
    required this.onAdd,
    required this.hasCategoryExists,
    required this.controllerDisposeDelay,
  });

  final List<ScrapCategoryEntity> categories;
  final void Function({
    required String categoryId,
    required ScrapPostDetailType type,
    required File imageFile,
    required String amountText,
  }) onAdd;
  final bool Function(String categoryId) hasCategoryExists;
  final Duration controllerDisposeDelay;

  @override
  State<AddItemBottomSheet> createState() => _AddItemBottomSheetState();
}

class _AddItemBottomSheetState extends State<AddItemBottomSheet> {
  final _itemFormKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _picker = ImagePicker();

  String? selectedCategoryId;
  ScrapPostDetailType? selectedType;
  File? selectedImage;

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  void _addItem() {
    final s = S.of(context)!;

    if (selectedImage == null) {
      CustomToast.show(context, s.please_select_image, type: ToastType.error);
      return;
    }
    if (selectedCategoryId == null) {
      CustomToast.show(context, s.please_select_category,
          type: ToastType.error);
      return;
    }
    if (selectedType == null) {
      CustomToast.show(context, s.scrap_type_required, type: ToastType.error);
      return;
    }
    if (!(_itemFormKey.currentState?.validate() ?? false)) {
      return;
    }

    if (widget.hasCategoryExists(selectedCategoryId!)) {
      CustomToast.show(
        context,
        s.error_category_exists,
        type: ToastType.error,
      );
      return;
    }

    widget.onAdd(
      categoryId: selectedCategoryId!,
      type: selectedType!,
      imageFile: selectedImage!,
      amountText: _amountController.text.trim(),
    );
    Navigator.pop(context);
  }

  Widget _buildImagePreview() {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final s = S.of(context)!;

    if (selectedImage == null) {
      return InkWell(
        onTap: _pickImage,
        borderRadius: BorderRadius.circular(spacing.screenPadding),
        child: Container(
          height: 160,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(spacing.screenPadding),
            border: Border.all(
              color: theme.dividerColor,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.add_photo_alternate_outlined,
                  size: 28,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                SizedBox(height: spacing.screenPadding * 0.67),
                Text(
                  s.please_select_image,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(spacing.screenPadding),
      child: Stack(
        children: [
          Image.file(
            selectedImage!,
            height: 160,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            right: 8,
            top: 8,
            child: IconButton.filledTonal(
              onPressed: _pickImage,
              icon: const Icon(Icons.edit),
            ),
          ),
          Positioned(
            left: 8,
            top: 8,
            child: IconButton.filledTonal(
              onPressed: () {
                setState(() => selectedImage = null);
              },
              icon: const Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    Future.delayed(widget.controllerDisposeDelay, () {
      try {
        _amountController.dispose();
      } catch (e) {
        debugPrint('Controller disposal: $e');
      }
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final s = S.of(context)!;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: spacing.screenPadding,
          right: spacing.screenPadding,
          top: spacing.screenPadding * 0.67,
          bottom:
              MediaQuery.of(context).viewInsets.bottom + spacing.screenPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                s.add_scrap_items,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: spacing.screenPadding),
            _buildImagePreview(),
            SizedBox(height: spacing.screenPadding),
            Form(
              key: _itemFormKey,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: selectedCategoryId,
                    items: widget.categories
                        .map(
                          (c) => DropdownMenuItem(
                            value: c.scrapCategoryId,
                            child: Text(c.categoryName),
                          ),
                        )
                        .toList(),
                    onChanged: (val) =>
                        setState(() => selectedCategoryId = val),
                    decoration: InputDecoration(
                      labelText: s.category,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        v == null ? s.please_select_category : null,
                  ),
                  SizedBox(height: spacing.screenPadding),
                  DropdownButtonFormField<ScrapPostDetailType>(
                    initialValue: selectedType,
                    items: ScrapPostDetailType.values
                        .map(
                          (t) => DropdownMenuItem(
                            value: t,
                            child: Text(
                              ScrapPostDetailTypeHelper.getLocalizedType(
                                  context, t),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) => setState(() => selectedType = val),
                    decoration: InputDecoration(
                      labelText: s.scrap_item,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (v) => v == null ? s.scrap_type_required : null,
                  ),
                  SizedBox(height: spacing.screenPadding),
                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: s.amount_description,
                      hintText: s.amount_description,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (v) {
                      final txt = (v ?? '').trim();
                      if (txt.isEmpty) return s.error_required;
                      return null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: spacing.screenPadding),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(s.cancel),
                  ),
                ),
                SizedBox(width: spacing.screenPadding),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: spacing.screenPadding * 1.15,
                      ),
                      backgroundColor: theme.primaryColor,
                      foregroundColor: theme.scaffoldBackgroundColor,
                    ),
                    onPressed: _addItem,
                    child: Text(s.add),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
