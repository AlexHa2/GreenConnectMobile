import 'package:GreenConnectMobile/core/helper/navigate_with_loading.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/layouts/nav_items/nav_item_collector.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CollectorLayout extends StatefulWidget {
  final Widget child;
  const CollectorLayout({super.key, required this.child});

  @override
  State<CollectorLayout> createState() => _CollectorLayoutState();
}

class _CollectorLayoutState extends State<CollectorLayout> {
  late int _currentIndex;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentIndex = _getCurrentIndex(context);
  }

  @override
  Widget build(BuildContext context) {
    final navItems = navItemsCollector;
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: CustomBottomNav(
        initialIndex: _currentIndex,
        items: navItems.map((item) {
          return BottomNavItem(
            icon: item.icon,
            label: _getLableWithLocalization(item.label),
            onPressed: () {
              setState(() => _currentIndex = navItems.indexOf(item));

              if (item.extra != null) {
                navigateWithLoading(
                  context,
                  route: item.routeName,
                  extra: item.extra,
                );
              } else {
                navigateWithLoading(context, route: item.routeName);
              }
            },
          );
        }).toList(),
      ),
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final index = navItemsCollector.indexWhere(
      (item) => location.startsWith(item.routeName),
    );
    return index >= 0 ? index : 0;
  }

  String _getLableWithLocalization(String label) {
    final s = S.of(context)!;
    switch (label.toLowerCase()) {
      case "home":
        return s.home;
      case "schedules":
        return s.scheduleListTitle;
      case "posts":
        return s.post;
      case "complaints":
        return s.complaints;
      case "transactions":
        return s.transactions;
      case "feedbacks":
        return s.feedbacks;
      case "profile":
        return s.profile;
      default:
        return label;
    }
  }
}
