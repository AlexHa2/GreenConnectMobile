import 'package:GreenConnectMobile/core/helper/currency_helper.dart';
import 'package:GreenConnectMobile/core/helper/date_time_extension.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/providers/transaction_providers.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentTransactionsListPage extends ConsumerStatefulWidget {
  const PaymentTransactionsListPage({super.key});

  @override
  ConsumerState<PaymentTransactionsListPage> createState() =>
      _PaymentTransactionsListPageState();
}

class _PaymentTransactionsListPageState
    extends ConsumerState<PaymentTransactionsListPage> {
  final ScrollController _scrollController = ScrollController();
  int _page = 1;
  final int _size = 10;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _filterType;
  bool _isSortDesc = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData(isRefresh: true);
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      if (!_isLoadingMore && _hasMore) {
        _fetchData();
      }
    }
  }

  Future<void> _fetchData({bool isRefresh = false}) async {
    if (_isLoadingMore) return;
    if (isRefresh) {
      _page = 1;
      _hasMore = true;
    }
    setState(() => _isLoadingMore = true);
    await ref
        .read(paymentTransactionViewModelProvider.notifier)
        .fetchMyPaymentTransactions(
          pageIndex: _page,
          pageSize: _size,
          status: _filterType,
          sortByCreatedAt: _isSortDesc,
        );
    final state = ref.read(paymentTransactionViewModelProvider);
    if (mounted) {
      setState(() {
        _isLoadingMore = false;
        _hasMore = (state.listData?.data.length ?? 0) >= _size;
        if (!isRefresh) _page++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final space = theme.extension<AppSpacing>()!.screenPadding;
    final s = S.of(context)!;
    final state = ref.watch(paymentTransactionViewModelProvider);
    final transactions = state.listData?.data ?? [];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        edgeOffset: 100,
        onRefresh: () => _fetchData(isRefresh: true),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: theme.primaryColor,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  s.payment_bank_transfer_description,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                background: Container(color: theme.primaryColor),
              ),
            ),
            
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: space / 2),
                color: theme.primaryColor,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: space),
                  child: Row(
                    children: [
                      _buildFilterChip(s.all, null),
                      _buildFilterChip(s.deposit, 'deposit'),
                      _buildFilterChip(s.withdraw, 'withdraw'),
                      const SizedBox(width: 8),
                      VerticalDivider(color: theme.dividerColor, width: 1),
                      IconButton(
                        icon: Icon(
                          _isSortDesc
                              ? Icons.arrow_downward_rounded
                              : Icons.arrow_upward_rounded,
                          color: theme.scaffoldBackgroundColor,
                        ),
                        tooltip: s.sort_by_creation_date,
                        onPressed: () {
                          setState(() => _isSortDesc = !_isSortDesc);
                          _fetchData(isRefresh: true);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (state.isLoadingList && transactions.isEmpty)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (transactions.isEmpty)
              SliverFillRemaining(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 80,
                      color: theme.hintColor.withAlpha(77),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      s.not_found,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  ],
                ),
              )
            else
              SliverPadding(
                padding: EdgeInsets.all(space),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    if (index == transactions.length) {
                      return _hasMore
                          ? const Padding(
                              padding: EdgeInsets.all(20),
                              child: Center(
                                child: CircularProgressIndicator.adaptive(),
                              ),
                            )
                          : const SizedBox.shrink();
                    }
                    final tx = transactions[index];
                    final isPositive = tx.amount >= 0;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.onSurface.withAlpha(10),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isPositive
                                ? theme.primaryColor.withAlpha(25)
                                : AppColors.danger.withAlpha(25),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            isPositive
                                ? Icons.add_circle_outline
                                : Icons.remove_circle_outline,
                            color: isPositive
                                ? theme.primaryColor
                                : AppColors.danger,
                          ),
                        ),
                        title: Text(
                          'ID: 	${tx.paymentId}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tx.createdAt.toCustomFormat(
                                  locale: Localizations.localeOf(
                                    context,
                                  ).languageCode,
                                ),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.hintColor,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Gateway: ${tx.paymentGateway}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.hintColor,
                                ),
                              ),
                              Text(
                                'Status: ${tx.status}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.hintColor,
                                ),
                              ),
                              Text(
                                'Ref: ${tx.transactionRef}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.hintColor,
                                ),
                              ),
                              Text(
                                'Bank: ${tx.bankCode}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.hintColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${isPositive ? '+' : ''}${formatVND(tx.amount)}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isPositive
                                    ? theme.primaryColor
                                    : AppColors.danger,
                              ),
                            ),
                            // You can add more trailing info if needed, e.g. packageModel, etc.
                          ],
                        ),
                      ),
                    );
                  }, childCount: transactions.length + 1),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String? type) {
    final isSelected = _filterType == type;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          setState(() => _filterType = type);
          _fetchData(isRefresh: true);
        },
        selectedColor: theme.colorScheme.onSurface,
        checkmarkColor: theme.primaryColor,
        labelStyle: TextStyle(
          color: isSelected ? theme.primaryColor : theme.primaryColor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        backgroundColor: theme.scaffoldBackgroundColor.withAlpha(51),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
      ),
    );
  }
}
