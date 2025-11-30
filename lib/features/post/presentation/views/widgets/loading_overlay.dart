import 'package:GreenConnectMobile/shared/widgets/custom_leaf_loading.dart';
import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: theme.scaffoldBackgroundColor.withValues(alpha: 0.8),
            child: const Center(
              child: RotatingLeafLoader(),
            ),
          ),
      ],
    );
  }
}
