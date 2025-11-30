import 'package:GreenConnectMobile/features/feedback/domain/entities/feedback_entity.dart';
import 'package:GreenConnectMobile/features/feedback/presentation/providers/feedback_providers.dart';
import 'package:GreenConnectMobile/features/feedback/presentation/views/widgets/feedback_card.dart';
import 'package:GreenConnectMobile/features/feedback/presentation/views/widgets/feedback_list_header.dart';
import 'package:GreenConnectMobile/features/feedback/presentation/views/widgets/feedback_states.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_leaf_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FeedbackListPage extends ConsumerStatefulWidget {
  const FeedbackListPage({super.key});

  @override
  ConsumerState<FeedbackListPage> createState() => _FeedbackListPageState();
}

class _FeedbackListPageState extends ConsumerState<FeedbackListPage> {
  final ScrollController _scrollController = ScrollController();

  bool? _sortByCreatAt = true; // true = newest first, false = oldest first
  int _currentPage = 1;
  final int _pageSize = 10;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;

  List<FeedbackEntity> _allFeedbacks = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _allFeedbacks = [];
      _currentPage = 1;
    });

    final notifier = ref.read(feedbackViewModelProvider.notifier);
    await notifier.fetchMyFeedbacks(
      page: 1,
      size: _pageSize,
      sortByCreatAt: _sortByCreatAt,
    );

    final state = ref.read(feedbackViewModelProvider);
    if (mounted && state.listData != null) {
      setState(() {
        _allFeedbacks = state.listData!.data;
        _currentPage = 1;
        _hasMoreData = state.listData!.pagination.nextPage != null;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _hasMoreData) {
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
    });

    final nextPage = _currentPage + 1;

    try {
      await ref.read(feedbackViewModelProvider.notifier).fetchMyFeedbacks(
            page: nextPage,
            size: _pageSize,
            sortByCreatAt: _sortByCreatAt,
          );

      final state = ref.read(feedbackViewModelProvider);
      if (state.listData != null) {
        setState(() {
          final newFeedbacks = state.listData!.data;
          _allFeedbacks.addAll(newFeedbacks);
          _currentPage = nextPage;
          _hasMoreData = state.listData!.pagination.nextPage != null;
        });
      }
    } catch (e) {
      debugPrint('Error loading more: $e');
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    setState(() {
      _currentPage = 1;
      _hasMoreData = true;
      _allFeedbacks.clear();
    });
    _loadInitialData();
  }

  void _toggleSortOrder() {
    setState(() {
      if (_sortByCreatAt == null) {
        _sortByCreatAt = true;
      } else if (_sortByCreatAt == true) {
        _sortByCreatAt = false;
      } else {
        _sortByCreatAt = true;
      }
      _currentPage = 1;
      _hasMoreData = true;
    });
    _loadInitialData().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()?.screenPadding ?? 12.0;
    final s = S.of(context)!;
    final feedbackState = ref.watch(feedbackViewModelProvider);

    ref.listen(feedbackViewModelProvider, (previous, next) {
      if (next.listData != null &&
          !next.isLoadingList &&
          next.errorMessage == null) {
        if (_currentPage == 1) {
          setState(() {
            _allFeedbacks = next.listData!.data;
            _hasMoreData = next.listData!.pagination.nextPage != null;
          });
        }
      }
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          FeedbackListHeader(
            sortByCreatAt: _sortByCreatAt,
            onToggleSort: _toggleSortOrder,
          ),
          Divider(height: 1, color: theme.dividerColor),
          Expanded(
            child: _buildContent(feedbackState, theme, spacing, s),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    dynamic feedbackState,
    ThemeData theme,
    double spacing,
    S s,
  ) {
    // Show loading when loading and no local data yet
    if (feedbackState.isLoadingList && _allFeedbacks.isEmpty) {
      return const Center(child: RotatingLeafLoader());
    }

    if (feedbackState.errorMessage != null && _allFeedbacks.isEmpty) {
      return FeedbackErrorState(
        error: feedbackState.errorMessage!,
        onRetry: _onRefresh,
      );
    }

    // Show empty state only when not loading and no data
    if (_allFeedbacks.isEmpty) {
      return FeedbackEmptyState(
        title: s.no_feedbacks_found,
        subtitle: s.no_feedbacks_available,
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: theme.primaryColor,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(spacing/2),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _allFeedbacks.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _allFeedbacks.length && _isLoadingMore) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: spacing),
              child: Center(
                child: SizedBox(
                  width: spacing * 2,
                  height: spacing * 2,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.primaryColor,
                    ),
                  ),
                ),
              ),
            );
          }

          final feedback = _allFeedbacks[index];
          return Padding(
            padding: EdgeInsets.only(bottom: spacing),
            child: FeedbackCard(
              feedback: feedback,
              onTap: () async {
                final result = await context.pushNamed<bool>(
                  'feedback-detail',
                  extra: {'feedbackId': feedback.feedbackId},
                );
                // If result is true, refresh the list
                if (result == true && mounted) {
                  _onRefresh();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
