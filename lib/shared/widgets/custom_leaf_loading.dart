import 'dart:math' as math;
import 'package:flutter/material.dart';

/// 🌱 Loading animation for Green Connect
class RotatingLeafLoader extends StatefulWidget {
  const RotatingLeafLoader({super.key});

  @override
  State<RotatingLeafLoader> createState() => _RotatingLeafLoaderState();
}

class _RotatingLeafLoaderState extends State<RotatingLeafLoader>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    // Hiệu ứng "thở"
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
      lowerBound: 0.9,
      upperBound: 1.1,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_rotationController, _scaleController]),
      builder: (context, child) {
        return Transform.rotate(
          // plus is clockwise
          angle: _rotationController.value * 2 * math.pi,
          child: Transform.scale(
            scale: _scaleController.value,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 🌿 8 icon leaf
                for (int i = 0; i < 8; i++)
                  Transform.translate(
                    offset: Offset(
                      50 * math.cos(i * math.pi / 4),
                      50 * math.sin(i * math.pi / 4),
                    ),
                    // ✨ reverse fade effect
                    child: Opacity(
                      opacity: 1 - ((8 - i - 1) * 0.1),
                      child: Image.asset(
                        'assets/images/leaf_2.png',
                        width: 26 - ((8 - i - 1) * 1.2),
                      ),
                    ),
                  ),

                // 🌍 center logo
                Image.asset('assets/images/green_connect_logo.png', width: 60),
              ],
            ),
          ),
        );
      },
    );
  }
}
