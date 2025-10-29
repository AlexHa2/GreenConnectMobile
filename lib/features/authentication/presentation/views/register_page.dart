import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/button_gradient.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedRole;

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  void submitForm() {
    if (_formKey.currentState!.validate() && selectedRole != null) {
      final data = {
        'role': selectedRole,
        'phoneNumber': phoneController.text,
        'otp': otpController.text,
      };

      debugPrint("Form data: $data");
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(S.of(context)!.error_all_field)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.cardColor,
        elevation: 0,
        title: Text(S.of(context)!.back),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        titleTextStyle: theme.textTheme.titleLarge,
        shape: Border.all(color: theme.dividerColor),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(spacing.screenPadding),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Text(
                          S.of(context)!.welcome_register_primary,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          S.of(context)!.welcome_register_secondary,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(spacing.screenPadding * 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context)!.select_role,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildRoleOption("H", AppColors.danger),
                          const SizedBox(height: 8),
                          _buildRoleOption("C", AppColors.danger),

                          const SizedBox(height: 12),

                          // Phone number
                          Row(
                            children: [
                              Icon(
                                Icons.call,
                                color: theme.primaryColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                S.of(context)!.phone_number,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          TextFormField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            validator: (value) => value == null || value.isEmpty
                                ? S.of(context)!.phone_number
                                : null,
                            decoration: InputDecoration(
                              hintText: S.of(context)!.phone_number_hint,
                              filled: true,
                              fillColor: theme.inputDecorationTheme.fillColor,
                              contentPadding:
                                  theme.inputDecorationTheme.contentPadding,
                              border: theme.inputDecorationTheme.border,
                              enabledBorder:
                                  theme.inputDecorationTheme.enabledBorder,
                              focusedBorder:
                                  theme.inputDecorationTheme.focusedBorder,
                              hintStyle: theme.inputDecorationTheme.hintStyle,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // OTP
                          Row(
                            children: [
                              Icon(
                                Icons.sms,
                                color: theme.primaryColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "${S.of(context)!.send} ${S.of(context)!.otp}",
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          TextFormField(
                            controller: otpController,
                            keyboardType: TextInputType.number,
                            validator: (value) => value == null || value.isEmpty
                                ? S.of(context)!.otp
                                : null,
                            decoration: InputDecoration(
                              hintText: S.of(context)!.otp_hint,
                              filled: true,
                              fillColor: theme.inputDecorationTheme.fillColor,
                              contentPadding:
                                  theme.inputDecorationTheme.contentPadding,
                              border: theme.inputDecorationTheme.border,
                              enabledBorder:
                                  theme.inputDecorationTheme.enabledBorder,
                              focusedBorder:
                                  theme.inputDecorationTheme.focusedBorder,
                              hintStyle: theme.inputDecorationTheme.hintStyle,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Submit
                          SizedBox(
                            width: double.infinity,
                            child: GradientButton(
                              text: S.of(context)!.register_complete,
                              onPressed: submitForm,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        S.of(context)!.already_have_account,
                        style: theme.textTheme.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () => context.go('/login'),
                        child: Text(
                          ' ${S.of(context)!.login}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
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
      ),
    );
  }

  Widget _buildRoleOption(String label, Color color) {
    final roleText = switch (label) {
      'H' => S.of(context)!.house_hold,
      'C' => S.of(context)!.collector,
      _ => label,
    };

    final isSelected = selectedRole == roleText;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => setState(() => selectedRole = roleText),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off_outlined,
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              roleText,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
