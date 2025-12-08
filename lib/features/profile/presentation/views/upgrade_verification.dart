import 'dart:typed_data';

import 'package:GreenConnectMobile/core/di/injector.dart';
import 'package:GreenConnectMobile/core/enum/buyer_type_status.dart';
import 'package:GreenConnectMobile/core/helper/navigate_with_loading.dart';
import 'package:GreenConnectMobile/core/network/token_storage.dart';
import 'package:GreenConnectMobile/features/authentication/presentation/providers/auth_provider.dart';
import 'package:GreenConnectMobile/features/profile/data/models/verification_model.dart';
import 'package:GreenConnectMobile/features/profile/presentation/providers/profile_providers.dart';
import 'package:GreenConnectMobile/features/profile/presentation/views/widgets/upload_card.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_leaf_loading.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

/// Verification page for upgrading account (Individual to Business)
/// Uses direct file upload via multipart/form-data
class UpgradeVerificationPage extends ConsumerStatefulWidget {
  final BuyerTypeStatus? initialBuyerType;

  const UpgradeVerificationPage({super.key, this.initialBuyerType});

  @override
  ConsumerState<UpgradeVerificationPage> createState() =>
      _UpgradeVerificationPageState();
}

class _UpgradeVerificationPageState
    extends ConsumerState<UpgradeVerificationPage> {
  Uint8List? frontBytes;

  late BuyerTypeStatus buyerType;

  @override
  void initState() {
    super.initState();
    buyerType = widget.initialBuyerType ?? BuyerTypeStatus.individual;
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    final bytes = await file.readAsBytes();
    setState(() {
      frontBytes = bytes;
    });
  }

  Future<void> handleSubmit() async {
    final s = S.of(context)!;
    final profileVM = ref.read(profileViewModelProvider.notifier);

    // Validation
    if (frontBytes == null) {
      CustomToast.show(context, s.cccd_upload_warning, type: ToastType.warning);
      return;
    }

    // Send files directly to API via multipart/form-data
    final verificationModel = VerificationModel.fromFiles(
      buyerType: buyerType
          .label, // Use label to capitalize first letter (Individual/Business)
      frontImageBytes: frontBytes!,
      backImageBytes: frontBytes!, // Using same front image as placeholder
      frontImageName: 'front.jpg',
      backImageName: 'back.jpg',
    );

    // Always use verifyUser() - backend handles both create and update
    await profileVM.verifyUser(verificationModel);

    // Check state after verification
    final state = ref.read(profileViewModelProvider);

    if (!mounted) return;

    if (state.errorMessage != null) {
      // Show error from ViewModel with appropriate message
      String errorMessage;

      if (state.errorMessage == 'AI_VERIFICATION_ERROR') {
        // Special handling for AI verification error
        errorMessage = s.ai_verification_error;
      } else if (state.errorMessage == 'VERIFICATION_CONFLICT') {
        // Special handling for duplicate verification
        errorMessage = s.verification_already_pending;
      } else if (state.errorMessage!.contains('AI_ERROR') ||
          state.errorMessage!.contains('FPT.AI')) {
        // Fallback for AI errors
        errorMessage = s.ai_verification_error;
      } else if (state.errorMessage!.contains('DATABASE_CONFLICT') ||
          state.errorMessage!.contains('duplicate')) {
        // Fallback for conflict errors
        errorMessage = s.verification_already_pending;
      } else {
        // Use the error message from server
        errorMessage = state.errorMessage!;
      }

      CustomToast.show(context, errorMessage, type: ToastType.error);
    } else if (state.verified) {
      // Success - show message and logout
      CustomToast.show(
        context,
        s.send_verification_info,
        type: ToastType.success,
      );

      // Wait a bit for toast to show
      await Future.delayed(const Duration(milliseconds: 1500));

      if (!mounted) return;

      // Perform logout after successful verification
      final tokenStorage = sl<TokenStorageService>();
      await tokenStorage.clearAuthData();
      ref.read(authViewModelProvider.notifier).reset();

      if (!mounted) return;
      // Navigate to login screen
      navigateWithLoading(context, route: '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    final profileState = ref.watch(profileViewModelProvider);
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final theme = Theme.of(context);

    // Only check profile loading (direct upload, no separate upload service needed)
    final isLoading = profileState.isLoading;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(s.account_verification),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(spacing.screenPadding * 1.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.upgrade_to_collector, style: theme.textTheme.titleLarge),
                SizedBox(height: spacing.screenPadding),

                Text(s.cccd_guide_text, style: theme.textTheme.bodyMedium),
                SizedBox(height: spacing.screenPadding * 2),

                // 🎯 Select Buyer Type
                Text(s.buyer_type, style: theme.textTheme.titleMedium),
                SizedBox(height: spacing.screenPadding / 2),
                DropdownButtonFormField<BuyerTypeStatus>(
                  initialValue: buyerType,
                  items: BuyerTypeStatus.values.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(_buyerTypeLabel(context, e)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => buyerType = value);
                    }
                  },
                ),

                SizedBox(height: spacing.screenPadding * 2),

                // Upload ID card front image
                SizedBox(height: spacing.screenPadding / 2),
                IgnorePointer(
                  ignoring: isLoading,
                  child: Opacity(
                    opacity: isLoading ? 0.5 : 1.0,
                    child: UploadCard(
                      title: s.front_image,
                      imageBytes: frontBytes,
                      onTap: pickImage,
                    ),
                  ),
                ),
                SizedBox(height: spacing.screenPadding * 3),

                Container(
                  padding: EdgeInsets.all(spacing.screenPadding),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.15),
                    border: Border.all(color: AppColors.warning),
                    borderRadius: BorderRadius.circular(spacing.screenPadding),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: AppColors.warning,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          s.cccd_warning_rules,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: spacing.screenPadding * 3),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : handleSubmit,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: spacing.screenPadding,
                      ),
                      disabledBackgroundColor: theme.disabledColor,
                    ),
                    child: isLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    theme.colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                              SizedBox(width: spacing.screenPadding),
                              Text(s.cccd_submit_success),
                            ],
                          )
                        : Text(s.submit_verification),
                  ),
                ),
                SizedBox(height: spacing.screenPadding * 3),
              ],
            ),
          ),
        ),

        if (isLoading)
          Container(
            color: theme.scaffoldBackgroundColor.withValues(alpha: 0.8),
            child: const Center(child: RotatingLeafLoader()),
          ),
      ],
    );
  }

  String _buyerTypeLabel(BuildContext context, BuyerTypeStatus type) {
    final s = S.of(context)!;
    switch (type) {
      case BuyerTypeStatus.individual:
        return s.buyer_type_individual;
      case BuyerTypeStatus.business:
        return s.buyer_type_business;
    }
  }
}
