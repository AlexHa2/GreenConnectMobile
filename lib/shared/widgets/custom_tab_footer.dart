import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:flutter/material.dart';

class TabItemData {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  TabItemData({
    required this.icon,
    required this.label,
    required this.onPressed,
  });
}

class CustomTabFooter extends StatefulWidget {
  final List<TabItemData> items;
  final int initialIndex;

  const CustomTabFooter({
    super.key,
    required this.items,
    this.initialIndex = 0,
  });

  @override
  State<CustomTabFooter> createState() => _CustomTabFooterState();
}

class _CustomTabFooterState extends State<CustomTabFooter>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  int? _hoverIndex;
  late AnimationController _controller;
  late Animation<double> curveAnimation;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    curveAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    setState(() => _selectedIndex = index);
    widget.items[index].onPressed();
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final double tabWidth =
        MediaQuery.of(context).size.width / widget.items.length;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        boxShadow: [
          const BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ===== Hover + Curve Effect =====
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            left:
                (_hoverIndex ?? _selectedIndex) * tabWidth + tabWidth / 2 - 25,
            bottom: 50,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _hoverIndex != null ? 1 : 0,
              child: CustomPaint(
                size: const Size(50, 25),
                painter: _CurvePainter(AppColors.primary),
              ),
            ),
          ),

          // ===== Tab Items =====
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(widget.items.length, (index) {
              final item = widget.items[index];
              final isActive = index == _selectedIndex;

              return MouseRegion(
                onEnter: (_) => setState(() => _hoverIndex = index),
                onExit: (_) => setState(() => _hoverIndex = null),
                child: GestureDetector(
                  onTap: () => _onTabSelected(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          item.icon,
                          color: isActive
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                        if (isActive)
                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Text(
                              item.label,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

/// Custom painter vẽ đường cong và chấm tròn nhỏ khi hover
class _CurvePainter extends CustomPainter {
  final Color color;
  _CurvePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(
      size.width / 2,
      -size.height,
      size.width,
      size.height,
    );
    path.close();
    canvas.drawPath(path, paint);

    // Vẽ chấm tròn nhỏ
    canvas.drawCircle(Offset(size.width / 2, -4), 4, Paint()..color = color);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
