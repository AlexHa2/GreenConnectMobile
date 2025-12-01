import 'dart:io';
import 'dart:typed_data';
import 'package:GreenConnectMobile/core/helper/get_location_from_address.dart';
import 'package:GreenConnectMobile/core/helper/navigate_with_loading.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/location_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_item_data.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_detail_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/post/presentation/providers/scrap_category_providers.dart';
import 'package:GreenConnectMobile/features/post/presentation/providers/scrap_post_providers.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/add_scrap_item_section.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/ai_result_dialog.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/loading_overlay.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/post_info_form.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/post_section_title.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/scrap_item_list.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/take_all_switch.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/update_scrap_item_dialog.dart';
import 'package:GreenConnectMobile/features/upload/domain/entities/upload_request_entity.dart';
import 'package:GreenConnectMobile/features/upload/presentation/providers/upload_provider.dart';
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
  final TextEditingController _amountDescriptionController =
      TextEditingController();

  LocationEntity? _location;
  bool _addressFound = false;

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  int? _selectedCategoryId;
  final List<ScrapItemData> _scrapItems = [];

  bool _isTakeAll = false;
  bool _isSubmitting = false;

  // AI Recognition state
  bool _isAnalyzingImage = false;
  String? _recognizedImageUrl;
  Map<String, dynamic>? _aiRecognitionData;
  String? _aiSuggestedDescription;

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
      setState(() {
        _selectedImage = File(pickedFile.path);
        _isAnalyzingImage = true;
        _aiRecognitionData = null;
        _recognizedImageUrl = null;
      });

      // Call AI API immediately after image selection
      await _analyzeImageWithAI();
    }
  }

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

        // Try to match AI category with existing categories
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
          // Save imageUrl from AI response (already uploaded)
          _recognizedImageUrl = aiResponse.savedImageUrl;
          _aiRecognitionData = {
            'categoryId': matchedCategory?.scrapCategoryId,
            'itemName': aiResponse.itemName,
            'category': aiResponse.category,
            'isRecyclable': aiResponse.isRecyclable,
            'confidence': aiResponse.confidence,
            'estimatedAmount': aiResponse.estimatedAmount,
            'advice': aiResponse.advice,
          };
          _aiSuggestedDescription = suggestedDesc;

          // Auto-fill fields
          if (matchedCategory != null) {
            _selectedCategoryId = matchedCategory.scrapCategoryId;
          }
        });

        // Show AI results dialog
        if (mounted) {
          _showAIResultDialog(aiResponse);
        }
      } else {
        // AI error: Keep imageFile, allow user to enter manually
        setState(() {
          _isAnalyzingImage = false;
          _recognizedImageUrl = null; // No URL
          _aiRecognitionData = null;
        });
        if (mounted) {
          CustomToast.show(
            context,
            S.of(context)!.ai_cannot_analyze,
            type: ToastType.warning,
          );
        }
      }
    } catch (e) {
      debugPrint('❌ ERROR ANALYZE IMAGE: $e');
      setState(() => _isAnalyzingImage = false);
      if (mounted) {
        CustomToast.show(
          context,
          S.of(context)!.error_analyze_image,
          type: ToastType.error,
        );
      }
    }
  }

  void _showAIResultDialog(dynamic aiResponse) {
    showDialog(
      context: context,
      builder: (context) => AIResultDialog(aiResponse: aiResponse),
    );
  }

  void _handleAddItem() {
    // Validate required fields
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

    // Add item with ScrapItemData (can be File or URL)
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
          // If URL from AI exists, use URL; otherwise use File (will upload later)
          imageUrl: _recognizedImageUrl,
          imageFile: _recognizedImageUrl == null ? _selectedImage : null,
          aiData: _aiRecognitionData,
        ),
      );

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

  /// BATCH UPLOAD: Upload all images without URL in a single batch
  Future<bool> _uploadPendingImages() async {
    final uploadNotifier = ref.read(uploadViewModelProvider.notifier);

    try {
      // Find all items that need upload
      final itemsNeedUpload = _scrapItems
          .where((item) => item.needsUpload)
          .toList();

      if (itemsNeedUpload.isEmpty) {
        return true; // Nothing to upload
      }

      // Upload each image
      for (int i = 0; i < itemsNeedUpload.length; i++) {
        final item = itemsNeedUpload[i];
        final file = item.imageFile!;

        // Step 1: Request upload URL
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

        // Step 2: Upload binary
        final Uint8List bytes = await file.readAsBytes();
        await uploadNotifier.uploadBinary(
          uploadUrl: uploadState.uploadUrl!.uploadUrl,
          fileBytes: bytes,
          contentType: contentType,
        );

        // Step 3: Update item with uploaded URL
        final itemIndex = _scrapItems.indexOf(item);
        setState(() {
          _scrapItems[itemIndex] = item.copyWith(
            imageUrl: uploadState.uploadUrl!.filePath,
            imageFile: null, // Remove local file
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

  void _resetAllData() {
    _titleController.clear();
    _descriptionController.clear();
    _pickupAddressController.clear();
    _pickupTimeController.clear();

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

    final categoryState = ref.watch(scrapCategoryViewModelProvider);
    final categories = categoryState.listData?.data ?? [];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${S.of(context)!.create} ${S.of(context)!.recycling} ${S.of(context)!.post}",
        ),
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
                PostSectionTitle(title: S.of(context)!.add_scrap_items),
                SizedBox(height: spacing.screenPadding),
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
                      final matchedCat = categories.firstWhere(
                        (cat) => cat.categoryName == updated['category'],
                      );

                      // Handle image: File path or URL
                      String? newImageUrl;
                      File? newImageFile;

                      if (updated['image'] is String &&
                          updated['image'] != null) {
                        final imagePath = updated['image'] as String;
                        // Check if file path (starts with /) or URL (http)
                        if (imagePath.startsWith('/') ||
                            imagePath.contains('file://')) {
                          // This is a new File
                          newImageFile = File(imagePath);
                          newImageUrl = null;
                        } else if (imagePath.startsWith('http')) {
                          // This is a URL
                          newImageUrl = imagePath;
                          newImageFile = null;
                        } else {
                          // Local path without /
                          newImageFile = File(imagePath);
                          newImageUrl = null;
                        }
                      }

                      setState(() {
                        _scrapItems[index] = ScrapItemData(
                          categoryId: matchedCat.scrapCategoryId,
                          categoryName: matchedCat.categoryName,
                          amountDescription: updated['amountDescription'] ?? '',
                          imageUrl: newImageUrl,
                          imageFile: newImageFile,
                        );
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
                  onPressed: _isSubmitting
                      ? null
                      : () async {
                          final requiredMsg = S.of(context)!.error_required;
                          final emptyMsg = S
                              .of(context)!
                              .error_scrap_item_empty;
                          final successMsg = S
                              .of(context)!
                              .success_post_created;
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
                            CustomToast.show(
                              context,
                              emptyMsg,
                              type: ToastType.error,
                            );
                            return;
                          }

                          if (_location == null) {
                            CustomToast.show(
                              context,
                              S.of(context)!.error_invalid_address,
                              type: ToastType.error,
                            );
                            return;
                          }

                          // Start loading
                          setState(() => _isSubmitting = true);

                          try {
                            final vm = ref.read(
                              scrapPostViewModelProvider.notifier,
                            );

                            // BATCH UPLOAD: Upload all images without URL before creating post
                            final uploadSuccess = await _uploadPendingImages();
                            if (!uploadSuccess) {
                              setState(() => _isSubmitting = false);
                              return; // Upload error, stop
                            }

                            final post = ScrapPostEntity(
                              title: _titleController.text.trim(),
                              description: _descriptionController.text.trim(),
                              address: _pickupAddressController.text.trim(),
                              availableTimeRange: _pickupTimeController.text
                                  .trim(),
                              scrapPostDetails: _scrapItems
                                  .map(
                                    (item) => ScrapPostDetailEntity(
                                      scrapCategoryId: item.categoryId,
                                      amountDescription: item.amountDescription,
                                      imageUrl:
                                          item.imageUrl ??
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
                                navigateWithLoading(
                                  context,
                                  route: '/list-post',
                                );
                              }
                            } else {
                              if (!mounted || !context.mounted) return;
                              CustomToast.show(
                                context,
                                "$generalMsg ${S.of(context)!.error_scrap_category}",
                                type: ToastType.error,
                              );
                            }
                          } finally {
                            // Stop loading
                            if (mounted) {
                              setState(() => _isSubmitting = false);
                            }
                          }
                        },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
