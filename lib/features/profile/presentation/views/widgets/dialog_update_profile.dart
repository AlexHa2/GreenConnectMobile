import 'package:GreenConnectMobile/core/helper/format_date.dart';
import 'package:GreenConnectMobile/features/payment/domain/entities/bank_entity.dart';
import 'package:GreenConnectMobile/features/payment/presentation/providers/bank_providers.dart';
import 'package:GreenConnectMobile/features/profile/data/models/user_update_model.dart';
import 'package:GreenConnectMobile/features/profile/domain/entities/user_update_entity.dart';
import 'package:GreenConnectMobile/features/profile/presentation/providers/profile_providers.dart';
import 'package:GreenConnectMobile/features/profile/presentation/viewmodels/states/profile_state.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
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
  final _addressCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _bankAccountNumberCtrl = TextEditingController();
  final _bankAccountNameCtrl = TextEditingController();

  String _gender = 'Other';
  DateTime? _selectedDob;
  BankEntity? _selectedBank;

  @override
  void initState() {
    super.initState();

    // Fetch banks list and init selected bank if user has bankCode
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(bankViewModelProvider.notifier).fetchBanks();

      // Try to find and set the bank from user's bankCode
      final u = widget.user;
      if (u?.bankCode != null && (u!.bankCode ?? '').isNotEmpty) {
        final banks = ref.read(bankViewModelProvider).banks ?? [];
        try {
          final bank = banks.firstWhere((b) => b.bin == u.bankCode);
          setState(() {
            _selectedBank = bank;
          });
        } catch (_) {
          // Bank not found, ignore
        }
      }
    });

    final u = widget.user;
    _fullNameCtrl.text = u?.fullName ?? '';
    _addressCtrl.text = u?.address ?? '';
    _gender = (u?.gender ?? '').isNotEmpty ? u!.gender : 'Other';
    _bankAccountNumberCtrl.text = u?.bankAccountNumber ?? '';
    _bankAccountNameCtrl.text = u?.bankAccountName ?? '';

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
    _addressCtrl.dispose();
    _dobCtrl.dispose();
    _bankAccountNumberCtrl.dispose();
    _bankAccountNameCtrl.dispose();
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
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final update = UserUpdateModel(
      fullName: _fullNameCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      gender: _gender,
      dateOfBirth: _selectedDob != null
          ? formatDateOnly(_selectedDob!)
          : DateFormat('yyyy-MM-dd').format(DateTime.now()),
      bankCode: _selectedBank?.bin,
      bankAccountNumber: _bankAccountNumberCtrl.text.trim().isNotEmpty
          ? _bankAccountNumberCtrl.text.trim()
          : null,
      bankAccountName: _bankAccountNameCtrl.text.trim().isNotEmpty
          ? _bankAccountNameCtrl.text.trim()
          : null,
    );

    final notifier = ref.read(profileViewModelProvider.notifier);
    await notifier.updateMe(update);

    if (mounted) {
      final state = ref.read(profileViewModelProvider);
      if (state.errorMessage == null) {
        widget.onUpdated?.call();
        Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final theme = Theme.of(context);
    final state = ref.watch(profileViewModelProvider);
    final bankState = ref.watch(bankViewModelProvider);

    // Listen for errors
    ref.listen<ProfileState>(profileViewModelProvider, (previous, next) {
      if (next.errorMessage != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${s.error}: ${next.errorMessage}'),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    });

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: EdgeInsets.all(spacing.screenPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      s.edit_profile,
                      style: theme.textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      style: IconButton.styleFrom(
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Form content
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(spacing.screenPadding),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Full Name
                        TextFormField(
                          controller: _fullNameCtrl,
                          decoration: InputDecoration(
                            labelText: s.fullName,
                            hintText: s.fullName_hint,
                            prefixIcon: const Icon(Icons.person_outline),
                          ),
                          validator: _validateFullName,
                        ),

                        SizedBox(height: spacing.screenPadding),

                        // Address
                        TextFormField(
                          controller: _addressCtrl,
                          decoration: InputDecoration(
                            labelText: s.street_address,
                            hintText: s.street_address_hint,
                            prefixIcon: const Icon(Icons.location_on_outlined),
                          ),
                          validator: _validateAddress,
                        ),

                        SizedBox(height: spacing.screenPadding),

                        // Date of Birth
                        TextFormField(
                          controller: _dobCtrl,
                          decoration: InputDecoration(
                            labelText: s.date_of_birth,
                            hintText: s.date_of_birth_hint,
                            prefixIcon: const Icon(Icons.calendar_today),
                            suffixIcon: const Icon(Icons.arrow_drop_down),
                          ),
                          readOnly: true,
                          onTap: _pickDob,
                          validator: (v) => _validateDob(v ?? ""),
                        ),

                        SizedBox(height: spacing.screenPadding),

                        // Gender
                        DropdownButtonFormField<String>(
                          initialValue: _gender,
                          decoration: InputDecoration(
                            labelText: s.gender,
                            prefixIcon: const Icon(Icons.wc),
                          ),
                          items: [
                            DropdownMenuItem(
                              value: "Male",
                              child: Text(s.male),
                            ),
                            DropdownMenuItem(
                              value: "Female",
                              child: Text(s.female),
                            ),
                            DropdownMenuItem(
                              value: "Other",
                              child: Text(s.other),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _gender = value ?? "Other";
                            });
                          },
                          validator: (_) => _validateGender(_gender),
                        ),

                        SizedBox(height: spacing.screenPadding * 1.5),

                        // Bank Information Section
                        Text(
                          'Thông tin ngân hàng',
                          style: theme.textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),

                        SizedBox(height: spacing.screenPadding),

                        // Bank Selection
                        InkWell(
                          onTap: bankState.isLoading
                              ? null
                              : () => _showBankSelector(context),
                          borderRadius: BorderRadius.circular(12),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Ngân hàng',
                              prefixIcon: const Icon(Icons.account_balance),
                              suffixIcon: bankState.isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    )
                                  : const Icon(Icons.arrow_drop_down),
                            ),
                            child: _selectedBank != null
                                ? Row(
                                    children: [
                                      if (_selectedBank!.logo.isNotEmpty)
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          child: Image.network(
                                            _selectedBank!.logo,
                                            width: 24,
                                            height: 24,
                                            errorBuilder: (_, _, _) =>
                                                const SizedBox(),
                                          ),
                                        ),
                                      if (_selectedBank!.logo.isNotEmpty)
                                        const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          '${_selectedBank!.shortName} - ${_selectedBank!.name}',
                                          style: theme.textTheme.bodyLarge,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(
                                    'Chọn ngân hàng',
                                    style: theme.textTheme.bodyLarge!.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                                  ),
                          ),
                        ),

                        SizedBox(height: spacing.screenPadding),

                        // Bank Account Number
                        TextFormField(
                          controller: _bankAccountNumberCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Số tài khoản',
                            hintText: 'Nhập số tài khoản ngân hàng',
                            prefixIcon: Icon(Icons.credit_card),
                          ),
                          keyboardType: TextInputType.number,
                        ),

                        SizedBox(height: spacing.screenPadding),

                        // Bank Account Name
                        TextFormField(
                          controller: _bankAccountNameCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Tên tài khoản',
                            hintText: 'Tên chủ tài khoản',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                        ),

                        // Error message
                        if (state.errorMessage != null) ...[
                          SizedBox(height: spacing.screenPadding),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.errorContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: theme.colorScheme.error,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    state.errorMessage!,
                                    style: TextStyle(
                                      color: theme.colorScheme.error,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        SizedBox(height: spacing.screenPadding * 2),

                        // Action buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: state.isLoading
                                    ? null
                                    : () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                                child: Text(s.cancel),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: state.isLoading ? null : _submit,
                                style: FilledButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor: AppColors.warningUpdate,
                                ),
                                icon: state.isLoading
                                    ?  SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: theme.scaffoldBackgroundColor,
                                        ),
                                      )
                                    : const Icon(Icons.save),
                                label: Text(
                                  state.isLoading ? s.please_wait : s.save,
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
            ],
          ),
        ),
      ),
    );
  }

  void _showBankSelector(BuildContext context) {
    final theme = Theme.of(context);
    final bankState = ref.read(bankViewModelProvider);
    final banks = bankState.banks ?? [];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Text(
              'Chọn ngân hàng',
              style: theme.textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            if (banks.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Text('Không có ngân hàng nào'),
              )
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: banks.length,
                  itemBuilder: (context, index) {
                    final bank = banks[index];
                    final isSelected = _selectedBank?.id == bank.id;

                    return ListTile(
                      leading: bank.logo.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                bank.logo,
                                width: 48,
                                height: 48,
                                errorBuilder: (_, _, _) => Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: theme
                                        .colorScheme
                                        .surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.account_balance),
                                ),
                              ),
                            )
                          : null,
                      title: Text(bank.name),
                      subtitle: Text('${bank.shortName} - ${bank.code}'),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: theme.colorScheme.primary,
                            )
                          : null,
                      selected: isSelected,
                      onTap: () {
                        setState(() {
                          _selectedBank = bank;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
