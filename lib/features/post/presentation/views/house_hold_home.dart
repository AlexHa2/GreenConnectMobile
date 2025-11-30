import 'package:GreenConnectMobile/core/di/injector.dart';
import 'package:GreenConnectMobile/core/enum/post_status.dart';
import 'package:GreenConnectMobile/core/helper/post_status_helper.dart';
import 'package:GreenConnectMobile/core/network/token_storage.dart';
import 'package:GreenConnectMobile/features/post/presentation/providers/scrap_post_providers.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/empty_post.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/message.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/notification_bell.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/post_item.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/stat_box.dart';
import 'package:GreenConnectMobile/features/profile/data/models/user_model.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/button_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
      ref
          .read(scrapPostViewModelProvider.notifier)
          .fetchMyPosts(page: 1, size: 2);
    });
  }

  void loadUser() async {
    final tokenStorage = sl<TokenStorageService>();
    UserModel? fetchedUser = await tokenStorage.getUserData();
    setState(() {
      user = fetchedUser;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref
          .read(scrapPostViewModelProvider.notifier)
          .fetchMyPosts(page: 1, size: 2);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    const logo = 'assets/images/user_image.png';

    final postState = ref.watch(scrapPostViewModelProvider);
    final posts = postState.listData?.data ?? [];
    final latestThree = posts.take(3).toList();

    final String nameAffterSetupProfile =
        widget.initialData["fullName"] ?? "Unknown";
    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final userName = (user?.fullName ?? '').trim();
    final setupName = (nameAffterSetupProfile).trim();

    final displayName = userName.isNotEmpty ? userName : setupName;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 🔹 Header
          SliverAppBar(
            pinned: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            expandedHeight: spacing.screenPadding * 6,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(
                left: spacing.screenPadding,
                right: spacing.screenPadding,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: spacing.screenPadding * 1.5,
                          backgroundImage: user!.avatarUrl != null
                              ? NetworkImage(user!.avatarUrl!)
                              : const AssetImage(logo) as ImageProvider,
                          backgroundColor: theme.primaryColor.withValues(
                            alpha: 0.4,
                          ),
                        ),
                        SizedBox(width: spacing.screenPadding),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                displayName,
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                              Text(
                                S.of(context)!.make_an_impact,
                                style: textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.normal,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Icon bell
                  NotificationIconButton(
                    count: 1,
                    onPressed: () {
                      context.push('/notifications');
                    },
                  ),
                  SizedBox(width: spacing.screenPadding),
                  MessageIconButton(
                    count: 2,
                    onPressed: () {
                      context.push('/list-message');
                    },
                  ),
                ],
              ),
            ),
          ),

          // 🔹 scroll content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(spacing.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: spacing.screenPadding * 2),

                  Container(
                    padding: EdgeInsets.all(spacing.screenPadding * 2),
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  S.of(context)!.your_impact,
                                  style: textTheme.titleLarge?.copyWith(
                                    color: theme.scaffoldBackgroundColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: spacing.screenPadding * 2,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  S.of(context)!.keep_your_tree,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: theme.scaffoldBackgroundColor,
                                    fontSize: spacing.screenPadding,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.eco,
                              color: theme.scaffoldBackgroundColor,
                              size: 48,
                            ),
                          ],
                        ),

                        SizedBox(height: spacing.screenPadding * 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "150 ${S.of(context)!.points}",
                              style: textTheme.bodyMedium?.copyWith(
                                color: theme.scaffoldBackgroundColor,
                              ),
                            ),
                            Text(
                              "500 ${S.of(context)!.points}",
                              style: textTheme.bodyMedium?.copyWith(
                                color: theme.scaffoldBackgroundColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: 150 / 500,
                          backgroundColor: theme.scaffoldBackgroundColor
                              .withValues(alpha: 0.3),
                          color: theme.scaffoldBackgroundColor,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: spacing.screenPadding * 2.5),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StatBox(
                        value: "112",
                        label: S.of(context)!.accepted,
                        color: AppColors.primary,
                      ),
                      StatBox(
                        value: "110",
                        label: "${S.of(context)!.completed} ",
                        color: AppColors.primary,
                      ),
                      StatBox(
                        value: "144",
                        label: "${S.of(context)!.available} ",
                        color: AppColors.warning,
                      ),
                    ],
                  ),

                  SizedBox(height: spacing.screenPadding * 2.5),

                  // ===== Create New Post =====
                  GradientButton(
                    text: '${S.of(context)!.create_new} ${S.of(context)!.post}',
                    onPressed: () {
                      context.push('/create-post');
                    },
                    icon: const Icon(Icons.add),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    S.of(context)!.my_recycling_post,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: spacing.screenPadding * 2,
                    ),
                  ),
                  SizedBox(height: spacing.screenPadding * 2),

                  if (postState.isLoadingList) ...[
                    const Center(child: CircularProgressIndicator()),
                  ] else if (postState.errorMessage != null) ...[
                    Text(
                      textAlign: TextAlign.center,
                      S.of(context)!.error_general,
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.danger,
                      ),
                    ),
                  ] else if (latestThree.isEmpty) ...[
                    const EmptyPost(),
                  ] else ...[
                    for (var p in latestThree)
                      PostItem(
                        title: p.title,
                        desc: p.description,
                        time: p.availableTimeRange,
                        rawStatus: p.status ?? "unknown",
                        localizedStatus: PostStatusHelper.getLocalizedStatus(
                          context,
                          PostStatus.parseStatus(
                            p.status ?? PostStatus.open.toString(),
                          ),
                        ),
                        onTapDetails: () {
                          context.push(
                            '/detail-post',
                            extra: {'postId': p.scrapPostId},
                          );
                        },
                        onGoToTransaction: () {
                          context.push(
                            '/transaction',
                            extra: {'postId': p.scrapPostId},
                          );
                        },
                        timeCreated: p.createdAt.toString(),
                      ),

                    SizedBox(height: spacing.screenPadding / 2),

                    Center(
                      child: TextButton(
                        onPressed: () {
                          context.push('/list-post');
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              S.of(context)!.see_all_posts,
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.primaryColor,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward,
                              size: 16,
                              color: theme.primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
