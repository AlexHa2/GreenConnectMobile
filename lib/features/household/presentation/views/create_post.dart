import 'dart:io';

import 'package:GreenConnectMobile/core/helper/get_location_from_address.dart';
import 'package:GreenConnectMobile/core/helper/navigate_with_loading.dart';
import 'package:GreenConnectMobile/features/household/domain/entities/location_entity.dart';
import 'package:GreenConnectMobile/features/household/domain/entities/scrap_post_detail_entity.dart';
import 'package:GreenConnectMobile/features/household/domain/entities/scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/household/presentation/providers/scrap_category_providers.dart';
import 'package:GreenConnectMobile/features/household/presentation/providers/scrap_post_providers.dart';
import 'package:GreenConnectMobile/features/household/presentation/views/widges/add_scrap_item_section.dart';
import 'package:GreenConnectMobile/features/household/presentation/views/widges/post_info_form.dart';
import 'package:GreenConnectMobile/features/household/presentation/views/widges/scrap_item_list.dart';
import 'package:GreenConnectMobile/features/household/presentation/views/widges/take_all_switch.dart';
import 'package:GreenConnectMobile/features/household/presentation/views/widges/update_scrap_item_dialog.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/button_gradient.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class CreateRecyclingPostPage extends ConsumerStatefulWidget {
  const CreateRecyclingPostPage({super.key});
  @override
  ConsumerState<CreateRecyclingPostPage> createState() =>
      _CreateRecyclingPostPageState();
}

class _CreateRecyclingPostPageState
    extends ConsumerState<CreateRecyclingPostPage> {
  final _formKey = GlobalKey<FormState>();
  final _itemFormKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _pickupAddressController =
      TextEditingController();
  final TextEditingController _pickupTimeController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController(
    text: "1",
  );
  final TextEditingController _weightController = TextEditingController(
    text: "1",
  );

  LocationEntity? _location;
  bool _addressFound = false;

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  int? _selectedCategoryId;
  final List<Map<String, dynamic>> _scrapItems = [];

  bool _isTakeAll = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(scrapCategoryViewModelProvider.notifier)
          .fetchScrapCategories(pageNumber: 1, pageSize: 50);
    });
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  void _handleAddItem() {
    if (!_itemFormKey.currentState!.validate() || _selectedCategoryId == null) {
      return;
    }

    final exists = _scrapItems.any(
      (item) => item['categoryId'] == _selectedCategoryId,
    );
    if (exists) {
      CustomToast.show(
        context,
        S.of(context)!.error_category_exists,
        type: ToastType.error,
      );
      return;
    }

    setState(() {
      _scrapItems.add({
        'categoryId': _selectedCategoryId!,
        'category': ref
            .read(scrapCategoryViewModelProvider)
            .listData!
            .data
            .firstWhere((cat) => cat.scrapCategoryId == _selectedCategoryId)
            .categoryName,
        'quantity': int.parse(_quantityController.text),
        'weight': double.parse(_weightController.text),
        'image': _selectedImage,
      });

      _selectedCategoryId = null;
      _quantityController.text = "1";
      _weightController.text = "1";
      _selectedImage = null;
      _itemFormKey.currentState!.reset();
    });
  }

  void _resetAllData() {
    _titleController.clear();
    _descriptionController.clear();
    _pickupAddressController.clear();
    _pickupTimeController.clear();
    _quantityController.text = "1";
    _weightController.text = "1";

    setState(() {
      _scrapItems.clear();
      _location = null;
      _addressFound = false;
      _selectedCategoryId = null;
      _selectedImage = null;
      _isTakeAll = false;
    });

    _formKey.currentState?.reset();
    _itemFormKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final theme = Theme.of(context);

    final categoryState = ref.watch(scrapCategoryViewModelProvider);
    final categories = categoryState.listData?.data ?? [];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${S.of(context)!.create} ${S.of(context)!.recycling} ${S.of(context)!.post}",
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.screenPadding),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              PostInfoForm(
                formKey: _formKey,
                titleController: _titleController,
                descController: _descriptionController,
                addressController: _pickupAddressController,
                timeController: _pickupTimeController,
                onSearchAddress: () async {
                  final loc = await getLocationFromAddress(
                    _pickupAddressController.text.trim(),
                  );
                  if (loc != null) {
                    setState(() {
                      _location = loc;
                      _addressFound = true;
                    });
                    if (!mounted || !context.mounted) return;
                    CustomToast.show(
                      context,
                      S.of(context)!.address_found,
                      type: ToastType.success,
                    );
                  } else {
                    setState(() {
                      _addressFound = false;
                    });
                    if (!mounted || !context.mounted) return;
                    CustomToast.show(
                      context,
                      S.of(context)!.address_not_found,
                      type: ToastType.error,
                    );
                  }
                },
                addressFound: _addressFound,
              ),

              SizedBox(height: spacing.screenPadding),
              Text(
                S.of(context)!.add_scrap_items,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: spacing.screenPadding * 2,
                ),
              ),
              SizedBox(height: spacing.screenPadding),
              AddScrapItemSection(
                key: ValueKey(_selectedCategoryId),
                itemFormKey: _itemFormKey,
                selectedCategoryId: _selectedCategoryId,
                categories: categories,
                quantityController: _quantityController,
                weightController: _weightController,
                image: _selectedImage,
                onPickImage: _pickImage,
                onCategoryChange: (value) {
                  setState(() => _selectedCategoryId = value);
                },
                onAddItem: _handleAddItem,
              ),

              SizedBox(height: spacing.screenPadding),

              ScrapItemList(
                items: _scrapItems,
                onUpdate: (index, data) async {
                  final updated = await showDialog(
                    context: context,
                    builder: (_) => UpdateScrapItemDialog(
                      categories: categories
                          .map((e) => e.categoryName)
                          .toList(),
                      initialCategory: data['category'],
                      initialQuantity: data['quantity'],
                      initialWeight: data['weight'],
                      initialImageUrl: data['image'],
                    ),
                  );

                  if (updated != null) {
                    setState(() {
                      _scrapItems[index] = {
                        'categoryId': categories
                            .firstWhere(
                              (cat) => cat.categoryName == updated['category'],
                            )
                            .scrapCategoryId,
                        'category': updated['category'],
                        'quantity': updated['quantity'],
                        'weight': updated['weight'],
                        'image': updated['image'],
                      };
                    });
                  }
                },
                onDelete: (item) => setState(() => _scrapItems.remove(item)),
              ),

              SizedBox(height: spacing.screenPadding * 2),
              TakeAllSwitch(
                value: _isTakeAll,
                onChange: (val) => setState(() => _isTakeAll = val),
              ),
              SizedBox(height: spacing.screenPadding),
              GradientButton(
                text: "${S.of(context)!.create} ${S.of(context)!.post}",
                onPressed: () async {
                  final requiredMsg = S.of(context)!.error_required;
                  final emptyMsg = S.of(context)!.error_scrap_item_empty;
                  final successMsg = S.of(context)!.success_post_created;
                  final generalMsg = S.of(context)!.error_general;

                  if (!_formKey.currentState!.validate()) {
                    CustomToast.show(
                      context,
                      requiredMsg,
                      type: ToastType.error,
                    );
                    return;
                  }

                  if (_scrapItems.isEmpty) {
                    CustomToast.show(context, emptyMsg, type: ToastType.error);
                    return;
                  }

                  final vm = ref.read(scrapPostViewModelProvider.notifier);

                  if (_location == null) {
                    CustomToast.show(
                      context,
                      S.of(context)!.error_invalid_address,
                      type: ToastType.error,
                    );
                    return;
                  }
                  final post = ScrapPostEntity(
                    title: _titleController.text.trim(),
                    description: _descriptionController.text.trim(),
                    address: _pickupAddressController.text.trim(),
                    availableTimeRange: _pickupTimeController.text.trim(),
                    scrapPostDetails: _scrapItems
                        .map(
                          (e) => ScrapPostDetailEntity(
                            scrapCategoryId: e['categoryId'],
                            amountDescription:
                                "${e['quantity']} pcs - ${e['weight'].toStringAsFixed(1)} kg",
                            // imageUrl: e['image'],
                            imageUrl:
                                "https://media.vietnamplus.vn/images/fbc23bef0d088b23a8965bce49f85a61cd286afccaf9606b44256f5d7ef5d5fefff6aa780c9464f6499f791f5dd6f3de1d175058d9a59d4e21100ddb41c54c45/ngaymoitruong_12.jpg",
                          ),
                        )
                        .toList(),
                    mustTakeAll: _isTakeAll,
                    location: _location!,
                  );

                  final success = await vm.createPost(post: post);

                  if (success) {
                    if (!mounted || !context.mounted) return;
                    _resetAllData();
                    CustomToast.show(
                      context,
                      successMsg,
                      type: ToastType.success,
                    );

                    if (context.mounted) {
                      navigateWithLoading(context, route: '/list-post');
                    }
                  } else {
                    if (!mounted || !context.mounted) return;

                    // final error = ref
                    //     .read(scrapPostViewModelProvider)
                    //     .errorMessage;
                    CustomToast.show(
                      context,
                      "$generalMsg ${S.of(context)!.error_scrap_category}",
                      type: ToastType.error,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
