import 'package:GreenConnectMobile/core/di/profile_injector.dart';
import 'package:GreenConnectMobile/core/enum/role.dart';
import 'package:GreenConnectMobile/core/enum/transaction_status.dart';
import 'package:GreenConnectMobile/core/network/token_storage.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/providers/transaction_providers.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_detail/transaction_detail_app_bar.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_detail/transaction_detail_bottom_actions.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_detail/transaction_detail_content.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_leaf_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TransactionDetailPageModern extends ConsumerStatefulWidget {
  final String transactionId;

  const TransactionDetailPageModern({
    super.key,
    required this.transactionId,
  });

  @override
  ConsumerState<TransactionDetailPageModern> createState() =>
      _TransactionDetailPageModernState();
}

class _TransactionDetailPageModernState
    extends ConsumerState<TransactionDetailPageModern> {
  final TokenStorageService _tokenStorage = sl<TokenStorageService>();
  bool _hasChanges = false;
  Role _userRole = Role.household;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserRole();
      _loadTransactionDetail();
    });
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

  Future<void> _loadTransactionDetail() async {
    await ref
        .read(transactionViewModelProvider.notifier)
        .fetchTransactionDetail(widget.transactionId);
  }

  Future<void> _onRefresh() async {
    await _loadTransactionDetail();
  }

  void _onActionCompleted() {
    setState(() => _hasChanges = true);
    _loadTransactionDetail();
  }

  void _onBack() {
    context.pop(_hasChanges);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final s = S.of(context)!;
    final state = ref.watch(transactionViewModelProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _onBack();
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        extendBodyBehindAppBar: true,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildBody(state, theme, spacing, s),
        ),
      ),
    );
  }

  Widget _buildBody(
    dynamic state,
    ThemeData theme,
    AppSpacing spacing,
    S s,
  ) {
    if (state.isLoadingDetail) {
      return const Center(
        key: ValueKey('loading'),
        child: RotatingLeafLoader(),
      );
    }

    if (state.detailData == null) {
      return _TransactionErrorState(
        key: const ValueKey('error'),
        onRetry: _loadTransactionDetail,
        onBack: _onBack,
      );
    }

    return _TransactionDetailContent(
      key: const ValueKey('content'),
      transaction: state.detailData!,
      userRole: _userRole,
      onRefresh: _onRefresh,
      onActionCompleted: _onActionCompleted,
      onBack: _onBack,
    );
  }
}

/// Main content widget for transaction detail
class _TransactionDetailContent extends StatelessWidget {
  final TransactionEntity transaction;
  final Role userRole;
  final VoidCallback onRefresh;
  final VoidCallback onActionCompleted;
  final VoidCallback onBack;

  const _TransactionDetailContent({
    super.key,
    required this.transaction,
    required this.userRole,
    required this.onRefresh,
    required this.onActionCompleted,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!.screenPadding;
    // final s = S.of(context)!;

    return Stack(
      children: [
        // Background gradient
        _TransactionBackgroundGradient(status: transaction.statusEnum),

        // Main content
        Positioned.fill(
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Top app bar
                TransactionDetailAppBar(
                  onBack: onBack,
                  onRefresh: onRefresh,
                ),

                // Scrollable content
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async => onRefresh(),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      padding: EdgeInsets.fromLTRB(
                        spacing,
                        0,
                        spacing,
                        spacing * 6,
                      ),
                      child: TransactionDetailContentBody(
                        transaction: transaction,
                        userRole: userRole,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bottom action buttons
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: TransactionDetailBottomActions(
            transaction: transaction,
            userRole: userRole,
            onActionCompleted: onActionCompleted,
          ),
        ),
      ],
    );
  }
}

/// Background gradient based on transaction status
class _TransactionBackgroundGradient extends StatelessWidget {
  final TransactionStatus status;

  const _TransactionBackgroundGradient({required this.status});

  Color _getStatusColor(BuildContext context) {
    final theme = Theme.of(context);

    switch (status) {
      case TransactionStatus.scheduled:
        return theme.colorScheme.onSurface;
      case TransactionStatus.inProgress:
        return AppColors.warningUpdate;
      case TransactionStatus.completed:
        return AppColors.primary;
      case TransactionStatus.canceledBySystem:
      case TransactionStatus.canceledByUser:
        return AppColors.danger;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: 280,
      child: Container(
        decoration: BoxDecoration(
          color: _getStatusColor(context).withValues(alpha: 0.8),
        ),
      ),
    );
  }
}

/// Error state widget
class _TransactionErrorState extends StatelessWidget {
  final VoidCallback onRetry;
  final VoidCallback onBack;

  const _TransactionErrorState({
    super.key,
    required this.onRetry,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context)!;

    return Center(
      child: Text(
        s.login_error,
        style: theme.textTheme.bodyLarge,
      ),
    );
  }
}
