import 'dart:io';
import 'dart:typed_data';

import 'package:GreenConnectMobile/core/enum/post_status.dart';
import 'package:GreenConnectMobile/core/enum/scrap_post_detail_type.dart';
import 'package:GreenConnectMobile/core/helper/format_date.dart';
import 'package:GreenConnectMobile/core/helper/get_location_from_address.dart';
import 'package:GreenConnectMobile/core/helper/navigate_with_loading.dart';
import 'package:GreenConnectMobile/core/helper/string_helper.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/location_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_category_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_item_data.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_detail_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/time_slot.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/update_scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/post/presentation/providers/scrap_category_providers.dart';
import 'package:GreenConnectMobile/features/post/presentation/providers/scrap_post_providers.dart';
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

class UpdateRecyclingPostPage extends ConsumerStatefulWidget {
  final Map<String, dynamic> initialData;

  const UpdateRecyclingPostPage({super.key, required this.initialData});

  @override
  ConsumerState<UpdateRecyclingPostPage> createState() =>
      _UpdateRecyclingPostPageState();
}

class _UpdateRecyclingPostPageState
    extends ConsumerState<UpdateRecyclingPostPage> {
  // ===== Constants =====
  static const int _stepCount = 4;
  static const Duration _pageTransitionDuration = Duration(milliseconds: 260);
  static const Duration _controllerDisposeDelay = Duration(milliseconds: 300);
  static const int _maxDaysAheadForDatePicker = 30;

  // ===== Form State =====
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _pickupAddressController;

  LocationEntity? _location;
  bool _addressFound = false;
  bool _isTakeAll = false;
  bool _isSubmitting = false;
  late String _postId;

  // ===== Step State =====
  int _currentStep = 0;
  late final PageController _pageController;

  // ===== Data State =====
  final List<TimeSlotEntity> _timeSlots = [];
  // Track time slot IDs from server
  final Map<int, String> _timeSlotIdMap = {}; // index -> server id
  final List<String> _deletedTimeSlotIds = [];
  // Track original time slots for comparison
  final Map<String, ScrapPostTimeSlotEntity> _originalTimeSlots = {};

  final List<ScrapItemData> _scrapItems = [];
  // Track which items are existing (from server) vs new
  final Map<String, bool> _existingItemsMap = {};
  // Track which items have been modified and what fields changed
  final Map<int, Set<String>> _modifiedItemFields = {};
  final List<String> _deletedCategoryIds = [];

  @override
  void initState() {
    super.initState();
    _initData();
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

  void _initData() {
    final data = widget.initialData;
    _postId = (data['id'] ?? data['postId']).toString();

    _titleController = TextEditingController(text: data['title'] ?? '');
    _descriptionController =
        TextEditingController(text: data['description'] ?? '');
    _pickupAddressController =
        TextEditingController(text: data['address'] ?? '');
    _isTakeAll = data['mustTakeAll'] ?? false;

    // Load location if available
    if (data['location'] != null) {
      try {
        final loc = data['location'];
        if (loc is Map) {
          _location = LocationEntity(
            latitude: loc['latitude']?.toDouble() ?? 0.0,
            longitude: loc['longitude']?.toDouble() ?? 0.0,
          );
          _addressFound = true;
        }
      } catch (e) {
        debugPrint('Error loading location: $e');
      }
    }

    // If address exists from server but no location, assume it's valid for update
    // User can re-validate if they change the address
    if (_pickupAddressController.text.isNotEmpty && _location == null) {
      _addressFound = true; // Assume valid for existing posts
    }

    // Load time slots
    final timeSlots = data['timeSlots'];
    if (timeSlots != null && timeSlots is List) {
      for (int i = 0; i < timeSlots.length; i++) {
        final slot = timeSlots[i];
        if (slot is ScrapPostTimeSlotEntity) {
          final timeSlotEntity = _parseTimeSlotFromServer(slot);
          if (timeSlotEntity != null) {
            _timeSlots.add(timeSlotEntity);
            if (slot.id != null) {
              _timeSlotIdMap[_timeSlots.length - 1] = slot.id!;
              _originalTimeSlots[slot.id!] = slot;
            }
          }
        }
      }
    }

    // Load scrap items
    final items = data['items'];
    if (items != null) {
      for (var item in items) {
        if (item is ScrapPostDetailEntity) {
          // Parse type from server (could be "Sale", "Donation", "Service" or lowercase)
          ScrapPostDetailType itemType = ScrapPostDetailType.sale; // Default
          if (item.type.isNotEmpty) {
            try {
              itemType = ScrapPostDetailType.fromJson(item.type);
            } catch (e) {
              debugPrint('⚠️ [INIT] Failed to parse type: ${item.type}, using default');
            }
          }
          
          final itemData = ScrapItemData(
            categoryId: item.scrapCategoryId,
            categoryName: item.scrapCategory?.categoryName ??
                'Category ${item.scrapCategoryId}',
            amountDescription: item.amountDescription,
            imageUrl: item.imageUrl,
            type: itemType,
          );

          _scrapItems.add(itemData);
          _existingItemsMap[item.scrapCategoryId] = true;
        }
      }
    }
  }

  // ========= Time Slot Parsing =========

  TimeSlotEntity? _parseTimeSlotFromServer(ScrapPostTimeSlotEntity slot) {
    try {
      // Parse date: "2025-12-24"
      final dateParts = slot.specificDate.split('-');
      if (dateParts.length != 3) return null;
      final date = DateTime(
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
      );

      // Parse time: "15:03:17.808Z" or "15:03:17"
      TimeOfDay parseTime(String timeStr) {
        final cleanTime = timeStr.split('.')[0]; // Remove milliseconds
        final parts = cleanTime.split(':');
        if (parts.length >= 2) {
          return TimeOfDay(
            hour: int.parse(parts[0]),
            minute: int.parse(parts[1]),
          );
        }
        return TimeOfDay.now();
      }

      return TimeSlotEntity(
        id: slot.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        date: date,
        startTime: parseTime(slot.startTime),
        endTime: parseTime(slot.endTime),
      );
    } catch (e) {
      debugPrint('Error parsing time slot: $e');
      return null;
    }
  }

  // ========= Time Slot Helpers =========

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
    // Note: Bottom sheet is already closed by Navigator.pop() in AddTimeSlotBottomSheet
  }

  void _handleDeleteTimeSlot(int index) {
    setState(() {
      // If this time slot has a server ID, track it for deletion
      if (_timeSlotIdMap.containsKey(index)) {
        final serverId = _timeSlotIdMap[index]!;
        _deletedTimeSlotIds.add(serverId);
        _timeSlotIdMap.remove(index);
        _originalTimeSlots.remove(serverId);
      }
      _timeSlots.removeAt(index);

      // Rebuild index map
      _timeSlotIdMap.clear();
      for (int i = 0; i < _timeSlots.length; i++) {
        final slot = _timeSlots[i];
        // Find original server ID if exists
        for (final entry in _originalTimeSlots.entries) {
          if (_isTimeSlotEqual(slot, entry.value)) {
            _timeSlotIdMap[i] = entry.key;
            break;
          }
        }
      }
    });
  }

  bool _isTimeSlotEqual(TimeSlotEntity local, ScrapPostTimeSlotEntity server) {
    try {
      final dateParts = server.specificDate.split('-');
      final date = DateTime(
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
      );
      if (date.year != local.date.year ||
          date.month != local.date.month ||
          date.day != local.date.day) {
        return false;
      }

      TimeOfDay parseTime(String timeStr) {
        final cleanTime = timeStr.split('.')[0];
        final parts = cleanTime.split(':');
        if (parts.length >= 2) {
          return TimeOfDay(
            hour: int.parse(parts[0]),
            minute: int.parse(parts[1]),
          );
        }
        return TimeOfDay.now();
      }

      final serverStart = parseTime(server.startTime);
      final serverEnd = parseTime(server.endTime);

      return serverStart.hour == local.startTime.hour &&
          serverStart.minute == local.startTime.minute &&
          serverEnd.hour == local.endTime.hour &&
          serverEnd.minute == local.endTime.minute;
    } catch (e) {
      return false;
    }
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
      String address, double? latitude, double? longitude,) async {
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
    });
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
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final address = _pickupAddressController.text.trim();

    final titleError = _validateTitle(title, s);
    final descError = _validateDescription(description, s);
    final addressError = _validateAddress(address, s);

    if (titleError != null || descError != null || addressError != null) {
      if (showToast) {
        final errorMsg =
            titleError ?? descError ?? addressError ?? s.error_required;
        CustomToast.show(context, errorMsg, type: ToastType.error);
      }
      return false;
    }

    // For update: if address exists and is marked as found, allow even without location
    // Location will be geocoded when submitting if needed
    if (!_addressFound) {
      if (showToast) {
        CustomToast.show(context, s.error_invalid_address,
            type: ToastType.error,);
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
        CustomToast.show(context, s.error_scrap_item_empty,
            type: ToastType.error,);
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
    });

    CustomToast.show(context, s.item_added_success, type: ToastType.success);
  }

  // ========= Extract Helpers =========

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

  String _extractPathFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      String path = uri.path;
      if (path.startsWith('/')) {
        path = path.substring(1);
      }
      final parts = path.split('/');
      if (parts.length > 1 && parts[0].contains('.')) {
        return parts.sublist(1).join('/');
      }
      return path;
    } catch (e) {
      return url;
    }
  }

  // ========= UPDATE =========

  Future<void> _handleUpdate() async {
    final s = S.of(context)!;
    final firstFailedStep = _findFirstInvalidStep();

    if (firstFailedStep != null) {
      _validateStep(firstFailedStep, showToast: true);
      await _jumpToStep(firstFailedStep);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // If location is null, geocode the address before submitting
      if (_location == null) {
        final address = _pickupAddressController.text.trim();
        if (address.isNotEmpty) {
          final loc = await getLocationFromAddress(address);
          if (loc == null) {
            if (!mounted) return;
            setState(() => _isSubmitting = false);
            CustomToast.show(
              context,
              S.of(context)!.error_invalid_address,
              type: ToastType.error,
            );
            return;
          }
          _location = loc;
        } else {
          if (!mounted) return;
          setState(() => _isSubmitting = false);
          CustomToast.show(
            context,
            S.of(context)!.error_required,
            type: ToastType.error,
          );
          return;
        }
      }

      // Upload images first
      if (!await _uploadPendingImages()) {
        setState(() => _isSubmitting = false);
        return;
      }

      final vm = ref.read(scrapPostViewModelProvider.notifier);
      bool allSuccess = true;

      // Update post basic info
      // Set refreshDetail: false to avoid multiple refreshes during batch update
      final updateEntity = UpdateScrapPostEntity(
        scrapPostId: _postId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        address: _pickupAddressController.text.trim(),
        availableTimeRange: 'từ thứ 2 đến thứ 6 các giờ trong tuần',
        mustTakeAll: _isTakeAll,
        location: _location!,
      );

      final postUpdated = await vm.updatePost(
        post: updateEntity,
        refreshDetail: false, // Disable auto refresh, will refresh at the end
      );
      if (!postUpdated) {
        allSuccess = false;
        debugPrint('❌ Failed to update post basic info');
      }

      // Sync time slots (create/update)
      // Set refreshDetail: false to avoid multiple refreshes
      final timeSlotSyncSuccess = await _syncTimeSlots(vm, s);
      if (!timeSlotSyncSuccess) {
        allSuccess = false;
        debugPrint('❌ Failed to sync time slots');
      }

      // Delete removed time slots
      for (var timeSlotId in _deletedTimeSlotIds) {
        final deleted = await vm.deleteTimeSlot(
          postId: _postId,
          timeSlotId: timeSlotId,
          refreshDetail: false, // Disable auto refresh
        );
        if (!deleted) {
          allSuccess = false;
          debugPrint('❌ Failed to delete time slot: $timeSlotId');
        }
      }

      // Delete removed scrap details
      for (var catId in _deletedCategoryIds) {
        final deleted = await vm.deleteDetail(
          postId: _postId,
          categoryId: catId,
          refreshDetail: false, // Disable auto refresh
        );
        if (!deleted) {
          allSuccess = false;
          debugPrint('❌ Failed to delete detail: $catId');
        }
      }

      // Update/create scrap details
      for (int i = 0; i < _scrapItems.length; i++) {
        final item = _scrapItems[i];

        String imageUrl =
            item.imageUrl ?? "https://placeholder.com/default.jpg";
        if (imageUrl.contains('?')) {
          imageUrl = _extractPathFromUrl(imageUrl);
        } else {
          imageUrl = _extractFileNameFromUrl(imageUrl);
        }

        // Capitalize first letter of type (e.g., "sale" -> "Sale")
        final typeString = item.type.toJson();
        final capitalizedType = typeString.isNotEmpty
            ? typeString[0].toUpperCase() + typeString.substring(1)
            : typeString;
        
        // Debug: Log type to ensure it's correct
        debugPrint('📝 [UPDATE] Item type: ${item.type.name} -> $capitalizedType');

        final detailEntity = ScrapPostDetailEntity(
          scrapCategoryId: item.categoryId,
          amountDescription: item.amountDescription,
          imageUrl: imageUrl,
          status: PostDetailStatus.available.name,
          type: capitalizedType,
        );

        if (_existingItemsMap[item.categoryId] == true) {
          // Existing item - only update if modified
          if (_modifiedItemFields.containsKey(i)) {
            final updated = await vm.updateDetail(
              postId: _postId,
              detail: detailEntity,
              refreshDetail: false, // Disable auto refresh
            );
            if (!updated) {
              allSuccess = false;
              debugPrint('❌ Failed to update detail for category: ${item.categoryId}');
            }
          }
        } else {
          // New item - create it
          final created = await vm.createDetail(
            postId: _postId,
            detail: detailEntity,
            refreshDetail: false, // Disable auto refresh
          );
          if (!created) {
            allSuccess = false;
            debugPrint('❌ Failed to create detail for category: ${item.categoryId}');
          }
        }
      }

      if (!mounted || !context.mounted) return;

      // Refresh detail data once after all updates complete
      if (allSuccess) {
        await vm.fetchDetail(_postId);
        
        CustomToast.show(
          // ignore: use_build_context_synchronously
          context,
          "${s.update} ${s.post} ${s.successfully}",
          type: ToastType.success,
        );
        if (context.mounted) {
          navigateWithLoading(
            // ignore: use_build_context_synchronously
            context,
            route: "/detail-post",
            extra: {'postId': _postId},
            asyncTask: () => Future.delayed(const Duration(milliseconds: 250)),
          );
        }
      } else {
        // Even if some operations failed, refresh to show current state
        await vm.fetchDetail(_postId);
        
        final errorMsg = ref.read(scrapPostViewModelProvider).errorMessage ??
            s.error_general;
        // ignore: use_build_context_synchronously
        CustomToast.show(context, errorMsg, type: ToastType.error);
      }
    } catch (e, stackTrace) {
      debugPrint('❌ [UPDATE] Exception occurred: $e');
      debugPrint('📌 [UPDATE] Stack trace: $stackTrace');
      if (mounted) {
        CustomToast.show(
          context,
          S.of(context)!.error_general,
          type: ToastType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<bool> _syncTimeSlots(dynamic vm, S s) async {
    bool allSuccess = true;
    
    // Create new time slots (those without server ID)
    for (int i = 0; i < _timeSlots.length; i++) {
      if (!_timeSlotIdMap.containsKey(i)) {
        // New time slot, create it
        final slot = _timeSlots[i];
        final result = await vm.createTimeSlot(
          postId: _postId,
          specificDate: formatDateOnly(slot.date),
          startTime: formatTimeOfDay(slot.startTime),
          endTime: formatTimeOfDay(slot.endTime),
          refreshDetail: false, // Disable auto refresh
        );
        if (result != null && result.id != null) {
          _timeSlotIdMap[i] = result.id!;
        } else {
          allSuccess = false;
          debugPrint('❌ Failed to create time slot at index: $i');
        }
      } else {
        // Existing time slot, check if modified
        final serverId = _timeSlotIdMap[i]!;
        final original = _originalTimeSlots[serverId];
        final current = _timeSlots[i];

        if (original != null) {
          // Check if changed
          final originalDate = original.specificDate;
          final currentDate = formatDateOnly(current.date);
          final originalStart = original.startTime.split('.')[0];
          final currentStart = '${formatTimeOfDay(current.startTime)}:00';
          final originalEnd = original.endTime.split('.')[0];
          final currentEnd = '${formatTimeOfDay(current.endTime)}:00';

          if (originalDate != currentDate ||
              originalStart != currentStart ||
              originalEnd != currentEnd) {
            // Time slot was modified, update it
            final result = await vm.updateTimeSlot(
              postId: _postId,
              timeSlotId: serverId,
              specificDate: currentDate,
              startTime: formatTimeOfDay(current.startTime),
              endTime: formatTimeOfDay(current.endTime),
              refreshDetail: false, // Disable auto refresh
            );
            if (result == null) {
              allSuccess = false;
              debugPrint('❌ Failed to update time slot: $serverId');
            }
          }
        }
      }
    }
    
    return allSuccess;
  }

  void _handleDeleteItem(int index) {
    setState(() {
      final item = _scrapItems[index];
      if (_existingItemsMap[item.categoryId] == true) {
        _deletedCategoryIds.add(item.categoryId);
      }
      _scrapItems.removeAt(index);
    });
  }

  // ========= UI Building Blocks =========

  PreferredSizeWidget _buildAppBar() {
    final s = S.of(context)!;

    return AppBar(
      title: Text('${s.update} ${s.recycling} ${s.post}'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: _isSubmitting ? null : () => context.pop(),
      ),
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
                  child: isLast
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: spacing.screenPadding * 1.15,
                            ),
                            backgroundColor: AppColors.warningUpdate,
                            foregroundColor: theme.scaffoldBackgroundColor,
                          ),
                          onPressed: _isSubmitting ? null : _handleUpdate,
                          child: Text(s.update),
                        )
                      : GradientButton(
                          onPressed: _isSubmitting ? null : _next,
                          child: Text(s.next),
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

    return _pageContainer(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
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
            ),
          ),
          SizedBox(height: spacing.screenPadding),
          if (_pickupAddressController.text.isNotEmpty)
            Container(
              padding: EdgeInsets.all(spacing.screenPadding),
              decoration: BoxDecoration(
                color: _addressFound
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
                    _addressFound
                        ? Icons.check_circle
                        : Icons.error_outline,
                    size: 20,
                    color: _addressFound
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
                  if (!_addressFound)
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
            onDelete: _handleDeleteTimeSlot,
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
                  final changedFields = <String>{};

                  String? newImageUrl = itemData.imageUrl;
                  File? newImageFile = itemData.imageFile;

                  final imageChanged = updated['imageChanged'] == true;

                  if (imageChanged) {
                    final imagePath = updated['image'];
                    changedFields.add('image');

                    if (imagePath == null) {
                      newImageUrl = null;
                      newImageFile = null;
                    } else if (imagePath.toString().startsWith('http')) {
                      newImageUrl = imagePath;
                      newImageFile = null;
                    } else if (imagePath != '__NO_CHANGE__') {
                      newImageFile = File(imagePath);
                      newImageUrl = null;
                    }
                  }

                  final matchedCat = categories.firstWhere(
                    (cat) => cat.categoryName == updated['category'],
                  );

                  if (matchedCat.scrapCategoryId != itemData.categoryId) {
                    changedFields.add('category');
                  }

                  final newAmountDesc = updated['amountDescription'] ?? '';
                  if (newAmountDesc != itemData.amountDescription) {
                    changedFields.add('amountDescription');
                  }

                  // Extract type from dialog result
                  ScrapPostDetailType newType = itemData.type; // Default to current type
                  if (updated['type'] != null) {
                    if (updated['type'] is ScrapPostDetailType) {
                      newType = updated['type'] as ScrapPostDetailType;
                      if (newType != itemData.type) {
                        changedFields.add('type');
                      }
                      debugPrint('✅ [UPDATE] Type from dialog (enum): ${newType.name}');
                    } else if (updated['type'] is String) {
                      // If type is returned as string, parse it
                      newType = ScrapPostDetailType.fromJson(updated['type'] as String);
                      if (newType != itemData.type) {
                        changedFields.add('type');
                      }
                      debugPrint('✅ [UPDATE] Type from dialog (string): ${updated['type']} -> ${newType.name}');
                    } else {
                      debugPrint('⚠️ [UPDATE] Type is unexpected type: ${updated['type'].runtimeType}');
                    }
                  } else {
                    debugPrint('⚠️ [UPDATE] Type is null, using current: ${itemData.type.name}');
                  }

                  if (changedFields.isNotEmpty) {
                    setState(() {
                      _scrapItems[index] = ScrapItemData(
                        categoryId: matchedCat.scrapCategoryId,
                        categoryName: matchedCat.categoryName,
                        amountDescription:
                            StringHelper.truncateForVarchar255(newAmountDesc),
                        type: newType,
                        imageUrl: newImageUrl,
                        imageFile: newImageFile,
                      );
                      _modifiedItemFields[index] = changedFields;
                    });
                  }
                }
              },
              onDelete: (item) {
                final index = _scrapItems.indexOf(item);
                if (index != -1) _handleDeleteItem(index);
              },
            ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _buildStep3_Review() {
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
