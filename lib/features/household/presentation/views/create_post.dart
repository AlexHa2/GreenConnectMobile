import 'dart:io';

import 'package:GreenConnectMobile/features/household/presentation/views/widges/update_scrap_item_dialog.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/button_gradient.dart';
import 'package:GreenConnectMobile/shared/widgets/dashed_border_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class CreateRecyclingPostPage extends StatefulWidget {
  const CreateRecyclingPostPage({super.key});

  @override
  State<CreateRecyclingPostPage> createState() =>
      _CreateRecyclingPostPageState();
}

class _CreateRecyclingPostPageState extends State<CreateRecyclingPostPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _pickupAddressController = TextEditingController(
    text: "123 green street",
  );
  final TextEditingController _pickupTimeController = TextEditingController(
    text: "Morning (8:00 AM - 12:00 PM)",
  );

  String? _selectedCategory;
  final TextEditingController _quantityController = TextEditingController(
    text: "1",
  );
  final TextEditingController _weightController = TextEditingController(
    text: "1",
  );

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  final List<Map<String, dynamic>> _scrapItems = [];

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${S.of(context)!.create} ${S.of(context)!.recycling} ${S.of(context)!.post}",
          style: theme.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(0)),
          side: BorderSide(color: theme.dividerColor),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.screenPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.all(spacing.screenPadding * 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context)!.post_title,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: spacing.screenPadding / 2),

                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          hintText: S.of(context)!.post_title_hint,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter a title";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: spacing.screenPadding),
                      Text(
                        S.of(context)!.description,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(height: spacing.screenPadding / 2),

                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          hintText: S.of(context)!.description_hint,
                        ),
                        maxLines: 2,
                      ),
                      SizedBox(height: spacing.screenPadding),

                      Text(
                        S.of(context)!.pickup_address,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(height: spacing.screenPadding / 2),

                      TextFormField(
                        controller: _pickupAddressController,
                        decoration: InputDecoration(
                          hintText: S.of(context)!.pickup_addres_hint,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please provide a pickup address";
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: spacing.screenPadding),

                      Text(
                        S.of(context)!.pickup_time,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: spacing.screenPadding / 2),
                      TextFormField(
                        controller: _pickupTimeController,
                        decoration: InputDecoration(
                          hintText: S.of(context)!.pickup_time_hint,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please provide a pickup time";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: spacing.screenPadding * 2),

              Text(
                S.of(context)!.add_scrap_items,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: spacing.screenPadding * 2,
                ),
              ),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(spacing.screenPadding * 2),
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
                        initialValue: _selectedCategory,
                        decoration: InputDecoration(
                          hintText: S.of(context)!.category,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: "Electronics",
                            child: Text("Electronics"),
                          ),
                          DropdownMenuItem(
                            value: "Plastic",
                            child: Text("Plastic"),
                          ),
                          DropdownMenuItem(
                            value: "Paper",
                            child: Text("Paper"),
                          ),
                          DropdownMenuItem(
                            value: "Metal",
                            child: Text("Metal"),
                          ),
                        ],
                        onChanged: (value) =>
                            setState(() => _selectedCategory = value),
                        validator: (value) =>
                            value == null ? "Select a category" : null,
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
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: spacing.screenPadding / 2),
                                TextFormField(
                                  controller: _quantityController,
                                  decoration: InputDecoration(
                                    hintText: S.of(context)!.quantity,
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null ||
                                        int.tryParse(value) == null ||
                                        int.parse(value) <= 0) {
                                      return "Enter valid quantity";
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  S.of(context)!.weight,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: spacing.screenPadding / 2),
                                TextFormField(
                                  controller: _weightController,
                                  decoration: InputDecoration(
                                    hintText: S.of(context)!.weight,
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null ||
                                        double.tryParse(value) == null ||
                                        double.parse(value) <= 0) {
                                      return "Enter valid weight";
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
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: spacing.screenPadding / 2),
                      GestureDetector(
                        onTap: () {
                          _pickImage();
                        },
                        child: DashedBorderContainer(
                          padding: EdgeInsets.all(spacing.screenPadding * 2),
                          width: double.infinity,
                          color: AppColors.primary,
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
                                color: AppColors.primary,
                              ),
                              SizedBox(height: spacing.screenPadding / 2),
                              Text(S.of(context)!.upload),
                            ],
                          ),
                        ),
                      ),
                      if (_selectedImage != null) ...[
                        SizedBox(height: spacing.screenPadding),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _selectedImage!,
                            width: double.infinity,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                      SizedBox(height: spacing.screenPadding),

                      Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton(
                          child: Text(S.of(context)!.add),
                          onPressed: () {
                            if (_selectedCategory == null ||
                                !_formKey.currentState!.validate())
                              return;

                            setState(() {
                              _scrapItems.insert(0, {
                                'category': _selectedCategory!,
                                'quantity': int.parse(
                                  _quantityController.text.trim(),
                                ),
                                'weight': double.parse(
                                  _weightController.text.trim(),
                                ),
                                'image': _selectedImage,
                              });
                              _selectedImage = null;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: spacing.screenPadding),

              Column(
                children: _scrapItems.map((item) {
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.all(spacing.screenPadding),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(spacing.screenPadding),
                    ),
                    shadowColor: theme.primaryColorDark.withValues(alpha: 0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: item['image'] != null
                                ? Image.file(
                                    item['image'],
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    width: 70,
                                    height: 70,
                                    color: theme.primaryColorDark.withValues(
                                      alpha: 0.1,
                                    ),
                                    child: const Icon(
                                      Icons.image,
                                      size: 36,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                          ),

                          SizedBox(width: spacing.screenPadding),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['category'] ?? "Unknown",
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Quantity: ${item['quantity']}",
                                  style: theme.textTheme.bodyMedium,
                                ),
                                Text(
                                  "Weight: ${item['weight']} kg",
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),

                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: theme.primaryColor,
                                ),
                                style: IconButton.styleFrom(
                                  backgroundColor: theme.primaryColor
                                      .withValues(alpha: 0.1),
                                ),
                                onPressed: () async {
                                  final updatedData =
                                      await showDialog<Map<String, dynamic>>(
                                        context: context,
                                        builder: (context) =>
                                            UpdateScrapItemDialog(
                                              categories: [
                                                "Electronics",
                                                "Plastic",
                                                "Paper",
                                                "Metal",
                                              ],
                                              initialCategory: item['category'],
                                              initialQuantity: item['quantity'],
                                              initialWeight: item['weight'],
                                              initialImages:
                                                  item['image'] != null
                                                  ? [item['image']]
                                                  : [],
                                            ),
                                      );

                                  if (updatedData != null) {
                                    setState(() {
                                      final index = _scrapItems.indexOf(item);
                                      _scrapItems[index] = {
                                        'category': updatedData['category'],
                                        'quantity': updatedData['quantity'],
                                        'weight': updatedData['weight'],
                                        'image':
                                            (updatedData['images'] as List)
                                                .isNotEmpty
                                            ? updatedData['images'][0]
                                            : item['image'],
                                      };
                                    });
                                  }
                                },
                              ),
                              SizedBox(width: spacing.screenPadding / 2),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: AppColors.danger,
                                ),
                                style: IconButton.styleFrom(
                                  backgroundColor: AppColors.danger.withValues(
                                    alpha: 0.1,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _scrapItems.remove(item);
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              SizedBox(height: spacing.screenPadding),

              SizedBox(
                width: double.infinity,
                child: GradientButton(
                  text: "${S.of(context)!.create} ${S.of(context)!.post}",
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        _scrapItems.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Post created successfully!"),
                        ),
                      );
                    } else if (_scrapItems.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please add at least one scrap item."),
                        ),
                      );
                    }
                  },
                ),
              ),
              SizedBox(height: spacing.screenPadding * 2),
            ],
          ),
        ),
      ),
    );
  }
}
