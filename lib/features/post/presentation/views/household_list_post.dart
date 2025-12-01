import 'dart:async';

import 'package:GreenConnectMobile/core/enum/post_status.dart';
import 'package:GreenConnectMobile/core/helper/post_status_helper.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/paginated_scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/post/presentation/providers/scrap_post_providers.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/empty_state_widget.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/post_filter_chips.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/post_item.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HouseholdListPostScreen extends ConsumerStatefulWidget {
  const HouseholdListPostScreen({super.key});

  @override
  ConsumerState<HouseholdListPostScreen> createState() =>
      _HouseholdListPostScreenState();
}

class _HouseholdListPostScreenState
    extends ConsumerState<HouseholdListPostScreen> {
  final ScrollController _scrollController = ScrollController();

  int _page = 1;
  final int _size = 10;
  bool _hasMore = true;
  bool _isFetchingMore = false;

  String? _selectedStatus;
  String? _searchTitle;
  Timer? _debounce;

  final List<ScrapPostEntity> _posts = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refresh();
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= maxScroll - 200) {
      _loadMore();
    }
  }

  Future<void> _refresh() async {
    _page = 1;
    _hasMore = true;
    _posts.clear();

    await ref
        .read(scrapPostViewModelProvider.notifier)
        .fetchMyPosts(
          page: _page,
          size: _size,
          title: _searchTitle,
          status: _selectedStatus,
        );

    final newItems = _extractItems(
      ref.read(scrapPostViewModelProvider).listData,
    );
    _posts.addAll(newItems);

    _hasMore = newItems.length == _size;
    setState(() {});
  }

  Future<void> _loadMore() async {
    if (!_hasMore) return;

    final vmState = ref.read(scrapPostViewModelProvider);
    if (vmState.isLoadingList || _isFetchingMore) return;

    _isFetchingMore = true;
    _page += 1;

    await ref
        .read(scrapPostViewModelProvider.notifier)
        .fetchMyPosts(
          page: _page,
          size: _size,
          title: _searchTitle,
          status: _selectedStatus,
        );

    final newItems = _extractItems(
      ref.read(scrapPostViewModelProvider).listData,
    );
    _posts.addAll(newItems);

    _hasMore = newItems.length == _size;
    _isFetchingMore = false;
    if (mounted) setState(() {});
  }

  List<ScrapPostEntity> _extractItems(PaginatedScrapPostEntity? paginatedData) {
    if (paginatedData == null) return [];
    return paginatedData.data;
  }

  void _onChangeSearch(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _searchTitle = value.trim();
      _refresh();
    });
  }

  void _onSelectFilter(String? status) {
    if (_selectedStatus == status) return;
    setState(() => _selectedStatus = status);
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;
    final s = S.of(context)!;

    final vmState = ref.watch(scrapPostViewModelProvider);

    final isFirstLoading = vmState.isLoadingList && _posts.isEmpty;
    final error = vmState.errorMessage;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${s.list} ${s.post}",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/household-home'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => context.push("/create-post"),
            tooltip: s.add,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: space),
        child: Column(
          children: [
            // Header Section with Search and Info
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                border: Border(
                  bottom: BorderSide(color: theme.dividerColor, width: 1),
                ),
              ),
              child: Column(
                children: [
                  // Search Bar
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      space,
                      space,
                      space,
                      space * 0.75,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(space),
                        border: Border.all(
                          color: theme.dividerColor.withValues(alpha: 0.5),
                        ),
                      ),
                      child: TextField(
                        onChanged: _onChangeSearch,
                        decoration: InputDecoration(
                          hintText: s.search_by_name_trash,
                          hintStyle: TextStyle(
                            color: theme.hintColor.withValues(alpha: 0.6),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: theme.primaryColor,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: space,
                            vertical: space * 0.75,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Filter Chips
                  Padding(
                    padding: EdgeInsets.only(bottom: space * 0.75),
                    child: PostFilterChips(
                      selectedStatus: _selectedStatus,
                      onSelectFilter: _onSelectFilter,
                      allLabel: s.all,
                      showAllStatuses: true,
                    ),
                  ),
                ],
              ),
            ),

            // Body
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh,
                child: Builder(
                  builder: (context) {
                    if (isFirstLoading) {
                      return Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: theme.scaffoldBackgroundColor.withValues(
                          alpha: 0.8,
                        ),
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (error != null && _posts.isEmpty) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                          ),
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(s.error_occurred),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: _refresh,
                                  child: Text(s.retry),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }

                    if (_posts.isEmpty) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                          ),
                          EmptyStateWidget(
                            icon: Icons.post_add_outlined,
                            message: s.not_found,
                          ),
                        ],
                      );
                    }

                    return ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _scrollController,
                      padding: EdgeInsets.all(space),
                      itemCount: _posts.length + (_hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _posts.length) {
                          // loading more indicator
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: space),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final post = _posts[index];

                        final title = post.title;
                        final desc = post.description;
                        final rawStatus = post.status ?? 'open';
                        final localizedStatus =
                            PostStatusHelper.getLocalizedStatus(
                              context,
                              PostStatus.parseStatus(rawStatus),
                            );

                        final time = post.availableTimeRange;

                        return Padding(
                          padding: EdgeInsets.only(bottom: space / 12),
                          child: PostItem(
                            title: title,
                            desc: desc,
                            time: time,
                            rawStatus: rawStatus,
                            localizedStatus: localizedStatus,
                            onTapDetails: () {
                              context.push(
                                '/detail-post',
                                extra: {'postId': post.scrapPostId},
                              );
                            },
                            onGoToOffers: () {
                              context.push(
                                '/offers-list',
                                extra: {
                                  'postId': post.scrapPostId,
                                  'isCollectorView': false,
                                },
                              );
                            },
                            onGoToTransaction: () {
                              context.push(
                                "/transaction",
                                extra: {'postId': post.scrapPostId},
                              );
                            },
                            timeCreated: post.createdAt.toString(),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
