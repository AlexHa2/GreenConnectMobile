import 'package:GreenConnectMobile/features/recurring_schedule/domain/entities/recurring_schedule_detail_entity.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/entities/recurring_schedule_entity.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/presentation/providers/recurring_schedule_providers.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_category_entity.dart';
import 'package:GreenConnectMobile/features/post/presentation/providers/scrap_category_providers.dart';
import 'package:GreenConnectMobile/core/enum/scrap_post_detail_type.dart';
import 'package:GreenConnectMobile/core/helper/scrap_post_detail_type_helper.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/location_entity.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_leaf_loading.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class RecurringScheduleDetailPage extends ConsumerStatefulWidget {
  final String id;

  const RecurringScheduleDetailPage({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<RecurringScheduleDetailPage> createState() =>
      _RecurringScheduleDetailPageState();
}

class _RecurringScheduleDetailPageState
    extends ConsumerState<RecurringScheduleDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(recurringScheduleViewModelProvider.notifier).fetchDetail(widget.id);
      ref
          .read(scrapCategoryViewModelProvider.notifier)
          .fetchScrapCategories(pageNumber: 1, pageSize: 50);
    });
  }

  Future<void> _openCreateDetailSheet(String scheduleId) async {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()?.screenPadding ?? 12.0;
    final s = S.of(context)!;

    String? selectedCategoryId;
    final quantityCtrl = TextEditingController(text: '0');
    final unitCtrl = TextEditingController();
    final amountDescCtrl = TextEditingController();
    ScrapPostDetailType selectedType = ScrapPostDetailType.sale;
    bool isSubmitting = false;

    String? selectedUnit;

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
                return Container(
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  padding: EdgeInsets.only(
                    left: spacing,
                    right: spacing,
                    top: spacing,
                    bottom:
                        spacing + MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            s.recurring_schedule_detail_create_title,
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
                      ),
                    ),
                    SizedBox(height: spacing),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: quantityCtrl,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: false,
                            ),
                            decoration: InputDecoration(
                              labelText: s.recurring_schedule_field_quantity,
                            ),
                          ),
                        ),
                        SizedBox(width: spacing),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: selectedUnit,
                            decoration: InputDecoration(
                              labelText: s.recurring_schedule_field_unit,
                            ),
                            items: [
                              DropdownMenuItem(value: s.kg, child: Text(s.kg)),
                              DropdownMenuItem(value: s.g, child: Text(s.g)),
                              DropdownMenuItem(
                                value: s.ton,
                                child: Text(s.ton),
                              ),
                              DropdownMenuItem(
                                value: s.piece,
                                child: Text(s.piece),
                              ),
                            ],
                            onChanged: (value) {
                              if (value == null) return;
                              setModalState(() {
                                selectedUnit = value;
                                unitCtrl.text = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: spacing),
                    TextField(
                      controller: amountDescCtrl,
                      decoration: InputDecoration(
                        labelText: s.recurring_schedule_field_amount_description,
                      ),
                    ),
                    SizedBox(height: spacing),
                    DropdownButtonFormField<ScrapPostDetailType>(
                      initialValue: selectedType,
                      decoration: InputDecoration(
                        labelText: s.recurring_schedule_field_type,
                      ),
                      items: ScrapPostDetailType.values
                          .map(
                            (t) => DropdownMenuItem(
                              value: t,
                              child: Text(
                                ScrapPostDetailTypeHelper.getLocalizedType(
                                  context,
                                  t,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v == null) return;
                        setModalState(() => selectedType = v);
                      },
                    ),
                    SizedBox(height: spacing * 1.5),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isSubmitting
                            ? null
                            : () async {
                                final scrapCategoryId = selectedCategoryId;
                                if (scrapCategoryId == null ||
                                    scrapCategoryId.isEmpty) {
                                  CustomToast.show(
                                    context,
                                    s.error_all_field,
                                    type: ToastType.warning,
                                  );
                                  return;
                                }

                                final quantity =
                                    num.tryParse(quantityCtrl.text.trim()) ?? 0;

                                setModalState(() => isSubmitting = true);

                                final detail = RecurringScheduleDetailEntity(
                                  id: '',
                                  recurringScheduleId: scheduleId,
                                  scrapCategoryId: scrapCategoryId,
                                  quantity: quantity,
                                  unit: unitCtrl.text.trim().isEmpty
                                      ? null
                                      : unitCtrl.text.trim(),
                                  amountDescription:
                                      amountDescCtrl.text.trim().isEmpty
                                          ? null
                                          : amountDescCtrl.text.trim(),
                                  type: selectedType.toJson(),
                                );

                                final created = await ref
                                    .read(recurringScheduleViewModelProvider
                                        .notifier,)
                                    .createScheduleDetail(
                                      scheduleId: scheduleId,
                                      detail: detail,
                                    );

                                if (!context.mounted) return;

                                if (created != null) {
                                  CustomToast.show(
                                    context,
                                    s.recurring_schedule_detail_create_success,
                                    type: ToastType.success,
                                  );
                                  Navigator.pop(context);
                                  ref
                                      .read(recurringScheduleViewModelProvider
                                          .notifier,)
                                      .fetchDetail(scheduleId);
                                } else {
                                  CustomToast.show(
                                    context,
                                    s.recurring_schedule_detail_create_failed,
                                    type: ToastType.error,
                                  );
                                  setModalState(() => isSubmitting = false);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: isSubmitting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(s.recurring_schedule_detail_create_submit),
                      ),
                    ),
                  ],
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

  String _weekdayLabel(BuildContext context, int dayOfWeek) {
    final locale = S.of(context)!.localeName;

    final normalized = dayOfWeek == 0 ? 7 : dayOfWeek;
    final baseMonday = DateTime(2020, 1, 6);
    final date = baseMonday.add(Duration(days: normalized - 1));
    return DateFormat.EEEE(locale).format(date);
  }

  String _timeLabel(BuildContext context, String raw) {
    final locale = S.of(context)!.localeName;

    // If API returns ISO time (contains 'T'), parse as DateTime
    if (raw.contains('T')) {
      final dt = DateTime.tryParse(raw);
      if (dt != null) {
        return DateFormat.Hm(locale).format(dt.toLocal());
      }
    }

    // Otherwise, handle "HH:mm:ss" or "HH:mm:ss.SSSSSSS"
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

  Future<void> _openDetailItemSheet(String detailId) async {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()?.screenPadding ?? 12.0;
    final s = S.of(context)!;

    Future<void> openEditSheet(RecurringScheduleDetailEntity current) async {
      final quantityCtrl = TextEditingController(
        text: (current.quantity ?? 0).toString(),
      );
      final unitCtrl = TextEditingController(text: current.unit ?? '');
      final amountDescCtrl =
          TextEditingController(text: current.amountDescription ?? '');
      ScrapPostDetailType selectedType =
          ScrapPostDetailType.parseType((current.type ?? 'sale').trim());
      bool isSubmitting = false;

      String? selectedUnit;

      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setModalState) {
              final currentUnit = unitCtrl.text.trim();
              final baseUnits = <String>[s.kg, s.g, s.ton, s.piece];
              final unitItems = <DropdownMenuItem<String>>[
                DropdownMenuItem(value: s.kg, child: Text(s.kg)),
                DropdownMenuItem(value: s.g, child: Text(s.g)),
                DropdownMenuItem(value: s.ton, child: Text(s.ton)),
                DropdownMenuItem(value: s.piece, child: Text(s.piece)),
                if (currentUnit.isNotEmpty && !baseUnits.contains(currentUnit))
                  DropdownMenuItem(value: currentUnit, child: Text(currentUnit)),
              ];

              selectedUnit ??= currentUnit.isEmpty ? null : currentUnit;
              return Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: EdgeInsets.only(
                  left: spacing,
                  right: spacing,
                  top: spacing,
                  bottom: spacing + MediaQuery.of(context).viewInsets.bottom,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              s.recurring_schedule_detail_update_title,
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
                      TextField(
                        controller: quantityCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: false,
                        ),
                        decoration: InputDecoration(
                          labelText: s.recurring_schedule_field_quantity,
                        ),
                      ),
                      SizedBox(height: spacing),
                      DropdownButtonFormField<String>(
                        initialValue: selectedUnit,
                        decoration: InputDecoration(
                          labelText: s.recurring_schedule_field_unit,
                        ),
                        items: unitItems,
                        onChanged: (value) {
                          if (value == null) return;
                          setModalState(() {
                            selectedUnit = value;
                            unitCtrl.text = value;
                          });
                        },
                      ),
                      SizedBox(height: spacing),
                      TextField(
                        controller: amountDescCtrl,
                        decoration: InputDecoration(
                          labelText: s.recurring_schedule_field_amount_description,
                        ),
                      ),
                      SizedBox(height: spacing),
                      DropdownButtonFormField<ScrapPostDetailType>(
                        initialValue: selectedType,
                        decoration: InputDecoration(
                          labelText: s.recurring_schedule_field_type,
                        ),
                        items: ScrapPostDetailType.values
                            .map(
                              (t) => DropdownMenuItem(
                                value: t,
                                child: Text(
                                  ScrapPostDetailTypeHelper.getLocalizedType(
                                    context,
                                    t,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (v) {
                          if (v == null) return;
                          setModalState(() => selectedType = v);
                        },
                      ),
                      SizedBox(height: spacing * 1.5),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isSubmitting
                              ? null
                              : () async {
                                  final qty =
                                      num.tryParse(quantityCtrl.text.trim());

                                  setModalState(() => isSubmitting = true);

                                  final updated = await ref
                                      .read(recurringScheduleViewModelProvider
                                          .notifier,)
                                      .updateScheduleDetail(
                                        scheduleId: widget.id,
                                        detailId: current.id,
                                        quantity: qty,
                                        unit: unitCtrl.text.trim().isEmpty
                                            ? null
                                            : unitCtrl.text.trim(),
                                        amountDescription:
                                            amountDescCtrl.text.trim().isEmpty
                                                ? null
                                                : amountDescCtrl.text.trim(),
                                        type: selectedType.toJson(),
                                      );

                                  if (!context.mounted) return;

                                  if (updated != null) {
                                    CustomToast.show(
                                      context,
                                      s.recurring_schedule_detail_update_success,
                                      type: ToastType.success,
                                    );
                                    Navigator.pop(context);
                                    // close the previous detail sheet too
                                    // ignore: use_build_context_synchronously
                                    if (Navigator.canPop(this.context)) {
                                      // ignore: use_build_context_synchronously
                                      Navigator.pop(this.context);
                                    }
                                    ref
                                        .read(recurringScheduleViewModelProvider
                                            .notifier,)
                                        .fetchDetail(widget.id);
                                  } else {
                                    CustomToast.show(
                                      context,
                                      s.recurring_schedule_detail_update_failed,
                                      type: ToastType.error,
                                    );
                                    setModalState(() => isSubmitting = false);
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          child: isSubmitting
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(s.recurring_schedule_detail_update_submit),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    }

    Future<void> confirmAndDelete(RecurringScheduleDetailEntity current) async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text(s.recurring_schedule_detail_delete_title),
            content: Text(s.recurring_schedule_detail_delete_message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text(s.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: Text(
                  s.delete,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
            ],
          );
        },
      );

      if (confirmed != true) return;

      final ok = await ref
          .read(recurringScheduleViewModelProvider.notifier)
          .deleteScheduleDetail(
            scheduleId: widget.id,
            detailId: current.id,
          );

      if (!context.mounted) return;

      if (ok) {
        CustomToast.show(
          // ignore: use_build_context_synchronously
          context,
          s.recurring_schedule_detail_delete_success,
          type: ToastType.success,
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        ref
            .read(recurringScheduleViewModelProvider.notifier)
            .fetchDetail(widget.id);
      } else {
        CustomToast.show(
          // ignore: use_build_context_synchronously
          context,
          s.recurring_schedule_detail_delete_failed,
          type: ToastType.error,
        );
      }
    }

    // Kick off fetch, then show sheet bound to provider state
    ref
        .read(recurringScheduleViewModelProvider.notifier)
        .getScheduleDetailItem(detailId);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final state = ref.watch(recurringScheduleViewModelProvider);
            final item = state.detailItem;
            final isLoading = state.isLoadingDetail;

            final name = (item?.scrapCategory?.categoryName ?? '').trim();

            final qty = item?.quantity;
            final unit = item?.unit;
            final qtyLabel = qty == null
                ? ''
                : unit == null || unit.isEmpty
                    ? qty.toString()
                    : '${qty.toString()} $unit';

            return Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.only(
                left: spacing,
                right: spacing,
                top: spacing,
                bottom: spacing + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name.isEmpty
                                    ? s.recurring_schedules_details_section
                                    : name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (qtyLabel.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  '${s.quantity}: $qtyLabel',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    SizedBox(height: spacing),
                    if (isLoading)
                      const Center(child: RotatingLeafLoader())
                    else if (item == null)
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(s.error_occurred),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                ref
                                    .read(recurringScheduleViewModelProvider
                                        .notifier,)
                                    .getScheduleDetailItem(detailId);
                              },
                              child: Text(s.retry),
                            ),
                          ],
                        ),
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    if ((item.amountDescription ?? '')
                                        .trim()
                                        .isNotEmpty)
                                      Chip(
                                        label: Text(
                                          '${s.amount_description}: ${item.amountDescription}',
                                          style: theme.textTheme.bodyMedium,
                                        ),
                                      ),
                                    if ((item.type ?? '').trim().isNotEmpty)
                                      Chip(
                                        label: Text(
                                          '${s.recurring_schedule_field_type}: ${ScrapPostDetailTypeHelper.getLocalizedType(context, ScrapPostDetailType.parseType(item.type!))}',
                                          style: theme.textTheme.bodyMedium,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: spacing),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => openEditSheet(item),
                                  icon: const Icon(Icons.edit_outlined, size: 18),
                                  label:
                                      Text(s.recurring_schedule_detail_update_title),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => confirmAndDelete(item),
                                  icon: Icon(
                                    Icons.delete_outline,
                                    size: 18,
                                    color: theme.colorScheme.error,
                                  ),
                                  label: Text(
                                    s.delete,
                                    style:
                                        TextStyle(color: theme.colorScheme.error),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: theme.colorScheme.error,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _openUpdateBottomSheet(RecurringScheduleEntity current) async {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()?.screenPadding ?? 12.0;
    final s = S.of(context)!;

    final titleCtrl = TextEditingController(text: current.title);
    final descCtrl = TextEditingController(text: current.description);
    final addressCtrl = TextEditingController(text: current.address);

    final latCtrl = TextEditingController(
      text: (current.location?.latitude ?? 0).toString(),
    );
    final lngCtrl = TextEditingController(
      text: (current.location?.longitude ?? 0).toString(),
    );

    bool mustTakeAll = current.mustTakeAll;
    int dayOfWeek = current.dayOfWeek;

    // Prefill time using current values if possible
    TimeOfDay parseTime(String raw, TimeOfDay fallback) {
      if (raw.contains('T')) {
        final dt = DateTime.tryParse(raw);
        if (dt != null) {
          final local = dt.toLocal();
          return TimeOfDay(hour: local.hour, minute: local.minute);
        }
      }
      final cleaned = raw.split('.').first;
      final parts = cleaned.split(':');
      if (parts.length >= 2) {
        final hh = int.tryParse(parts[0]);
        final mm = int.tryParse(parts[1]);
        if (hh != null && mm != null) {
          return TimeOfDay(hour: hh, minute: mm);
        }
      }
      return fallback;
    }

    TimeOfDay start =
        parseTime(current.startTime, const TimeOfDay(hour: 7, minute: 0));
    TimeOfDay end =
        parseTime(current.endTime, const TimeOfDay(hour: 8, minute: 0));

    bool isSubmitting = false;

    String timeToIso(TimeOfDay t) {
      final now = DateTime.now().toUtc();
      final dt = DateTime.utc(now.year, now.month, now.day, t.hour, t.minute);
      return dt.toIso8601String();
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

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.only(
                left: spacing,
                right: spacing,
                top: spacing,
                bottom: spacing + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            s.recurring_schedules_update_title,
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
                    TextField(
                      controller: titleCtrl,
                      decoration: InputDecoration(
                        labelText: s.recurring_schedule_field_title,
                      ),
                    ),
                    SizedBox(height: spacing),
                    TextField(
                      controller: descCtrl,
                      decoration: InputDecoration(
                        labelText: s.recurring_schedule_field_description,
                      ),
                    ),
                    SizedBox(height: spacing),
                    TextField(
                      controller: addressCtrl,
                      decoration: InputDecoration(
                        labelText: s.recurring_schedule_field_address,
                      ),
                    ),
                    SizedBox(height: spacing),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: latCtrl,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: true,
                            ),
                            decoration: InputDecoration(
                              labelText: s.recurring_schedule_field_latitude,
                            ),
                          ),
                        ),
                        SizedBox(width: spacing),
                        Expanded(
                          child: TextField(
                            controller: lngCtrl,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: true,
                            ),
                            decoration: InputDecoration(
                              labelText: s.recurring_schedule_field_longitude,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: spacing),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: Text(s.recurring_schedule_must_take_all),
                      value: mustTakeAll,
                      onChanged: (v) => setModalState(() => mustTakeAll = v),
                    ),
                    SizedBox(height: spacing / 2),
                    DropdownButtonFormField<int>(
                      initialValue: dayOfWeek,
                      decoration: InputDecoration(
                        labelText: s.recurring_schedule_field_day_of_week,
                      ),
                      items: List.generate(
                        7,
                        (i) => DropdownMenuItem(
                          value: i,
                          child: Text(i.toString()),
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
                                labelText: s.recurring_schedule_field_end_time,
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
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isSubmitting
                            ? null
                            : () async {
                                final title = titleCtrl.text.trim();
                                final description = descCtrl.text.trim();
                                final address = addressCtrl.text.trim();

                                final lat =
                                    double.tryParse(latCtrl.text.trim()) ?? 0;
                                final lng =
                                    double.tryParse(lngCtrl.text.trim()) ?? 0;

                                if (title.isEmpty || address.isEmpty) {
                                  CustomToast.show(
                                    context,
                                    s.error_all_field,
                                    type: ToastType.warning,
                                  );
                                  return;
                                }

                                setModalState(() => isSubmitting = true);

                                final entity = RecurringScheduleEntity(
                                  id: current.id,
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
                                  isActive: current.isActive,
                                  scheduleDetails: current.scheduleDetails,
                                  lastRunDate: current.lastRunDate,
                                  createdAt: current.createdAt,
                                );

                                final ok = await ref
                                    .read(recurringScheduleViewModelProvider
                                        .notifier,)
                                    .updateSchedule(
                                      id: current.id,
                                      entity: entity,
                                    );

                                if (!mounted) return;

                                if (ok) {
                                  CustomToast.show(
                                    // ignore: use_build_context_synchronously
                                    context,
                                    s.recurring_schedules_update_success,
                                    type: ToastType.success,
                                  );
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context);
                                  ref
                                      .read(recurringScheduleViewModelProvider
                                          .notifier,)
                                      .fetchDetail(widget.id);
                                } else {
                                  CustomToast.show(
                                    // ignore: use_build_context_synchronously
                                    context,
                                    s.recurring_schedules_update_failed,
                                    type: ToastType.error,
                                  );
                                  setModalState(() => isSubmitting = false);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: isSubmitting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(s.recurring_schedules_update_submit),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()?.screenPadding ?? 12.0;
    final s = S.of(context)!;

    final state = ref.watch(recurringScheduleViewModelProvider);
    final detail = state.detailData;
    final isLoading = state.isLoadingDetail;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
                    Icons.event_note_outlined,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: spacing),
                Expanded(
                  child: Text(
                    s.recurring_schedules_detail_title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (detail != null)
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () => _openUpdateBottomSheet(detail),
                  ),
              ],
            ),
          ),
          Divider(height: 1, color: theme.dividerColor),
          Expanded(
            child: isLoading
                ? const Center(child: RotatingLeafLoader())
                : detail == null
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(spacing),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(s.error_occurred),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {
                                  ref
                                      .read(recurringScheduleViewModelProvider
                                          .notifier,)
                                      .fetchDetail(widget.id);
                                },
                                child: Text(s.retry),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView(
                        padding: EdgeInsets.all(spacing),
                        children: [
                          _InfoCard(
                            title: detail.title.isNotEmpty
                                ? detail.title
                                : '${_weekdayLabel(context, detail.dayOfWeek)} · ${_timeLabel(context, detail.startTime)} - ${_timeLabel(context, detail.endTime)}',
                            subtitle: detail.description,
                            isActive: detail.isActive,
                            onToggle: (value) async {
                              final ok = await ref
                                  .read(recurringScheduleViewModelProvider
                                      .notifier,)
                                  .toggleSchedule(detail.id);

                              if (!context.mounted) return;

                              if (ok) {
                                CustomToast.show(
                                  context,
                                  s.recurring_schedules_toggle_success,
                                  type: ToastType.success,
                                );
                                ref
                                    .read(recurringScheduleViewModelProvider
                                        .notifier,)
                                    .fetchDetail(widget.id);
                              } else {
                                CustomToast.show(
                                  context,
                                  s.recurring_schedules_toggle_failed,
                                  type: ToastType.error,
                                );
                              }
                            },
                          ),
                          SizedBox(height: spacing),
                          _KeyValueRow(
                            label: s.recurring_schedule_address,
                            value: detail.address,
                          ),
                          SizedBox(height: spacing / 2),
                          _KeyValueRow(
                            label: s.recurring_schedule_created_at,
                            value: _dateTimeLabel(context, detail.createdAt),
                          ),
                          SizedBox(height: spacing / 2),
                          _KeyValueRow(
                            label: s.recurring_schedule_last_run_date,
                            value: _dateTimeLabel(context, detail.lastRunDate),
                          ),
                          SizedBox(height: spacing / 2),
                          _KeyValueRow(
                            label: s.recurring_schedule_must_take_all,
                            value: detail.mustTakeAll ? s.yes : s.no,
                          ),
                          SizedBox(height: spacing * 1.5),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  s.recurring_schedules_details_section,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () =>
                                    _openCreateDetailSheet(detail.id),
                                icon: const Icon(Icons.add_circle_outline),
                                tooltip: s.add,
                              ),
                            ],
                          ),
                          SizedBox(height: spacing),
                          if (detail.scheduleDetails.isEmpty)
                            Text(
                              s.no_data,
                              style: theme.textTheme.bodyMedium,
                            )
                          else
                            ...detail.scheduleDetails.map(
                              (e) => _DetailItemCard(
                                detail: e,
                                onTap: () => _openDetailItemSheet(e.id),
                              ),
                            ),
                        ],
                      ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isActive;
  final ValueChanged<bool> onToggle;

  const _InfoCard({
    required this.title,
    required this.subtitle,
    required this.isActive,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()?.screenPadding ?? 12.0;

    return Container(
      padding: EdgeInsets.all(spacing),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
          SizedBox(width: spacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch.adaptive(value: isActive, onChanged: onToggle),
        ],
      ),
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  final String label;
  final String value;

  const _KeyValueRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Text(
            value.isEmpty ? '-' : value,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

class _DetailItemCard extends StatelessWidget {
  final RecurringScheduleDetailEntity detail;
  final VoidCallback onTap;

  const _DetailItemCard({required this.detail, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()?.screenPadding ?? 12.0;
    final s = S.of(context)!;
    final name = (detail.scrapCategory?.categoryName ?? '').trim().isEmpty
        ? s.recurring_schedules_details_section
        : detail.scrapCategory!.categoryName;

    final qty = detail.quantity;
    final unit = detail.unit;
    final qtyLabel = qty == null
        ? ''
        : unit == null || unit.isEmpty
            ? qty.toString()
            : '${qty.toString()} $unit';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: EdgeInsets.only(bottom: spacing),
          padding: EdgeInsets.all(spacing),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border:
                Border.all(color: theme.dividerColor.withValues(alpha: 0.6)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (qtyLabel.isNotEmpty) ...[
                      SizedBox(height: spacing / 2),
                      Text(
                        '${s.quantity}: $qtyLabel',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if ((detail.amountDescription ?? '').trim().isNotEmpty)
                          Chip(
                            label: Text(
                              detail.amountDescription!,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        if ((detail.type ?? '').trim().isNotEmpty)
                          Chip(
                            label: Text(
                              detail.type!,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: theme.primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.chevron_right,
                  color: theme.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
