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

class CollectorListPostPage extends ConsumerStatefulWidget {
  const CollectorListPostPage({super.key});

  @override
  ConsumerState<CollectorListPostPage> createState() =>
      _CollectorListPostPageState();
}

class _CollectorListPostPageState extends ConsumerState<CollectorListPostPage> {
  final ScrollController _scrollController = ScrollController();

  int _page = 1;
  final int _size = 10;
  bool _hasMore = true;
  bool _isFetchingMore = false;

  String? _selectedStatus = 'Open';
  String? _searchTitle;
  Timer? _debounce;
  bool _sortByLocation = false;
  bool _sortByCreateAt = true;

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
        .searchPostsForCollector(
          page: _page,
          size: _size,
          categoryName: _searchTitle,
          status: _selectedStatus,
          sortByLocation: _sortByLocation,
          sortByCreateAt: _sortByCreateAt,
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
        .searchPostsForCollector(
          page: _page,
          size: _size,
          categoryName: _searchTitle,
          status: _selectedStatus,
          sortByLocation: _sortByLocation,
          sortByCreateAt: _sortByCreateAt,
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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: space),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  border: Border(
                    bottom: BorderSide(color: theme.dividerColor, width: 1),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        space,
                        space * 1.25,
                        space,
                        space * 0.75,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(space * 1.5),
                          border: Border.all(
                            color: theme.dividerColor.withValues(alpha: 0.5),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: theme.shadowColor.withValues(alpha: 0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          onChanged: _onChangeSearch,
                          decoration: InputDecoration(
                            hintText: s.search_by_name_trash,
                            hintStyle: TextStyle(
                              color: theme.hintColor.withValues(alpha: 0.6),
                              fontSize: 15,
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: theme.primaryColor,
                              size: 22,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: space,
                              vertical: space * 0.85,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: space,
                        vertical: space * 0.5,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildSortToggle(
                              context: context,
                              label: s.sort_by_location,
                              icon: Icons.location_on_outlined,
                              isActive: _sortByLocation,
                              onTap: () {
                                setState(() {
                                  _sortByLocation = !_sortByLocation;
                                  if (_sortByLocation) {
                                    _sortByCreateAt = false;
                                  }
                                });
                                _refresh();
                              },
                            ),
                          ),
                          SizedBox(width: space * 0.5),
                          Expanded(
                            child: _buildSortToggle(
                              context: context,
                              label: s.sort_by_date,
                              icon: Icons.calendar_today_outlined,
                              isActive: _sortByCreateAt,
                              onTap: () {
                                setState(() {
                                  _sortByCreateAt = !_sortByCreateAt;
                                  if (_sortByCreateAt) {
                                    _sortByLocation = false;
                                  }
                                });
                                _refresh();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: space * 0.75),
                      child: PostFilterChips(
                        selectedStatus: _selectedStatus,
                        onSelectFilter: _onSelectFilter,
                        allLabel: s.open,
                        showAllStatuses: false,
                        showAllChip: false,
                      ),
                    ),
                  ],
                ),
              ),
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
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (error != null && _posts.isEmpty) {
                        return ListView(
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
                        controller: _scrollController,
                        padding: EdgeInsets.all(space),
                        itemCount: _posts.length + (_hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _posts.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          final post = _posts[index];
                          final rawStatus = post.status ?? 'open';
                          // final statusColor = PostStatusHelper.getStatusColor(
                          //   context,
                          //   PostStatus.parseStatus(rawStatus),
                          // );
                          final localizedStatus =
                              PostStatusHelper.getLocalizedStatus(
                                context,
                                PostStatus.parseStatus(rawStatus),
                              );

                          return Padding(
                            padding: EdgeInsets.only(bottom: space / 12),
                            child: PostItem(
                              title: post.title,
                              desc: post.description,
                              time: post.availableTimeRange,
                              rawStatus: rawStatus,
                              localizedStatus: localizedStatus,
                              timeCreated:
                                  post.createdAt?.toIso8601String() ?? '',
                              isCollectorView: true,
                              onTapDetails: () {
                                context.push(
                                  '/detail-post',
                                  extra: {
                                    'postId': post.scrapPostId,
                                    'isCollectorView': true,
                                  },
                                );
                              },
                              onGoToOffers: () {
                                context.push(
                                  '/offers-list',
                                  extra: {
                                    'postId': post.scrapPostId,
                                    'isCollectorView': true,
                                  },
                                );
                              },
                              onGoToTransaction: () {
                                context.push(
                                  '/transaction-detail',
                                  extra: {'transactionId': post.scrapPostId},
                                );
                              },
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
      ),
    );
  }

  Widget _buildSortToggle({
    required BuildContext context,
    required String label,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(space * 0.5),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: space * 0.75,
            vertical: space * 0.5,
          ),
          decoration: BoxDecoration(
            color: isActive
                ? theme.primaryColor
                : theme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(space * 0.5),
            border: Border.all(
              color: isActive
                  ? theme.primaryColor
                  : theme.primaryColor.withValues(alpha: 0.3),
              width: isActive ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isActive
                    ? theme.scaffoldBackgroundColor
                    : theme.primaryColor,
              ),
              SizedBox(width: space * 0.25),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isActive
                        ? theme.scaffoldBackgroundColor
                        : theme.primaryColor,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
