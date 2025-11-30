import 'dart:typed_data';

import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class ComplaintImagePreview extends StatelessWidget {
  final Uint8List? imageBytes;
  final String? networkImageUrl;
  final VoidCallback? onRemove;
  final String? badgeText;

  const ComplaintImagePreview({
    super.key,
    this.imageBytes,
    this.networkImageUrl,
    this.onRemove,
    this.badgeText,
  });

  bool get hasImage => imageBytes != null || networkImageUrl != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;

    if (!hasImage) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(space),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(space),
            child: imageBytes != null
                ? Image.memory(
                    imageBytes!,
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    networkImageUrl!,
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: theme.hintColor.withValues(alpha: 0.1),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.broken_image_outlined,
                              size: 48,
                              color: theme.hintColor,
                            ),
                            SizedBox(height: space * 0.5),
                            Text(
                              'Failed to load image',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.hintColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          if (onRemove != null)
            Positioned(
              top: space * 0.75,
              right: space * 0.75,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onRemove,
                  borderRadius: BorderRadius.circular(space * 2),
                  child: Container(
                    padding: EdgeInsets.all(space * 0.5),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          if (badgeText != null)
            Positioned(
              bottom: space * 0.75,
              left: space * 0.75,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: space * 0.75,
                  vertical: space * 0.5,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(space * 0.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.greenAccent,
                      size: 16,
                    ),
                    SizedBox(width: space * 0.25),
                    Text(
                      badgeText!,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
