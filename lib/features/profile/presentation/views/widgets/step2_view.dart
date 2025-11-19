import 'package:GreenConnectMobile/core/helper/pick_date.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/button_gradient.dart';
import 'package:flutter/material.dart';

class ProfileSetupStep2View extends StatefulWidget {
  final Function(String fullName, String gender, DateTime dob) onNext;
  final VoidCallback onBack;

  const ProfileSetupStep2View({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<ProfileSetupStep2View> createState() => _ProfileSetupStep2ViewState();
}

class _ProfileSetupStep2ViewState extends State<ProfileSetupStep2View> {
  final nameController = TextEditingController();
  final dobController = TextEditingController();

  String? genderValue;
  DateTime? selectedDate;

  // Error fields
  String? fullNameError;
  String? genderError;
  String? dobError;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = Theme.of(context).extension<AppSpacing>()!;

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(spacing.screenPadding),
        side: BorderSide(color: theme.dividerColor),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.screenPadding * 2),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(Icons.person, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    S.of(context)!.personal_information,
                    style: theme.textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Full Name
              Text(S.of(context)!.fullName, style: theme.textTheme.bodyLarge),
              SizedBox(height: spacing.screenPadding / 2),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: S.of(context)!.fullName_hint,
                  errorText: fullNameError,
                ),
              ),
              SizedBox(height: spacing.screenPadding),

              // Gender
              Text(S.of(context)!.gender, style: theme.textTheme.bodyLarge),
              SizedBox(height: spacing.screenPadding / 2),
              DropdownButtonFormField<String>(
                initialValue: genderValue,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  errorText: genderError,
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
                  setState(() => genderValue = value);
                },
              ),
              SizedBox(height: spacing.screenPadding),

              // Date of Birth
              Text(
                S.of(context)!.date_of_birth,
                style: theme.textTheme.bodyLarge,
              ),
              SizedBox(height: spacing.screenPadding / 2),
              TextField(
                controller: dobController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: S.of(context)!.date_of_birth_hint,
                  suffixIcon: const Icon(Icons.calendar_today),
                  isDense: true,
                  errorText: dobError,
                ),
                onTap: () =>
                    pickDate(context, selectedDate, dobController, setState),
              ),
              SizedBox(height: spacing.screenPadding * 3),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: widget.onBack,
                        child: Text(S.of(context)!.back),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: GradientButton(
                        text: S.of(context)!.next,
                        onPressed: () {
                          if (validateFields()) {
                            widget.onNext(
                              nameController.text.trim(),
                              genderValue!,
                              selectedDate!,
                            );
                          }
                        },
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

  /// ===========================
  /// VALIDATION LOGIC
  /// ===========================
  bool validateFields() {
    bool isValid = true;
    final t = S.of(context)!;

    setState(() {
      // Full Name
      if (nameController.text.trim().isEmpty) {
        fullNameError = t.fullName_error;
        isValid = false;
      } else if (nameController.text.trim().length < 2) {
        fullNameError = t.fullName_length_error;
        isValid = false;
      } else {
        fullNameError = null;
      }

      // Gender
      if (genderValue == null) {
        genderError = t.gender_error;
        isValid = false;
      } else {
        genderError = null;
      }

      // Date of Birth
      if (selectedDate == null) {
        dobError = t.date_of_birth_error;
        isValid = false;
      } else {
        dobError = null;
      }
    });

    return isValid;
  }
}
