import 'package:GreenConnectMobile/core/di/injector.dart';
import 'package:GreenConnectMobile/core/network/token_storage.dart';
import 'package:GreenConnectMobile/features/notification/presentation/providers/notification_providers.dart';
import 'package:GreenConnectMobile/features/post/presentation/providers/scrap_post_providers.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/create_post_button.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/household_header.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/impact_card.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/quick_actions_grid.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/recent_posts_section.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/stats_row.dart';
import 'package:GreenConnectMobile/features/profile/data/models/user_model.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HouseHoldHome extends ConsumerStatefulWidget {
  final Map<String, dynamic> initialData;
  const HouseHoldHome({super.key, required this.initialData});

  @override
  ConsumerState<HouseHoldHome> createState() => _HouseHoldHomeState();
}

class _HouseHoldHomeState extends ConsumerState<HouseHoldHome>
    with WidgetsBindingObserver {
  UserModel? user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    loadUser();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _refreshData();
    });
  }

  void loadUser() async {
    final tokenStorage = sl<TokenStorageService>();
    UserModel? fetchedUser = await tokenStorage.getUserData();
    setState(() {
      user = fetchedUser;
    });
  }

  Future<void> _refreshData() async {
    await Future.wait([
      ref
          .read(scrapPostViewModelProvider.notifier)
          .fetchMyPosts(page: 1, size: 2),
      ref.read(notificationViewModelProvider.notifier).fetchNotifications(),
    ]);
    loadUser();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshData();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;

    final postState = ref.watch(scrapPostViewModelProvider);
    final notificationState = ref.watch(notificationViewModelProvider);
    final posts = postState.listData?.data ?? [];
    final latestThree = posts.take(3).toList();
    final unreadCount = notificationState.unreadCount;

    final String nameAffterSetupProfile =
        widget.initialData["fullName"] ?? "Unknown";
    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final userName = (user?.fullName ?? '').trim();
    final setupName = (nameAffterSetupProfile).trim();

    final displayName = userName.isNotEmpty ? userName : setupName;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: CustomScrollView(
          slivers: [
            // Header
            HouseholdHeader(
              user: user!,
              displayName: displayName,
              unreadCount: unreadCount,
            ),

            // Content
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Impact Card
                  const ImpactCard(),

                  SizedBox(height: spacing.screenPadding),

                  // Stats Row
                  const StatsRow(
                    acceptedCount: "112",
                    completedCount: "110",
                    availableCount: "144",
                  ),

                  SizedBox(height: spacing.screenPadding * 2),

                  // Create Post Button
                  const CreatePostButton(),

                  SizedBox(height: spacing.screenPadding * 2.5),

                  // Quick Actions
                  const QuickActionsGrid(),

                  SizedBox(height: spacing.screenPadding * 3),

                  // Recent Posts
                  RecentPostsSection(
                    isLoading: postState.isLoadingList,
                    errorMessage: postState.errorMessage,
                    posts: latestThree,
                    onRefresh: _refreshData,
                  ),

                  SizedBox(height: spacing.screenPadding * 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
