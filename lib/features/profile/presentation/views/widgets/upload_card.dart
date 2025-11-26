import 'dart:typed_data';

import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class UploadCard extends StatelessWidget {
  final String title;
  final Uint8List? imageBytes;
  final VoidCallback onTap;

  const UploadCard({
    super.key,
    required this.title,
    this.imageBytes,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleMedium!),
        SizedBox(height: spacing.screenPadding / 2),

        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 170,
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.textTheme.bodyMedium!.color!.withValues(alpha: 0.2),
              border: Border.all(color: theme.canvasColor),
              borderRadius: BorderRadius.circular(spacing.screenPadding),
              image: imageBytes != null
                  ? DecorationImage(
                      image: MemoryImage(imageBytes!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imageBytes == null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          size: 34,
                          color: theme.disabledColor,
                        ),
                        SizedBox(height: spacing.screenPadding / 2),
                        Text(
                          S.of(context)!.upload_image,
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: theme.disabledColor,
                          ),
                        ),
                      ],
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
