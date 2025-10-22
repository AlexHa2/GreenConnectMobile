import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class BottomNavItem {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  BottomNavItem({
    required this.icon,
    required this.label,
    required this.onPressed,
  });
}

class CustomBottomNav extends StatefulWidget {
  final List<BottomNavItem> items;
  final int initialIndex;

  const CustomBottomNav({
    super.key,
    required this.items,
    this.initialIndex = 0,
  });

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav>
    with SingleTickerProviderStateMixin {
  late int _selectedIndex;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() => _selectedIndex = index);
      widget.items[index].onPressed();
      _controller.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = Theme.of(context).extension<AppSpacing>()!;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(spacing.screenPadding ),
          topRight: Radius.circular(spacing.screenPadding),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.only(bottom: 6),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary.withValues(alpha: 0.7),
        showUnselectedLabels: true,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        onTap: _onItemTapped,
        items: List.generate(widget.items.length, (index) {
          final item = widget.items[index];
          final bool isActive = _selectedIndex == index;

          return BottomNavigationBarItem(
            icon: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: AnimatedScale(
                duration: const Duration(milliseconds: 300),
                scale: isActive ? 1.2 : 1.0,
                curve: Curves.easeOutBack,
                child: Icon(
                  item.icon,
                  color: isActive
                      ? AppColors.primary
                      : AppColors.textSecondary.withValues(alpha: 0.7),
                ),
              ),
            ),
            label: item.label,
          );
        }),
      ),
    );
  }
}
