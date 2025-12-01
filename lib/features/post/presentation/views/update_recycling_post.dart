import 'dart:io';
import 'dart:typed_data';
import 'package:GreenConnectMobile/core/enum/post_status.dart';
import 'package:GreenConnectMobile/core/helper/get_location_from_address.dart';
import 'package:GreenConnectMobile/core/helper/navigate_with_loading.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/location_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_item_data.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_detail_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/update_scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/post/presentation/providers/scrap_category_providers.dart';
import 'package:GreenConnectMobile/features/post/presentation/providers/scrap_post_providers.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/add_scrap_item_section.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/loading_overlay.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/post_info_form.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/post_section_title.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/scrap_item_list.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/take_all_switch.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/update_scrap_item_dialog.dart';
import 'package:GreenConnectMobile/features/upload/domain/entities/upload_request_entity.dart';
import 'package:GreenConnectMobile/features/upload/presentation/providers/upload_provider.dart';
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

  // Controllers
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _pickupAddressController;
  late TextEditingController _pickupTimeController;

  LocationEntity? _location;
  bool _addressFound = true;

  final List<ScrapItemData> _scrapItems = [];
  // Track which items are existing (from server) vs new
  final Map<int, bool> _existingItemsMap = {};
  // Track which items have been modified
  final Set<int> _modifiedItemIndices = {};

  final List<int> _deletedCategoryIds = [];

  // State for AddScrapItemSection
  final _itemFormKey = GlobalKey<FormState>();
  final TextEditingController _amountDescriptionController =
      TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  int? _selectedCategoryId;
  bool _isAnalyzingImage = false;
  String? _recognizedImageUrl;
  Map<String, dynamic>? _aiRecognitionData;
  String? _aiSuggestedDescription;

  bool _isTakeAll = false;
  bool _isSubmitting = false;
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
          final itemData = ScrapItemData(
            categoryId: item.scrapCategoryId,
            categoryName:
                item.scrapCategory?.categoryName ??
                'Category ${item.scrapCategoryId}',
            amountDescription: item.amountDescription,
            imageUrl: item.imageUrl,
          );

          _scrapItems.add(itemData);
          _existingItemsMap[item.scrapCategoryId] = true;
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
    // _quantityController.dispose();
    // _weightController.dispose();
    super.dispose();
  }

  void _handleDeleteItem(int index) {
    setState(() {
      final item = _scrapItems[index];
      // If existing item (from server), track for deletion
      if (_existingItemsMap[item.categoryId] == true) {
        _deletedCategoryIds.add(item.categoryId);
      }
      _scrapItems.removeAt(index);
    });
  }

  // Method to pick image
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _isAnalyzingImage = true;
        _aiRecognitionData = null;
        _recognizedImageUrl = null;
      });

      await _analyzeImageWithAI();
    }
  }

  // Method to analyze image with AI
  Future<void> _analyzeImageWithAI() async {
    if (_selectedImage == null) return;

    try {
      final uploadNotifier = ref.read(uploadViewModelProvider.notifier);
      final Uint8List bytes = await _selectedImage!.readAsBytes();
      final fileName = _selectedImage!.path.split('/').last;

      await uploadNotifier.recognizeScrap(bytes, fileName);

      final uploadState = ref.read(uploadViewModelProvider);

      if (uploadState.recognizeScrapResponse != null) {
        final aiResponse = uploadState.recognizeScrapResponse!;

        final categories =
            ref.read(scrapCategoryViewModelProvider).listData?.data ?? [];
        final matchedCategory = categories.where((cat) {
          final categoryLower = cat.categoryName.toLowerCase();
          final aiCategoryLower = aiResponse.category.toLowerCase();
          return categoryLower.contains(aiCategoryLower) ||
              aiCategoryLower.contains(categoryLower);
        }).firstOrNull;

        // Generate AI suggested description from estimatedAmount and advice
        String? suggestedDesc;
        if (aiResponse.estimatedAmount.isNotEmpty) {
          suggestedDesc = aiResponse.estimatedAmount;
          if (aiResponse.advice.isNotEmpty) {
            suggestedDesc += '. ${aiResponse.advice}';
          }
        } else if (aiResponse.advice.isNotEmpty) {
          suggestedDesc = aiResponse.advice;
        }

        setState(() {
          _isAnalyzingImage = false;
          _recognizedImageUrl = aiResponse.savedImageUrl;
          _aiRecognitionData = {
            'categoryId': matchedCategory?.scrapCategoryId,
            'itemName': aiResponse.itemName,
            'category': aiResponse.category,
          };
          _aiSuggestedDescription = suggestedDesc;

          if (matchedCategory != null) {
            _selectedCategoryId = matchedCategory.scrapCategoryId;
          }
        });
      } else {
        setState(() {
          _isAnalyzingImage = false;
          _recognizedImageUrl = null;
          _aiRecognitionData = null;
        });
        if (mounted) {
          CustomToast.show(
            context,
            S.of(context)!.ai_cannot_analyze_update,
            type: ToastType.warning,
          );
        }
      }
    } catch (e) {
      setState(() {
        _isAnalyzingImage = false;
        _recognizedImageUrl = null;
        _aiRecognitionData = null;
      });
      debugPrint('❌ ERROR ANALYZING IMAGE: $e');
      if (mounted) {
        CustomToast.show(
          context,
          S.of(context)!.ai_connect_error,
          type: ToastType.warning,
        );
      }
    }
  }

  // Method to handle adding item
  void _handleAddItem() {
    if (_selectedImage == null) {
      CustomToast.show(
        context,
        S.of(context)!.please_select_image,
        type: ToastType.error,
      );
      return;
    }

    if (_selectedCategoryId == null) {
      CustomToast.show(
        context,
        S.of(context)!.please_select_category,
        type: ToastType.error,
      );
      return;
    }

    if (!_itemFormKey.currentState!.validate()) {
      return;
    }

    final exists = _scrapItems.any(
      (item) => item.categoryId == _selectedCategoryId,
    );
    if (exists) {
      CustomToast.show(
        context,
        S.of(context)!.error_category_exists,
        type: ToastType.error,
      );
      return;
    }

    final categoryName = ref
        .read(scrapCategoryViewModelProvider)
        .listData!
        .data
        .firstWhere((cat) => cat.scrapCategoryId == _selectedCategoryId)
        .categoryName;

    setState(() {
      _scrapItems.add(
        ScrapItemData(
          categoryId: _selectedCategoryId!,
          categoryName: categoryName,
          amountDescription: _amountDescriptionController.text.trim(),
          imageUrl: _recognizedImageUrl,
          imageFile: _recognizedImageUrl == null ? _selectedImage : null,
          aiData: _aiRecognitionData,
        ),
      );
      // New item is not marked as existing
      // _existingItemsMap[_selectedCategoryId!] = false; // Not needed, defaults to false

      // Reset form
      _selectedCategoryId = null;
      _amountDescriptionController.clear();
      _selectedImage = null;
      _recognizedImageUrl = null;
      _aiRecognitionData = null;
      _aiSuggestedDescription = null;
      _isAnalyzingImage = false;
      _itemFormKey.currentState!.reset();
    });

    CustomToast.show(
      context,
      S.of(context)!.item_added_success,
      type: ToastType.success,
    );
  }

  /// BATCH UPLOAD: Upload all new images (only File, no URL yet)
  Future<bool> _uploadPendingImages() async {
    final uploadNotifier = ref.read(uploadViewModelProvider.notifier);

    try {
      final itemsNeedUpload = _scrapItems
          .where((item) => item.needsUpload)
          .toList();

      if (itemsNeedUpload.isEmpty) {
        return true; // Nothing to upload
      }

      for (int i = 0; i < itemsNeedUpload.length; i++) {
        final item = itemsNeedUpload[i];
        final file = item.imageFile!;

        final fileName = file.path.split('/').last;
        final contentType = "image/${fileName.split('.').last}";

        await uploadNotifier.requestUploadUrlForScrapPost(
          UploadFileRequest(fileName: fileName, contentType: contentType),
        );

        final uploadState = ref.read(uploadViewModelProvider);
        if (uploadState.uploadUrl == null) {
          if (!mounted) return false;
          throw Exception(S.of(context)!.error_get_upload_url);
        }

        final Uint8List bytes = await file.readAsBytes();
        await uploadNotifier.uploadBinary(
          uploadUrl: uploadState.uploadUrl!.uploadUrl,
          fileBytes: bytes,
          contentType: contentType,
        );

        // Update item with uploaded URL
        final itemIndex = _scrapItems.indexOf(item);
        setState(() {
          _scrapItems[itemIndex] = item.copyWith(
            imageUrl: uploadState.uploadUrl!.filePath,
            imageFile: null,
          );
        });
      }

      return true;
    } catch (e, st) {
      debugPrint('❌ ERROR UPLOADING IMAGES: $e');
      debugPrint('📌 STACK TRACE: $st');
      if (!mounted) return false;
      CustomToast.show(
        context,
        S.of(context)!.error_upload_image(e.toString()),
        type: ToastType.error,
      );
      return false;
    }
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

    // If location not reset (user didn't edit address),
    // we need old location or search again. Here we assume search again for accuracy.
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

    // Start loading
    setState(() => _isSubmitting = true);

    try {
      // BATCH UPLOAD: Upload all new images before updating post
      final uploadSuccess = await _uploadPendingImages();
      if (!uploadSuccess) {
        setState(() => _isSubmitting = false);
        return; // Upload error, stop
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
        final deleted = await vm.deleteDetail(
          postId: _postId,
          categoryId: catId,
        );
        if (!deleted) allSuccess = false;
      }

      for (int i = 0; i < _scrapItems.length; i++) {
        final item = _scrapItems[i];
        final detailEntity = ScrapPostDetailEntity(
          scrapCategoryId: item.categoryId,
          amountDescription: item.amountDescription,
          // All images already uploaded in previous step
          imageUrl: item.imageUrl ?? "https://placeholder.com/default.jpg",
          status: PostDetailStatus.available.name,
        );

        if (_existingItemsMap[item.categoryId] == true) {
          // Only update if this item was modified
          if (_modifiedItemIndices.contains(i)) {
            final updated = await vm.updateDetail(
              postId: _postId,
              detail: detailEntity,
            );
            if (!updated) allSuccess = false;
          }
        } else {
          // Create Detail (new items)
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
            ref.read(scrapPostViewModelProvider).errorMessage ??
            s.error_general;
        CustomToast.show(context, errorMsg, type: ToastType.error);
      }
    } finally {
      // Stop loading
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final categoryState = ref.watch(scrapCategoryViewModelProvider);
    final categories = categoryState.listData?.data ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text("${S.of(context)!.update} ${S.of(context)!.post}"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _isSubmitting ? null : () => context.pop(),
        ),
      ),
      body: LoadingOverlay(
        isLoading: _isSubmitting,
        child: SingleChildScrollView(
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

                PostSectionTitle(title: S.of(context)!.add_scrap_items),

                SizedBox(height: spacing.screenPadding),

                // AddScrapItemSection to add new items
                AddScrapItemSection(
                  key: ValueKey(_selectedCategoryId),
                  itemFormKey: _itemFormKey,
                  selectedCategoryId: _selectedCategoryId,
                  categories: categories,
                  amountDescriptionController: _amountDescriptionController,
                  aiSuggestedDescription: _aiSuggestedDescription,
                  image: _selectedImage,
                  recognizedImageUrl: _recognizedImageUrl,
                  onPickImage: _pickImage,
                  onCategoryChange: (value) {
                    setState(() => _selectedCategoryId = value);
                  },
                  onAddItem: _handleAddItem,
                  isAnalyzing: _isAnalyzingImage,
                ),

                SizedBox(height: spacing.screenPadding),

                ScrapItemList(
                  items: _scrapItems,
                  onUpdate: (index, itemData) async {
                    final updated = await showDialog(
                      context: context,
                      builder: (_) => UpdateScrapItemDialog(
                        categories: categories
                            .map((e) => e.categoryName)
                            .toList(),
                        initialCategory: itemData.categoryName,
                        initialAmountDescription: itemData.amountDescription,
                        initialImageUrl: itemData.displayPath,
                      ),
                    );

                    if (updated != null) {
                      // Handle image: File (new) or URL (existing)
                      String? newImageUrl = itemData.imageUrl;
                      File? newImageFile;

                      if (updated['image'] is String &&
                          updated['image'] != null) {
                        final imagePath = updated['image'] as String;
                        // Check if it's a file path (new image) or URL (existing image)
                        if (imagePath.startsWith('/') ||
                            imagePath.contains('file://')) {
                          // This is a new File, save File, will upload on submit
                          newImageFile = File(imagePath);
                          newImageUrl = null; // Clear URL to trigger upload
                        } else if (imagePath.startsWith('http')) {
                          // This is existing URL, keep as is
                          newImageUrl = imagePath;
                          newImageFile = null;
                        } else {
                          // Local path without prefix
                          newImageFile = File(imagePath);
                          newImageUrl = null;
                        }
                      }

                      final matchedCat = categories.firstWhere(
                        (cat) => cat.categoryName == updated['category'],
                      );

                      setState(() {
                        _scrapItems[index] = ScrapItemData(
                          categoryId: matchedCat.scrapCategoryId,
                          categoryName: matchedCat.categoryName,
                          amountDescription: updated['amountDescription'] ?? '',
                          imageUrl: newImageUrl,
                          imageFile: newImageFile,
                        );
                        // Mark this item as modified
                        _modifiedItemIndices.add(index);
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
                    onPressed: _isSubmitting ? null : _handleUpdate,
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
      ),
    );
  }
}
