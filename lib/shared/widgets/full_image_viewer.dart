import 'package:flutter/material.dart';

class FullImageViewer extends StatelessWidget {
  final String imagePath;
  final bool isNetworkImage;
  final VoidCallback? onClose;

  const FullImageViewer({
    super.key,
    required this.imagePath,
    this.isNetworkImage = false,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onClose ?? () => Navigator.pop(context),
      child: Scaffold(
        backgroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.9),
        body: Center(
          child: Hero(
            tag: imagePath,
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.8,
              maxScale: 4.0,
              child: isNetworkImage
                  ? Image.network(imagePath, fit: BoxFit.contain)
                  : Image.asset(imagePath, fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }
}
