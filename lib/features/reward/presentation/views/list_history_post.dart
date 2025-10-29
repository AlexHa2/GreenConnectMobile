import 'package:GreenConnectMobile/features/reward/presentation/views/widges/activity_card.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class HouseholdRewardHistory extends StatefulWidget {
  const HouseholdRewardHistory({super.key});

  @override
  State<HouseholdRewardHistory> createState() => _HouseholdRewardHistoryState();
}

class _HouseholdRewardHistoryState extends State<HouseholdRewardHistory> {
  String selectedTab = 'All';

  final transactions = [
    {
      'date': '2025-10-5',
      'title': 'Recycled plastic bottles',
      'status': 'Completed',
      'weight': '2.5 kg',
      'value': '\$5.00',
      'points': 50,
      'isCompleted': true,
      'description': 'Recycled plastic bottles',
    },
    {
      'date': '2025-10-5',
      'title': 'Compossted food waste',
      'status': 'Pending',
      'points': 50,
      'isCompleted': false,
      'description': 'Compossted food waste',
    },
    {
      'date': '2025-10-5',
      'title': 'Bike commute ( 5 days )',
      'status': 'Completed',
      'points': 100,
      'isCompleted': true,
      'description': 'Bike commute ( 5 days )',
    },
    {
      'date': '2025-10-5',
      'title': 'Compossted food waste',
      'status': 'Pending',
      'points': 50,
      'isCompleted': false,
      'description': 'Compossted food waste',
    },
    {
      'date': '2025-10-5',
      'title': 'Bike commute ( 5 days )',
      'status': 'Completed',
      'points': 100,
      'isCompleted': true,
      'description': 'Bike commute ( 5 days )',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;
    final s = S.of(context)!;
    final filtered = selectedTab == 'All'
        ? transactions
        : transactions
              .where(
                (t) => selectedTab == 'Completed'
                    ? t['isCompleted'] == true
                    : t['isCompleted'] == false,
              )
              .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(s.transaction_history),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(space.toDouble()),
        child: Column(
          children: [
            SizedBox(height: space),
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final item = filtered[index];
                  return ActivityCard(
                    title: item['title'].toString(),
                    points: item['points'].toString(),
                    status: item['status'].toString(),
                    weight: item['weight'].toString(),
                    value: item['value'].toString(),
                    date: item['date'].toString(),
                    description: item['description'].toString(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildTabBar(ThemeData theme) {
  //   final tabs = ['All', 'Completed', 'Pending'];
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: theme.cardColor,
  //       borderRadius: BorderRadius.circular(30),
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //       children: tabs.map((tab) {
  //         final isSelected = tab == selectedTab;
  //         return Expanded(
  //           child: GestureDetector(
  //             onTap: () => setState(() => selectedTab = tab),
  //             child: Container(
  //               padding: const EdgeInsets.symmetric(vertical: 10),
  //               decoration: BoxDecoration(
  //                 color: isSelected
  //                     ? theme.primaryColor.withValues(alpha: 0.1)
  //                     : Colors.transparent,
  //                 borderRadius: BorderRadius.circular(30),
  //               ),
  //               child: Center(
  //                 child: Text(
  //                   tab,
  //                   style: TextStyle(
  //                     color: isSelected
  //                         ? theme.primaryColor
  //                         : theme.textTheme.bodyMedium!.color,
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       }).toList(),
  //     ),
  //   );
  // }
}
