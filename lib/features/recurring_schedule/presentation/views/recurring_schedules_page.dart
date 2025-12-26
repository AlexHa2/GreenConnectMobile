// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/entities/recurring_schedule_entity.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/entities/recurring_schedule_detail_entity.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/presentation/providers/recurring_schedule_providers.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_category_entity.dart';
import 'package:GreenConnectMobile/features/post/presentation/providers/scrap_category_providers.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/empty_state_widget.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/location_entity.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_leaf_loading.dart';
import 'package:GreenConnectMobile/shared/widgets/app_input_field.dart';
import 'package:GreenConnectMobile/shared/widgets/address_picker_bottom_sheet.dart';
import 'package:GreenConnectMobile/shared/widgets/button_gradient.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class RecurringSchedulesPage extends ConsumerStatefulWidget {
  const RecurringSchedulesPage({super.key});

  @override
  ConsumerState<RecurringSchedulesPage> createState() =>
      _RecurringSchedulesPageState();
}

class _RecurringSchedulesPageState
    extends ConsumerState<RecurringSchedulesPage> {
  final ScrollController _scrollController = ScrollController();

  int _currentPage = 1;
  final int _pageSize = 10;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  bool _sortByCreatedAtDesc = true;

  final List<RecurringScheduleEntity> _items = [];

  Future<void> _openCreateBottomSheet() async {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()?.screenPadding ?? 12.0;
    final s = S.of(context)!;

    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final addressCtrl = TextEditingController();
    final latCtrl = TextEditingController(text: '0');
    final lngCtrl = TextEditingController(text: '0');
    String? selectedCategoryId;
    final quantityCtrl = TextEditingController(text: '0');
    final unitCtrl = TextEditingController();
    final amountDescCtrl = TextEditingController();
    final typeCtrl = TextEditingController(text: 'Sale');

    bool mustTakeAll = true;
    int dayOfWeek = 0;
    TimeOfDay start = const TimeOfDay(hour: 7, minute: 0);
    TimeOfDay end = const TimeOfDay(hour: 8, minute: 0);
    bool isSubmitting = false;

    Widget labeledField({
      required String label,
      required TextEditingController controller,
      required String hint,
      TextInputType? keyboardType,
      int maxLines = 1,
    }) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: spacing / 2),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              isDense: true,
            ),
          ),
        ],
      );
    }

    Future<void> pickStart(void Function(void Function()) setModalState) async {
      final picked = await showTimePicker(
        context: context,
        initialTime: start,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: theme.primaryColor,
                onPrimary: Colors.white,
                surface: theme.scaffoldBackgroundColor,
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null) {
        setModalState(() => start = picked);
      }
    }

    Future<void> pickEnd(void Function(void Function()) setModalState) async {
      final picked = await showTimePicker(
        context: context,
        initialTime: end,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: theme.primaryColor,
                onPrimary: Colors.white,
                surface: theme.scaffoldBackgroundColor,
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null) {
        setModalState(() => end = picked);
      }
    }

    String timeToIso(TimeOfDay t) {
      final now = DateTime.now().toUtc();
      final dt = DateTime.utc(now.year, now.month, now.day, t.hour, t.minute);
      return dt.toIso8601String();
    }

    void handleAddressSelected(
      void Function(void Function()) setModalState,
      String address,
      double? latitude,
      double? longitude,
    ) {
      addressCtrl.text = address;
      if (latitude != null) {
        latCtrl.text = latitude.toString();
      }
      if (longitude != null) {
        lngCtrl.text = longitude.toString();
      }
      setModalState(() {});
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final catState = ref.watch(scrapCategoryViewModelProvider);
            final categories = catState.listData?.data ?? <ScrapCategoryEntity>[];

            return StatefulBuilder(
              builder: (context, setModalState) {
                Future<void> openAddressPicker() async {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (ctx) => AddressPickerBottomSheet(
                      initialAddress: addressCtrl.text.trim(),
                      onAddressSelected: (address, latitude, longitude) {
                        handleAddressSelected(
                          setModalState,
                          address,
                          latitude,
                          longitude,
                        );
                      },
                    ),
                  );
                }

                return SafeArea(
                  top: false,
                  child: Container(
                    padding: EdgeInsets.only(
                      left: spacing,
                      right: spacing,
                      top: spacing,
                      bottom:
                          spacing + MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(spacing * 2),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  s.recurring_schedules_create_title,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                          SizedBox(height: spacing),
                          AppInputField(
                            label: s.recurring_schedule_field_title,
                            controller: titleCtrl,
                            hint: s.recurring_schedule_field_title,
                          ),
                          SizedBox(height: spacing),
                          AppInputField(
                            label: s.recurring_schedule_field_description,
                            controller: descCtrl,
                            hint: s.recurring_schedule_field_description,
                            maxLines: 2,
                          ),
                          SizedBox(height: spacing),
                          Text(
                            s.recurring_schedule_field_address,
                            style: theme.textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: spacing / 2),
                          if (addressCtrl.text.trim().isNotEmpty)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: theme.primaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: theme.primaryColor.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: theme.primaryColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      addressCtrl.text,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: openAddressPicker,
                              icon: const Icon(Icons.edit_location_alt),
                              label: Text(
                                addressCtrl.text.trim().isEmpty
                                    ? s.select_address
                                    : s.change_address,
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                side: BorderSide(color: theme.primaryColor),
                              ),
                            ),
                          ),
                          SizedBox(height: spacing),
                          SwitchListTile.adaptive(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              s.recurring_schedule_must_take_all,
                              style: theme.textTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            value: mustTakeAll,
                            onChanged: (v) =>
                                setModalState(() => mustTakeAll = v),
                          ),
                          SizedBox(height: spacing / 2),
                          Text(
                            s.recurring_schedule_field_day_of_week,
                            style: theme.textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: spacing / 2),
                          DropdownButtonFormField<int>(
                            initialValue: dayOfWeek,
                            decoration: const InputDecoration(
                              isDense: true,
                            ),
                            items: List.generate(
                              7,
                              (i) => DropdownMenuItem(
                                value: i,
                                child: Text(_weekdayLabel(context, i)),
                              ),
                            ),
                            onChanged: (v) {
                              if (v != null) setModalState(() => dayOfWeek = v);
                            },
                          ),
                          SizedBox(height: spacing),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () => pickStart(setModalState),
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      labelText:
                                          s.recurring_schedule_field_start_time,
                                      isDense: true,
                                    ),
                                    child: Text(
                                      start.format(context),
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: spacing),
                              Expanded(
                                child: InkWell(
                                  onTap: () => pickEnd(setModalState),
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      labelText:
                                          s.recurring_schedule_field_end_time,
                                      isDense: true,
                                    ),
                                    child: Text(
                                      end.format(context),
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: spacing * 1.5),
                          Text(
                            s.recurring_schedules_details_section,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: spacing),
                          DropdownButtonFormField<String>(
                            initialValue: selectedCategoryId,
                            items: categories
                                .map(
                                  (c) => DropdownMenuItem(
                                    value: c.scrapCategoryId,
                                    child: Text(c.categoryName),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) =>
                                setModalState(() => selectedCategoryId = val),
                            decoration: InputDecoration(
                              labelText: s.category,
                              isDense: true,
                            ),
                          ),
                          SizedBox(height: spacing),
                          Row(
                            children: [
                              Expanded(
                                child: labeledField(
                                  label: s.recurring_schedule_field_quantity,
                                  controller: quantityCtrl,
                                  hint: '0',
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                    decimal: true,
                                    signed: false,
                                  ),
                                ),
                              ),
                              SizedBox(width: spacing),
                              Expanded(
                                child: AppInputField(
                                  label: s.recurring_schedule_field_unit,
                                  controller: unitCtrl,
                                  hint: s.recurring_schedule_field_unit,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: spacing),
                          AppInputField(
                            label: s.recurring_schedule_field_amount_description,
                            controller: amountDescCtrl,
                            hint: s.recurring_schedule_field_amount_description,
                          ),
                          SizedBox(height: spacing),
                          AppInputField(
                            label: s.recurring_schedule_field_type,
                            controller: typeCtrl,
                            hint: s.recurring_schedule_field_type,
                          ),
                          SizedBox(height: spacing * 1.5),
                          GradientButton(
                            onPressed: isSubmitting
                                ? null
                                : () async {
                                    final title = titleCtrl.text.trim();
                                    final description = descCtrl.text.trim();
                                    final address = addressCtrl.text.trim();
                                    final scrapCategoryId = selectedCategoryId;

                                    final lat =
                                        double.tryParse(latCtrl.text.trim()) ?? 0;
                                    final lng =
                                        double.tryParse(lngCtrl.text.trim()) ?? 0;

                                    final quantity =
                                        num.tryParse(quantityCtrl.text.trim()) ??
                                            0;

                                    if (title.isEmpty ||
                                        address.isEmpty ||
                                        scrapCategoryId == null ||
                                        scrapCategoryId.isEmpty) {
                                      CustomToast.show(
                                        context,
                                        s.error_all_field,
                                        type: ToastType.warning,
                                      );
                                      return;
                                    }

                                    setModalState(() => isSubmitting = true);

                                    final entity = RecurringScheduleEntity(
                                      id: '',
                                      title: title,
                                      description: description,
                                      address: address,
                                      location: LocationEntity(
                                        longitude: lng,
                                        latitude: lat,
                                      ),
                                      mustTakeAll: mustTakeAll,
                                      dayOfWeek: dayOfWeek,
                                      startTime: timeToIso(start),
                                      endTime: timeToIso(end),
                                      isActive: true,
                                      scheduleDetails: [
                                        RecurringScheduleDetailEntity(
                                          id: '',
                                          recurringScheduleId: '',
                                          scrapCategoryId: scrapCategoryId,
                                          quantity: quantity,
                                          unit: unitCtrl.text.trim().isEmpty
                                              ? null
                                              : unitCtrl.text.trim(),
                                          amountDescription:
                                              amountDescCtrl.text.trim().isEmpty
                                                  ? null
                                                  : amountDescCtrl.text.trim(),
                                          type: typeCtrl.text.trim().isEmpty
                                              ? null
                                              : typeCtrl.text.trim(),
                                        ),
                                      ],
                                      lastRunDate: null,
                                      createdAt: null,
                                    );

                                    final ok = await ref
                                        .read(recurringScheduleViewModelProvider
                                            .notifier,)
                                        .createSchedule(entity);

                                    if (!mounted) return;

                                    if (ok) {
                                      CustomToast.show(
                                        context,
                                        s.recurring_schedules_create_success,
                                        type: ToastType.success,
                                      );
                                      Navigator.pop(context);
                                      await _onRefresh();
                                    } else {
                                      CustomToast.show(
                                        // ignore: use_build_context_synchronously
                                        context,
                                        s.recurring_schedules_create_failed,
                                        type: ToastType.error,
                                      );
                                      setModalState(() => isSubmitting = false);
                                    }
                                  },
                            child: isSubmitting
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(s.recurring_schedules_create_submit),
                          ),
                        ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSchedules(isRefresh: true);
      ref
          .read(scrapCategoryViewModelProvider.notifier)
          .fetchScrapCategories(pageNumber: 1, pageSize: 50);
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _hasMoreData) {
      _loadMore();
    }
  }

  Future<void> _loadSchedules({required bool isRefresh}) async {
    if (isRefresh) {
      _currentPage = 1;
      _hasMoreData = true;
      _items.clear();
      if (mounted) setState(() {});
    }

    await ref.read(recurringScheduleViewModelProvider.notifier).fetchList(
          page: _currentPage,
          size: _pageSize,
          sortByCreatedAt: _sortByCreatedAtDesc,
        );

    if (!mounted) return;

    final state = ref.read(recurringScheduleViewModelProvider);
    final listData = state.listData;
    if (listData != null) {
      _items.addAll(listData.data);
      _hasMoreData = listData.pagination.nextPage != null;
      setState(() {});
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;
    final state = ref.read(recurringScheduleViewModelProvider);
    final nextPage = state.listData?.pagination.nextPage;
    if (nextPage == null) {
      setState(() => _hasMoreData = false);
      return;
    }

    setState(() {
      _isLoadingMore = true;
      _currentPage = nextPage;
    });

    await ref.read(recurringScheduleViewModelProvider.notifier).fetchList(
          page: _currentPage,
          size: _pageSize,
          sortByCreatedAt: _sortByCreatedAtDesc,
        );

    if (!mounted) return;

    final newData = ref.read(recurringScheduleViewModelProvider).listData?.data;
    if (newData != null) {
      _items.addAll(newData);
      _hasMoreData =
          ref.read(recurringScheduleViewModelProvider).listData?.pagination
                  .nextPage !=
              null;
    }

    setState(() => _isLoadingMore = false);
  }

  Future<void> _onRefresh() async {
    await _loadSchedules(isRefresh: true);
  }

  String _weekdayLabel(BuildContext context, int dayOfWeek) {
    final locale = S.of(context)!.localeName;

    // Handle both 0-6 and 1-7 formats safely.
    final normalized = dayOfWeek == 0 ? 7 : dayOfWeek;

    // 2020-01-06 is Monday (weekday=1)
    final baseMonday = DateTime(2020, 1, 6);
    final date = baseMonday.add(Duration(days: normalized - 1));
    return DateFormat.EEEE(locale).format(date);
  }

  String _timeLabel(BuildContext context, String raw) {
    // API returns "HH:mm:ss" or "HH:mm:ss.SSSSSSS"; display as HH:mm
    final locale = S.of(context)!.localeName;
    final cleaned = raw.split('.').first;
    final parts = cleaned.split(':');
    if (parts.length < 2) return raw;
    final hh = int.tryParse(parts[0]);
    final mm = int.tryParse(parts[1]);
    if (hh == null || mm == null) return raw;
    final fake = DateTime(2020, 1, 1, hh, mm);
    return DateFormat.Hm(locale).format(fake);
  }

  String _dateTimeLabel(BuildContext context, DateTime? dt) {
    if (dt == null) return '';
    final locale = S.of(context)!.localeName;
    return DateFormat('dd/MM/yyyy HH:mm', locale).format(dt.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()?.screenPadding ?? 12.0;
    final s = S.of(context)!;

    final vmState = ref.watch(recurringScheduleViewModelProvider);
    final isFirstLoading = vmState.isLoadingList && _items.isEmpty;
    final error = vmState.errorMessage;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateBottomSheet,
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(s.recurring_schedules_create),
      ),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Padding(
            padding: EdgeInsets.all(spacing),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/household-home');
                    }
                  },
                  tooltip: s.back,
                ),
                SizedBox(width: spacing * 0.5),
                Container(
                  padding: EdgeInsets.all(spacing * 0.7),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.linearPrimary,
                  ),
                  child: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: spacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.recurring_schedules,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        s.recurring_schedules_description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _sortByCreatedAtDesc = !_sortByCreatedAtDesc;
                    });
                    _loadSchedules(isRefresh: true);
                  },
                  icon: Icon(
                    _sortByCreatedAtDesc
                        ? Icons.arrow_downward_rounded
                        : Icons.arrow_upward_rounded,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: theme.dividerColor),
          Expanded(
            child: Builder(
              builder: (context) {
                if (isFirstLoading) {
                  return const Center(child: RotatingLeafLoader());
                }

                if (error != null && _items.isEmpty) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.25,
                      ),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(s.error_occurred),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: _onRefresh,
                              child: Text(s.retry),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }

                if (_items.isEmpty) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(spacing),
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.18,
                      ),
                      EmptyStateWidget(
                        icon: Icons.event_repeat_outlined,
                        message: s.recurring_schedules_empty_message,
                        actionText: s.recurring_schedules_create,
                        onAction: _openCreateBottomSheet,
                      ),
                    ],
                  );
                }

                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  color: theme.primaryColor,
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(spacing),
                    itemCount: _items.length + (_isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _items.length && _isLoadingMore) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: spacing),
                          child: const Center(child: RotatingLeafLoader()),
                        );
                      }

                      final item = _items[index];
                      final weekday = _weekdayLabel(context, item.dayOfWeek);
                      final start = _timeLabel(context, item.startTime);
                      final end = _timeLabel(context, item.endTime);
                      final created = _dateTimeLabel(context, item.createdAt);
                      final lastRun = _dateTimeLabel(context, item.lastRunDate);

                      return Card(
                        elevation: 0,
                        margin: EdgeInsets.only(bottom: spacing),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: theme.dividerColor.withValues(alpha: 0.6),
                          ),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(spacing),
                          leading: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.event_repeat_outlined,
                              color: theme.primaryColor,
                            ),
                          ),
                          title: Text(
                            '$weekday · $start - $end',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (created.isNotEmpty)
                                  Text(
                                    created,
                                    style: theme.textTheme.bodySmall,
                                  ),
                                if (lastRun.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Text(
                                      lastRun,
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          trailing: Switch.adaptive(
                            value: item.isActive,
                            onChanged: (value) async {
                              final ok = await ref
                                  .read(recurringScheduleViewModelProvider
                                      .notifier,)
                                  .toggleSchedule(item.id);

                              if (!context.mounted) return;

                              if (ok) {
                                CustomToast.show(
                                  context,
                                  s.recurring_schedules_toggle_success,
                                  type: ToastType.success,
                                );
                                await _onRefresh();
                              } else {
                                CustomToast.show(
                                  context,
                                  s.recurring_schedules_toggle_failed,
                                  type: ToastType.error,
                                );
                              }
                            },
                          ),
                          onTap: () {
                            context.push('/recurring-schedules/${item.id}');
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
