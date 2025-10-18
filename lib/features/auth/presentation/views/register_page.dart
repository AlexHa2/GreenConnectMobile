import 'dart:io';

import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/button_gradient.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedRole;
  File? imageFile;

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() => imageFile = File(picked.path));
    }
  }

  void submitForm() {
    if (_formKey.currentState!.validate() && selectedRole != null) {
      final data = {
        'role': selectedRole,
        'phoneNumber': phoneController.text,
        'otp': otpController.text,
      };

      debugPrint("Form data: $data");
      debugPrint("Image file: $imageFile");
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

                  const SizedBox(height: 24),

                  // Card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context)!.select_role,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildRoleOption("HouseHold", Colors.red),
                          const SizedBox(height: 8),
                          _buildRoleOption("Collector", Colors.red),

                          const SizedBox(height: 24),

                          Text(
                            S.of(context)!.select_image,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.grey[300],
                                backgroundImage: imageFile != null
                                    ? FileImage(imageFile!)
                                    : null,
                                child: imageFile == null
                                    ? const Icon(
                                        Icons.camera_alt,
                                        color: Colors.grey,
                                        size: 30,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 16),
                              OutlinedButton.icon(
                                onPressed: pickImage,
                                icon: const Icon(Icons.upload),
                                label: Text(S.of(context)!.upload),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Phone number
                          TextFormField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            validator: (value) => value == null || value.isEmpty
                                ? S.of(context)!.phone_number
                                : null,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.phone),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // OTP
                          TextFormField(
                            controller: otpController,
                            keyboardType: TextInputType.number,
                            validator: (value) => value == null || value.isEmpty
                                ? S.of(context)!.otp
                                : null,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.lock),
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

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        S.of(context)!.already_have_account,
                        style: theme.textTheme.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () {},
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
    final bool isSelected = selectedRole == label;

    return InkWell(
      onTap: () => setState(() => selectedRole = label),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
