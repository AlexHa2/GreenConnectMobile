import 'package:GreenConnectMobile/features/reward/presentation/providers/reward_providers.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// My Rewards Page
/// Shows the user's redeemed rewards history with filtering and sorting options
class MyRewardsPage extends ConsumerStatefulWidget {
  const MyRewardsPage({super.key});

  @override
  ConsumerState<MyRewardsPage> createState() => _MyRewardsPageState();
}

class _MyRewardsPageState extends ConsumerState<MyRewardsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'all'; // all, credit, package

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(rewardViewModelProvider.notifier).fetchRewardHistory();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await ref.read(rewardViewModelProvider.notifier).fetchRewardHistory();
  }

  List<dynamic> _filterRewards(List<dynamic> rewards) {
    if (_selectedFilter == 'all') return rewards;
    // Filter by type when type field is added to entity
    return rewards;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;
    final s = S.of(context)!;
    final rewardState = ref.watch(rewardViewModelProvider);
    final rewardHistory = rewardState.rewardHistory ?? [];
    final filteredRewards = _filterRewards(rewardHistory);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.my_rewards),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list_rounded),
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'all',
                child: Row(
                  children: [
                    Icon(
                      Icons.all_inclusive_rounded,
                      size: 20,
                      color: _selectedFilter == 'all'
                          ? theme.colorScheme.primary
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      s.all,
                      style: TextStyle(
                        color: _selectedFilter == 'all'
                            ? theme.colorScheme.primary
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'credit',
                child: Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet_rounded,
                      size: 20,
                      color: _selectedFilter == 'credit'
                          ? theme.colorScheme.primary
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      s.credits,
                      style: TextStyle(
                        color: _selectedFilter == 'credit'
                            ? theme.colorScheme.primary
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'package',
                child: Row(
                  children: [
                    Icon(
                      Icons.card_giftcard_rounded,
                      size: 20,
                      color: _selectedFilter == 'package'
                          ? theme.colorScheme.primary
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      s.packages,
                      style: TextStyle(
                        color: _selectedFilter == 'package'
                            ? theme.colorScheme.primary
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: s.active, icon: const Icon(Icons.check_circle_outline)),
            Tab(text: s.used, icon: const Icon(Icons.history_rounded)),
          ],
        ),
      ),
      body: rewardState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : rewardState.errorMessage != null
          ? Center(
              child: Padding(
                padding: EdgeInsets.all(space * 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 64,
                      color: AppColors.danger,
                    ),
                    SizedBox(height: space),
                    Text(
                      rewardState.errorMessage!,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge,
                    ),
                    SizedBox(height: space),
                    ElevatedButton.icon(
                      onPressed: _onRefresh,
                      icon: const Icon(Icons.refresh_rounded),
                      label: Text(s.try_again),
                    ),
                  ],
                ),
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                // Active Rewards Tab
                _buildRewardsList(context, filteredRewards, isActive: true),
                // Used Rewards Tab
                _buildRewardsList(context, filteredRewards, isActive: false),
              ],
            ),
    );
  }

  Widget _buildRewardsList(
    BuildContext context,
    List<dynamic> rewards, {
    required bool isActive,
  }) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;
    final s = S.of(context)!;
    if (rewards.isEmpty) {
      return RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isActive ? Icons.card_giftcard_outlined : Icons.history,
                    size: 80,
                    color: theme.disabledColor,
                  ),
                  SizedBox(height: space),
                  Text(
                    isActive ? s.no_active_rewards : s.no_used_rewards,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.disabledColor,
                    ),
                  ),
                  SizedBox(height: space * 0.5),
                  Text(
                    isActive
                        ? s.redeem_rewards_from_store
                        : s.used_rewards_appear_here,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.disabledColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        padding: EdgeInsets.all(space),
        itemCount: rewards.length,
        itemBuilder: (context, index) {
          final reward = rewards[index];
          return _MyRewardCard(reward: reward, isActive: isActive);
        },
      ),
    );
  }
}

class _MyRewardCard extends StatelessWidget {
  final dynamic reward;
  final bool isActive;

  const _MyRewardCard({required this.reward, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;

    return Card(
      margin: EdgeInsets.only(bottom: space),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(space)),
      child: InkWell(
        onTap: () {
          // : Navigate to reward detail or show usage dialog
        },
        borderRadius: BorderRadius.circular(space),
        child: Padding(
          padding: EdgeInsets.all(space),
          child: Row(
            children: [
              // Reward Image
              ClipRRect(
                borderRadius: BorderRadius.circular(space * 0.8),
                child: Container(
                  width: 80,
                  height: 80,
                  color: theme.colorScheme.primaryContainer,
                  child: reward.imageUrl.isNotEmpty
                      ? Image.network(
                          reward.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.card_giftcard_rounded,
                            size: 40,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        )
                      : Icon(
                          Icons.card_giftcard_rounded,
                          size: 40,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                ),
              ),
              SizedBox(width: space),

              // Reward Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reward.itemName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: space * 0.3),
                    Text(
                      reward.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: space * 0.5),
                    Row(
                      children: [
                        const Icon(
                          Icons.stars_rounded,
                          size: 16,
                          color: AppColors.warning,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${reward.pointsSpent} points',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.warning,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: space * 0.8,
                            vertical: space * 0.3,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.primary.withValues(alpha: 0.1)
                                : theme.disabledColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(space * 0.5),
                          ),
                          child: Text(
                            isActive ? 'Active' : 'Used',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: isActive
                                  ? AppColors.primary
                                  : theme.disabledColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
