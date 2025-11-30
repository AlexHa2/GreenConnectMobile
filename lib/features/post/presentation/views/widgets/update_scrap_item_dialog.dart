import 'dart:io';

import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/dashed_border_container.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateScrapItemDialog extends StatefulWidget {
  final String? initialCategory;
  final int? initialQuantity;
  final double? initialWeight;
  final String? initialImageUrl;
  final List<String> categories;

  const UpdateScrapItemDialog({
    super.key,
    this.initialCategory,
    this.initialQuantity,
    this.initialWeight,
    required this.categories,
    this.initialImageUrl,
  });

  @override
  State<UpdateScrapItemDialog> createState() => _UpdateScrapItemDialogState();
}

class _UpdateScrapItemDialogState extends State<UpdateScrapItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  late String? _selectedCategory;
  late TextEditingController _quantityController;
  late TextEditingController _weightController;

  // Logic: Separate old image (URL) and new image (File)
  String? _currentImageUrl;
  File? _newPickedFile;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _quantityController = TextEditingController(
      text: widget.initialQuantity?.toString() ?? "1",
    );
    _weightController = TextEditingController(
      text: widget.initialWeight?.toString() ?? "1.0",
    );
    _currentImageUrl = widget.initialImageUrl;
  }

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _newPickedFile = File(picked.path);
        // When selecting new image, prioritize displaying new image,
        // but keep _currentImageUrl for reference if needed (or set null depending on business logic)
      });
    }
  }

  void _removeImage() {
    setState(() {
      _newPickedFile = null;
      _currentImageUrl = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final theme = Theme.of(context);

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: spacing.screenPadding * 2,
        vertical: spacing.screenPadding,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(spacing.screenPadding),
      ),
      backgroundColor: theme.cardColor,
      child: SingleChildScrollView(
        // Add scroll to prevent overflow when keyboard appears
        child: Padding(
          padding: EdgeInsets.all(spacing.screenPadding * 2),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${S.of(context)!.update} ${S.of(context)!.scrap_item}",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),

                SizedBox(height: spacing.screenPadding * 1.5),

                // Category Dropdown
                _buildLabel(context, S.of(context)!.category),
                SizedBox(height: spacing.screenPadding / 2),
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  items: widget.categories
                      .map(
                        (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                      )
                      .toList(),
                  onChanged: (val) => setState(() => _selectedCategory = val),
                  decoration: InputDecoration(
                    hintText: S.of(context)!.category,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (val) =>
                      val == null ? S.of(context)!.error_required : null,
                ),

                SizedBox(height: spacing.screenPadding),

                // Quantity & Weight Row
                Row(
                  children: [
                    Expanded(
                      child: _buildNumberInput(
                        context,
                        S.of(context)!.quantity,
                        _quantityController,
                        "10",
                      ),
                    ),
                    SizedBox(width: spacing.screenPadding),
                    Expanded(
                      child: _buildNumberInput(
                        context,
                        S.of(context)!.weight,
                        _weightController,
                        "1.0",
                        isDouble: true,
                        suffixText: "kg",
                      ),
                    ),
                  ],
                ),

                SizedBox(height: spacing.screenPadding * 1.5),

                // --- IMPROVED IMAGE SECTION ---
                _buildLabel(context, S.of(context)!.image), // "Image"
                SizedBox(height: spacing.screenPadding / 2),
                _buildImageSection(context, theme, spacing),

                // -----------------------------
                SizedBox(height: spacing.screenPadding * 2),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        S.of(context)!.cancel,
                        style: TextStyle(
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                    ),
                    SizedBox(width: spacing.screenPadding),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors
                            .warningUpdate, // Orange/yellow update color
                        foregroundColor: theme.scaffoldBackgroundColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Return data logic
                          // Prioritize returning new file, if not available return old url (or null if all deleted)
                          dynamic imageResult;
                          if (_newPickedFile != null) {
                            imageResult =
                                _newPickedFile!.path; // Return Path String
                          } else {
                            imageResult =
                                _currentImageUrl; // Return old URL or null
                          }

                          Navigator.pop(context, {
                            "category": _selectedCategory,
                            "quantity": int.parse(_quantityController.text),
                            "weight": double.parse(_weightController.text),
                            "image": imageResult,
                          });
                        }
                      },
                      child: Text(S.of(context)!.update),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(
    BuildContext context,
    ThemeData theme,
    AppSpacing spacing,
  ) {
    bool hasImage =
        _newPickedFile != null ||
        (_currentImageUrl != null && _currentImageUrl!.isNotEmpty);
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    
    // Check if _currentImageUrl is a file path or URL
    final bool isCurrentImageFile = _currentImageUrl != null && 
        !_currentImageUrl!.startsWith('http');
    
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(spacing.screenPadding),
          color: theme.cardColor,
          border: hasImage ? null : Border.all(color: Colors.transparent),
        ),
        child: hasImage
            ? Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(spacing.screenPadding),
                    child: _newPickedFile != null
                        ? Image.file(_newPickedFile!, fit: BoxFit.cover)
                        : isCurrentImageFile
                            ? Image.file(
                                File(_currentImageUrl!),
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, err, stack) => Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    color: theme.disabledColor,
                                  ),
                                ),
                              )
                            : Image.network(
                                _currentImageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, err, stack) => Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    color: theme.disabledColor,
                                  ),
                                ),
                              ),
                  ),

                  Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    height: 50,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            Colors.transparent,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),

                  // Layer 3: Controls (Edit & Delete)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Edit Button
                        _buildCircleActionBtn(
                          icon: Icons.edit_rounded,
                          color: theme.scaffoldBackgroundColor,
                          bgColor: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                          onTap: _pickImage,
                        ),
                        const SizedBox(width: 8),
                        // Delete Button
                        _buildCircleActionBtn(
                          icon: Icons.delete_outline_rounded,
                          color: AppColors.danger,
                          bgColor: theme.scaffoldBackgroundColor,
                          onTap: _removeImage,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : DashedBorderContainer(
                color: theme.primaryColor.withValues(alpha: 0.5),
                padding: EdgeInsets.all(spacing.screenPadding),
                borderRadius: 12,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 32,
                      color: theme.primaryColor,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      S.of(context)!.upload,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildCircleActionBtn({
    required IconData icon,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }

  Widget _buildLabel(BuildContext ctx, String text) {
    return Text(
      text,
      style: Theme.of(ctx).textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: Theme.of(ctx).textTheme.bodyLarge?.color?.withValues(alpha: 0.8),
      ),
    );
  }

  Widget _buildNumberInput(
    BuildContext context,
    String label,
    TextEditingController controller,
    String hint, {
    bool isDouble = false,
    String? suffixText,
  }) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(context, label),
        SizedBox(height: spacing.screenPadding / 2),
        TextFormField(
          controller: controller,
          textAlign: TextAlign.center,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: hint,
            suffixText: suffixText,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          validator: (val) {
            if (val == null || val.isEmpty) {
              return S.of(context)!.error_required;
            }
            if (isDouble) {
              return double.tryParse(val) == null
                  ? S.of(context)!.error_all_field
                  : null;
            } else {
              return int.tryParse(val) == null
                  ? S.of(context)!.error_all_field
                  : null;
            }
          },
        ),
      ],
    );
  }
}
