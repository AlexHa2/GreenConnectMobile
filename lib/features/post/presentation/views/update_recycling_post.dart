import 'dart:io';

import 'package:GreenConnectMobile/core/enum/post_status.dart';
import 'package:GreenConnectMobile/core/helper/get_location_from_address.dart';
import 'package:GreenConnectMobile/core/helper/navigate_with_loading.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/location_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_detail_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/update_scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/post/presentation/providers/scrap_category_providers.dart';
import 'package:GreenConnectMobile/features/post/presentation/providers/scrap_post_providers.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/add_scrap_item_section.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/post_info_form.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/scrap_item_list.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/take_all_switch.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/update_scrap_item_dialog.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class UpdateRecyclingPostPage extends ConsumerStatefulWidget {
  final Map<String, dynamic> initialData;

  const UpdateRecyclingPostPage({super.key, required this.initialData});

  @override
  ConsumerState<UpdateRecyclingPostPage> createState() =>
      _UpdateRecyclingPostPageState();
}

class _UpdateRecyclingPostPageState
    extends ConsumerState<UpdateRecyclingPostPage> {
  final _formKey = GlobalKey<FormState>();
  final _itemFormKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _pickupAddressController;
  late TextEditingController _pickupTimeController;
  final TextEditingController _quantityController = TextEditingController(
    text: "1",
  );
  final TextEditingController _weightController = TextEditingController(
    text: "1",
  );

  LocationEntity? _location;
  bool _addressFound = true;

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  int? _selectedCategoryId;

  final List<Map<String, dynamic>> _scrapItems = [];

  final List<int> _deletedCategoryIds = [];

  bool _isTakeAll = false;
  late String _postId;

  @override
  void initState() {
    super.initState();
    _initData();
    Future.microtask(() {
      ref
          .read(scrapCategoryViewModelProvider.notifier)
          .fetchScrapCategories(pageNumber: 1, pageSize: 50);
    });
  }

  void _initData() {
    final data = widget.initialData;
    _postId = (data['id'] ?? data['postId']).toString();

    _titleController = TextEditingController(text: data['title']);
    _descriptionController = TextEditingController(text: data['description']);
    _pickupAddressController = TextEditingController(text: data['address']);
    _pickupTimeController = TextEditingController(
      text: data['availableTimeRange'],
    );
    _isTakeAll = data['mustTakeAll'] ?? false;

    final items = data['items'];
    if (items != null) {
      for (var item in items) {
        if (item is ScrapPostDetailEntity) {
          int q = 1;
          double w = 1.0;
          try {
            final parts = item.amountDescription.split(' - ');
            q = int.parse(parts[0].replaceAll(RegExp(r'[^0-9]'), ''));
            w = double.parse(parts[1].replaceAll(RegExp(r'[^0-9.]'), ''));
          } catch (_) {}

          _scrapItems.add({
            'categoryId': item.scrapCategoryId,
            'category':
                item.scrapCategory?.categoryName ??
                'Category ${item.scrapCategoryId}',
            'quantity': q,
            'weight': w,
            'imageUrl': item.imageUrl,
            'isExisting': true,
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _pickupAddressController.dispose();
    _pickupTimeController.dispose();
    _quantityController.dispose();
    _weightController.dispose();
    super.dispose();
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
        'isExisting': false,
      });

      _selectedCategoryId = null;
      _quantityController.text = "1";
      _weightController.text = "1";
      _selectedImage = null;
      _itemFormKey.currentState!.reset();
    });
  }

  void _handleDeleteItem(int index) {
    setState(() {
      final item = _scrapItems[index];
      if (item['isExisting'] == true) {
        _deletedCategoryIds.add(item['categoryId']);
      }
      _scrapItems.removeAt(index);
    });
  }

  Future<void> _handleUpdate() async {
    final s = S.of(context)!;
    if (!_formKey.currentState!.validate()) {
      CustomToast.show(context, s.error_required, type: ToastType.error);
      return;
    }
    if (_scrapItems.isEmpty) {
      CustomToast.show(
        context,
        s.error_scrap_item_empty,
        type: ToastType.error,
      );
      return;
    }

    // Nếu location chưa được set lại (người dùng không sửa địa chỉ),
    // ta cần location cũ hoặc search lại. Ở đây giả định search lại để đảm bảo chính xác.
    if (_location == null) {
      final loc = await getLocationFromAddress(
        _pickupAddressController.text.trim(),
      );
      if (loc == null) {
        if (!mounted) return;
        CustomToast.show(
          context,
          s.error_invalid_address,
          type: ToastType.error,
        );
        return;
      }
      _location = loc;
    }

    final vm = ref.read(scrapPostViewModelProvider.notifier);

    final updateEntity = UpdateScrapPostEntity(
      scrapPostId: _postId,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      address: _pickupAddressController.text.trim(),
      availableTimeRange: _pickupTimeController.text.trim(),
      mustTakeAll: _isTakeAll,
      location: _location!,
    );

    bool allSuccess = true;

    final postUpdated = await vm.updatePost(post: updateEntity);
    if (!postUpdated) allSuccess = false;

    for (var catId in _deletedCategoryIds) {
      final deleted = await vm.deleteDetail(postId: _postId, categoryId: catId);
      if (!deleted) allSuccess = false;
    }

    for (var item in _scrapItems) {
      final detailEntity = ScrapPostDetailEntity(
        scrapCategoryId: item['categoryId'],
        amountDescription:
            "${item['quantity']} pcs - ${item['weight'].toStringAsFixed(1)} kg",
        // Logic ảnh: Nếu là item mới -> dùng file upload (cần logic upload ảnh riêng hoặc base64).
        // Nếu là item cũ -> giữ nguyên imageUrl cũ.
        // *Lưu ý*: Ở đây giả định imageUrl nhận string. Nếu backend cần File cho create/update,
        // usecase cần xử lý MultipartFile.
        imageUrl: item['imageUrl'] ?? "https://placeholder.com/default.jpg",
        status: PostDetailStatus.available.name,
      );

      if (item['isExisting'] == true) {
        // Update Detail
        final updated = await vm.updateDetail(
          postId: _postId,
          detail: detailEntity,
        );
        if (!updated) allSuccess = false;
      } else {
        // Create Detail
        final created = await vm.createDetail(
          postId: _postId,
          detail: detailEntity,
        );
        if (!created) allSuccess = false;
      }
    }

    if (allSuccess) {
      if (!mounted) return;
      navigateWithLoading(
        context,
        route: "/detail-post",
        extra: {'postId': _postId},
        asyncTask: () => Future.delayed(const Duration(milliseconds: 250)),
      );
      CustomToast.show(
        context,
        "${s.update} ${s.post} ${s.successfully}",
        type: ToastType.success,
      );
    } else {
      if (!mounted) return;
      final errorMsg =
          ref.read(scrapPostViewModelProvider).errorMessage ?? s.error_general;
      CustomToast.show(context, errorMsg, type: ToastType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final theme = Theme.of(context);
    final categoryState = ref.watch(scrapCategoryViewModelProvider);
    final categories = categoryState.listData?.data ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text("${S.of(context)!.update} ${S.of(context)!.post}"),
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
                addressFound: _addressFound,
                onSearchAddress: () async {
                  final loc = await getLocationFromAddress(
                    _pickupAddressController.text.trim(),
                  );
                  setState(() {
                    _location = loc;
                    _addressFound = loc != null;
                  });
                  if (!mounted && !context.mounted) {
                    return;
                  }
                  CustomToast.show(
                    context,
                    loc != null
                        ? S.of(context)!.address_found
                        : S.of(context)!.address_not_found,
                    type: loc != null ? ToastType.success : ToastType.error,
                  );
                },
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
                onCategoryChange: (val) =>
                    setState(() => _selectedCategoryId = val),
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
                      initialImageUrl: data['imageUrl'],
                    ),
                  );

                  if (updated != null) {
                    setState(() {
                      _scrapItems[index]['quantity'] = updated['quantity'];
                      _scrapItems[index]['weight'] = updated['weight'];
                    });
                  }
                },
                onDelete: (item) {
                  final index = _scrapItems.indexOf(item);
                  if (index != -1) _handleDeleteItem(index);
                },
              ),

              SizedBox(height: spacing.screenPadding * 2),

              TakeAllSwitch(
                value: _isTakeAll,
                onChange: (val) => setState(() => _isTakeAll = val),
              ),

              SizedBox(height: spacing.screenPadding),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: spacing.screenPadding,
                    ),
                    backgroundColor: AppColors.warningUpdate,
                  ),
                  onPressed: _handleUpdate,
                  child: Text(
                    "${S.of(context)!.update} ${S.of(context)!.post}",
                  ),
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
