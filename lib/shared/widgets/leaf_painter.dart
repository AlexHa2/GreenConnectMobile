import 'dart:math';

import 'package:flutter/material.dart';

class FallingLeaves extends StatefulWidget {
  final int leafCount;
  const FallingLeaves({super.key, this.leafCount = 30});

  @override
  State<FallingLeaves> createState() => _FallingLeavesState();
}

class _FallingLeavesState extends State<FallingLeaves>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();
  late List<_Leaf> _leaves;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();

    _leaves = List.generate(widget.leafCount, (_) => _Leaf(random: _random));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final leafImage = 'assets/images/leaf_2.png';
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, _) {
        return Stack(
          children: _leaves.map((leaf) {
            final progress =
                (_controller.value + leaf.delay) % 1.0; // drop time progress
            final y =
                progress * size.height * 1.2; // falling from top to bottom
            final x =
                leaf.startX +
                sin(progress * pi * 2) * leaf.swing; // swinging back and forth
            final rotation = progress * 2 * pi * leaf.rotationDir;

            return Positioned(
              top: y - 50,
              left: x,
              child: Transform.rotate(
                angle: rotation,
                child: Opacity(
                  opacity: (1 - progress).clamp(0.0, 1.0),
                  child: Image.asset(
                    leafImage,
                    width: leaf.size,
                    height: leaf.size,
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _Leaf {
  final double startX;
  final double swing;
  final double delay;
  final double size;
  final int rotationDir;

  _Leaf({required Random random})
    : startX = random.nextDouble() * 400, // initial horizontal position
      swing = 20 + random.nextDouble() * 60, // swinging amplitude
      delay = random.nextDouble(), // delay time
      size = 20 + random.nextDouble() * 25, // leaf size
      rotationDir = random.nextBool() ? 1 : -1; // rotation direction
}
