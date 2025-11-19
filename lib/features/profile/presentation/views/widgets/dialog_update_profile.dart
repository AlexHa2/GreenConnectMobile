import 'package:GreenConnectMobile/core/helper/format_date.dart';
import 'package:GreenConnectMobile/features/profile/data/models/user_update_model.dart';
import 'package:GreenConnectMobile/features/profile/domain/entities/user_update_entity.dart';
import 'package:GreenConnectMobile/features/profile/presentation/providers/profile_providers.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
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
      title: Text(s.edit_profile),
      content: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Fullname
                Text(S.of(context)!.fullName, style: theme.textTheme.bodyLarge),
                SizedBox(height: spacing.screenPadding / 2),
                TextFormField(
                  controller: _fullNameCtrl,
                  decoration: InputDecoration(hintText: s.fullName_hint),
                  validator: _validateFullName,
                ),
                SizedBox(height: spacing.screenPadding),

                // Address
                Text(
                  S.of(context)!.street_address,
                  style: theme.textTheme.bodyLarge,
                ),
                SizedBox(height: spacing.screenPadding / 2),
                TextFormField(
                  controller: _addressCtrl,
                  decoration: InputDecoration(hintText: s.street_address_hint),
                  validator: _validateAddress,
                ),
                SizedBox(height: spacing.screenPadding),

                // Gender
                Text(S.of(context)!.gender, style: theme.textTheme.bodyLarge),
                SizedBox(height: spacing.screenPadding / 2),
                DropdownButtonFormField<String>(
                  initialValue: _gender,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    errorText: _validateGender(_gender),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: "Male",
                      child: Text(S.of(context)!.male),
                    ),
                    DropdownMenuItem(
                      value: "Female",
                      child: Text(S.of(context)!.female),
                    ),
                    DropdownMenuItem(
                      value: "Other",
                      child: Text(S.of(context)!.other),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _gender = value ?? "Other";
                    });
                  },
                ),

                SizedBox(height: spacing.screenPadding),

                // DOB
                Text(
                  S.of(context)!.date_of_birth,
                  style: theme.textTheme.bodyLarge,
                ),
                SizedBox(height: spacing.screenPadding / 2),
                TextFormField(
                  controller: _dobCtrl,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: S.of(context)!.date_of_birth_hint,
                    suffixIcon: const Icon(Icons.calendar_today),
                    isDense: true,
                    errorText: _validateDob(_dobCtrl.text),
                  ),
                  onTap: _pickDob,
                ),

                if (_error != null) ...[
                  SizedBox(height: spacing.screenPadding),
                  Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.pop(context),
          child: Text(s.cancel),
        ),
        ElevatedButton.icon(
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
