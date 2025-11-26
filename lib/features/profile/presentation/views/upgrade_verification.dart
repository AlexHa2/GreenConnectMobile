import 'dart:typed_data';

import 'package:GreenConnectMobile/core/enum/buyer_type.dart';
import 'package:GreenConnectMobile/features/profile/data/models/verification_model.dart';
import 'package:GreenConnectMobile/features/profile/presentation/providers/profile_providers.dart';
import 'package:GreenConnectMobile/features/profile/presentation/views/widgets/upload_card.dart';
import 'package:GreenConnectMobile/features/upload/domain/entities/upload_request_entity.dart';
import 'package:GreenConnectMobile/features/upload/presentation/providers/upload_provider.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_leaf_loading.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class UpgradeVerificationScreen extends ConsumerStatefulWidget {
  const UpgradeVerificationScreen({super.key});

  @override
  ConsumerState<UpgradeVerificationScreen> createState() =>
      _UpgradeVerificationScreenState();
}

class _UpgradeVerificationScreenState
    extends ConsumerState<UpgradeVerificationScreen> {
  Uint8List? frontBytes;
  Uint8List? backBytes;

  String? frontFilePath;
  String? backFilePath;

  BuyerTypeStatus buyerType = BuyerTypeStatus.individual; // mặc định

  Future<String?> uploadCCCD(Uint8List imageBytes, String fileName) async {
    final uploadVM = ref.read(uploadViewModelProvider.notifier);
    try {
      final contentType = "image/${fileName.split('.').last}";

      await uploadVM.requestUploadUrl(
        UploadFileRequest(fileName: fileName, contentType: contentType),
      );

      final uploadState = ref.read(uploadViewModelProvider);
      if (uploadState.uploadUrl == null) return null;

      await uploadVM.uploadBinary(
        uploadUrl: uploadState.uploadUrl!.uploadUrl,
        fileBytes: imageBytes,
        contentType: contentType,
      );

      return uploadState.uploadUrl!.filePath;
    } catch (_) {
      return null;
    }
  }

  Future<void> pickImage(bool isFront) async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    final bytes = await file.readAsBytes();
    setState(() {
      isFront ? frontBytes = bytes : backBytes = bytes;
    });
  }

  Future<void> handleSubmit() async {
    final s = S.of(context)!;
    // final uploadVM = ref.read(uploadViewModelProvider.notifier);
    final profileVM = ref.read(profileViewModelProvider.notifier);

    if (frontBytes == null || backBytes == null) {
      CustomToast.show(context, s.cccd_upload_warning, type: ToastType.warning);
      return;
    }

    try {
      final frontUrl = await uploadCCCD(frontBytes!, "front.jpg");
      final backUrl = await uploadCCCD(backBytes!, "back.jpg");

      if (frontUrl == null || backUrl == null) {
        if (!mounted) return;
        CustomToast.show(
          context,
          s.cannot_get_uploadurl,
          type: ToastType.error,
        );
        return;
      }

      await profileVM.verifyUser(
        VerificationModel(
          buyerType: buyerType.toJson(),
          documentFrontUrl: frontUrl,
          documentBackUrl: backUrl,
        ),
      );
      if (!mounted) return;
      CustomToast.show(
        context,
        s.send_verification_info,
        type: ToastType.success,
      );
      context.pop();
    } catch (e) {
      CustomToast.show(
        context,
        s.error_occurred_while_updating_avatar,
        type: ToastType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    final uploadState = ref.watch(uploadViewModelProvider);
    final profileState = ref.watch(profileViewModelProvider);
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final theme = Theme.of(context);

    final isLoading = uploadState.isLoading || profileState.isLoading;

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

                UploadCard(
                  title: s.front_image,
                  imageBytes: frontBytes,
                  onTap: () => pickImage(true),
                ),
                SizedBox(height: spacing.screenPadding * 2),

                UploadCard(
                  title: s.back_image,
                  imageBytes: backBytes,
                  onTap: () => pickImage(false),
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
                    child: Text(s.submit_verification),
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
