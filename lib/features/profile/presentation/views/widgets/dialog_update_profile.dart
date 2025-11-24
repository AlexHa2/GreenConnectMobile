import 'package:GreenConnectMobile/core/helper/format_date.dart';
import 'package:GreenConnectMobile/features/profile/data/models/user_update_model.dart';
import 'package:GreenConnectMobile/features/profile/domain/entities/user_update_entity.dart';
import 'package:GreenConnectMobile/features/profile/presentation/providers/profile_providers.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/app_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class UpdateProfileDialog extends ConsumerStatefulWidget {
  final UserUpdateEntity? user;
  final void Function()? onUpdated;

  const UpdateProfileDialog({super.key, this.user, this.onUpdated});

  @override
  ConsumerState<UpdateProfileDialog> createState() =>
      _UpdateProfileDialogState();
}

class _UpdateProfileDialogState extends ConsumerState<UpdateProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();

  String _gender = 'Other';
  DateTime? _selectedDob;

  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final u = widget.user;

    _fullNameCtrl.text = u?.fullName ?? '';
    _addressCtrl.text = u?.address ?? '';
    _gender = (u?.gender ?? '').isNotEmpty ? u!.gender : 'Other';

    _dobCtrl.text = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if ((u?.dateOfBirth ?? '').isNotEmpty) {
      try {
        _selectedDob = DateFormat('yyyy-MM-dd').parse(u!.dateOfBirth);
        _dobCtrl.text = DateFormat('yyyy-MM-dd').format(_selectedDob!);
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _dobCtrl.dispose();
    super.dispose();
  }

  // ---------------- VALIDATORS ----------------

  String? _validateFullName(String? v) {
    final s = S.of(context)!;

    if (v == null || v.trim().isEmpty) return s.fullname_required;
    if (v.trim().length > 255) return s.max_length_255;

    return null;
  }

  String? _validateAddress(String? v) {
    final s = S.of(context)!;

    if (v == null || v.trim().isEmpty) return s.address_required;
    if (v.trim().length > 255) return s.max_length_255;

    return null;
  }

  String? _validateGender(String? v) {
    final s = S.of(context)!;
    if (v == null || v.isEmpty) return s.gender_required;
    return null;
  }

  String? _validateDob(String? v) {
    final s = S.of(context)!;
    if (_selectedDob == null) return s.dob_required;

    final now = DateTime.now();
    if (_selectedDob!.isAfter(now)) return s.dob_invalid;

    final age =
        now.year -
        _selectedDob!.year -
        ((now.month < _selectedDob!.month ||
                (now.month == _selectedDob!.month &&
                    now.day < _selectedDob!.day))
            ? 1
            : 0);

    if (age < 13) return s.age_must_be_13;
    if (age > 120) return s.dob_invalid;

    return null;
  }

  // ---------------- PICK DOB ----------------
  Future<void> _pickDob() async {
    final now = DateTime.now();
    final init = _selectedDob ?? DateTime(now.year - 20);

    final picked = await showDatePicker(
      context: context,
      initialDate: init,
      firstDate: DateTime(now.year - 120),
      lastDate: now,
    );

    if (picked != null) {
      setState(() {
        _selectedDob = picked;
        _dobCtrl.text = DateFormat.yMMMMd().format(picked);
      });
    }
  }

  // ---------------- SUBMIT ----------------
  Future<void> _submit() async {
    final s = S.of(context)!;

    setState(() => _error = null);

    if (!(_formKey.currentState?.validate() ?? false)) return;

    final payload = {
      "fullName": _fullNameCtrl.text.trim(),
      "phoneNumber": _phoneCtrl.text.trim(),
      "address": _addressCtrl.text.trim(),
      "gender": _gender,
      "dateOfBirth": _selectedDob != null
          ? formatDateOnly(_selectedDob!)
          : null,
    };

    const restricted = {"std", "roles", "rank", "id", "_id"};
    payload.removeWhere((k, v) => restricted.contains(k));

    try {
      setState(() => _loading = true);

      final notifier = ref.read(profileViewModelProvider.notifier);
      await notifier.updateMe(UserUpdateModel.fromJson(payload));

      if (mounted) {
        widget.onUpdated?.call();
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      setState(() => _error = "${s.error}: ${e.toString()}");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final theme = Theme.of(context);

    return AlertDialog(
      backgroundColor: theme.scaffoldBackgroundColor,
      title: Text(s.edit_profile),
      content: SingleChildScrollView(
        child: SizedBox(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppInputField(
                  label: s.fullName,
                  controller: _fullNameCtrl,
                  hint: s.fullName_hint,
                  validator: _validateFullName,
                ),

                SizedBox(height: spacing.screenPadding),

                AppInputField(
                  label: s.street_address,
                  controller: _addressCtrl,
                  hint: s.street_address_hint,
                  validator: _validateAddress,
                ),

                SizedBox(height: spacing.screenPadding),

                ///
                Text(
                  s.gender,
                  style: theme.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                DropdownButtonFormField<String>(
                  initialValue: _gender,
                  decoration: const InputDecoration(isDense: true),
                  items: [
                    DropdownMenuItem(value: "Male", child: Text(s.male)),
                    DropdownMenuItem(value: "Female", child: Text(s.female)),
                    DropdownMenuItem(value: "Other", child: Text(s.other)),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _gender = value ?? "Other";
                    });
                  },
                  validator: (_) => _validateGender(_gender),
                ),

                SizedBox(height: spacing.screenPadding),

                /// DOB
                AppInputField(
                  label: s.date_of_birth,
                  controller: _dobCtrl,
                  hint: s.date_of_birth_hint,
                  readOnly: true,
                  suffixIcon: const Icon(Icons.calendar_today),
                  validator: (v) => _validateDob(v ?? ""),
                  onTap: _pickDob,
                ),

                /// GLOBAL ERROR IF ANY
                if (_error != null) ...[
                  SizedBox(height: spacing.screenPadding),
                  Text(
                    _error!,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),

      /// ACTION BUTTONS
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.pop(context),
          child: Text(s.cancel),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.warningUpdate,
          ),
          onPressed: _loading ? null : _submit,
          icon: _loading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.save),
          label: Text(_loading ? s.please_wait : s.save),
        ),
      ],
    );
  }
}
