import 'package:GreenConnectMobile/core/helper/currency_helper.dart';
import 'package:GreenConnectMobile/core/helper/date_time_extension.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/credit_transaction_entity.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/providers/transaction_providers.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreditTransactionsListPage extends ConsumerStatefulWidget {
  const CreditTransactionsListPage({super.key});

  @override
  ConsumerState<CreditTransactionsListPage> createState() =>
      _CreditTransactionsListPageState();
}

class _CreditTransactionsListPageState
    extends ConsumerState<CreditTransactionsListPage> {
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
      _onRefresh();
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ===================== SCROLL LOAD MORE =====================
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      if (!_isLoadingMore && _hasMore) {
        _fetchData();
      }
    }
  }

  // ===================== REFRESH =====================
  Future<void> _onRefresh() async {
    _page = 1;
    _hasMore = true;
    ref.read(creditTransactionViewModelProvider.notifier).clearList();
    await _fetchData(isRefresh: true);
  }

  // ===================== FETCH DATA =====================
  Future<void> _fetchData({bool isRefresh = false}) async {
    if (_isLoadingMore) return;

    setState(() => _isLoadingMore = true);

    await ref
        .read(creditTransactionViewModelProvider.notifier)
        .fetchCreditTransactions(
          pageIndex: isRefresh ? 1 : _page,
          pageSize: _size,
          type: _filterType,
          sortByCreatedAt: _isSortDesc,
        );

    final state = ref.read(creditTransactionViewModelProvider);

    if (!mounted) return;

    setState(() {
      _isLoadingMore = false;
      _hasMore = (state.listData?.data.length ?? 0) >= _size;
      if (_hasMore) _page++;
    });
  }

  // ===================== UI =====================
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.dividerColor,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildFilterBar(context),
          Expanded(child: _buildTransactionList(context)),
        ],
      ),
    );
  }

  // ===================== APP BAR =====================
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context)!;
    // final space = theme.extension<AppSpacing>()!.screenPadding;
    return AppBar(
      elevation: 0,
      backgroundColor: theme.scaffoldBackgroundColor,
      leading: BackButton(color: theme.colorScheme.onSurface),
      centerTitle: true,
      title: Text(
        s.credit_transactions,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
      ),
      actions: [
        IconButton(
          tooltip: s.sort_by_creation_date,
          icon: Icon(
            _isSortDesc
                ? Icons.arrow_downward_rounded
                : Icons.arrow_upward_rounded,
            color: theme.primaryColor,
          ),
          onPressed: () {
            setState(() => _isSortDesc = !_isSortDesc);
            _onRefresh();
          },
        ),
      ],
    );
  }

  // ===================== FILTER BAR =====================
  Widget _buildFilterBar(BuildContext context) {
    final theme = Theme.of(context);
    final space = theme.extension<AppSpacing>()!.screenPadding;
    final s = S.of(context)!;

    return Container(
      // color: theme.scaffoldBackgroundColor,
      padding: EdgeInsets.symmetric(horizontal: space, vertical: space / 2),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(s.all, null),
            _buildFilterChip(s.deposit, 'deposit'),
            _buildFilterChip(s.withdraw, 'withdraw'),
          ],
        ),
      ),
    );
  }

  // ===================== LIST =====================
  Widget _buildTransactionList(BuildContext context) {
    final theme = Theme.of(context);
    final space = theme.extension<AppSpacing>()!.screenPadding;
    final s = S.of(context)!;

    final state = ref.watch(creditTransactionViewModelProvider);
    final transactions = state.listData?.data ?? [];

    if (state.isLoadingList && transactions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 80,
              color: theme.hintColor.withValues(alpha: 0.3),
            ),
            SizedBox(height: space),
            Text(
              s.not_found,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.hintColor,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: theme.primaryColor,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(space),
        itemCount: transactions.length + 1,
        itemBuilder: (context, index) {
          if (index == transactions.length) {
            return _hasMore
                ? Padding(
                    padding: EdgeInsets.all(space),
                    child: const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  )
                : const SizedBox.shrink();
          }

          final tx = transactions[index];
          final isPositive = tx.amount >= 0;

          return _buildTransactionItem(context, tx, isPositive);
        },
      ),
    );
  }

  // ===================== ITEM =====================
  Widget _buildTransactionItem(
    BuildContext context,
    CreditTransactionEntity tx,
    bool isPositive,
  ) {
    final theme = Theme.of(context);
    final space = theme.extension<AppSpacing>()!.screenPadding;
    final s = S.of(context)!;
    return Container(
      margin: EdgeInsets.only(bottom: space),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(space),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: space,
          vertical: space / 2,
        ),
        leading: CircleAvatar(
          backgroundColor: isPositive
              ? theme.primaryColor.withValues(alpha: 0.12)
              : AppColors.danger.withValues(alpha: 0.12),
          child: Icon(
            isPositive ? Icons.add : Icons.remove,
            color: isPositive ? theme.primaryColor : AppColors.danger,
          ),
        ),
        title: Text(
          tx.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            tx.createdAt.toCustomFormat(locale: s.localeName),
            style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
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
                color: isPositive ? theme.primaryColor : AppColors.danger,
              ),
            ),
            Text(
              '${s.balance}: ${formatVND(tx.balanceAfter)}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===================== FILTER CHIP =====================
  Widget _buildFilterChip(String label, String? type) {
    final isSelected = _filterType == type;
    final theme = Theme.of(context);
    final space = theme.extension<AppSpacing>()!.screenPadding;
    return Padding(
      padding: EdgeInsets.only(right: space / 2),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          setState(() => _filterType = type);
          _onRefresh();
        },
        selectedColor: theme.primaryColor.withValues(alpha: 0.2),
        checkmarkColor: theme.primaryColor,
        labelStyle: TextStyle(
          color: theme.primaryColor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        backgroundColor: theme.scaffoldBackgroundColor.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(space * 2),
        ),
        side: BorderSide.none,
      ),
    );
  }
}
