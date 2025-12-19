import 'package:GreenConnectMobile/core/helper/currency_helper.dart';
import 'package:GreenConnectMobile/core/helper/date_time_extension.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/payment_transaction_entity.dart';
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

  String? _filterType; // Pending | Success | Failed
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
        _scrollController.position.maxScrollExtent - 120) {
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
    final s = S.of(context)!;
    final space = theme.extension<AppSpacing>()!.screenPadding;

    final state = ref.watch(paymentTransactionViewModelProvider);
    final transactions = state.listData?.data ?? [];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      // ================= APP BAR =================
      appBar: AppBar(
        title: Text(s.payment_transactions, style: theme.textTheme.titleLarge),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0.5,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            tooltip: s.sort_by_creation_date,
            icon: Icon(
              _isSortDesc ? Icons.south_rounded : Icons.north_rounded,
              color: theme.colorScheme.primary,
            ),
            onPressed: () {
              setState(() => _isSortDesc = !_isSortDesc);
              _fetchData(isRefresh: true);
            },
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: () => _fetchData(isRefresh: true),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // ================= FILTER =================
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(space, space, space, space / 2),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(s.all, null),
                      _buildFilterChip(s.pending, 'Pending'),
                      _buildFilterChip(s.success, 'Success'),
                      _buildFilterChip(s.failed, 'Failed'),
                    ],
                  ),
                ),
              ),
            ),

            // ================= LOADING =================
            if (state.isLoadingList && transactions.isEmpty)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            // ================= EMPTY =================
            else if (transactions.isEmpty)
              SliverFillRemaining(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 72,
                      color: theme.hintColor,
                    ),
                    const SizedBox(height: 16),
                    Text(s.not_found, style: theme.textTheme.bodyLarge),
                  ],
                ),
              )
            // ================= LIST =================
            else
              SliverPadding(
                padding: EdgeInsets.fromLTRB(space, 0, space, space),
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
                    return _TransactionCard(tx: tx);
                  }, childCount: transactions.length + 1),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ================= FILTER CHIP =================
  Widget _buildFilterChip(String label, String? type) {
    final theme = Theme.of(context);
    final isSelected = _filterType == type;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          setState(() => _filterType = type);
          _fetchData(isRefresh: true);
        },
        selectedColor: theme.colorScheme.primary.withAlpha(20),
        checkmarkColor: theme.colorScheme.primary,
        backgroundColor: theme.cardColor,
        side: BorderSide(color: theme.dividerColor),
        labelStyle: theme.textTheme.bodySmall?.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

// ===================================================================
// ======================== TRANSACTION CARD ==========================
// ===================================================================

class _TransactionCard extends StatelessWidget {
  final PaymentTransactionEntity tx;

  const _TransactionCard({required this.tx});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final space = theme.extension<AppSpacing>()!.screenPadding;
    final s = S.of(context)!;

    // ================= STATUS MAPPING =================
    late Color statusColor;
    late IconData statusIcon;
    late String statusLabel;

    switch (tx.status) {
      case 'Success':
        statusColor = theme.colorScheme.primary;
        statusIcon = Icons.check_circle_rounded;
        statusLabel = s.success;
        break;
      case 'Pending':
        statusColor = AppColors.warningUpdate;
        statusIcon = Icons.hourglass_top_rounded;
        statusLabel = s.pending;
        break;
      default:
        statusColor = AppColors.danger;
        statusIcon = Icons.cancel_rounded;
        statusLabel = s.failed;
    }

    return Container(
      margin: EdgeInsets.only(bottom: space),
      padding: EdgeInsets.all(space),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(space),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= ICON =================
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: statusColor.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(statusIcon, color: statusColor),
          ),

          SizedBox(width: space),

          // ================= INFO =================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // STATUS BADGE
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withAlpha(15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    statusLabel,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                // DATE
                Text(
                  tx.createdAt.toCustomFormat(
                    locale: Localizations.localeOf(context).languageCode,
                  ),
                  style: theme.textTheme.bodySmall,
                ),

                const SizedBox(height: 2),

                // META
                Text(
                  '${tx.bankCode} • ${tx.paymentGateway}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ],
            ),
          ),

          // ================= AMOUNT + CONNECTION =================
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // MONEY (ALWAYS NEGATIVE)
              Text(
                '-${formatVND(tx.amount.abs())}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.danger,
                ),
              ),

              const SizedBox(height: 6),

              // CONNECTION (ALWAYS POSITIVE)
              Row(
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    size: 14,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${tx.packageModel.connectionAmount}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
