import 'package:GreenConnectMobile/core/di/profile_injector.dart';
import 'package:GreenConnectMobile/core/enum/role.dart';
import 'package:GreenConnectMobile/core/enum/transaction_status.dart';
import 'package:GreenConnectMobile/core/network/token_storage.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/providers/transaction_providers.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_list/transaction_list_card.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_list/transaction_list_empty_state.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_list/transaction_list_filter_menu.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_list/transaction_list_header.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_leaf_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Refactored transaction list page with modular components
class TransactionsListPage extends ConsumerStatefulWidget {
  const TransactionsListPage({super.key});

  @override
  ConsumerState<TransactionsListPage> createState() =>
      _TransactionsListPageState();
}

class _TransactionsListPageState extends ConsumerState<TransactionsListPage> {
  final TokenStorageService _tokenStorage = sl<TokenStorageService>();
  final ScrollController _scrollController = ScrollController();

  Role _userRole = Role.household;
  int _currentPage = 1;
  final int _pageSize = 20;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;

  // Local accumulated data for pagination
  List<TransactionEntity> _accumulatedData = [];

  // Filter state
  String _filterType = 'createAt'; // 'createAt' or 'updateAt'
  bool _isDescending = true; // true = newest first, false = oldest first

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserRole();
      _loadTransactions(isRefresh: true);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && _hasMoreData) {
        _loadMoreTransactions();
      }
    }
  }

  Future<void> _loadUserRole() async {
    final user = await _tokenStorage.getUserData();
    if (user != null && user.roles.isNotEmpty) {
      setState(() {
        if (Role.hasRole(user.roles, Role.household)) {
          _userRole = Role.household;
        } else if (Role.hasRole(user.roles, Role.individualCollector)) {
          _userRole = Role.individualCollector;
        } else if (Role.hasRole(user.roles, Role.businessCollector)) {
          _userRole = Role.businessCollector;
        }
      });
    }
  }

  Future<void> _loadTransactions({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
      _hasMoreData = true;
      _accumulatedData.clear();
    }

    await ref.read(transactionViewModelProvider.notifier).fetchAllTransactions(
          page: _currentPage,
          size: _pageSize,
          sortByCreateAt: _filterType == 'createAt' ? _isDescending : null,
          sortByUpdateAt: _filterType == 'updateAt' ? _isDescending : null,
        );

    if (mounted) {
      final state = ref.read(transactionViewModelProvider);
      setState(() {
        if (state.listData != null) {
          if (isRefresh) {
            _accumulatedData = List.from(state.listData!.data);
          } else {
            _accumulatedData = List.from(state.listData!.data);
          }
          _hasMoreData = state.listData!.data.length >= _pageSize;
        }
      });
    }
  }

  Future<void> _loadMoreTransactions() async {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
      _currentPage++;
    });

    await ref.read(transactionViewModelProvider.notifier).fetchAllTransactions(
          page: _currentPage,
          size: _pageSize,
          sortByCreateAt: _filterType == 'createAt' ? _isDescending : null,
          sortByUpdateAt: _filterType == 'updateAt' ? _isDescending : null,
        );

    if (mounted) {
      final state = ref.read(transactionViewModelProvider);
      setState(() {
        _isLoadingMore = false;
        if (state.listData != null) {
          // Append new data to accumulated list
          final newData = state.listData!.data;
          _accumulatedData = [..._accumulatedData, ...newData];
          _hasMoreData = newData.length >= _pageSize;
        }
      });
    }
  }

  Future<void> _onRefresh() async {
    await _loadTransactions(isRefresh: true);
  }

  TransactionStatus _getStatusFromString(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return TransactionStatus.scheduled;
      case 'in_progress':
      case 'inprogress':
        return TransactionStatus.inProgress;
      case 'completed':
        return TransactionStatus.completed;
      case 'canceled_by_user':
      case 'canceledbyuser':
        return TransactionStatus.canceledByUser;
      case 'canceled_by_system':
      case 'canceledbysystem':
        return TransactionStatus.canceledBySystem;
      default:
        return TransactionStatus.scheduled;
    }
  }

  void _showFilterMenu() {
    TransactionListFilterMenu.show(
      context: context,
      currentFilterType: _filterType,
      currentIsDescending: _isDescending,
      onFilterChanged: (filterType, isDescending) {
        setState(() {
          _filterType = filterType;
          _isDescending = isDescending;
        });
        _loadTransactions(isRefresh: true);
      },
    );
  }

  void _navigateToDetail(TransactionEntity transaction) async {
    // Extract all necessary fields from transaction entity
    // GoRouter may not serialize complex objects properly, so we extract fields
    final postId = transaction.offer?.scrapPostId;
    final collectorId = transaction.scrapCollectorId;
    final slotId = transaction.timeSlotId ?? transaction.offer?.timeSlotId;

    final statusEnum = _getStatusFromString(transaction.status);

    // Route selection based on status:
    // - Scheduled -> transaction-detail-onlyone (check-in first)
    // - InProgress -> transaction-detail (multi-transaction, input quantity)
    // - Others -> transaction-detail-onlyone (read-only / single transaction)
    final routeName = statusEnum == TransactionStatus.inProgress
        ? 'transaction-detail'
        : 'transaction-detail-onlyone';

    final result = await context.pushNamed<bool>(
      routeName,
      extra: {
        'transactionId': transaction.transactionId,
        'postId': postId,
        'collectorId': collectorId,
        'slotId': slotId,
      },
    );

    // Refresh list if transaction was updated
    debugPrint('Returned from detail with result: $result');
    if (result == true && mounted) {
      _onRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final space = theme.extension<AppSpacing>()!.screenPadding;
    // final s = S.of(context)!;
    final transactionState = ref.watch(transactionViewModelProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            // Filter header
            TransactionListHeader(
              filterType: _filterType,
              isDescending: _isDescending,
              onFilterTap: _showFilterMenu,
            ),

            // Content
            Expanded(
              child: transactionState.isLoadingList && _currentPage == 1
                  ? const Center(child: RotatingLeafLoader())
                  : _accumulatedData.isEmpty
                      ? const TransactionListEmptyState()
                      : ListView.separated(
                          controller: _scrollController,
                          padding: EdgeInsets.all(space),
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: _accumulatedData.length +
                              (_isLoadingMore ? 1 : 0),
                          separatorBuilder: (context, index) =>
                              SizedBox(height: space),
                          itemBuilder: (context, index) {
                            if (index == _accumulatedData.length) {
                              return const TransactionListLoadingIndicator();
                            }

                            final transaction = _accumulatedData[index];

                            return TransactionListCard(
                              transaction: transaction,
                              userRole: _userRole,
                              onTap: () => _navigateToDetail(transaction),
                              onReviewTap: () async {
                                final result = await context.pushNamed<bool>(
                                  'create-feedback',
                                  extra: {
                                    'transactionId': transaction.transactionId,
                                  },
                                );
                                if (result == true) {
                                  _onRefresh();
                                }
                              },
                              onComplainTap: () async {
                                final result = await context.pushNamed<bool>(
                                  'create-complaint',
                                  extra: {
                                    'transactionId': transaction.transactionId
                                  },
                                );
                                if (result == true) {
                                  _onRefresh();
                                }
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
