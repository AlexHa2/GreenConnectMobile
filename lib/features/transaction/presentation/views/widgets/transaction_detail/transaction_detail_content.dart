import 'package:GreenConnectMobile/core/enum/role.dart';
import 'package:GreenConnectMobile/core/enum/transaction_status.dart';
import 'package:GreenConnectMobile/core/helper/currency_helper.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_category_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/transaction_entity.dart'
    as post_entity;
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_detail_entity.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_detail/related_transactions_section.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_detail/transaction_address_info.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_items_section.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_party_info.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Main content body for transaction detail
class TransactionDetailContentBody extends StatefulWidget {
  final TransactionEntity transaction;
  final Role userRole;
  final post_entity.PostTransactionsResponseEntity? transactionsData;
  final bool isLoadingTransactions;
  final int currentTransactionIndex;
  final ValueChanged<int>? onTransactionChanged;
  final TransactionEntity Function(post_entity.TransactionEntity)? convertPostTransactionToTransaction;

  const TransactionDetailContentBody({
    super.key,
    required this.transaction,
    required this.userRole,
    this.transactionsData,
    this.isLoadingTransactions = false,
    this.currentTransactionIndex = 0,
    this.onTransactionChanged,
    this.convertPostTransactionToTransaction,
  });

  @override
  State<TransactionDetailContentBody> createState() =>
      _TransactionDetailContentBodyState();
}

class _TransactionDetailContentBodyState
    extends State<TransactionDetailContentBody> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.currentTransactionIndex;
    _pageController = PageController(initialPage: widget.currentTransactionIndex);
  }

  @override
  void didUpdateWidget(TransactionDetailContentBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync PageController when currentTransactionIndex changes externally
    if (oldWidget.currentTransactionIndex != widget.currentTransactionIndex &&
        _currentPage != widget.currentTransactionIndex) {
      _currentPage = widget.currentTransactionIndex;
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          widget.currentTransactionIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    if (_currentPage != index) {
      setState(() {
        _currentPage = index;
      });
      widget.onTransactionChanged?.call(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!.screenPadding;
    final s = S.of(context)!;

    // If we have multiple transactions, use PageView
    if (widget.transactionsData != null &&
        widget.transactionsData!.transactions.length > 1 &&
        widget.convertPostTransactionToTransaction != null) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Transaction selector
          _TransactionSelector(
            transactions: widget.transactionsData!.transactions,
            currentIndex: _currentPage,
            onChanged: (index) {
              if (_pageController.hasClients) {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
          SizedBox(height: spacing * 1.5),
          // PageView for transactions
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: widget.transactionsData!.transactions.length,
              itemBuilder: (context, index) {
                final postTransaction =
                    widget.transactionsData!.transactions[index];
                final transaction =
                    widget.convertPostTransactionToTransaction!(postTransaction);
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: _buildTransactionContent(
                            context,
                            transaction,
                            theme,
                            spacing,
                            s,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      );
    }

    // Single transaction - no PageView needed
    return SingleChildScrollView(
      child: _buildTransactionContent(
        context,
        widget.transaction,
        theme,
        spacing,
        s,
      ),
    );
  }

  /// Get items to display - use transactionDetails if available, otherwise use offerDetails
  List<TransactionDetailEntity> _getItemsToDisplay(TransactionEntity transaction) {
    // If transactionDetails is not empty, use it
    if (transaction.transactionDetails.isNotEmpty) {
      return transaction.transactionDetails;
    }

    // Otherwise, convert offerDetails to TransactionDetailEntity
    final offer = transaction.offer;
    if (offer == null || offer.offerDetails.isEmpty) {
      return [];
    }

    return offer.offerDetails.map((offerDetail) {
      // Create ScrapCategoryEntity from offerDetail
      final category = offerDetail.scrapCategory != null
          ? ScrapCategoryEntity(
              scrapCategoryId: offerDetail.scrapCategory!.scrapCategoryId,
              categoryName: offerDetail.scrapCategory!.categoryName,
              description: null,
            )
          : ScrapCategoryEntity(
              scrapCategoryId: offerDetail.scrapCategoryId,
              categoryName: '', // Will be localized when displayed
              description: null,
            );

      return TransactionDetailEntity(
        transactionId: transaction.transactionId,
        scrapCategoryId: offerDetail.scrapCategoryId,
        scrapCategory: category,
        pricePerUnit: offerDetail.pricePerUnit,
        unit: offerDetail.unit,
        quantity: 0, // Not entered yet
        finalPrice: 0, // No price since quantity is 0
        type: offerDetail.type ?? '',
      );
    }).toList();
  }

  Widget _buildTransactionContent(
    BuildContext context,
    TransactionEntity transaction,
    ThemeData theme,
    double spacing,
    S s,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TransactionHeaderInfo(
          transaction: transaction,
          amountDifference: widget.transactionsData?.amountDifference,
          isLoadingTransactions: widget.isLoadingTransactions,
        ),
        SizedBox(height: spacing * 1.5),
        TransactionSummaryCard(
          transaction: transaction,
          amountDifference: widget.transactionsData?.amountDifference,
          isLoadingTransactions: widget.isLoadingTransactions,
        ),
        SizedBox(height: spacing * 1.5),
        // Time slot card (separate)
        TransactionTimeSlotCard(transaction: transaction),
        SizedBox(height: spacing * 1.5),
        // Pickup address using TransactionAddressInfo widget
        TransactionAddressInfo(
          address: transaction.offer?.scrapPost?.address,
          theme: theme,
          space: spacing,
        ),
        SizedBox(height: spacing),
        TransactionPartyInfo(
          transaction: transaction,
          userRole: widget.userRole,
          theme: theme,
          space: spacing,
          s: s,
        ),
        SizedBox(height: spacing * 1.5),
        // Always show items section - use offerDetails if transactionDetails is empty
        TransactionItemsSection(
          transactionDetails: _getItemsToDisplay(transaction),
          transaction: transaction,
          theme: theme,
          space: spacing,
          s: s,
        ),
        SizedBox(height: spacing * 1.5),
        // Related transactions section from fetchPostTransactions
        RelatedTransactionsSection(
          transactionsData: widget.transactionsData,
          isLoadingTransactions: widget.isLoadingTransactions,
          currentTransactionId: transaction.transactionId,
        ),
      ],
    );
  }
}

/// Transaction selector widget for multiple transactions
class _TransactionSelector extends StatelessWidget {
  final List<post_entity.TransactionEntity> transactions;
  final int currentIndex;
  final ValueChanged<int>? onChanged;

  const _TransactionSelector({
    required this.transactions,
    required this.currentIndex,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!.screenPadding;
    final s = S.of(context)!;

    return Container(
      padding: EdgeInsets.all(spacing),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(spacing * 1.5),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.swap_horiz_rounded,
                color: theme.primaryColor,
                size: 20,
              ),
              SizedBox(width: spacing * 0.5),
              Text(
                s.transactions_count(transactions.length),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing),
          // Transaction chips
          Wrap(
            spacing: spacing * 0.5,
            runSpacing: spacing * 0.5,
            children: List.generate(transactions.length, (index) {
              final isSelected = index == currentIndex;
              return InkWell(
                onTap: () => onChanged?.call(index),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: spacing * 0.8,
                    vertical: spacing * 0.4,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.primaryColor
                        : theme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color:
                          isSelected ? theme.primaryColor : theme.dividerColor,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        s.transaction_number(index + 1),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? theme.scaffoldBackgroundColor
                              : theme.primaryColor,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      if (isSelected) ...[
                        SizedBox(width: spacing * 0.3),
                        Icon(
                          Icons.check_circle,
                          size: 14,
                          color: theme.scaffoldBackgroundColor,
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

/// Header info with status and ID
class TransactionHeaderInfo extends StatelessWidget {
  final TransactionEntity transaction;
  final double? amountDifference;
  final bool isLoadingTransactions;

  const TransactionHeaderInfo({
    super.key,
    required this.transaction,
    this.amountDifference,
    this.isLoadingTransactions = false,
  });

  IconData _getStatusIcon(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.scheduled:
        return Icons.schedule;
      case TransactionStatus.inProgress:
        return Icons.loop;
      case TransactionStatus.completed:
        return Icons.check_circle_outline;
      default:
        return Icons.cancel_outlined;
    }
  }

  String _localizeStatus(S s, TransactionStatus status) {
    switch (status) {
      case TransactionStatus.scheduled:
        return s.scheduled;
      case TransactionStatus.inProgress:
        return s.in_progress;
      case TransactionStatus.completed:
        return s.completed;
      default:
        return s.cancelled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!.screenPadding;
    final s = S.of(context)!;

    return Column(
      children: [
        // Status badge
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: spacing * 1.5,
            vertical: spacing * 0.5,
          ),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.scaffoldBackgroundColor.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getStatusIcon(transaction.statusEnum),
                color: theme.scaffoldBackgroundColor,
                size: 16,
              ),
              SizedBox(width: spacing * 0.5),
              Text(
                _localizeStatus(s, transaction.statusEnum).toUpperCase(),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.scaffoldBackgroundColor.withValues(alpha: 0.9),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),

        // Transaction ID
        SizedBox(height: spacing * 0.5),
        GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: transaction.transactionId));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(s.copied_id(transaction.transactionId)),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          child: Text(
            '${s.id_label} ${transaction.transactionId}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.scaffoldBackgroundColor.withValues(alpha: 0.8),
            ),
          ),
        ),
      ],
    );
  }
}

/// Summary card with key transaction info
class TransactionSummaryCard extends StatelessWidget {
  final TransactionEntity transaction;
  final double? amountDifference;
  final bool isLoadingTransactions;

  const TransactionSummaryCard({
    super.key,
    required this.transaction,
    this.amountDifference,
    this.isLoadingTransactions = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!.screenPadding;
    final s = S.of(context)!;

    return Container(
      padding: EdgeInsets.all(spacing),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(spacing * 1.5),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Amount Difference (prominent display)
          if (amountDifference != null || isLoadingTransactions)
            Container(
              padding: EdgeInsets.all(spacing * 1.2),
              margin: EdgeInsets.only(bottom: spacing),
              decoration: BoxDecoration(
                color: theme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(spacing),
                border: Border.all(
                  color: theme.primaryColor.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_balance_wallet,
                        color: theme.primaryColor,
                        size: 24,
                      ),
                      SizedBox(width: spacing * 0.5),
                      Text(
                        amountDifference != null && amountDifference! > 0
                            ? s.total_will_receive
                            : s.total_will_pay,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.hintColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: spacing * 0.5),
                  if (isLoadingTransactions)
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.primaryColor,
                        ),
                      ),
                    )
                  else
                    Text(
                      formatVND(amountDifference?.abs() ?? 0.0),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  SizedBox(height: spacing * 0.3),
                  Text(
                    s.from_all_transactions,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),

          // Transaction amount and quantity
          Row(
            children: [
              Expanded(
                child: _SummaryItem(
                  label: s.total_money,
                  value: formatVND(transaction.totalPrice.abs()),
                  color: theme.colorScheme.onSurface,
                  icon: Icons.receipt_long,
                ),
              ),
              VerticalDivider(
                width: spacing * 2,
                thickness: 1,
                color: theme.dividerColor.withValues(alpha: 0.5),
              ),
              Expanded(
                child: _SummaryItem(
                  label: s.item_quantity,
                  value: "${transaction.transactionDetails.length}",
                  color: theme.primaryColor,
                  icon: Icons.inventory_2_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Individual summary item
class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.textTheme.bodyLarge?.color,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.hintColor,
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Separate time slot card
class TransactionTimeSlotCard extends StatelessWidget {
  final TransactionEntity transaction;

  const TransactionTimeSlotCard({
    super.key,
    required this.transaction,
  });

  String _formatDate(DateTime date, String locale) {
    if (locale == 'vi') {
      // Vietnamese format: "25 thg 12, 2025"
      final day = date.day;
      final monthNames = [
        '',
        'thg 1',
        'thg 2',
        'thg 3',
        'thg 4',
        'thg 5',
        'thg 6',
        'thg 7',
        'thg 8',
        'thg 9',
        'thg 10',
        'thg 11',
        'thg 12'
      ];
      final monthName = monthNames[date.month];
      final year = date.year;
      return '$day $monthName, $year';
    } else {
      // English format: "Dec 25, 2025"
      return DateFormat('MMM d, yyyy', locale).format(date);
    }
  }

  String _formatTime(String timeString) {
    // Format time from "00:17:00" to "00:17"
    if (timeString.length >= 5) {
      return timeString.substring(0, 5);
    }
    return timeString;
  }

  String _formatTimeFromDateTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!.screenPadding;
    final s = S.of(context)!;
    final locale = s.localeName;

    // Priority: timeSlot > scheduledTime
    String? dateText;
    String? startTimeText;
    String? endTimeText;
    bool hasTimeRange = false;

    if (transaction.timeSlot != null) {
      try {
        final date = DateTime.parse(transaction.timeSlot!.specificDate);
        dateText = _formatDate(date, locale);
        final startTime = _formatTime(transaction.timeSlot!.startTime);
        final endTime = _formatTime(transaction.timeSlot!.endTime);

        startTimeText = startTime;
        endTimeText = endTime;
        hasTimeRange = startTime != endTime;
      } catch (e) {
        dateText = null;
        startTimeText = null;
        endTimeText = null;
      }
    } else if (transaction.scheduledTime != null) {
      try {
        dateText = _formatDate(transaction.scheduledTime!, locale);
        startTimeText = _formatTimeFromDateTime(transaction.scheduledTime!);
        endTimeText = null;
        hasTimeRange = false;
      } catch (e) {
        dateText = null;
        startTimeText = null;
        endTimeText = null;
      }
    }

    // Don't show card if no time data
    if (dateText == null || startTimeText == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing * 1.2,
        vertical: spacing * 0.9,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(spacing / 2),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: EdgeInsets.all(spacing * 0.6),
            decoration: BoxDecoration(
              color: AppColors.warningUpdate.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(spacing * 0.8),
            ),
            child: const Icon(
              Icons.calendar_today_outlined,
              color: AppColors.warningUpdate,
              size: 18,
            ),
          ),
          SizedBox(width: spacing * 0.9),
          // Date and time content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Label
                Text(
                  s.scheduled_time,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.hintColor,
                    fontSize: 11,
                  ),
                ),
                SizedBox(height: spacing * 0.3),
                // Date and time in one line
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Date
                    Flexible(
                      child: Text(
                        dateText,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.textTheme.bodyLarge?.color,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: spacing * 0.6),
                    // Time separator dot
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.hintColor.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: spacing * 0.6),
                    // Time display
                    if (hasTimeRange && endTimeText != null) ...[
                      // Time range
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              startTimeText,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.textTheme.bodyLarge?.color,
                                fontSize: 15,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: spacing * 0.3),
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                size: 14,
                                color: theme.hintColor.withValues(alpha: 0.6),
                              ),
                            ),
                            Text(
                              endTimeText,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.textTheme.bodyLarge?.color,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      // Single time
                      Text(
                        startTimeText,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.textTheme.bodyLarge?.color,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
