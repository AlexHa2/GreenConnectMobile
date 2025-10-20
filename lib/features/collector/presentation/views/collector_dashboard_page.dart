import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/button_gradient.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/features/collector/presentation/providers/dashboard_provider.dart';
import 'package:GreenConnectMobile/features/collector/presentation/widgets/stats_card.dart';
import 'package:GreenConnectMobile/features/collector/presentation/widgets/nearby_opportunities_card.dart';

class CollectorDashboardPage extends ConsumerWidget {
  const CollectorDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(dashboardStatsProvider);
    final opportunities = ref.watch(nearbyOpportunitiesProvider);
    final l10n = S.of(context);
    final spacing = Theme.of(context).extension<AppSpacing>()!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(spacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeader(l10n),
              const SizedBox(height: 24),
              
              // Divider
              Container(
                height: 1,
                color: const Color(0xFFE0E0E0),
              ),
              const SizedBox(height: 24),
              
              // Today's Stats Section
              _buildSectionTitle(l10n?.todays_stats ?? 'THỐNG KÊ HÔM NAY'),
              const SizedBox(height: 16),
              
              // Stats Cards
              StatsCard(
                icon: Icons.attach_money,
                title: l10n?.earnings_today ?? 'Thu nhập hôm nay',
                value: '\$${stats.earningsToday.toStringAsFixed(2)}',
                iconColor: AppColors.primary,
              ),
              const SizedBox(height: 12),
              
              StatsCard(
                icon: Icons.work_outline,
                title: l10n?.jobs_available ?? 'Công việc có sẵn',
                value: '${stats.jobsAvailable}',
                iconColor: AppColors.primary,
              ),
              const SizedBox(height: 12),
              
              StatsCard(
                icon: Icons.star_outline,
                title: l10n?.your_rating ?? 'Đánh giá của bạn',
                value: '${stats.rating}',
                iconColor: Colors.orange,
              ),
              const SizedBox(height: 32),
              
              // Nearby Opportunities Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionTitle(l10n?.nearby_opportunities ?? 'CƠ HỘI GẦN ĐÂY'),
                  Icon(
                    Icons.book_outlined,
                    color: AppColors.primary.withOpacity(0.7),
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Map Card
              NearbyOpportunitiesCard(
                opportunities: opportunities,
                tapText: l10n?.tap_to_view_opportunities ?? 'Chạm để xem các cơ hội gần đó',
              ),
              const SizedBox(height: 32),
              
              // Quick Actions Section
              _buildSectionTitle(l10n?.quick_actions ?? 'HÀNH ĐỘNG NHANH'),
              const SizedBox(height: 16),
              
              // Browse All Jobs Button using shared GradientButton
              GradientButton(
                text: l10n?.browse_all_jobs ?? 'Duyệt tất cả công việc',
                onPressed: () {
                  // TODO: Navigate to jobs list
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(S? l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n?.ecocollect ?? 'EcoCollect',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontFamily: 'Roboto',
              ),
            ),
            Text(
              l10n?.collector_dashboard ?? 'Dashboard',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text(
              'JD',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppColors.textSecondary,
        letterSpacing: 0.5,
      ),
    );
  }
}
