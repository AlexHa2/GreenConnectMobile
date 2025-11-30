import 'dart:async';

import 'package:GreenConnectMobile/core/enum/post_status.dart';
import 'package:GreenConnectMobile/core/helper/post_status_helper.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/paginated_scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/post/presentation/providers/scrap_post_providers.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/empty_state_widget.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/post_filter_chips.dart';
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

class _CollectorListPostPageState
    extends ConsumerState<CollectorListPostPage> {
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

    await ref.read(scrapPostViewModelProvider.notifier).searchPostsForCollector(
          page: _page,
          size: _size,
          categoryName: _searchTitle,
          status: _selectedStatus,
          sortByLocation: false,
          sortByCreateAt: true,
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

    await ref.read(scrapPostViewModelProvider.notifier).searchPostsForCollector(
          page: _page,
          size: _size,
          categoryName: _searchTitle,
          status: _selectedStatus,
          sortByLocation: false,
          sortByCreateAt: true,
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
          s.available_posts,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Header Section with Search and Info
          Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              border: Border(
                bottom: BorderSide(
                  color: theme.dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                // Search Bar
                Padding(
                  padding: EdgeInsets.fromLTRB(space, space, space, space * 0.75),
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
                        hintText: s.search_by_name,
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
                      color: theme.scaffoldBackgroundColor.withValues(alpha: 0.8),
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (error != null && _posts.isEmpty) {
                    return ListView(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.3),
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
                        SizedBox(height: MediaQuery.of(context).size.height * 0.3),
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
                        // loading more indicator
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final post = _posts[index];
                      final rawStatus = post.status ?? 'open';
                      final statusColor = PostStatusHelper.getStatusColor(
                        context,
                        PostStatus.parseStatus(rawStatus),
                      );
                      final statusIcon = PostStatusHelper.getStatusIcon(
                        PostStatus.parseStatus(rawStatus),
                      );
                      final localizedStatus =
                          PostStatusHelper.getLocalizedStatus(
                        context,
                        PostStatus.parseStatus(rawStatus),
                      );

                      return Padding(
                        padding: EdgeInsets.only(bottom: space),
                        child: _buildPostCard(
                          context,
                          post,
                          statusColor,
                          statusIcon,
                          localizedStatus,
                          space,
                          s,
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
    );
  }

  Widget _buildPostCard(
    BuildContext context,
    ScrapPostEntity post,
    Color statusColor,
    IconData statusIcon,
    String statusLabel,
    double space,
    S s,
  ) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(space),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(space),
        onTap: () {
          context.push(
            '/collector-post-detail',
            extra: {'postId': post.scrapPostId},
          );
        },
        child: Padding(
          padding: EdgeInsets.all(space),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: space * 0.75,
                  vertical: space * 0.35,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(space * 0.75),
                  border: Border.all(
                    color: statusColor.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 14, color: statusColor),
                    SizedBox(width: space * 0.25),
                    Text(
                      statusLabel,
                      style: textTheme.labelSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: space * 0.75),

              // Title
              Text(
                post.title,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: space * 0.5),

              // Description
              Text(
                post.description,
                style: textTheme.bodyMedium?.copyWith(
                  color: theme.hintColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: space * 0.75),

              // Time and Location
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: theme.hintColor),
                  SizedBox(width: space * 0.35),
                  Expanded(
                    child: Text(
                      post.availableTimeRange,
                      style: textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              if (post.address.isNotEmpty) ...[
                SizedBox(height: space * 0.35),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: theme.hintColor),
                    SizedBox(width: space * 0.35),
                    Expanded(
                      child: Text(
                        post.address,
                        style: textTheme.bodySmall?.copyWith(
                          color: theme.hintColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

}
