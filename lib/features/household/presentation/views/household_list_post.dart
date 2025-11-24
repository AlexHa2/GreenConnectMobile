import 'dart:async';

import 'package:GreenConnectMobile/core/enum/post_status.dart';
import 'package:GreenConnectMobile/core/helper/post_status_helper.dart';
import 'package:GreenConnectMobile/features/household/domain/entities/paginated_scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/household/domain/entities/scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/household/presentation/providers/scrap_post_providers.dart';
import 'package:GreenConnectMobile/features/household/presentation/views/widges/post_item.dart';
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
    final s = S.of(context)!;

    final vmState = ref.watch(scrapPostViewModelProvider);

    final isFirstLoading = vmState.isLoadingList && _posts.isEmpty;
    final error = vmState.errorMessage;

    return Scaffold(
      appBar: AppBar(
        title: Text("${s.list} ${s.post}"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go("/"),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(spacing.screenPadding * 2),
        ),
        onPressed: () => context.push("/create-post"),
        backgroundColor: theme.primaryColor,
        label: Text(
          s.add,
          style: theme.textTheme.labelLarge!.copyWith(
            color: theme.scaffoldBackgroundColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(spacing.screenPadding),
        child: Column(
          children: [
            // Search bar
            TextField(
              onChanged: _onChangeSearch,
              decoration: InputDecoration(
                hintText: s.search_by_name,
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 12),

            // Filter buttons
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterButton(
                    label: s.all,
                    color: theme.primaryColor,
                    isSelected: _selectedStatus == null,
                    onTap: () => _onSelectFilter(null),
                  ),
                  SizedBox(width: spacing.screenPadding / 2),

                  _buildStatusFilter(context, "Open"),
                  SizedBox(width: spacing.screenPadding / 2),

                  _buildStatusFilter(context, "Partiallybooked"),
                  SizedBox(width: spacing.screenPadding / 2),

                  _buildStatusFilter(context, "Fullybooked"),
                  SizedBox(width: spacing.screenPadding / 2),

                  _buildStatusFilter(context, "Completed"),
                  SizedBox(width: spacing.screenPadding / 2),

                  _buildStatusFilter(context, "Canceled"),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Body
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh,
                child: Builder(
                  builder: (context) {
                    if (isFirstLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (error != null && _posts.isEmpty) {
                      return Center(
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
                      );
                    }

                    if (_posts.isEmpty) {
                      return Center(child: Text(s.not_found));
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: _posts.length + (_hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _posts.length) {
                          // loading more indicator
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final post = _posts[index];

                        final title = post.title;
                        final desc = post.description;
                        final rawStatus = post.status ?? 'open';
                        final localizedStatus =
                            PostStatusHelper.getLocalizedStatus(
                              context,
                              rawStatus as PostStatus,
                            );

                        final time = post.availableTimeRange;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
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

  Widget _buildStatusFilter(BuildContext context, String status) {
    final color = PostStatusHelper.getStatusColor(
      context,
      status as PostStatus,
    );
    final label = PostStatusHelper.getLocalizedStatus(
      context,
      status as PostStatus,
    );
    return _buildFilterButton(
      label: label,
      color: color,
      isSelected: _selectedStatus == status,
      onTap: () => _onSelectFilter(status),
    );
  }

  Widget _buildFilterButton({
    required String label,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected
            ? color.withValues(alpha: 0.1)
            : Colors.transparent,
        side: BorderSide(color: color),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodyMedium!.copyWith(
          color: isSelected ? color : theme.textTheme.bodyMedium!.color,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
