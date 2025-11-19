import 'package:GreenConnectMobile/core/helper/format_date.dart';
import 'package:GreenConnectMobile/core/helper/navigate_with_loading.dart';
import 'package:GreenConnectMobile/features/profile/data/models/user_update_model.dart';
import 'package:GreenConnectMobile/features/profile/domain/entities/address_entity.dart';
import 'package:GreenConnectMobile/features/profile/presentation/providers/profile_providers.dart';
import 'package:GreenConnectMobile/features/profile/presentation/views/widgets/step1_view.dart';
import 'package:GreenConnectMobile/features/profile/presentation/views/widgets/step2_view.dart';
import 'package:GreenConnectMobile/features/profile/presentation/views/widgets/step3_view.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileSetupPage extends ConsumerStatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  ConsumerState<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends ConsumerState<ProfileSetupPage> {
  int currentStep = 0;

  Address? addressData;

  String? fullName;
  String? gender;
  DateTime? dob;

  void nextStep() {
    setState(() {
      if (currentStep < 2) currentStep++;
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
    final viewModel = ref.read(profileViewModelProvider.notifier);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(spacing.screenPadding),
          child: ListView(
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

                  // Step text
                  Text(
                    currentStep == 0
                        ? S.of(context)!.profile_setup_step1
                        : currentStep == 1
                        ? S.of(context)!.profile_setup_step2
                        : S.of(context)!.profile_setup_step3,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),

              const SizedBox(height: 24),
              // Shared Tree Icon
              // Shared Tree Icon
              Center(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(
                              spacing.screenPadding,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: theme.primaryColorDark.withValues(
                                  alpha: 0.1,
                                ),
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.park,
                            size: 50,
                            color: theme.primaryColor,
                          ),
                        ),

                        if (currentStep > 0)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              spacing.screenPadding,
                            ),
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: 100,
                                  height: 100 * (currentStep / 2),
                                  decoration: BoxDecoration(
                                    color: theme.primaryColor,
                                  ),
                                  child: Icon(
                                    Icons.park,
                                    size: 50,
                                    color: theme.colorScheme.surface,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      S.of(context)!.profile_setup_primary,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: theme.textTheme.bodyMedium!.color!.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Progress
              LinearProgressIndicator(
                value: (currentStep + 1) / 3,
                color: theme.primaryColor,
                backgroundColor: theme.dividerColor.withValues(alpha: 0.3),
                minHeight: 6,
                borderRadius: BorderRadius.circular(8),
              ),

              const SizedBox(height: 24),

              // Step view
              IndexedStack(
                index: currentStep,
                children: [
                  ProfileSetupStep1View(
                    onNext: (Address data) {
                      addressData = data;
                      nextStep();
                    },
                  ),
                  ProfileSetupStep2View(
                    onBack: previousStep,
                    onNext: (String name, String genderVal, DateTime dobVal) {
                      fullName = name;
                      gender = genderVal;
                      dob = dobVal;
                      nextStep();
                    },
                  ),
                  if (addressData != null &&
                      fullName != null &&
                      gender != null &&
                      dob != null)
                    ProfileSetupStep3View(
                      addressData: addressData!,
                      fullName: fullName!,
                      gender: gender!,
                      dob: dob!,
                      onBack: previousStep,
                      onComplete: () {
                        navigateWithLoading(
                          context,
                          route: '/household-home',
                          asyncTask: () async {
                            await viewModel.updateMe(
                              UserUpdateModel(
                                fullName: fullName!,
                                gender: gender!,
                                dateOfBirth: formatDateOnly(dob!),
                                address:
                                    "${addressData!.street}, ${addressData!.wardCommune}, ${addressData!.stateProvince}, ${addressData!.country}, ${addressData!.zipCode}",
                              ),
                            );
                          },
                        );
                      },
                    )
                  else
                    const SizedBox.shrink(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
