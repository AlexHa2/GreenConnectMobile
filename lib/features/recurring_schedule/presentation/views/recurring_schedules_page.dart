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
import 'package:GreenConnectMobile/core/enum/scrap_post_detail_type.dart';
import 'package:GreenConnectMobile/core/helper/scrap_post_detail_type_helper.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_leaf_loading.dart';
import 'package:GreenConnectMobile/shared/widgets/app_input_field.dart';
import 'package:GreenConnectMobile/shared/widgets/address_picker_bottom_sheet.dart';
import 'package:GreenConnectMobile/shared/widgets/button_gradient.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/post_info_form.dart';
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

    final formKey = GlobalKey<FormState>();

    const stepCount = 3;
    int currentStep = 0;
    final pageController = PageController(initialPage: currentStep);

    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final addressCtrl = TextEditingController();
    LocationEntity? location;
    bool addressFound = false;
    String? selectedCategoryId;
    final quantityCtrl = TextEditingController(text: '0');
    final unitCtrl = TextEditingController();
    final amountDescCtrl = TextEditingController();
    ScrapPostDetailType selectedType = ScrapPostDetailType.sale;

    bool mustTakeAll = true;
    int dayOfWeek = DateTime.now().weekday;
    TimeOfDay start = const TimeOfDay(hour: 7, minute: 0);
    TimeOfDay end = const TimeOfDay(hour: 8, minute: 0);
    bool isSubmitting = false;

    bool validateStep(int step) {
      if (step == 0) {
        final title = titleCtrl.text.trim();
        final description = descCtrl.text.trim();
        final address = addressCtrl.text.trim();

        final formState = formKey.currentState;
        final ok = formState?.validate();

        // When user is on later steps, the Form widget in step 0 might be
        // offstage and formState can be null. In that case, we validate using
        // controller values instead of blocking submission.
        if (ok == false || formState == null) {
          String? err;
          if (title.isEmpty) {
            err = s.error_required;
          } else if (title.length < 3) {
            err = s.error_post_title_min;
          } else if (description.isEmpty) {
            err = s.error_required;
          } else if (description.length < 10) {
            err = s.error_description_min;
          } else if (address.isEmpty) {
            err = s.error_required;
          }

          if (err != null) {
            CustomToast.show(context, err, type: ToastType.warning);
            return false;
          }
        }
        if (location == null || !addressFound) {
          CustomToast.show(
            context,
            s.error_invalid_address,
            type: ToastType.warning,
          );
          return false;
        }
        return true;
      }

      if (step == 1) {
        final startMinutes = start.hour * 60 + start.minute;
        final endMinutes = end.hour * 60 + end.minute;
        if (endMinutes <= startMinutes) {
          CustomToast.show(
            context,
            s.error_occurred,
            type: ToastType.warning,
          );
          return false;
        }
        return true;
      }

      if (step == 2) {
        if (selectedCategoryId == null || selectedCategoryId!.trim().isEmpty) {
          CustomToast.show(
            context,
            s.error_all_field,
            type: ToastType.warning,
          );
          return false;
        }
        return true;
      }

      return true;
    }

    Future<void> jumpToStep(
      void Function(void Function()) setModalState,
      int step,
    ) async {
      if (step == currentStep) return;
      if (step < 0 || step >= stepCount) return;

      if (step > currentStep) {
        final ok = validateStep(currentStep);
        if (!ok) return;
      }

      setModalState(() => currentStep = step);
      await pageController.animateToPage(
        step,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOut,
      );
    }

    Widget buildStepHeader(void Function(void Function()) setModalState) {
      final progress = (currentStep + 1) / stepCount;

      final steps = <({String title, IconData icon})>[
        (title: '${s.post} ${s.information}', icon: Icons.edit_note),
        (title: s.recurring_schedules_create_title, icon: Icons.calendar_month),
        (title: s.recurring_schedules_details_section, icon: Icons.category),
      ];

      return Padding(
        padding: EdgeInsets.only(bottom: spacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(steps[currentStep].icon, size: 20),
                SizedBox(width: spacing * 0.67),
                Expanded(
                  child: Text(
                    steps[currentStep].title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${currentStep + 1}/$stepCount',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing * 0.83),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: progress.clamp(0.0, 1.0)),
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeOutCubic,
                builder: (context, animatedValue, child) {
                  return LinearProgressIndicator(
                    value: animatedValue,
                    minHeight: 6,
                    backgroundColor: theme.canvasColor,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(theme.primaryColor),
                  );
                },
              ),
            ),
            SizedBox(height: spacing * 0.83),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(stepCount, (index) {
                  final isActive = index == currentStep;
                  final canTap = index <= currentStep;

                  return Padding(
                    padding: EdgeInsets.only(
                      right: index == stepCount - 1 ? 0 : spacing * 0.67,
                    ),
                    child: InkWell(
                      onTap: canTap
                          ? () => jumpToStep(setModalState, index)
                          : null,
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: spacing,
                          vertical: spacing * 0.67,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: isActive
                                ? theme.colorScheme.primary
                                : theme.dividerColor,
                          ),
                          color: isActive
                              ? theme.primaryColor.withValues(alpha: 0.10)
                              : theme.colorScheme.surface,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              steps[index].icon,
                              size: 16,
                              color: canTap
                                  ? (isActive
                                      ? theme.colorScheme.primary
                                      : theme.iconTheme.color)
                                  : theme.colorScheme.onSurface
                                      .withValues(alpha: 0.38),
                            ),
                            SizedBox(width: spacing / 2),
                            Text(
                              (index + 1).toString(),
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: canTap
                                    ? (isActive
                                        ? theme.colorScheme.primary
                                        : theme.textTheme.labelLarge?.color)
                                    : theme.colorScheme.onSurface
                                        .withValues(alpha: 0.38),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      );
    }

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
      final hh = t.hour.toString().padLeft(2, '0');
      final mm = t.minute.toString().padLeft(2, '0');
      return '$hh:$mm:00.000';
    }

    void handleAddressSelected(
      void Function(void Function()) setModalState,
      String address,
      double? latitude,
      double? longitude,
    ) {
      addressCtrl.text = address;
      if (latitude != null && longitude != null) {
        location = LocationEntity(latitude: latitude, longitude: longitude);
        addressFound = true;
      } else {
        location = null;
        addressFound = false;
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
                            SizedBox(height: spacing * 0.5),
                            buildStepHeader(setModalState),
                            Expanded(
                              child: PageView(
                                controller: pageController,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  SingleChildScrollView(
                                    child: Form(
                                      key: formKey,
                                      child: PostInfoForm(
                                        formKey: formKey,
                                        titleController: titleCtrl,
                                        descController: descCtrl,
                                        addressController: addressCtrl,
                                        onSearchAddress: openAddressPicker,
                                        onGetCurrentLocation: openAddressPicker,
                                        addressFound: addressFound,
                                        isLoadingLocation: false,
                                      ),
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SwitchListTile.adaptive(
                                          contentPadding: EdgeInsets.zero,
                                          title: Text(
                                            s.recurring_schedule_must_take_all,
                                            style: theme.textTheme.bodyLarge!
                                                .copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          value: mustTakeAll,
                                          onChanged: (v) => setModalState(
                                            () => mustTakeAll = v,
                                          ),
                                        ),
                                        SizedBox(height: spacing / 2),
                                        Text(
                                          s.recurring_schedule_field_day_of_week,
                                          style: theme.textTheme.bodyLarge!
                                              .copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: spacing / 2),
                                        DropdownButtonFormField<int>(
                                          initialValue: dayOfWeek,
                                          decoration: const InputDecoration(
                                            isDense: true,
                                          ),
                                          items: List.generate(7, (i) {
                                            final value = i + 1; // 1..7
                                            return DropdownMenuItem(
                                              value: value,
                                              child: Text(
                                                _weekdayLabel(context, value),
                                              ),
                                            );
                                          }),
                                          onChanged: (v) {
                                            if (v != null) {
                                              setModalState(
                                                () => dayOfWeek = v,
                                              );
                                            }
                                          },
                                        ),
                                        SizedBox(height: spacing),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                onTap: () =>
                                                    pickStart(setModalState),
                                                child: InputDecorator(
                                                  decoration: InputDecoration(
                                                    labelText: s
                                                        .recurring_schedule_field_start_time,
                                                    isDense: true,
                                                  ),
                                                  child: Text(
                                                    start.format(context),
                                                    style: theme
                                                        .textTheme.bodyMedium,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: spacing),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () =>
                                                    pickEnd(setModalState),
                                                child: InputDecorator(
                                                  decoration: InputDecoration(
                                                    labelText: s
                                                        .recurring_schedule_field_end_time,
                                                    isDense: true,
                                                  ),
                                                  child: Text(
                                                    end.format(context),
                                                    style: theme
                                                        .textTheme.bodyMedium,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          s.recurring_schedules_details_section,
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
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
                                          onChanged: (val) => setModalState(
                                            () => selectedCategoryId = val,
                                          ),
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
                                                label: s
                                                    .recurring_schedule_field_quantity,
                                                controller: quantityCtrl,
                                                hint: '0',
                                                keyboardType:
                                                    const TextInputType
                                                        .numberWithOptions(
                                                  decimal: true,
                                                  signed: false,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: spacing),
                                            Expanded(
                                              child: AppInputField(
                                                label: s
                                                    .recurring_schedule_field_unit,
                                                controller: unitCtrl,
                                                hint: s
                                                    .recurring_schedule_field_unit,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: spacing),
                                        AppInputField(
                                          label: s
                                              .recurring_schedule_field_amount_description,
                                          controller: amountDescCtrl,
                                          hint: s
                                              .recurring_schedule_field_amount_description,
                                        ),
                                        SizedBox(height: spacing),
                                        DropdownButtonFormField<ScrapPostDetailType>(
                                          value: selectedType,
                                          decoration: InputDecoration(
                                            labelText:
                                                s.recurring_schedule_field_type,
                                            isDense: true,
                                          ),
                                          items: ScrapPostDetailType.values
                                              .map(
                                                (t) => DropdownMenuItem(
                                                  value: t,
                                                  child: Text(
                                                    ScrapPostDetailTypeHelper
                                                        .getLocalizedType(
                                                      context,
                                                      t,
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: (v) {
                                            if (v == null) return;
                                            setModalState(
                                              () => selectedType = v,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: spacing),
                            Row(
                              children: [
                                if (currentStep > 0)
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: isSubmitting
                                          ? null
                                          : () => jumpToStep(
                                                setModalState,
                                                currentStep - 1,
                                              ),
                                      child: Text(s.back),
                                    ),
                                  ),
                                if (currentStep > 0)
                                  SizedBox(width: spacing),
                                Expanded(
                                  flex: 2,
                                  child: GradientButton(
                                    onPressed: isSubmitting
                                        ? null
                                        : () async {
                                            if (currentStep < stepCount - 1) {
                                              await jumpToStep(
                                                setModalState,
                                                currentStep + 1,
                                              );
                                              return;
                                            }

                                            final okSteps =
                                                validateStep(0) &&
                                                    validateStep(1) &&
                                                    validateStep(2);
                                            if (!okSteps) {
                                              return;
                                            }

                                            final title = titleCtrl.text.trim();
                                            final description =
                                                descCtrl.text.trim();
                                            final address =
                                                addressCtrl.text.trim();
                                            final scrapCategoryId =
                                                selectedCategoryId;

                                            final quantity = num.tryParse(
                                                  quantityCtrl.text.trim(),
                                                ) ??
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

                                            setModalState(
                                              () => isSubmitting = true,
                                            );

                                            try {
                                              final backendDayOfWeek =
                                                  dayOfWeek == 7 ? 0 : dayOfWeek;

                                              final entity = RecurringScheduleEntity(
                                                id: '',
                                                title: title,
                                                description: description,
                                                address: address,
                                                location: location!,
                                                mustTakeAll: mustTakeAll,
                                                dayOfWeek: backendDayOfWeek,
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
                                                    type: selectedType.label,
                                                  ),
                                                ],
                                                lastRunDate: null,
                                                createdAt: null,
                                              );

                                              final ok = await ref
                                                  .read(
                                                    recurringScheduleViewModelProvider
                                                        .notifier,
                                                  )
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
                                                  context,
                                                  s.recurring_schedules_create_failed,
                                                  type: ToastType.error,
                                                );
                                                setModalState(
                                                  () => isSubmitting = false,
                                                );
                                              }
                                            } catch (e) {
                                              CustomToast.show(
                                                context,
                                                s.recurring_schedules_create_failed,
                                                type: ToastType.error,
                                              );
                                              setModalState(
                                                () => isSubmitting = false,
                                              );
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
                                        : Text(
                                            currentStep < stepCount - 1
                                                ? s.next
                                                : s.recurring_schedules_create_submit,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ],
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
                      // final lastRun = _dateTimeLabel(context, item.lastRunDate);

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
                            item.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.schedule_rounded,
                                      size: 16,
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        '$weekday · $start - $end',
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: theme.colorScheme.onSurfaceVariant,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (item.address.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        size: 16,
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          item.address,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            color: theme.colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                if (created.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      'Tạo lúc: $created',
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
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
