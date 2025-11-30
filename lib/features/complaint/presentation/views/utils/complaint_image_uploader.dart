import 'dart:typed_data';

import 'package:GreenConnectMobile/features/upload/domain/entities/upload_request_entity.dart';
import 'package:GreenConnectMobile/features/upload/presentation/providers/upload_provider.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ComplaintImageUploader {
  static Future<String?> uploadImage({
    required BuildContext context,
    required WidgetRef ref,
    required Uint8List imageBytes,
    required String imageName,
  }) async {
    final uploadNotifier = ref.read(uploadViewModelProvider.notifier);
    final s = S.of(context)!;

    try {
      final contentType = "image/${imageName.split('.').last}";

      await uploadNotifier.requestUploadUrlForComplaint(
        UploadFileRequest(
          fileName: imageName,
          contentType: contentType,
        ),
      );

      final uploadState = ref.read(uploadViewModelProvider);
      if (uploadState.uploadUrl == null) {
        if (context.mounted) {
          CustomToast.show(
            context,
            s.cannot_get_uploadurl,
            type: ToastType.error,
          );
        }
        return null;
      }

      await uploadNotifier.uploadBinary(
        uploadUrl: uploadState.uploadUrl!.uploadUrl,
        fileBytes: imageBytes,
        contentType: contentType,
      );

      return uploadState.uploadUrl!.filePath;
    } catch (e) {
      debugPrint('❌ ERROR UPLOADING IMAGE: $e');
      if (context.mounted) {
        CustomToast.show(context, s.error_occurred, type: ToastType.error);
      }
      return null;
    }
  }
}
