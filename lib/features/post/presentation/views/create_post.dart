import 'dart:io';
import 'dart:typed_data';

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

class CreateRecyclingPostPage extends ConsumerStatefulWidget {
  const CreateRecyclingPostPage({super.key});

  @override
  ConsumerState<CreateRecyclingPostPage> createState() =>
      _CreateRecyclingPostPageState();
}

class _CreateRecyclingPostPageState
    extends ConsumerState<CreateRecyclingPostPage> {
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

  // ===== Step State =====
  int _currentStep = 0;
  late final PageController _pageController;

  // ===== Data State =====
  final List<TimeSlotEntity> _timeSlots = [];
  final List<ScrapItemData> _scrapItems = [];

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
    // Bottom sheet will close itself via Navigator.pop(context)
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
      String address, double? latitude, double? longitude) async {
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

    if (_location == null || !_addressFound) {
      if (showToast) {
        CustomToast.show(context, s.error_invalid_address,
            type: ToastType.error);
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
            type: ToastType.error);
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
        // Debug: Log type to ensure it's correct
        debugPrint('📝 [SUBMIT] Item type: ${item.type.name} -> ${item.type.toJson()}');
        
        // Capitalize first letter of type (e.g., "sale" -> "Sale")
        final typeString = item.type.toJson();
        final capitalizedType = typeString.isNotEmpty
            ? typeString[0].toUpperCase() + typeString.substring(1)
            : typeString;
        
        return ScrapPostDetailEntity(
          scrapCategoryId: item.categoryId,
          amountDescription: item.amountDescription,
          imageUrl: item.imageUrl != null
              ? _extractFileNameFromUrl(item.imageUrl!)
              : defaultImageUrl,
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
        CustomToast.show(context, s.success_post_created,
            type: ToastType.success);
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
                  ScrapPostDetailType newType = itemData.type; // Default to current type
                  if (updated['type'] != null) {
                    if (updated['type'] is ScrapPostDetailType) {
                      newType = updated['type'] as ScrapPostDetailType;
                      debugPrint('✅ [UPDATE] Type from dialog (enum): ${newType.name}');
                    } else if (updated['type'] is String) {
                      // If type is returned as string, parse it
                      newType = ScrapPostDetailType.fromJson(updated['type'] as String);
                      debugPrint('✅ [UPDATE] Type from dialog (string): ${updated['type']} -> ${newType.name}');
                    } else {
                      debugPrint('⚠️ [UPDATE] Type is unexpected type: ${updated['type'].runtimeType}');
                    }
                  } else {
                    debugPrint('⚠️ [UPDATE] Type is null, using current: ${itemData.type.name}');
                  }

                  if (updated['imageChanged'] == true) {
                    final imageResult = _parseImageUpdate(updated['image']);
                    newImageFile = imageResult.file;
                    newImageUrl = imageResult.url;
                  } else {
                    newImageUrl = itemData.imageUrl;
                    newImageFile = itemData.imageFile;
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
                    );
                  });
                }
              },
              onDelete: (item) => setState(() => _scrapItems.remove(item)),
            ),
        ],
      ),
    );
  }

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
