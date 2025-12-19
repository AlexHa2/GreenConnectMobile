import 'package:GreenConnectMobile/features/package/presentation/views/widgets/package_dashboard_action_button.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ActionGrid extends StatelessWidget {
  const ActionGrid({super.key});
  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    final actions = [
      DashboardAction(
        icon: Icons.shopping_cart,
        label: s.buy_package,
        onTap: () => context.pushNamed('package-list'),
      ),
      DashboardAction(
        icon: Icons.history,
        label: s.point_history,
        onTap: () => context.pushNamed('collector-list-credit-transactions'),
      ),
      DashboardAction(
        icon: Icons.receipt_long,
        label: s.purchase_history,
        onTap: () => context.pushNamed('payment-transaction-history'),
      ),
    ];

    /// 📱 small screen → GRID
    if (isSmallScreen) {
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
        children: actions,
      );
    }

    /// 📱 normal screen → ROW
    return Row(
      children: actions
          .map(
            (e) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: e,
              ),
            ),
          )
          .toList(),
    );
  }
}
