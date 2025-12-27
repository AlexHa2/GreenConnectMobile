import 'package:GreenConnectMobile/core/enum/scrap_post_detail_type.dart';
import 'package:GreenConnectMobile/core/helper/scrap_post_detail_type_helper.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/location_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_category_entity.dart';
import 'package:GreenConnectMobile/features/post/presentation/providers/scrap_category_providers.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/post_info_form.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/entities/recurring_schedule_detail_entity.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/entities/recurring_schedule_entity.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/presentation/providers/recurring_schedule_providers.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/address_picker_bottom_sheet.dart';
import 'package:GreenConnectMobile/shared/widgets/button_gradient.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CreateRecurringSchedulePage extends ConsumerStatefulWidget {
  const CreateRecurringSchedulePage({super.key});

  @override
  ConsumerState<CreateRecurringSchedulePage> createState() =>
      _CreateRecurringSchedulePageState();
}

class _CreateRecurringSchedulePageState
    extends ConsumerState<CreateRecurringSchedulePage> {
  static const int _stepCount = 3;

  final _formKey = GlobalKey<FormState>();
  late final PageController _pageController;

  int _currentStep = 0;

  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  final TextEditingController _addressCtrl = TextEditingController();

  LocationEntity? _location;
  bool _addressFound = false;
  bool _mustTakeAll = false;

  int _dayOfWeek = 1; // 1..7 (UI)
  TimeOfDay _start = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay _end = const TimeOfDay(hour: 8, minute: 0);

  final List<RecurringScheduleDetailEntity> _details = [];

  bool _isSubmitting = false;

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
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  bool _hasCategoryExists(String categoryId) {
    return _details.any((e) => e.scrapCategoryId == categoryId);
  }

  String _detailTitle(RecurringScheduleDetailEntity detail) {
    final name = (detail.scrapCategory?.categoryName ?? '').trim();
    if (name.isNotEmpty) return name;
    return detail.scrapCategoryId;
  }

  String _detailSubtitle(
      BuildContext context, RecurringScheduleDetailEntity d) {
    final s = S.of(context)!;
    final qty = d.quantity;
    final unit = (d.unit ?? '').trim();

    String qtyLabel = '';
    if (qty != null) {
      qtyLabel = unit.isEmpty ? qty.toString() : '${qty.toString()} $unit';
    }

    final typeRaw = (d.type ?? '').trim();
    final typeLabel = typeRaw.isEmpty
        ? ''
        : ScrapPostDetailTypeHelper.getLocalizedType(
            context,
            ScrapPostDetailType.parseType(typeRaw),
          );

    final parts = <String>[];
    if (qtyLabel.isNotEmpty) parts.add('${s.quantity}: $qtyLabel');
    if (typeLabel.isNotEmpty) {
      parts.add('${s.recurring_schedule_field_type}: $typeLabel');
    }

    return parts.join(' • ');
  }

  Future<void> _openAddItemSheet(List<ScrapCategoryEntity> categories) async {
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
                            s.add_scrap_items,
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
                        isDense: true,
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
                              isDense: true,
                            ),
                          ),
                        ),
                        SizedBox(width: spacing),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: selectedUnit,
                            decoration: InputDecoration(
                              labelText: s.recurring_schedule_field_unit,
                              isDense: true,
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
                        labelText:
                            s.recurring_schedule_field_amount_description,
                        isDense: true,
                      ),
                    ),
                    SizedBox(height: spacing),
                    DropdownButtonFormField<ScrapPostDetailType>(
                      value: selectedType,
                      decoration: InputDecoration(
                        labelText: s.recurring_schedule_field_type,
                        isDense: true,
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
                            : () {
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

                                if (_hasCategoryExists(scrapCategoryId)) {
                                  CustomToast.show(
                                    context,
                                    s.error_category_exists,
                                    type: ToastType.warning,
                                  );
                                  return;
                                }

                                setModalState(() => isSubmitting = true);

                                final qty =
                                    num.tryParse(quantityCtrl.text.trim());
                                ScrapCategoryEntity? pickedCategory;
                                for (final c in categories) {
                                  if (c.scrapCategoryId == scrapCategoryId) {
                                    pickedCategory = c;
                                    break;
                                  }
                                }

                                setState(() {
                                  _details.add(
                                    RecurringScheduleDetailEntity(
                                      id: '',
                                      recurringScheduleId: '',
                                      scrapCategoryId: scrapCategoryId,
                                      scrapCategory: pickedCategory,
                                      quantity: qty,
                                      unit: unitCtrl.text.trim().isEmpty
                                          ? null
                                          : unitCtrl.text.trim(),
                                      amountDescription:
                                          amountDescCtrl.text.trim().isEmpty
                                              ? null
                                              : amountDescCtrl.text.trim(),
                                      type: selectedType.toJson(),
                                    ),
                                  );
                                });

                                Navigator.pop(context);
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
                            : Text(s.add),
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

  Future<void> _openEditItemSheet(
    List<ScrapCategoryEntity> categories,
    int index,
  ) async {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()?.screenPadding ?? 12.0;
    final s = S.of(context)!;

    final current = _details[index];

    String? selectedCategoryId = current.scrapCategoryId;
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
                    TextField(
                      controller: quantityCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: false,
                      ),
                      decoration: InputDecoration(
                        labelText: s.recurring_schedule_field_quantity,
                        isDense: true,
                      ),
                    ),
                    SizedBox(height: spacing),
                    DropdownButtonFormField<String>(
                      initialValue: selectedUnit,
                      decoration: InputDecoration(
                        labelText: s.recurring_schedule_field_unit,
                        isDense: true,
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
                        labelText:
                            s.recurring_schedule_field_amount_description,
                        isDense: true,
                      ),
                    ),
                    SizedBox(height: spacing),
                    DropdownButtonFormField<ScrapPostDetailType>(
                      value: selectedType,
                      decoration: InputDecoration(
                        labelText: s.recurring_schedule_field_type,
                        isDense: true,
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
                            : () {
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

                                if (scrapCategoryId !=
                                        current.scrapCategoryId &&
                                    _hasCategoryExists(scrapCategoryId)) {
                                  CustomToast.show(
                                    context,
                                    s.error_category_exists,
                                    type: ToastType.warning,
                                  );
                                  return;
                                }

                                setModalState(() => isSubmitting = true);
                                final qty =
                                    num.tryParse(quantityCtrl.text.trim());
                                ScrapCategoryEntity? pickedCategory;
                                for (final c in categories) {
                                  if (c.scrapCategoryId == scrapCategoryId) {
                                    pickedCategory = c;
                                    break;
                                  }
                                }

                                setState(() {
                                  _details[index] =
                                      RecurringScheduleDetailEntity(
                                    id: '',
                                    recurringScheduleId: '',
                                    scrapCategoryId: scrapCategoryId,
                                    scrapCategory: pickedCategory,
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
                                });

                                Navigator.pop(context);
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
                            : Text(s.save),
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

  Widget _buildDetailCard(
    BuildContext context,
    RecurringScheduleDetailEntity detail,
    int index,
    List<ScrapCategoryEntity> categories,
  ) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()?.screenPadding ?? 12.0;

    final title = _detailTitle(detail);
    final subtitle = _detailSubtitle(context, detail);
    final amountDesc = (detail.amountDescription ?? '').trim();

    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(spacing),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: spacing * 3,
              height: spacing * 3,
              decoration: BoxDecoration(
                color: theme.primaryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(spacing),
              ),
              child: Icon(
                Icons.inventory_2_outlined,
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
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle.isNotEmpty) ...[
                    SizedBox(height: spacing * 0.25),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (amountDesc.isNotEmpty) ...[
                    SizedBox(height: spacing * 0.25),
                    Text(
                      amountDesc,
                      style: theme.textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () => _openEditItemSheet(categories, index),
                  icon: Icon(
                    Icons.edit_outlined,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() => _details.removeAt(index));
                  },
                  icon: Icon(
                    Icons.delete_outline,
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _weekdayLabel(BuildContext context, int value) {
    final locale = S.of(context)!.localeName;

    // Normalize to 1..7 (Mon..Sun)
    final normalized = value == 0 ? 7 : value;

    // 2020-01-06 is Monday
    final baseMonday = DateTime(2020, 1, 6);
    final date = baseMonday.add(Duration(days: normalized - 1));
    return DateFormat.EEEE(locale).format(date);
  }

  Future<void> _pickStart() async {
    final theme = Theme.of(context);
    final picked = await showTimePicker(
      context: context,
      initialTime: _start,
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
      setState(() => _start = picked);
    }
  }

  Future<void> _pickEnd() async {
    final theme = Theme.of(context);
    final picked = await showTimePicker(
      context: context,
      initialTime: _end,
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
      setState(() => _end = picked);
    }
  }

  String _timeToIso(TimeOfDay t) {
    final hh = t.hour.toString().padLeft(2, '0');
    final mm = t.minute.toString().padLeft(2, '0');
    return '$hh:$mm:00.000';
  }

  void _handleAddressSelected(
    String address,
    double? latitude,
    double? longitude,
  ) {
    _addressCtrl.text = address;
    if (latitude != null && longitude != null) {
      _location = LocationEntity(latitude: latitude, longitude: longitude);
      _addressFound = true;
    } else {
      _location = null;
      _addressFound = false;
    }
    setState(() {});
  }

  Future<void> _openAddressPicker() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddressPickerBottomSheet(
        initialAddress: _addressCtrl.text.trim(),
        onAddressSelected: (address, latitude, longitude) {
          _handleAddressSelected(address, latitude, longitude);
        },
      ),
    );
  }

  bool _validateStep(int step) {
    final s = S.of(context)!;

    if (step == 0) {
      final title = _titleCtrl.text.trim();
      final address = _addressCtrl.text.trim();

      if (title.isEmpty || address.isEmpty) {
        CustomToast.show(
          context,
          s.error_all_field,
          type: ToastType.warning,
        );
        return false;
      }

      if (!_addressFound || _location == null) {
        CustomToast.show(
          context,
          s.address_not_found,
          type: ToastType.warning,
        );
        return false;
      }

      return true;
    }

    if (step == 1) {
      if (_start.hour == _end.hour && _start.minute == _end.minute) {
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
      if (_details.isEmpty) {
        CustomToast.show(
          context,
          s.error_scrap_item_empty,
          type: ToastType.warning,
        );
        return false;
      }
      return true;
    }

    return true;
  }

  Future<void> _jumpToStep(int step) async {
    if (step < 0 || step >= _stepCount) return;

    if (step > _currentStep) {
      final ok = _validateStep(_currentStep);
      if (!ok) return;
    }

    setState(() => _currentStep = step);
    await _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  Widget _buildStepHeader() {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()?.screenPadding ?? 12.0;

    final progress = (_currentStep + 1) / _stepCount;

    final steps = <({String title, IconData icon})>[
      (title: S.of(context)!.post_information, icon: Icons.list_alt_rounded),
      (
        title: S.of(context)!.scheduleListTitle,
        icon: Icons.calendar_month_rounded
      ),
      (
        title: S.of(context)!.pricing_information,
        icon: Icons.inventory_2_rounded
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                steps[_currentStep].title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              '${_currentStep + 1}/$_stepCount',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: spacing * 0.8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor:
                theme.colorScheme.onSurface.withValues(alpha: 0.08),
            valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
          ),
        ),
        SizedBox(height: spacing * 1.2),
        Row(
          children: List.generate(steps.length, (index) {
            final isActive = index == _currentStep;
            final canTap = index <= _currentStep;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing * 0.25),
                child: InkWell(
                  onTap: canTap ? () => _jumpToStep(index) : null,
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: spacing * 0.7,
                      horizontal: spacing * 0.8,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? theme.primaryColor.withValues(alpha: 0.12)
                          : theme.colorScheme.onSurface.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: isActive
                            ? theme.primaryColor.withValues(alpha: 0.35)
                            : theme.colorScheme.onSurface
                                .withValues(alpha: 0.08),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          steps[index].icon,
                          size: 18,
                          color: isActive
                              ? theme.primaryColor
                              : theme.colorScheme.onSurface
                                  .withValues(alpha: 0.65),
                        ),
                        SizedBox(width: spacing * 0.5),
                        Flexible(
                          child: Text(
                            '${index + 1}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: isActive
                                  ? theme.primaryColor
                                  : theme.colorScheme.onSurface
                                      .withValues(alpha: 0.75),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    final s = S.of(context)!;

    final okSteps = _validateStep(0) && _validateStep(1) && _validateStep(2);
    if (!okSteps) return;

    final title = _titleCtrl.text.trim();
    final description = _descCtrl.text.trim();
    final address = _addressCtrl.text.trim();

    if (_details.isEmpty) {
      CustomToast.show(
        context,
        s.error_scrap_item_empty,
        type: ToastType.warning,
      );
      return;
    }

    if (title.isEmpty || address.isEmpty || _location == null) {
      CustomToast.show(
        context,
        s.error_all_field,
        type: ToastType.warning,
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final backendDayOfWeek = _dayOfWeek == 7 ? 0 : _dayOfWeek;

      final entity = RecurringScheduleEntity(
        id: '',
        title: title,
        description: description,
        address: address,
        location: _location!,
        mustTakeAll: _mustTakeAll,
        dayOfWeek: backendDayOfWeek,
        startTime: _timeToIso(_start),
        endTime: _timeToIso(_end),
        isActive: true,
        scheduleDetails: _details
            .map(
              (d) => RecurringScheduleDetailEntity(
                id: '',
                recurringScheduleId: '',
                scrapCategoryId: d.scrapCategoryId,
                quantity: d.quantity,
                unit: (d.unit ?? '').trim().isEmpty ? null : d.unit,
                amountDescription: (d.amountDescription ?? '').trim().isEmpty
                    ? null
                    : d.amountDescription,
                type: (d.type ?? '').trim().isEmpty ? null : d.type,
              ),
            )
            .toList(),
        lastRunDate: null,
        createdAt: null,
      );

      final ok = await ref
          .read(recurringScheduleViewModelProvider.notifier)
          .createSchedule(entity);

      if (!mounted) return;

      if (ok) {
        CustomToast.show(
          context,
          s.recurring_schedules_create_success,
          type: ToastType.success,
        );
        Navigator.pop(context, true);
        return;
      }

      CustomToast.show(
        context,
        s.recurring_schedules_create_failed,
        type: ToastType.error,
      );
      setState(() => _isSubmitting = false);
    } catch (e) {
      if (!mounted) return;
      CustomToast.show(
        context,
        s.recurring_schedules_create_failed,
        type: ToastType.error,
      );
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()?.screenPadding ?? 12.0;
    final s = S.of(context)!;

    final catState = ref.watch(scrapCategoryViewModelProvider);
    final categories = catState.listData?.data ?? <ScrapCategoryEntity>[];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(spacing),
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: spacing * 0.5),
              _buildStepHeader(),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: PostInfoForm(
                          formKey: _formKey,
                          titleController: _titleCtrl,
                          descController: _descCtrl,
                          addressController: _addressCtrl,
                          onSearchAddress: _openAddressPicker,
                          onGetCurrentLocation: _openAddressPicker,
                          addressFound: _addressFound,
                          isLoadingLocation: false,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.recurring_schedule_field_day_of_week,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: spacing / 2),
                          DropdownButtonFormField<int>(
                            initialValue: _dayOfWeek,
                            decoration: const InputDecoration(
                              isDense: true,
                            ),
                            items: List.generate(7, (i) {
                              final value = i + 1;
                              return DropdownMenuItem(
                                value: value,
                                child: Text(_weekdayLabel(context, value)),
                              );
                            }),
                            onChanged: (v) {
                              if (v != null) {
                                setState(() => _dayOfWeek = v);
                              }
                            },
                          ),
                          SizedBox(height: spacing),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: _pickStart,
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      labelText:
                                          s.recurring_schedule_field_start_time,
                                      isDense: true,
                                    ),
                                    child: Text(
                                      _start.format(context),
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: spacing),
                              Expanded(
                                child: InkWell(
                                  onTap: _pickEnd,
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      labelText:
                                          s.recurring_schedule_field_end_time,
                                      isDense: true,
                                    ),
                                    child: Text(
                                      _end.format(context),
                                      style: theme.textTheme.bodyMedium,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.recurring_schedules_details_section,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: spacing),
                          SwitchListTile.adaptive(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              s.recurring_schedule_must_take_all,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            value: _mustTakeAll,
                            onChanged: (v) => setState(() => _mustTakeAll = v),
                          ),
                          SizedBox(height: spacing),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  s.add_scrap_items,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: categories.isEmpty
                                    ? null
                                    : () => _openAddItemSheet(categories),
                                icon: const Icon(Icons.add),
                                label: Text(s.add),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.primaryColor,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: spacing),
                          if (_details.isEmpty)
                            Container(
                              padding: EdgeInsets.all(spacing),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.04),
                                borderRadius: BorderRadius.circular(spacing),
                                border: Border.all(
                                  color: theme.dividerColor,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    size: 18,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  SizedBox(width: spacing * 0.6),
                                  Expanded(
                                    child: Text(
                                      s.error_scrap_item_empty,
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        color:
                                            theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            Column(
                              children: _details
                                  .asMap()
                                  .entries
                                  .map(
                                    (e) => _buildDetailCard(
                                      context,
                                      e.value,
                                      e.key,
                                      categories,
                                    ),
                                  )
                                  .toList(),
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
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isSubmitting
                            ? null
                            : () => _jumpToStep(_currentStep - 1),
                        child: Text(s.back),
                      ),
                    ),
                  if (_currentStep > 0) SizedBox(width: spacing),
                  Expanded(
                    flex: 2,
                    child: GradientButton(
                      onPressed: _isSubmitting
                          ? null
                          : () async {
                              if (_currentStep < _stepCount - 1) {
                                await _jumpToStep(_currentStep + 1);
                                return;
                              }
                              await _submit();
                            },
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              _currentStep < _stepCount - 1
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
    );
  }
}
