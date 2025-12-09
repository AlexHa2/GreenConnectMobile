import 'package:GreenConnectMobile/core/di/injector.dart';
import 'package:GreenConnectMobile/features/collector/domain/entities/collector_report_entity.dart';
import 'package:GreenConnectMobile/features/collector/presentation/providers/collector_report_provider.dart';
import 'package:GreenConnectMobile/features/notification/presentation/providers/notification_providers.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/notification_bell.dart';
import 'package:GreenConnectMobile/features/profile/data/models/user_model.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/core/network/token_storage.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CollectorHomePage extends ConsumerStatefulWidget {
  const CollectorHomePage({super.key});

  @override
  ConsumerState<CollectorHomePage> createState() => _CollectorHomePageState();
}

class _CollectorHomePageState extends ConsumerState<CollectorHomePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  AnimationController? _barAnimationController;
  Animation<double>? _barAnimation;
  UserModel? user;
  Map<String, DateTime>? _cachedWeekRange;
  int? _cachedWeekNumber;

  // Sample data for bar chart - matching the image
  final List<double> weeklyEarnings = [12, 15, 18, 15, 21, 15, 24]; // Mon-Sun
  final List<String> weekDays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  // Get start and end of current week - cached to prevent unnecessary rebuilds
  Map<String, DateTime> _getWeekRange() {
    final now = DateTime.now();
    final currentWeekNumber = _getWeekNumber(now);

    // Only recalculate if week has changed
    if (_cachedWeekRange == null || _cachedWeekNumber != currentWeekNumber) {
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final endOfWeek = startOfWeek.add(const Duration(days: 6));
      _cachedWeekRange = {
        'start': DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day),
        'end': DateTime(
          endOfWeek.year,
          endOfWeek.month,
          endOfWeek.day,
          23,
          59,
          59,
        ),
      };
      _cachedWeekNumber = currentWeekNumber;
    }

    return _cachedWeekRange!;
  }

  // Get week number for the year (1-53)
  int _getWeekNumber(DateTime date) {
    final startOfYear = DateTime(date.year, 1, 1);
    final daysSinceStart = date.difference(startOfYear).inDays;
    return ((daysSinceStart + startOfYear.weekday) / 7).ceil();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeAnimations();
    loadUser();
    // Initialize week range once
    _getWeekRange();
    // Fetch notifications
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _refreshNotifications();
      }
    });
  }

  Future<void> _refreshNotifications() async {
    await ref.read(notificationViewModelProvider.notifier).fetchNotifications();
  }

  void _initializeAnimations() {
    _barAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _barAnimation = CurvedAnimation(
      parent: _barAnimationController!,
      curve: Curves.easeOutCubic,
    );
    _barAnimationController!.forward();
  }

  Future<void> loadUser() async {
    final tokenStorage = sl<TokenStorageService>();
    UserModel? fetchedUser = await tokenStorage.getUserData();
    if (mounted) {
      setState(() {
        user = fetchedUser;
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshNotifications();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _barAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;
    final s = S.of(context)!;

    if (user == null) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
          ),
        ),
      );
    }

    // Fetch collector report data - use stable key to prevent refetch
    final weekRange = _getWeekRange();
    final weekKey =
        '${weekRange['start']!.toIso8601String()}_${weekRange['end']!.toIso8601String()}';
    final reportAsync = ref.watch(collectorReportProvider(weekKey));

    // Watch notification state
    final notificationState = ref.watch(notificationViewModelProvider);
    final unreadCount = notificationState.unreadCount;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: _refreshNotifications,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Header Section
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                  space * 2,
                  MediaQuery.of(context).padding.top + space * 1.5,
                  space * 2,
                  space * 5,
                ),
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.your_earnings,
                                style: theme.textTheme.headlineLarge?.copyWith(
                                  color: theme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.w800,
                                  fontSize: space * 3.2,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              SizedBox(height: space * 0.8),
                              Text(
                                s.track_performance_impact,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.onPrimary.withValues(
                                    alpha: 0.95,
                                  ),
                                  fontSize: space * 1.2,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        NotificationIconButton(
                          count: unreadCount,
                          onPressed: () => context.push('/notifications'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Earnings Overview Card
            SliverToBoxAdapter(
              child: Transform.translate(
                offset: Offset(0, -space * 2.5),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: space * 2),
                  child: reportAsync.when(
                    data: (report) => _buildEarningsOverviewCard(
                      context,
                      space,
                      theme,
                      s,
                      totalEarning: report.totalEarning,
                    ),
                    loading: () => _buildEarningsOverviewCard(
                      context,
                      space,
                      theme,
                      s,
                      totalEarning: 0,
                    ),
                    error: (_, __) => _buildEarningsOverviewCard(
                      context,
                      space,
                      theme,
                      s,
                      totalEarning: 0,
                    ),
                  ),
                ),
              ),
            ),

            // Statistics Cards
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  space * 2,
                  space * 0.5,
                  space * 2,
                  space * 2,
                ),
                child: reportAsync.when(
                  data: (report) => Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          icon: Icons.check_circle_rounded,
                          label: s.completion_rate,
                          value: report.totalFeedbacks > 0
                              ? '${((report.totalRating / report.totalFeedbacks / 5) * 100).toStringAsFixed(0)}%'
                              : '0%',
                          color: Colors.green,
                          space: space,
                          theme: theme,
                        ),
                      ),
                      SizedBox(width: space * 1.5),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          icon: Icons.eco_rounded,
                          label: s.eco_impact,
                          value: report.totalRating >= 4.5
                              ? s.excellent
                              : report.totalRating >= 3.5
                              ? 'Tốt'
                              : report.totalRating > 0
                              ? 'Trung bình'
                              : 'Chưa có',
                          color: theme.primaryColor,
                          space: space,
                          theme: theme,
                        ),
                      ),
                    ],
                  ),
                  loading: () => Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          icon: Icons.check_circle_rounded,
                          label: s.completion_rate,
                          value: '0%',
                          color: Colors.green,
                          space: space,
                          theme: theme,
                        ),
                      ),
                      SizedBox(width: space * 1.5),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          icon: Icons.eco_rounded,
                          label: s.eco_impact,
                          value: s.excellent,
                          color: theme.primaryColor,
                          space: space,
                          theme: theme,
                        ),
                      ),
                    ],
                  ),
                  error: (_, __) => Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          icon: Icons.check_circle_rounded,
                          label: s.completion_rate,
                          value: '0%',
                          color: Colors.green,
                          space: space,
                          theme: theme,
                        ),
                      ),
                      SizedBox(width: space * 1.5),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          icon: Icons.eco_rounded,
                          label: s.eco_impact,
                          value: s.excellent,
                          color: theme.primaryColor,
                          space: space,
                          theme: theme,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Eco Impact Card
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  space * 2,
                  0,
                  space * 2,
                  space * 2,
                ),
                child: reportAsync.when(
                  data: (report) => _buildEcoImpactCard(
                    context,
                    space,
                    theme,
                    s,
                    totalFeedbacks: report.totalFeedbacks,
                    totalRating: report.totalRating,
                  ),
                  loading: () => _buildEcoImpactCard(
                    context,
                    space,
                    theme,
                    s,
                    totalFeedbacks: 0,
                    totalRating: 0,
                  ),
                  error: (_, __) => _buildEcoImpactCard(
                    context,
                    space,
                    theme,
                    s,
                    totalFeedbacks: 0,
                    totalRating: 0,
                  ),
                ),
              ),
            ),

            // Level Progress Card
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  space * 2,
                  0,
                  space * 2,
                  space * 2,
                ),
                child: _buildLevelProgressCard(context, space, theme, s),
              ),
            ),

            // Quick Actions Section
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: space * 2),
                child: _buildQuickActionsSection(context, space, theme, s),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: space * 3)),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningsOverviewCard(
    BuildContext context,
    double space,
    ThemeData theme,
    S s, {
    required double totalEarning,
  }) {
    return Container(
      padding: EdgeInsets.all(space * 3),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.cardColor, theme.primaryColor.withValues(alpha: 0.05)],
        ),
        borderRadius: BorderRadius.circular(space * 2.5),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(space * 1.2),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.primaryColor,
                          theme.primaryColor.withValues(alpha: 0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(space * 1.5),
                    ),
                    child: Icon(
                      Icons.account_balance_wallet_rounded,
                      color: theme.colorScheme.onPrimary,
                      size: space * 2.5,
                    ),
                  ),
                  SizedBox(width: space * 1.2),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.earnings_overview,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: space * 1.9,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: space * 0.3),
                      Text(
                        s.average_weekly_earnings,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: space * 1.1,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: space * 3.5),
          // Số tiền lớn và nổi bật
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: space * 0.5),
                child: Text(
                  '\$',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: space * 3.5,
                  ),
                ),
              ),
              SizedBox(width: space * 0.5),
              Text(
                totalEarning.toStringAsFixed(0),
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.w900,
                  fontSize: space * 5.5,
                  letterSpacing: -1.5,
                  height: 1.1,
                ),
              ),
            ],
          ),
          SizedBox(height: space * 2.5),
          // Thông tin bổ sung
          Container(
            padding: EdgeInsets.all(space * 1.2),
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(space * 1.5),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.trending_up_rounded,
                  color: theme.primaryColor,
                  size: space * 2,
                ),
                SizedBox(width: space),
                Expanded(
                  child: Text(
                    s.tap_to_see_detailed_breakdown,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: space * 1.05,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYAxisLabel(String label, double space, ThemeData theme) {
    return Text(
      label,
      style: theme.textTheme.bodySmall?.copyWith(
        fontSize: space * 0.85,
        color: theme.colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required double space,
    required ThemeData theme,
  }) {
    return Container(
      padding: EdgeInsets.all(space * 2),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(space * 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(space * 1.3),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withValues(alpha: 0.15),
                  color.withValues(alpha: 0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(space * 1.2),
            ),
            child: Icon(icon, color: color, size: space * 3.2),
          ),
          SizedBox(height: space * 1.5),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: space * 1.05,
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: space * 0.8),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: space * 2.8,
              color: color,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEcoImpactCard(
    BuildContext context,
    double space,
    ThemeData theme,
    S s, {
    required int totalFeedbacks,
    required double totalRating,
  }) {
    return Container(
      padding: EdgeInsets.all(space * 2.5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.cardColor, theme.primaryColor.withValues(alpha: 0.02)],
        ),
        borderRadius: BorderRadius.circular(space * 2.5),
        border: Border.all(
          color: theme.primaryColor.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 6),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(space * 0.8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.primaryColor,
                      theme.primaryColor.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(space * 1),
                ),
                child: Icon(
                  Icons.eco_rounded,
                  color: theme.colorScheme.onPrimary,
                  size: space * 2,
                ),
              ),
              SizedBox(width: space),
              Text(
                s.eco_impact,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: space * 1.9,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          SizedBox(height: space * 2.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildEcoMetric(
                context,
                icon: Icons.star_rounded,
                value: totalRating > 0 ? totalRating.toStringAsFixed(1) : '0',
                label: s.feedbacks,
                space: space,
                theme: theme,
              ),
              _buildEcoMetric(
                context,
                icon: Icons.message_rounded,
                value: totalFeedbacks.toString(),
                label: s.feedbacks,
                space: space,
                theme: theme,
              ),
              _buildEcoMetric(
                context,
                icon: Icons.trending_up_rounded,
                value: totalRating > 0
                    ? '${((totalRating / 5) * 100).toStringAsFixed(0)}%'
                    : '0%',
                label: s.completion_rate,
                space: space,
                theme: theme,
              ),
            ],
          ),
          SizedBox(height: space * 2.5),
          Container(
            padding: EdgeInsets.all(space * 1.5),
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(space * 1.5),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.celebration_rounded,
                  color: theme.primaryColor,
                  size: space * 2,
                ),
                SizedBox(width: space),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        totalRating > 0
                            ? 'Đánh giá trung bình: ${totalRating.toStringAsFixed(1)}/5.0'
                            : 'Chưa có đánh giá',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: space * 1.4,
                          color: theme.primaryColor,
                        ),
                      ),
                      SizedBox(height: space * 0.3),
                      Text(
                        totalFeedbacks > 0
                            ? 'Tổng số đánh giá: $totalFeedbacks'
                            : s.keep_up_amazing_work,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: space * 1.05,
                        ),
                      ),
                    ],
                  ),
                ),
                const Text('🌱', style: TextStyle(fontSize: 24)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEcoMetric(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required double space,
    required ThemeData theme,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(space * 1.2),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.primaryColor.withValues(alpha: 0.15),
                  theme.primaryColor.withValues(alpha: 0.08),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: theme.primaryColor, size: space * 3.5),
          ),
          SizedBox(height: space * 1.2),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.primaryColor,
              fontWeight: FontWeight.w800,
              fontSize: space * 2.2,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: space * 0.5),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: space * 1,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLevelProgressCard(
    BuildContext context,
    double space,
    ThemeData theme,
    S s,
  ) {
    return Container(
      padding: EdgeInsets.all(space * 2.5),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(space * 2.5),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.emoji_events_rounded,
                color: theme.colorScheme.tertiary,
                size: space * 2.2,
              ),
              SizedBox(width: space),
              Text(
                s.level_progress,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: space * 1.9,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          SizedBox(height: space * 1.5),
          Text(
            s.percent_to_level('75', '6'),
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: space * 1.15,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: space * 1.5),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(space * 2),
                child: LinearProgressIndicator(
                  value: 0.75,
                  minHeight: space * 1.5,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.primaryColor.withValues(alpha: 0.3),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(space * 2),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 0.75),
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return LinearProgressIndicator(
                      value: value,
                      minHeight: space * 1.5,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.primaryColor,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: space * 2),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(vertical: space * 1.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(space * 1.5),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.visibility_rounded, size: space * 1.5),
                  SizedBox(width: space * 0.8),
                  Text(
                    s.preview_level_up,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: space * 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalStatsSection(
    BuildContext context,
    double space,
    ThemeData theme,
    S s, {
    required CollectorReportEntity report,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thống kê chi tiết',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: space * 1.9,
            letterSpacing: -0.3,
          ),
        ),
        SizedBox(height: space * 1.5),
        Wrap(
          spacing: space * 1.5,
          runSpacing: space * 1.5,
          children: [
            _buildStatCard(
              context,
              icon: Icons.receipt_long_rounded,
              label: s.transactions,
              value: report.totalTransactions.toString(),
              color: Colors.blue,
              space: space,
              theme: theme,
            ),
            _buildStatCard(
              context,
              icon: Icons.handshake_rounded,
              label: s.offers,
              value: report.totalOffers.toString(),
              color: Colors.orange,
              space: space,
              theme: theme,
            ),
            _buildStatCard(
              context,
              icon: Icons.report_problem_rounded,
              label: s.complaints,
              value: report.totalComplaints.toString(),
              color: Colors.red,
              space: space,
              theme: theme,
            ),
            _buildStatCard(
              context,
              icon: Icons.gavel_rounded,
              label: s.accused,
              value: report.totalAccused.toString(),
              color: Colors.purple,
              space: space,
              theme: theme,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionsSection(
    BuildContext context,
    double space,
    ThemeData theme,
    S s,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.dashboard_rounded,
              color: theme.primaryColor,
              size: space * 2.2,
            ),
            SizedBox(width: space),
            Text(
              s.quick_actions,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: space * 1.9,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        SizedBox(height: space * 2),
        Wrap(
          spacing: space * 1.5,
          runSpacing: space * 1.5,
          children: [
            _buildQuickActionCard(
              context,
              icon: Icons.local_offer_rounded,
              label: s.offers,
              color: theme.primaryColor,
              space: space,
              theme: theme,
              onTap: () => context.push(
                '/collector-offer-list',
                extra: {'isCollectorView': true},
              ),
            ),
            _buildQuickActionCard(
              context,
              icon: Icons.shop_rounded,
              label: s.offers,
              color: theme.primaryColor,
              space: space,
              theme: theme,
              onTap: () => context.push('/package-list'),
            ),
            _buildQuickActionCard(
              context,
              icon: Icons.schedule_rounded,
              label: s.scheduleListTitle,
              color: Colors.purple,
              space: space,
              theme: theme,
              onTap: () => context.go('/collector-schedule-list'),
            ),
            _buildQuickActionCard(
              context,
              icon: Icons.receipt_long_rounded,
              label: s.transactions,
              color: Colors.blue,
              space: space,
              theme: theme,
              onTap: () => context.go('/collector-list-transactions'),
            ),
            _buildQuickActionCard(
              context,
              icon: Icons.star_rounded,
              label: s.feedbacks,
              color: Colors.amber,
              space: space,
              theme: theme,
              onTap: () => context.go('/collector-feedback-list'),
            ),
            _buildQuickActionCard(
              context,
              icon: Icons.report_problem_rounded,
              label: s.complaints,
              color: Colors.red,
              space: space,
              theme: theme,
              onTap: () => context.go('/collector-complaint-list'),
            ),
          ],
        ),
        SizedBox(height: space * 2),
      ],
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required double space,
    required ThemeData theme,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - space * 6) / 2,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(space * 2),
          child: Container(
            padding: EdgeInsets.all(space * 2),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withValues(alpha: 0.12),
                  color.withValues(alpha: 0.06),
                ],
              ),
              borderRadius: BorderRadius.circular(space * 2),
              border: Border.all(
                color: color.withValues(alpha: 0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(space * 1.2),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color.withValues(alpha: 0.2),
                        color.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(space * 1.2),
                  ),
                  child: Icon(icon, color: color, size: space * 3),
                ),
                SizedBox(height: space * 1.2),
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: space * 1.1,
                    color: color,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
