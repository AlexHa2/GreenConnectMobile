import 'dart:io';
import 'dart:typed_data';

import 'package:GreenConnectMobile/core/enum/scrap_post_detail_type.dart';
import 'package:GreenConnectMobile/core/helper/format_date.dart';
import 'package:GreenConnectMobile/core/helper/get_location_from_address.dart';
import 'package:GreenConnectMobile/core/helper/navigate_with_loading.dart';
import 'package:GreenConnectMobile/core/helper/string_helper.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/analyze_scrap_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/location_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_category_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_item_data.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_detail_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/time_slot.dart';
import 'package:GreenConnectMobile/features/post/presentation/providers/scrap_category_providers.dart';
import 'package:GreenConnectMobile/features/post/presentation/providers/scrap_post_providers.dart';
import 'package:GreenConnectMobile/features/post/presentation/viewmodels/states/scrap_post_state.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/add_item_bottom_sheet.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/add_time_slot_bottom_sheet.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/create_post_header.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/loading_overlay.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/post_info_form.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/review_page.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/scrap_item_list.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/time_slot_list.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/update_scrap_item_dialog.dart';
import 'package:GreenConnectMobile/features/upload/domain/entities/upload_request_entity.dart';
import 'package:GreenConnectMobile/features/upload/presentation/providers/upload_provider.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/address_picker_bottom_sheet.dart';
import 'package:GreenConnectMobile/shared/widgets/button_gradient.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class CreateRecyclingPostWithAIPage extends ConsumerStatefulWidget {
  const CreateRecyclingPostWithAIPage({super.key});

  @override
  ConsumerState<CreateRecyclingPostWithAIPage> createState() =>
      _CreateRecyclingPostWithAIPageState();
}

class _CreateRecyclingPostWithAIPageState
    extends ConsumerState<CreateRecyclingPostWithAIPage> {
  // ===== Constants =====
  static const int _stepCount = 4;
  static const Duration _pageTransitionDuration = Duration(milliseconds: 260);
  static const Duration _controllerDisposeDelay = Duration(milliseconds: 300);
  static const int _maxDaysAheadForDatePicker = 30;

  // ===== Form State =====
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _pickupAddressController =
      TextEditingController();

  LocationEntity? _location;
  bool _addressFound = false;
  bool _isTakeAll = false;
  bool _isSubmitting = false;
  String? _addressError;

  // ===== Step State =====
  int _currentStep = 0;
  late final PageController _pageController;

  // ===== Data State =====
  final List<TimeSlotEntity> _timeSlots = [];
  final List<ScrapItemData> _scrapItems = [];

  // ===== AI State =====
  File? _aiAnalyzeImage;
  bool _isAIFilled = false;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentStep);

    Future.microtask(() {
      ref
          .read(scrapCategoryViewModelProvider.notifier)
          .fetchScrapCategories(pageNumber: 1, pageSize: 50);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _pickupAddressController.dispose();
    super.dispose();
  }

  /// Extract fileName from full URL
  /// Example: https://api.com/scraps/uuid/file.jpg -> scraps/uuid/file.jpg
  String _extractFileNameFromUrl(String url) {
    if (url.isEmpty) return '';
    if (url.startsWith('scraps/')) return url;

    final uri = Uri.tryParse(url);
    if (uri != null && uri.pathSegments.isNotEmpty) {
      final scrapsIndex = uri.pathSegments.indexOf('scraps');
      if (scrapsIndex != -1) {
        return uri.pathSegments.sublist(scrapsIndex).join('/');
      }
      return uri.pathSegments.join('/');
    }
    return url;
  }

  bool _isOverlapping(TimeSlotEntity a, TimeSlotEntity b) {
    if (!_isSameDay(a.date, b.date)) return false;

    final aStart = _timeToMinutes(a.startTime);
    final aEnd = _timeToMinutes(a.endTime);
    final bStart = _timeToMinutes(b.startTime);
    final bEnd = _timeToMinutes(b.endTime);
    return aStart < bEnd && bStart < aEnd;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  int _timeToMinutes(TimeOfDay time) => time.hour * 60 + time.minute;

  bool _isInvalidTimeRange(TimeOfDay start, TimeOfDay end) {
    return end.hour < start.hour ||
        (end.hour == start.hour && end.minute <= start.minute);
  }

  void _handleAddTimeSlot(
    DateTime date,
    TimeOfDay startTime,
    TimeOfDay endTime,
    S s,
  ) {
    if (_isInvalidTimeRange(startTime, endTime)) {
      CustomToast.show(context, s.time_slot_required, type: ToastType.error);
      return;
    }

    final newSlot = TimeSlotEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: date,
      startTime: startTime,
      endTime: endTime,
    );

    if (_timeSlots.any((slot) => _isOverlapping(slot, newSlot))) {
      CustomToast.show(context, s.time_slot_required, type: ToastType.error);
      return;
    }

    setState(() => _timeSlots.add(newSlot));
    // Bottom sheet will pop itself, no need to pop here
  }

  // ========= UX: Address Picker =========

  Future<void> _openAddressPicker() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddressPickerBottomSheet(
        initialAddress: _pickupAddressController.text.trim(),
        onAddressSelected: _handleAddressSelected,
      ),
    );
  }

  Future<void> _handleAddressSelected(
    String address,
    double? latitude,
    double? longitude,
  ) async {
    setState(() => _pickupAddressController.text = address);

    if (latitude != null && longitude != null) {
      _updateLocation(
        LocationEntity(latitude: latitude, longitude: longitude),
        found: true,
      );
    } else {
      final loc = await getLocationFromAddress(address);
      _updateLocation(loc, found: loc != null);
    }
  }

  void _updateLocation(LocationEntity? location, {required bool found}) {
    setState(() {
      _location = location;
      _addressFound = found;
      // Clear address error when location is updated
      if (found && location != null) {
        _addressError = null;
      }
    });
  }

  // ========= AI: Image Upload & Analysis =========

  Future<void> _pickImageForAI() async {
    final s = S.of(context)!;
    try {
      final XFile? pickedFile =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _aiAnalyzeImage = File(pickedFile.path);
          _isAIFilled = false;
        });
        await _analyzeImageWithAI();
      }
    } catch (e) {
      if (!mounted) return;
      CustomToast.show(
        context,
        s.error_general,
        type: ToastType.error,
      );
    }
  }

  Future<void> _analyzeImageWithAI() async {
    if (_aiAnalyzeImage == null) return;

    final s = S.of(context)!;
    final vm = ref.read(scrapPostViewModelProvider.notifier);

    try {
      final imageBytes = await _aiAnalyzeImage!.readAsBytes();
      final fileName = _aiAnalyzeImage!.path.split('/').last;

      final result = await vm.analyzeScrap(
        imageBytes: imageBytes,
        fileName: fileName,
      );

      if (!mounted) return;

      if (result != null) {
        _applyAnalyzeResult(result, s);
        CustomToast.show(
          context,
          s.ai_analyzing_success,
          type: ToastType.success,
        );
      } else {
        final errorState = ref.read(scrapPostViewModelProvider);
        final errorMsg = errorState.errorMessage ?? s.error_general;
        CustomToast.show(
          context,
          errorMsg,
          type: ToastType.error,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('❌ [AI ANALYZE] Exception: $e');
      debugPrint('📌 [AI ANALYZE] Stack: $stackTrace');
      if (!mounted) return;
      CustomToast.show(
        context,
        s.error_general,
        type: ToastType.error,
      );
    }
  }

  void _applyAnalyzeResult(AnalyzeScrapResultEntity result, S s) {
    final categories =
        ref.read(scrapCategoryViewModelProvider).listData?.data ?? [];

    setState(() {
      // Auto-fill title if not empty
      if (result.suggestedTitle.isNotEmpty &&
          _titleController.text.trim().isEmpty) {
        _titleController.text = result.suggestedTitle;
      }

      // Auto-fill description if not empty
      if (result.suggestedDescription.isNotEmpty &&
          _descriptionController.text.trim().isEmpty) {
        _descriptionController.text = result.suggestedDescription;
      }

      // Convert identified items to ScrapItemData
      if (result.identifiedItems.isNotEmpty) {
        final newItems = _convertIdentifiedItemsToScrapItems(
          result.identifiedItems,
          categories,
          savedImageFilePath: result.savedImageFilePath,
        );
        _scrapItems.addAll(newItems);
        // Auto set isTakeAll to false if items <= 1
        if (_scrapItems.length <= 1) {
          _isTakeAll = false;
        }
      }

      _isAIFilled = true;
    });
  }

  List<ScrapItemData> _convertIdentifiedItemsToScrapItems(
    List<AnalyzeScrapItemEntity> identifiedItems,
    List<ScrapCategoryEntity> categories, {
    String? savedImageFilePath,
  }) {
    final List<ScrapItemData> scrapItems = [];

    for (final item in identifiedItems) {
      // Try to find matching category
      ScrapCategoryEntity? matchedCategory;
      if (item.suggestedCategoryId != null && categories.isNotEmpty) {
        try {
          matchedCategory = categories.firstWhere(
            (cat) => cat.scrapCategoryId == item.suggestedCategoryId,
          );
        } catch (e) {
          // Category not found, will use fallback
        }
      } else if (item.categoryName != null && categories.isNotEmpty) {
        try {
          matchedCategory = categories.firstWhere(
            (cat) =>
                cat.categoryName.toLowerCase() ==
                item.categoryName!.toLowerCase(),
          );
        } catch (e) {
          // Category not found, will use fallback
        }
      }

      // Skip if no category found and no categories available
      if (categories.isEmpty) continue;
      matchedCategory ??= categories.first;

      // Build amount description
      String amountDescription = item.itemName;
      if (item.estimatedQuantity != null) {
        amountDescription += ' - ${item.estimatedQuantity}';
        if (item.unit != null && item.unit!.isNotEmpty) {
          amountDescription += ' ${item.unit}';
        }
      }

      // For UI display: use full URL from item.imageUrl
      // For API submission: use savedImageFilePath if available and user hasn't changed
      String? imageUrlForDisplay; // Full URL for UI display
      File? imageFile;
      String? savedFilePath; // File path for API submission

      // Priority: item.imageUrl (full URL) > original picked image
      if (item.imageUrl != null && item.imageUrl!.isNotEmpty) {
        // Use full URL from AI response for UI display
        imageUrlForDisplay = item.imageUrl;
        imageFile = null;
        // Store savedImageFilePath for API submission if available
        if (savedImageFilePath != null && savedImageFilePath.isNotEmpty) {
          savedFilePath = savedImageFilePath;
        }
      } else {
        // Fallback to original picked image
        imageUrlForDisplay = null;
        imageFile = _aiAnalyzeImage;
        savedFilePath = null;
      }

      // Create ScrapItemData
      scrapItems.add(
        ScrapItemData(
          categoryId: matchedCategory.scrapCategoryId,
          categoryName: matchedCategory.categoryName,
          amountDescription:
              StringHelper.truncateForVarchar255(amountDescription),
          type: ScrapPostDetailType
              .sale, // Default to sale, user can change later
          imageFile: imageFile,
          imageUrl: imageUrlForDisplay, // Full URL for UI display
          aiData: {
            'itemName': item.itemName,
            'confidence': item.confidence,
            'estimatedQuantity': item.estimatedQuantity,
            'unit': item.unit,
            'savedImageFilePath': savedFilePath, // Store for API submission
          },
        ),
      );
    }

    return scrapItems;
  }

  // ========= Custom Stepper Navigation =========

  Future<void> _jumpToStep(int step) async {
    if (step == _currentStep) return;

    // Only allow jump forward if all prior steps valid
    if (step > _currentStep && !_validateStepsRange(_currentStep, step)) {
      return;
    }

    setState(() => _currentStep = step);
    await _pageController.animateToPage(
      step,
      duration: _pageTransitionDuration,
      curve: Curves.easeOut,
    );
  }

  bool _validateStepsRange(int from, int to) {
    for (int s = from; s < to; s++) {
      if (!_validateStep(s, showToast: true)) return false;
    }
    return true;
  }

  Future<void> _next() async {
    if (!_validateStep(_currentStep, showToast: true)) return;
    if (_currentStep >= _stepCount - 1) return;
    await _jumpToStep(_currentStep + 1);
  }

  Future<void> _back() async {
    if (_currentStep <= 0) return;
    await _jumpToStep(_currentStep - 1);
  }

  bool _validateStep(int step, {required bool showToast}) {
    switch (step) {
      case 0:
        return _validatePostInfoStep(showToast);
      case 1:
        return _validateTimeSlotsStep(showToast);
      case 2:
        return _validateScrapItemsStep(showToast);
      case 3:
        return true;
      default:
        return false;
    }
  }

  bool _validatePostInfoStep(bool showToast) {
    final s = S.of(context)!;

    // Trigger form validation to show red errors on fields
    _formKey.currentState?.validate();

    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final address = _pickupAddressController.text.trim();

    final titleError = _validateTitle(title, s);
    final descError = _validateDescription(description, s);
    final addressError = _validateAddress(address, s);

    // Update address error state
    String? newAddressError;
    if (addressError != null) {
      newAddressError = addressError;
    } else if (address.isNotEmpty && (_location == null || !_addressFound)) {
      newAddressError = s.error_invalid_address;
    } else {
      newAddressError = null;
    }

    setState(() {
      _addressError = newAddressError;
    });

    if (titleError != null || descError != null || addressError != null) {
      if (showToast) {
        final errorMsg =
            titleError ?? descError ?? addressError ?? s.error_required;
        CustomToast.show(context, errorMsg, type: ToastType.error);
      }
      return false;
    }

    if (_location == null || !_addressFound) {
      if (showToast) {
        CustomToast.show(
          context,
          s.error_invalid_address,
          type: ToastType.error,
        );
      }
      return false;
    }
    return true;
  }

  String? _validateTitle(String title, S s) {
    if (title.isEmpty) return s.error_required;
    if (title.length < 3) return s.error_post_title_min;
    return null;
  }

  String? _validateDescription(String description, S s) {
    if (description.isEmpty) return s.error_required;
    if (description.length < 10) return s.error_description_min;
    return null;
  }

  String? _validateAddress(String address, S s) {
    if (address.isEmpty) return s.error_required;
    return null;
  }

  bool _validateTimeSlotsStep(bool showToast) {
    final s = S.of(context)!;

    if (_timeSlots.isEmpty) {
      if (showToast) {
        CustomToast.show(context, s.time_slot_required, type: ToastType.error);
      }
      return false;
    }

    if (_hasInvalidTimeRanges()) {
      if (showToast) {
        CustomToast.show(context, s.time_slot_required, type: ToastType.error);
      }
      return false;
    }

    if (_hasOverlappingTimeSlots()) {
      if (showToast) {
        CustomToast.show(context, s.time_slot_required, type: ToastType.error);
      }
      return false;
    }

    return true;
  }

  bool _hasInvalidTimeRanges() {
    return _timeSlots.any(
      (slot) =>
          slot.endTime.hour < slot.startTime.hour ||
          (slot.endTime.hour == slot.startTime.hour &&
              slot.endTime.minute <= slot.startTime.minute),
    );
  }

  bool _hasOverlappingTimeSlots() {
    for (int i = 0; i < _timeSlots.length; i++) {
      for (int j = i + 1; j < _timeSlots.length; j++) {
        if (_isOverlapping(_timeSlots[i], _timeSlots[j])) {
          return true;
        }
      }
    }
    return false;
  }

  bool _validateScrapItemsStep(bool showToast) {
    final s = S.of(context)!;
    if (_scrapItems.isEmpty) {
      if (showToast) {
        CustomToast.show(
          context,
          s.error_scrap_item_empty,
          type: ToastType.error,
        );
      }
      return false;
    }
    return true;
  }

  // ========= UX: Add Time Slot Sheet =========

  Future<void> _showAddTimeSlotSheet() async {
    final s = S.of(context)!;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => AddTimeSlotBottomSheet(
        onAdd: (date, startTime, endTime) {
          _handleAddTimeSlot(date, startTime, endTime, s);
        },
        isInvalidTimeRange: _isInvalidTimeRange,
        maxDaysAhead: _maxDaysAheadForDatePicker,
      ),
    );
  }

  // ========= UX: Add Item Sheet =========

  Future<void> _showAddItemSheet(List<ScrapCategoryEntity> categories) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => AddItemBottomSheet(
        categories: categories,
        onAdd: ({
          required String categoryId,
          required ScrapPostDetailType type,
          required File imageFile,
          required String amountText,
        }) {
          final s = S.of(context)!;
          _addScrapItem(
            categories: categories,
            categoryId: categoryId,
            type: type,
            imageFile: imageFile,
            amountText: amountText,
            s: s,
          );
        },
        hasCategoryExists: _hasCategoryExists,
        controllerDisposeDelay: _controllerDisposeDelay,
      ),
    );
  }

  // ========= Post Submission Helpers =========

  int? _findFirstInvalidStep() {
    for (int i = 0; i < _stepCount - 1; i++) {
      if (!_validateStep(i, showToast: false)) return i;
    }
    return null;
  }

  ScrapPostEntity _buildScrapPostEntity(S s) {
    const defaultImageUrl =
        "https://media.vietnamplus.vn/images/fbc23bef0d088b23a8965bce49f85a61cd286afccaf9606b44256f5d7ef5d5fefff6aa780c9464f6499f791f5dd6f3de1d175058d9a59d4e21100ddb41c54c45/ngaymoitruong_12.jpg";

    return ScrapPostEntity(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      address: _pickupAddressController.text.trim(),
      availableTimeRange: 'từ thứ 2 đến thứ 6 các giờ trong tuần',
      scrapPostDetails: _scrapItems.map((item) {
        String finalImageUrl;

        // Check if item has savedImageFilePath from AI and user hasn't changed it
        final savedFilePath = item.aiData?['savedImageFilePath'] as String?;
        final hasChangedImage =
            item.imageFile != null; // User changed if imageFile exists

        if (savedFilePath != null &&
            savedFilePath.isNotEmpty &&
            !hasChangedImage) {
          // Use savedImageFilePath directly for API submission
          finalImageUrl = savedFilePath;
        } else if (item.imageUrl != null && item.imageUrl!.isNotEmpty) {
          // If imageUrl is a full URL, extract the filename
          if (item.imageUrl!.startsWith('http://') ||
              item.imageUrl!.startsWith('https://')) {
            // Full URL - extract filename
            finalImageUrl = _extractFileNameFromUrl(item.imageUrl!);
          } else {
            // File path (e.g., "scrap-posts/ai_scan_xxx.jpg") - use directly
            finalImageUrl = item.imageUrl!;
          }
        } else {
          finalImageUrl = defaultImageUrl;
        }

        // Debug: Log type to ensure it's correct
        debugPrint(
            '📝 [SUBMIT] Item type: ${item.type.name} -> ${item.type.toJson()}');

        // Capitalize first letter of type (e.g., "sale" -> "Sale")
        final typeString = item.type.toJson();
        final capitalizedType = typeString.isNotEmpty
            ? typeString[0].toUpperCase() + typeString.substring(1)
            : typeString;

        return ScrapPostDetailEntity(
          scrapCategoryId: item.categoryId,
          amountDescription: item.amountDescription,
          imageUrl: finalImageUrl,
          type: capitalizedType,
        );
      }).toList(),
      mustTakeAll: _isTakeAll,
      location: _location!,
      scrapPostTimeSlots: _timeSlots.map((slot) {
        return ScrapPostTimeSlotEntity(
          specificDate: formatDateOnly(slot.date),
          startTime: formatTimeOfDay(slot.startTime),
          endTime: formatTimeOfDay(slot.endTime),
        );
      }).toList(),
    );
  }

  // ========= BATCH UPLOAD =========

  Future<bool> _uploadPendingImages() async {
    final uploadNotifier = ref.read(uploadViewModelProvider.notifier);

    try {
      final itemsNeedUpload =
          _scrapItems.where((item) => item.imageFile != null).toList();

      if (itemsNeedUpload.isEmpty) return true;

      for (final item in itemsNeedUpload) {
        final success = await _uploadSingleImage(item, uploadNotifier);
        if (!success) return false;
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

  Future<bool> _uploadSingleImage(
    ScrapItemData item,
    dynamic uploadNotifier,
  ) async {
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

    final itemIndex = _scrapItems.indexOf(item);
    setState(() {
      _scrapItems[itemIndex] = item.copyWith(
        imageUrl: uploadState.uploadUrl!.filePath,
        imageFile: null,
      );
    });

    return true;
  }

  // ========= Item Validation & Creation =========

  bool _hasCategoryExists(String categoryId) {
    return _scrapItems.any((item) => item.categoryId == categoryId);
  }

  ({File? file, String? url}) _parseImageUpdate(dynamic image) {
    if (image is! String || image.isEmpty) {
      return (file: null, url: null);
    }

    if (image.startsWith('/') || image.contains('file://')) {
      return (file: File(image), url: null);
    } else if (image.startsWith('http')) {
      return (file: null, url: image);
    } else {
      return (file: File(image), url: null);
    }
  }

  void _addScrapItem({
    required List<ScrapCategoryEntity> categories,
    required String categoryId,
    required ScrapPostDetailType type,
    required File imageFile,
    required String amountText,
    required S s,
  }) {
    final categoryName = categories
        .firstWhere((c) => c.scrapCategoryId == categoryId)
        .categoryName;

    setState(() {
      _scrapItems.add(
        ScrapItemData(
          categoryId: categoryId,
          categoryName: categoryName,
          amountDescription: StringHelper.truncateForVarchar255(amountText),
          type: type,
          imageUrl: null,
          imageFile: imageFile,
        ),
      );
      // Auto set isTakeAll to false if items <= 1
      if (_scrapItems.length <= 1) {
        _isTakeAll = false;
      }
    });

    CustomToast.show(context, s.item_added_success, type: ToastType.success);
  }

  // ========= RESET =========

  void _resetAllData() {
    _titleController.clear();
    _descriptionController.clear();
    _pickupAddressController.clear();

    setState(() {
      _scrapItems.clear();
      _timeSlots.clear();
      _location = null;
      _addressFound = false;
      _isTakeAll = false;
      _currentStep = 0;
      _aiAnalyzeImage = null;
      _isAIFilled = false;
      _addressError = null;
    });

    _formKey.currentState?.reset();

    _pageController.jumpToPage(0);
  }

  // ========= SUBMIT =========

  Future<void> _submitPost() async {
    final s = S.of(context)!;
    final firstFailedStep = _findFirstInvalidStep();

    if (firstFailedStep != null) {
      _validateStep(firstFailedStep, showToast: true);
      await _jumpToStep(firstFailedStep);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      if (!await _uploadPendingImages()) {
        setState(() => _isSubmitting = false);
        return;
      }

      final post = _buildScrapPostEntity(s);
      final vm = ref.read(scrapPostViewModelProvider.notifier);
      final success = await vm.createPost(post: post);

      if (!mounted || !context.mounted) return;

      if (success) {
        _resetAllData();
        CustomToast.show(
          context,
          s.success_post_created,
          type: ToastType.success,
        );
        if (context.mounted) {
          navigateWithLoading(context, route: '/household-list-post');
        }
      } else {
        CustomToast.show(
          context,
          "${s.error_general} ${s.error_scrap_category}",
          type: ToastType.error,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('❌ [SUBMIT] Exception occurred: $e');
      debugPrint('📌 [SUBMIT] Stack trace: $stackTrace');
      rethrow;
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  // ========= UI Building Blocks =========

  PreferredSizeWidget _buildAppBar() {
    final s = S.of(context)!;

    return AppBar(
      title: Text('${s.create} ${s.recycling} ${s.post}'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: _isSubmitting ? null : () => context.pop(),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : _resetAllData,
          child: Text(s.cancel),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final s = S.of(context)!;

    final isLast = _currentStep == _stepCount - 1;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          spacing.screenPadding,
          spacing.screenPadding * 0.625,
          spacing.screenPadding,
          spacing.screenPadding * 0.75,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSubmitting ? null : _back,
                      child: Text(s.back),
                    ),
                  )
                else
                  const Expanded(child: SizedBox.shrink()),
                SizedBox(width: spacing.screenPadding * 0.75),
                Expanded(
                  child: GradientButton(
                    onPressed:
                        _isSubmitting ? null : (isLast ? _submitPost : _next),
                    child: Text(isLast ? s.create : s.next),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ========= UI: AI Image Upload Section =========

  Widget _buildAIImageUploadSection(
    ThemeData theme,
    AppSpacing spacing,
    S s,
    bool isAnalyzing,
    ScrapPostState scrapPostState,
  ) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(spacing.screenPadding * 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  size: 20,
                  color: theme.primaryColor,
                ),
                SizedBox(width: spacing.screenPadding / 2),
                Text(
                  s.ai_analysis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.primaryColor,
                  ),
                ),
                if (_isAIFilled) ...[
                  SizedBox(width: spacing.screenPadding / 2),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: spacing.screenPadding / 2,
                      vertical: spacing.screenPadding / 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      s.ai_filled,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: spacing.screenPadding),
            if (_aiAnalyzeImage == null)
              InkWell(
                onTap: _isSubmitting || isAnalyzing ? null : _pickImageForAI,
                borderRadius: BorderRadius.circular(spacing.screenPadding),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(spacing.screenPadding * 1.5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.dividerColor,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(spacing.screenPadding),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 48,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(height: spacing.screenPadding / 2),
                      Text(
                        s.upload_image_for_ai_analysis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: spacing.screenPadding / 4),
                      Text(
                        s.ai_will_analyze_and_auto_fill,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(spacing.screenPadding),
                    child: Image.file(
                      _aiAnalyzeImage!,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (isAnalyzing)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.dividerColor.withValues(alpha: 0.9),
                          borderRadius:
                              BorderRadius.circular(spacing.screenPadding),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Progress indicator with value
                              SizedBox(
                                width: 60,
                                height: 60,
                                child: CircularProgressIndicator(
                                  value: scrapPostState.analyzeProgress > 0
                                      ? scrapPostState.analyzeProgress
                                      : null,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    theme.primaryColor,
                                  ),
                                  backgroundColor:
                                      theme.primaryColor.withValues(alpha: 0.2),
                                  strokeWidth: 4,
                                ),
                              ),
                              SizedBox(height: spacing.screenPadding / 2),
                              // Progress percentage
                              Text(
                                '${(scrapPostState.analyzeProgress * 100).toStringAsFixed(0)}%',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: spacing.screenPadding / 4),
                              Text(
                                s.analyzing,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.scaffoldBackgroundColor
                                      .withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // ========= Pages (Steps) =========

  Widget _pageContainer({required Widget child}) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        spacing.screenPadding,
        spacing.screenPadding,
        spacing.screenPadding,
        spacing.screenPadding,
      ),
      child: child,
    );
  }

  // ignore: non_constant_identifier_names
  Widget _buildStep0_PostInfo() {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final s = S.of(context)!;
    final scrapPostState = ref.watch(scrapPostViewModelProvider);
    final isAnalyzing = scrapPostState.isAnalyzing;

    return _pageContainer(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          // AI Image Upload Section
          _buildAIImageUploadSection(
            theme,
            spacing,
            s,
            isAnalyzing,
            scrapPostState,
          ),
          SizedBox(height: spacing.screenPadding),
          Form(
            key: _formKey,
            child: PostInfoForm(
              formKey: _formKey,
              titleController: _titleController,
              descController: _descriptionController,
              addressController: _pickupAddressController,
              onSearchAddress: () {},
              onGetCurrentLocation: _openAddressPicker,
              addressFound: _addressFound,
              addressValidationError: _addressError,
            ),
          ),
          SizedBox(height: spacing.screenPadding),
          if (_pickupAddressController.text.isNotEmpty)
            Container(
              padding: EdgeInsets.all(spacing.screenPadding),
              decoration: BoxDecoration(
                color: _addressFound && _location != null
                    ? theme.primaryColor.withValues(alpha: 0.3)
                    : AppColors.danger.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(spacing.screenPadding),
                border: Border.all(
                  color: theme.dividerColor,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _addressFound && _location != null
                        ? Icons.check_circle
                        : Icons.error_outline,
                    size: 20,
                    color: _addressFound && _location != null
                        ? theme.colorScheme.primary
                        : theme.colorScheme.error,
                  ),
                  SizedBox(width: spacing.screenPadding / 2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.pickup_address,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: spacing.screenPadding / 4),
                        Text(
                          _pickupAddressController.text,
                          style: theme.textTheme.bodyMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (!_addressFound || _location == null)
                    TextButton(
                      onPressed: _isSubmitting ? null : _openAddressPicker,
                      child: Text(s.change_address),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _buildStep1_TimeSlots() {
    return _pageContainer(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          TimeSlotList(
            timeSlots: _timeSlots,
            onAdd: _showAddTimeSlotSheet,
            onDelete: (index) => setState(() => _timeSlots.removeAt(index)),
            isSubmitting: _isSubmitting,
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _buildStep2_Items(List<ScrapCategoryEntity> categories) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final s = S.of(context)!;

    return _pageContainer(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  s.scrap_item,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              FilledButton.icon(
                onPressed: _isSubmitting
                    ? null
                    : (categories.isEmpty
                        ? null
                        : () => _showAddItemSheet(categories)),
                icon: const Icon(Icons.add, size: 20),
                label: Text(s.add),
              ),
            ],
          ),
          SizedBox(height: spacing.screenPadding),
          if (_scrapItems.isEmpty)
            Container(
              padding: EdgeInsets.all(spacing.screenPadding * 1.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(spacing.screenPadding),
                border: Border.all(
                  color: theme.dividerColor,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  SizedBox(width: spacing.screenPadding / 2),
                  Expanded(
                    child: Text(
                      s.error_scrap_item_empty,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            ScrapItemList(
              items: _scrapItems,
              onUpdate: (index, itemData) async {
                final updated = await showDialog(
                  context: context,
                  builder: (_) => UpdateScrapItemDialog(
                    categories: categories.map((e) => e.categoryName).toList(),
                    initialCategory: itemData.categoryName,
                    initialAmountDescription: itemData.amountDescription,
                    initialImageUrl: itemData.imageUrl,
                    initialImageFile: itemData.imageFile,
                    initialType: itemData.type,
                  ),
                );

                if (updated != null) {
                  final matchedCat = categories.firstWhere(
                    (cat) => cat.categoryName == updated['category'],
                  );

                  String? newImageUrl;
                  File? newImageFile;

                  // Ensure type is correctly extracted from dialog result
                  ScrapPostDetailType newType =
                      itemData.type; // Default to current type
                  if (updated['type'] != null) {
                    if (updated['type'] is ScrapPostDetailType) {
                      newType = updated['type'] as ScrapPostDetailType;
                    } else if (updated['type'] is String) {
                      // If type is returned as string, parse it
                      newType = ScrapPostDetailType.fromJson(
                        updated['type'] as String,
                      );
                    }
                  }

                  Map<String, dynamic>? newAiData = itemData.aiData;

                  if (updated['imageChanged'] == true) {
                    final imageResult = _parseImageUpdate(updated['image']);
                    newImageFile = imageResult.file;
                    newImageUrl = imageResult.url;
                    // User changed image, clear savedImageFilePath
                    if (newAiData != null) {
                      newAiData = Map<String, dynamic>.from(newAiData);
                      newAiData.remove('savedImageFilePath');
                    }
                  } else {
                    newImageUrl = itemData.imageUrl;
                    newImageFile = itemData.imageFile;
                    // Keep aiData including savedImageFilePath if user didn't change image
                  }

                  setState(() {
                    _scrapItems[index] = ScrapItemData(
                      categoryId: matchedCat.scrapCategoryId,
                      categoryName: matchedCat.categoryName,
                      amountDescription: StringHelper.truncateForVarchar255(
                        updated['amountDescription'] ?? '',
                      ),
                      type: newType,
                      imageUrl: newImageUrl,
                      imageFile: newImageFile,
                      aiData: newAiData,
                    );
                  });
                }
              },
              onDelete: (item) => setState(() {
                    _scrapItems.remove(item);
                    // Auto set isTakeAll to false if items <= 1
                    if (_scrapItems.length <= 1) {
                      _isTakeAll = false;
                    }
                  }),
            ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _buildStep3_Review() {
    // Auto set isTakeAll to false if items <= 1 when entering review step
    if (_scrapItems.length <= 1 && _isTakeAll) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => _isTakeAll = false);
        }
      });
    }

    return _pageContainer(
      child: ReviewPage(
        title: _titleController.text,
        description: _descriptionController.text,
        pickupAddress: _pickupAddressController.text,
        timeSlots: _timeSlots,
        scrapItems: _scrapItems,
        isTakeAll: _isTakeAll,
        onEditStep: _jumpToStep,
        onTakeAllChanged: (val) {
          if (_isSubmitting) return;
          setState(() => _isTakeAll = val);
        },
        isSubmitting: _isSubmitting,
      ),
    );
  }

  // ========= Build =========

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(scrapCategoryViewModelProvider);
    final categories = categoryState.listData?.data ?? [];

    return Scaffold(
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildBottomBar(),
      body: LoadingOverlay(
        isLoading: _isSubmitting,
        child: Column(
          children: [
            CreatePostHeader(
              currentStep: _currentStep,
              stepCount: _stepCount,
              onStepTap: _jumpToStep,
            ),
            Divider(height: 1, color: Theme.of(context).dividerColor),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStep0_PostInfo(),
                  _buildStep1_TimeSlots(),
                  _buildStep2_Items(categories),
                  _buildStep3_Review(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
