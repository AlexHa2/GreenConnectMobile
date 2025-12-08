import 'package:GreenConnectMobile/features/reward/presentation/providers/reward_providers.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Reward History Page
/// Shows complete transaction history with filtering by date range and type
class RewardHistoryPage extends ConsumerStatefulWidget {
  const RewardHistoryPage({super.key});

  @override
  ConsumerState<RewardHistoryPage> createState() => _RewardHistoryPageState();
}

class _RewardHistoryPageState extends ConsumerState<RewardHistoryPage> {
  String _selectedPeriod = 'all'; // all, week, month, year
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(rewardViewModelProvider.notifier).fetchRewardHistory();
    });
  }

  Future<void> _onRefresh() async {
    await ref.read(rewardViewModelProvider.notifier).fetchRewardHistory();
  }

  List<dynamic> _filterByPeriod(List<dynamic> history) {
    if (_selectedPeriod == 'all') return history;

    final now = DateTime.now();
    DateTime cutoffDate;

    switch (_selectedPeriod) {
      case 'week':
        cutoffDate = now.subtract(const Duration(days: 7));
        break;
      case 'month':
        cutoffDate = DateTime(now.year, now.month - 1, now.day);
        break;
      case 'year':
        cutoffDate = DateTime(now.year - 1, now.month, now.day);
        break;
      default:
        return history;
    }

    return history.where((item) {
      return item.redemptionDate.isAfter(cutoffDate);
    }).toList();
  }

  Map<String, List<dynamic>> _groupByMonth(List<dynamic> history) {
    final Map<String, List<dynamic>> grouped = <String, List<dynamic>>{};

    for (var item in history) {
      final monthKey = DateFormat('MMMM yyyy').format(item.redemptionDate);
      if (!grouped.containsKey(monthKey)) {
        grouped[monthKey] = <dynamic>[];
      }
      grouped[monthKey]!.add(item);
    }

    return grouped;
  }

  int _calculateTotalPoints(List<dynamic> history) {
    return history.fold(0, (sum, item) => sum + (item.pointsSpent as int));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;
    final s = S.of(context)!;
    final rewardState = ref.watch(rewardViewModelProvider);
    final allHistory = rewardState.rewardHistory ?? [];
    final filteredHistory = _filterByPeriod(allHistory);
    final groupedHistory = _groupByMonth(filteredHistory);
    final totalPoints = _calculateTotalPoints(filteredHistory);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.transaction_history),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.calendar_today_rounded),
            tooltip: s.filter_by_period,
            onSelected: (value) {
              setState(() {
                _selectedPeriod = value;
              });
            },
            itemBuilder: (context) => [
              _buildPeriodMenuItem(
                context,
                'all',
                s.all_time,
                Icons.all_inclusive_rounded,
              ),
              _buildPeriodMenuItem(
                context,
                'week',
                s.past_week,
                Icons.calendar_view_week_rounded,
              ),
              _buildPeriodMenuItem(
                context,
                'month',
                s.past_month,
                Icons.calendar_view_month_rounded,
              ),
              _buildPeriodMenuItem(
                context,
                'year',
                s.past_year,
                Icons.calendar_month_rounded,
              ),
            ],
          ),
        ],
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
          : filteredHistory.isEmpty
          ? RefreshIndicator(
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history_rounded,
                          size: 80,
                          color: theme.disabledColor,
                        ),
                        SizedBox(height: space),
                        Text(
                          s.no_transaction_history,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.disabledColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: _onRefresh,
              child: CustomScrollView(
                slivers: [
                  // Summary Card
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(space),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(space),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(space * 1.5),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary.withValues(alpha: 0.1),
                                AppColors.primary.withValues(alpha: 0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(space),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _SummaryItem(
                                icon: Icons.redeem_rounded,
                                label: s.total_redeemed,
                                value: '${filteredHistory.length}',
                                color: AppColors.primary,
                              ),
                              Container(
                                width: 1,
                                height: 40,
                                color: theme.dividerColor,
                              ),
                              _SummaryItem(
                                icon: Icons.stars_rounded,
                                label: s.points_spent,
                                value: '$totalPoints',
                                color: AppColors.warning,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Grouped History List
                  ...groupedHistory.entries.map((entry) {
                    return SliverMainAxisGroup(
                      slivers: [
                        // Month Header
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              space * 1.5,
                              space,
                              space * 1.5,
                              space * 0.5,
                            ),
                            child: Text(
                              entry.key,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                        // Month Items
                        SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final item = entry.value[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: space,
                                vertical: space * 0.3,
                              ),
                              child: _HistoryCard(
                                item: item,
                                dateFormat: _dateFormat,
                              ),
                            );
                          }, childCount: entry.value.length),
                        ),
                      ],
                    );
                  }),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
            ),
    );
  }

  PopupMenuItem<String> _buildPeriodMenuItem(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final isSelected = _selectedPeriod == value;

    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isSelected ? theme.colorScheme.primary : null,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? theme.colorScheme.primary : null,
              fontWeight: isSelected ? FontWeight.w600 : null,
            ),
          ),
          if (isSelected) ...[
            const Spacer(),
            Icon(Icons.check, size: 18, color: theme.colorScheme.primary),
          ],
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final dynamic item;
  final DateFormat dateFormat;

  const _HistoryCard({required this.item, required this.dateFormat});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(space * 0.8),
        side: BorderSide(color: theme.dividerColor, width: 0.5),
      ),
      child: Padding(
        padding: EdgeInsets.all(space),
        child: Row(
          children: [
            // Icon
            Container(
              padding: EdgeInsets.all(space * 0.8),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.card_giftcard_rounded,
                color: AppColors.warning,
                size: 24,
              ),
            ),
            SizedBox(width: space),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.itemName,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dateFormat.format(item.redemptionDate),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.disabledColor,
                    ),
                  ),
                ],
              ),
            ),

            // Points
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.stars_rounded,
                      size: 16,
                      color: AppColors.danger,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '-${item.pointsSpent}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.danger,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
