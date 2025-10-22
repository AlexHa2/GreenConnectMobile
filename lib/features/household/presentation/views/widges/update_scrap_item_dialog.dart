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
  final List<File>? initialImages;
  final List<String> categories;

  const UpdateScrapItemDialog({
    super.key,
    this.initialCategory,
    this.initialQuantity,
    this.initialWeight,
    this.initialImages,
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

  late List<File> _images;

  @override
  void initState() {
    super.initState();
    _selectedCategory =
        widget.initialCategory ??
        (widget.categories.isNotEmpty ? widget.categories.first : null);
    _quantityController = TextEditingController(
      text: widget.initialQuantity?.toString() ?? "1",
    );
    _weightController = TextEditingController(
      text: widget.initialWeight?.toString() ?? "1.0",
    );
    _images = List<File>.from(widget.initialImages ?? []);
  }

  Future<void> _pickImage() async {
    if (_images.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You can upload up to 3 images.")),
      );
      return;
    }

    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _images.add(File(picked.path)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final theme = Theme.of(context);
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: double.infinity),
        child: Padding(
          padding: EdgeInsets.all(spacing.screenPadding * 2),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${S.of(context)!.update} ${S.of(context)!.scrap_item}",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  SizedBox(height: spacing.screenPadding * 2),

                  Text(
                    S.of(context)!.category,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: spacing.screenPadding / 2),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCategory,
                    items: widget.categories
                        .map(
                          (cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)),
                        )
                        .toList(),
                    onChanged: (val) => setState(() => _selectedCategory = val),
                    decoration: const InputDecoration(),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Please select a category";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: spacing.screenPadding),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context)!.quantity,
                              style: Theme.of(context).textTheme.bodyLarge!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: spacing.screenPadding / 2),
                            TextFormField(
                              controller: _quantityController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(hintText: "10"),
                              validator: (val) {
                                if (val == null ||
                                    int.tryParse(val) == null ||
                                    int.parse(val) <= 0) {
                                  return "Invalid quantity";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: spacing.screenPadding),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context)!.weight,
                              style: Theme.of(context).textTheme.bodyLarge!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _weightController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: S.of(context)!.weight_hint,
                              ),
                              validator: (val) {
                                if (val == null ||
                                    double.tryParse(val) == null ||
                                    double.parse(val) <= 0) {
                                  return "Invalid weight";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: spacing.screenPadding),

                  Text(
                    "${S.of(context)!.update} ${S.of(context)!.image}",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),

                  GestureDetector(
                    onTap: _pickImage,
                    child: DashedBorderContainer(
                      padding: EdgeInsets.all(spacing.screenPadding * 2),
                      width: double.infinity,
                      color: theme.primaryColor,
                      strokeWidth: 2,
                      dashWidth: 5,
                      dashSpace: 3,
                      borderRadius: 8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.upload_file,
                            size: spacing.screenPadding * 2,
                            color: theme.primaryColor,
                          ),
                          SizedBox(height: spacing.screenPadding / 2),
                          Text(S.of(context)!.upload),
                        ],
                      ),
                    ),
                  ),

                  if (_images.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _images
                          .asMap()
                          .entries
                          .map(
                            (entry) => Stack(
                              alignment: Alignment.topRight,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    entry.value,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => setState(() {
                                    _images.removeAt(entry.key);
                                  }),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: theme.scaffoldBackgroundColor,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      size: 20,
                                      color: AppColors.danger,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ],

                  SizedBox(height: spacing.screenPadding * 2),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: theme.dividerColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              spacing.screenPadding,
                            ),
                            side: BorderSide(
                              color: theme.primaryColorDark.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          S.of(context)!.cancel,
                          style: theme.textTheme.bodyLarge!.copyWith(),
                        ),
                      ),

                      SizedBox(width: spacing.screenPadding),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.warningUpdate,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pop(context, {
                              "category": _selectedCategory,
                              "quantity": int.parse(
                                _quantityController.text.trim(),
                              ),
                              "weight": double.parse(
                                _weightController.text.trim(),
                              ),
                              "images": _images,
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
      ),
    );
  }
}
