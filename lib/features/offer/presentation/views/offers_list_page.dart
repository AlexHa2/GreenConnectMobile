import 'package:GreenConnectMobile/core/enum/offer_status.dart';
import 'package:GreenConnectMobile/features/offer/domain/entities/collection_offer_entity.dart';
import 'package:GreenConnectMobile/features/offer/presentation/providers/offer_providers.dart';
import 'package:GreenConnectMobile/features/offer/presentation/views/widgets/offer_card.dart';
import 'package:GreenConnectMobile/features/offer/presentation/views/widgets/offer_filter_chips.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_leaf_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OffersListPage extends ConsumerStatefulWidget {
  final String? postId;
  final bool isCollectorView;

  const OffersListPage({super.key, this.postId, this.isCollectorView = false});

  @override
  ConsumerState<OffersListPage> createState() => _OffersListPageState();
}

class _OffersListPageState extends ConsumerState<OffersListPage> {
  final ScrollController _scrollController = ScrollController();

  OfferStatus? _selectedStatus;
  int _currentPage = 1;
  final int _pageSize = 10;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;

  List<CollectionOfferEntity> _allOffers = [];

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
      _allOffers = [];
      _currentPage = 1;
    });
    final notifier = ref.read(offerViewModelProvider.notifier);

    if (widget.isCollectorView) {
      await notifier.fetchAllOffers(
        status: _selectedStatus?.name,
        sortByCreateAtDesc: true,
        page: 1,
        size: _pageSize,
      );
    } else if (widget.postId != null) {
      await notifier.fetchOffersByPost(
        postId: widget.postId!,
        status: _selectedStatus?.name,
        page: 1,
        size: _pageSize,
      );
    }

    final state = ref.read(offerViewModelProvider);
    if (mounted && state.listData != null) {
      setState(() {
        _allOffers = state.listData!.data;
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
      if (widget.isCollectorView) {
        await ref
            .read(offerViewModelProvider.notifier)
            .fetchAllOffers(
              status: _selectedStatus?.name,
              sortByCreateAtDesc: true,
              page: nextPage,
              size: _pageSize,
            );
      } else if (widget.postId != null) {
        await ref
            .read(offerViewModelProvider.notifier)
            .fetchOffersByPost(
              postId: widget.postId!,
              status: _selectedStatus?.name,
              page: nextPage,
              size: _pageSize,
            );
      }

      final state = ref.read(offerViewModelProvider);
      if (state.listData != null) {
        setState(() {
          final newOffers = state.listData!.data;
          _allOffers.addAll(newOffers);
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
      _allOffers.clear();
    });
    _loadInitialData();
  }

  Future<void> _navigateToOfferDetail(String offerId) async {
    final result = await context.pushNamed(
      'offer-detail',
      extra: {'offerId': offerId, 'isCollectorView': widget.isCollectorView},
    );

    // If result is true (changes made), reload the list
    if (result == true && mounted) {
      _onRefresh();
    }
  }

  void _onFilterChanged(OfferStatus? status) {
    setState(() {
      _selectedStatus = status;
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
    final offerState = ref.watch(offerViewModelProvider);
    ref.listen(offerViewModelProvider, (previous, next) {
      if (next.listData != null &&
          !next.isLoadingList &&
          next.errorMessage == null) {
        if (_currentPage == 1) {
          setState(() {
            _allOffers = next.listData!.data;
            _hasMoreData = next.listData!.pagination.nextPage != null;
          });
        }
      }
    });
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.cardColor,
        title: Text(
          widget.isCollectorView ? s.all_offers : s.post_offers,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: theme.iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        automaticallyImplyLeading: !widget.isCollectorView,
      ),
      body: Column(
        children: [
          Container(
            color: theme.cardColor,
            padding: EdgeInsets.symmetric(
              horizontal: spacing,
              vertical: spacing,
            ),
            child: OfferFilterChips(
              selectedStatus: _selectedStatus,
              onFilterChanged: _onFilterChanged,
            ),
          ),
          Divider(height: 1, color: theme.dividerColor),
          Expanded(child: _buildContent(offerState, theme, spacing, s)),
        ],
      ),
    );
  }

  Widget _buildContent(
    dynamic offerState,
    ThemeData theme,
    double spacing,
    S s,
  ) {
    // Show loading when loading and no local data yet
    if (offerState.isLoadingList && _allOffers.isEmpty) {
      return const Center(child: RotatingLeafLoader());
    }

    if (offerState.errorMessage != null && _allOffers.isEmpty) {
      return _buildErrorState(offerState.errorMessage!, theme, spacing, s);
    }

    // Show empty state only when not loading and no data
    if (_allOffers.isEmpty) {
      return _buildEmptyState(theme, spacing, s);
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: theme.primaryColor,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(spacing),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _allOffers.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _allOffers.length && _isLoadingMore) {
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

          final offer = _allOffers[index];
          return Padding(
            padding: EdgeInsets.only(bottom: spacing),
            child: OfferCard(
              offer: offer,
              isCollectorView: widget.isCollectorView,
              onTap: () async {
                await _navigateToOfferDetail(offer.collectionOfferId);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, double spacing, S s) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inbox_outlined,
              size: 60,
              color: theme.primaryColor,
            ),
          ),
          SizedBox(height: spacing * 1.5),
          Text(
            s.no_offers_found,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: spacing * 0.5),
          Text(
            _selectedStatus != null
                ? s.no_offers_yet(
                    OfferStatus.labelS(
                      context,
                      OfferStatus.parseStatus(_selectedStatus!.name),
                    ).toLowerCase(),
                  )
                : s.no_offers_available,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error, ThemeData theme, double spacing, S s) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing * 1.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.danger.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 60,
                color: AppColors.danger,
              ),
            ),
            SizedBox(height: spacing * 1.5),
            Text(
              s.something_went_wrong,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: spacing * 0.5),
            Text(
              error,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing * 1.5),
            ElevatedButton.icon(
              onPressed: _onRefresh,
              icon: const Icon(Icons.refresh),
              label: Text(s.try_again),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: theme.scaffoldBackgroundColor,
                padding: EdgeInsets.symmetric(
                  horizontal: spacing * 1.5,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(spacing),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
