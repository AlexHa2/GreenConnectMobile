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
  final File? initialImage;
  final List<String> categories;

  const UpdateScrapItemDialog({
    super.key,
    this.initialCategory,
    this.initialQuantity,
    this.initialWeight,
    this.initialImage,
    required this.categories,
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
  File? _image;

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
    _image = widget.initialImage;
  }

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _image = File(picked.path));
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
      child: Padding(
        padding: EdgeInsets.all(spacing.screenPadding * 2),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${S.of(context)!.update} ${S.of(context)!.scrap_item}",
                    style: theme.textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              SizedBox(height: spacing.screenPadding),

              _buildLabel(context, S.of(context)!.category),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                items: widget.categories
                    .map(
                      (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _selectedCategory = val),
                decoration: InputDecoration(hintText: S.of(context)!.category),
                validator: (val) =>
                    val == null ? S.of(context)!.error_required : null,
              ),

              SizedBox(height: spacing.screenPadding),

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
                    ),
                  ),
                ],
              ),

              SizedBox(height: spacing.screenPadding),

              _buildLabel(context, S.of(context)!.upload),
              GestureDetector(
                onTap: _pickImage,
                child: DashedBorderContainer(
                  color: theme.primaryColor,
                  padding: EdgeInsets.all(spacing.screenPadding * 2),
                  width: double.infinity,
                  borderRadius: spacing.screenPadding,
                  child: Center(
                    child: Text(
                      S.of(context)!.upload,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ),
              ),

              if (_image != null) ...[
                SizedBox(height: spacing.screenPadding),
                ClipRRect(
                  borderRadius: BorderRadius.circular(spacing.screenPadding),
                  child: Image.file(
                    _image!,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: AppColors.danger),
                    onPressed: () => setState(() => _image = null),
                  ),
                ),
              ],

              SizedBox(height: spacing.screenPadding * 2),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(S.of(context)!.cancel),
                  ),
                  SizedBox(width: spacing.screenPadding),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pop(context, {
                          "category": _selectedCategory,
                          "quantity": int.parse(_quantityController.text),
                          "weight": double.parse(_weightController.text),
                          "image": _image,
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
    );
  }

  Widget _buildLabel(BuildContext ctx, String text) {
    return Text(
      text,
      style: Theme.of(
        ctx,
      ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  Widget _buildNumberInput(
    BuildContext context,
    String label,
    TextEditingController controller,
    String hint, {
    bool isDouble = false,
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
          decoration: const InputDecoration(isDense: true),
          keyboardType: TextInputType.number,
          validator: (val) {
            if (val == null) return S.of(context)!.error_required;
            return isDouble
                ? (double.tryParse(val) == null
                      ? S.of(context)!.error_required
                      : null)
                : (int.tryParse(val) == null
                      ? S.of(context)!.error_required
                      : null);
          },
        ),
      ],
    );
  }
}
