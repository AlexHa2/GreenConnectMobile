import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/button_gradient.dart';
import 'package:flutter/material.dart';

class RewardStore extends StatefulWidget {
  const RewardStore({super.key});

  @override
  State<RewardStore> createState() => _RewardStoreState();
}

class _RewardStoreState extends State<RewardStore> {
  int points = 850;
  int cartTotal = 0;
  int itemCount = 0;

  final List<Map<String, dynamic>> rewards = [
    {'name': 'Plant A Tree', 'image': 'assets/images/leaf_2.png', 'cost': 100},
    {'name': 'Eco Bag', 'image': 'assets/images/leaf_2.png', 'cost': 100},
    {'name': 'Solar Charger', 'image': 'assets/images/leaf_2.png', 'cost': 100},
    {
      'name': 'Reusable Bottle',
      'image': 'assets/images/leaf_2.png',
      'cost': 100,
    },
    {
      'name':
          'Compost KitCompost KitCompost KitCompost KitCompost KitCompost KitCompost Kit',
      'image': 'assets/images/leaf_2.png',
      'cost': 100,
    },
    {
      'name': 'LED Bulbs Pack',
      'image': 'assets/images/leaf_2.png',
      'cost': 100,
    },
  ];

  void addToCart(int cost) {
    if (points >= cartTotal + cost) {
      setState(() {
        cartTotal += cost;
        itemCount++;
      });
    }
  }

  void redeem() {
    if (itemCount == 0) return;
    setState(() {
      points -= cartTotal;
      cartTotal = 0;
      itemCount = 0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(S.of(context)!.items_redeemed_successfully)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final s = S.of(context)!;
    final space = spacing.screenPadding;
    final logo = 'assets/images/leaf_2.png';
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(s.reward_store),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(space),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${s.your_point}: $points',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: space),
            Expanded(
              child: GridView.builder(
                itemCount: rewards.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: space * 20,
                  crossAxisSpacing: space,
                  mainAxisSpacing: space,
                ),
                itemBuilder: (context, index) {
                  final item = rewards[index];
                  return Container(
                    margin: EdgeInsets.all(space / 2),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(space),
                      boxShadow: [
                        BoxShadow(
                          color: theme.primaryColorDark.withValues(alpha: 0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(space),
                            topRight: Radius.circular(space),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                height: 100,
                                width: double.infinity,
                                color: theme.textTheme.bodyMedium?.color
                                    ?.withValues(alpha: 0.1),
                                child: Image.asset(logo, fit: BoxFit.cover),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: EdgeInsets.all(space / 2),
                                  decoration: BoxDecoration(
                                    gradient: AppColors.linearSecondary,
                                    borderRadius: BorderRadius.circular(space),
                                  ),
                                  child: Text(
                                    '⭐ ${item['cost']}',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.primaryColorDark,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: space,
                            vertical: space / 2,
                          ),
                          child: Column(
                            children: [
                              Text(
                                item['name'],
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: space),
                              GradientButton(
                                text: s.add,
                                onPressed: () => addToCart(item['cost']),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: space),
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(space),
                border: Border.all(color: theme.dividerColor),
              ),
              padding: EdgeInsets.symmetric(
                vertical: space,
                horizontal: space * 1.2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${s.cart_total}: ⭐ $cartTotal',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: space / 2),
                  GradientButton(
                    text: '${s.redeem} ($itemCount ${s.items})',
                    onPressed: redeem,
                    isEnabled: itemCount > 0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
