import 'package:GreenConnectMobile/features/profile/domain/entities/address.dart';
import 'package:GreenConnectMobile/features/profile/presentation/views/widgets/step1_view.dart';
import 'package:GreenConnectMobile/features/profile/presentation/views/widgets/step2_view.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  int currentStep = 0;

  void nextStep() {
    setState(() {
      if (currentStep < 1) currentStep++;
    });
  }

  void previousStep() {
    setState(() {
      if (currentStep > 0) currentStep--;
    });
  }

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(spacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context)!.profile_setup,
                    style: theme.textTheme.titleLarge!.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    currentStep < 1
                        ? S.of(context)!.profile_setup_step1
                        : S.of(context)!.profile_setup_step2,
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Shared Tree Icon
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: currentStep < 1
                            ? AppColors.surface
                            : AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.park,
                        size: 50,
                        color: currentStep < 1
                            ? AppColors.primary
                            : AppColors.surface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      S.of(context)!.profile_setup_primary,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Progress
              LinearProgressIndicator(
                value: currentStep == 0 ? 0.50 : 1.0,
                color: AppColors.primary,
                backgroundColor: AppColors.border.withValues(alpha: 0.3),
                minHeight: 6,
                borderRadius: BorderRadius.circular(8),
              ),
              const SizedBox(height: 24),

              // Step views
              SizedBox(
                height: 360,
                child: IndexedStack(
                  index: currentStep,
                  children: [
                    ProfileSetupStep1View(onNext: nextStep),
                    ProfileSetupStep2View(
                      onBack: previousStep,
                      onComplete: () {
                        context.go('/welcome');
                      },
                      addressData: Address(
                        street: "123 Green Street",
                        city: "Binh Duong",
                        zipCode: "123456",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
