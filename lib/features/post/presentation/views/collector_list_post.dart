import 'dart:async';

import 'package:GreenConnectMobile/core/enum/post_status.dart';
import 'package:GreenConnectMobile/core/helper/post_status_helper.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/paginated_scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/post/presentation/providers/scrap_category_providers.dart';
import 'package:GreenConnectMobile/features/post/presentation/providers/scrap_post_providers.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/collector_post_filters.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/empty_state_widget.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/post_filter_chips.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/post_item.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

  bool _showFullHeader = true;
  bool _showMiniHeader = false;

  bool _isFetchingMore = false;
  bool _isRefreshing = false;
  bool _isFilterChanging = false;

  String? _selectedStatus = 'Open';
  String? _searchTitle;
  bool _sortByLocation = false;
  bool _sortByCreateAt = false;
  int? _selectedCategoryId;

  final List<ScrapPostEntity> _posts = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(scrapCategoryViewModelProvider.notifier)
          .fetchScrapCategories(pageNumber: 1, pageSize: 50);
      _refresh();
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ================= CORE FETCH =================

  Future<List<ScrapPostEntity>> _fetchPosts({required int page}) async {
    await ref
        .read(scrapPostViewModelProvider.notifier)
        .searchPostsForCollector(
          page: page,
          size: _size,
          categoryId: _selectedCategoryId,
          categoryName: _searchTitle,
          status: _selectedStatus,
          sortByLocation: _sortByLocation,
          sortByCreateAt: _sortByCreateAt,
        );

    final paginatedData = ref.read(scrapPostViewModelProvider).listData;

    return _extractItems(paginatedData);
  }

  // ================= REFRESH =================

  List<ScrapPostEntity> _extractItems(PaginatedScrapPostEntity? paginatedData) {
    if (paginatedData == null) return [];
    return paginatedData.data;
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final direction = _scrollController.position.userScrollDirection;
    final offset = _scrollController.position.pixels;

    // Scroll down → hide full header, hide mini
    if (direction == ScrollDirection.reverse) {
      if (_showFullHeader || _showMiniHeader) {
        setState(() {
          _showFullHeader = false;
          _showMiniHeader = false;
        });
      }
    }

    if (direction == ScrollDirection.forward) {
      // near top → show full header
      if (offset < 40) {
        if (!_showFullHeader) {
          setState(() {
            _showFullHeader = true;
            _showMiniHeader = false;
          });
        }
      } else {
        // Not at top → show mini header
        if (!_showMiniHeader) {
          setState(() {
            _showFullHeader = false;
            _showMiniHeader = true;
          });
        }
      }
    }

    // Infinite scroll
    final maxScroll = _scrollController.position.maxScrollExtent;
    if (offset >= maxScroll - 200) {
      _loadMore();
    }
  }

  // ================= REFRESH =================

  Future<void> _refresh() async {
    if (_isRefreshing) return;

    _isRefreshing = true;
    _page = 1;
    _hasMore = true;

    final newItems = await _fetchPosts(page: _page);

    if (!mounted) return;

    _posts
      ..clear()
      ..addAll(newItems);

    _hasMore = newItems.length == _size;
    _isRefreshing = false;
    setState(() {});
  }

  // ================= LOAD MORE =================

  Future<void> _loadMore() async {
    if (!_hasMore || _isFetchingMore || _isRefreshing) return;

    _isFetchingMore = true;
    _page += 1;

    final newItems = await _fetchPosts(page: _page);

    if (!mounted) return;

    _posts.addAll(newItems);
    _hasMore = newItems.length == _size;
    _isFetchingMore = false;
    setState(() {});
  }

  // ================= FILTER CHANGE =================

  Future<void> _onFilterChanged(VoidCallback update) async {
    if (_isFilterChanging) return;

    _isFilterChanging = true;
    update();
    _page = 1;
    _hasMore = true;

    final newItems = await _fetchPosts(page: _page);

    if (!mounted) return;

    _posts
      ..clear()
      ..addAll(newItems);

    _hasMore = newItems.length == _size;
    _isFilterChanging = false;
    setState(() {});
  }

  void _onSelectFilter(String? status) {
    if (_selectedStatus == status) return;

    _onFilterChanged(() {
      _selectedStatus = status;
    });
  }

  // ================= UI =================

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
              // ===== HEADER =====
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: _showFullHeader ? null : 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _showFullHeader ? 1 : 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.04,
                          ),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CollectorCategorySearch(
                          selectedCategoryId: _selectedCategoryId,
                          onChanged: (value) {
                            _onFilterChanged(() {
                              _selectedCategoryId = value;
                            });
                          },
                        ),
                        SizedBox(height: space * 0.75),
                        CollectorSortSection(
                          sortByLocation: _sortByLocation,
                          sortByCreateAt: _sortByCreateAt,
                          onSortByLocation: () {
                            _onFilterChanged(() {
                              _sortByLocation = !_sortByLocation;
                              if (_sortByLocation) _sortByCreateAt = false;
                            });
                          },
                          onSortByCreateAt: () {
                            _onFilterChanged(() {
                              _sortByCreateAt = !_sortByCreateAt;
                              if (_sortByCreateAt) _sortByLocation = false;
                            });
                          },
                        ),
                        SizedBox(height: space * 0.5),
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
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: _showMiniHeader ? 56 : 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 150),
                  opacity: _showMiniHeader ? 1 : 0,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.08,
                          ),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: space),
                    child: PostFilterChips(
                      selectedStatus: _selectedStatus,
                      onSelectFilter: _onSelectFilter,
                      allLabel: s.open,
                      showAllStatuses: false,
                      showAllChip: false,
                    ),
                  ),
                ),
              ),

              // ===== LIST =====
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refresh,
                  child: Builder(
                    builder: (context) {
                      if (isFirstLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (error != null && _posts.isEmpty) {
                        return ListView(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.3,
                            ),
                            Center(
                              child: Column(
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
                        itemCount:
                            _posts.length +
                            (_hasMore || _isFilterChanging ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _posts.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          final post = _posts[index];
                          final rawStatus = post.status ?? 'open';
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
}
