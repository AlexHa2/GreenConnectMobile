import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ComplaintImagePicker {
  static Future<Map<String, dynamic>?> pickImage(BuildContext context) async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        return {
          'bytes': bytes,
          'name': image.name,
        };
      }
    } catch (e) {
      debugPrint('❌ ERROR PICKING IMAGE: $e');
      if (context.mounted) {
        CustomToast.show(
          context,
          S.of(context)!.error_occurred,
          type: ToastType.error,
        );
      }
    }
    return null;
  }
}
