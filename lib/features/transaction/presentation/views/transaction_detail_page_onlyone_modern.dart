import 'package:GreenConnectMobile/core/di/profile_injector.dart';
import 'package:GreenConnectMobile/core/enum/role.dart';
import 'package:GreenConnectMobile/core/enum/transaction_status.dart';
import 'package:GreenConnectMobile/core/network/token_storage.dart';
import 'package:GreenConnectMobile/features/message/presentation/providers/message_providers.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/providers/transaction_providers.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_detail/transaction_address_info.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_detail/transaction_detail_app_bar.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_detail/transaction_detail_bottom_actions.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_detail/transaction_detail_content.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_items_section.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_party_info.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TransactionDetailPageModern extends ConsumerStatefulWidget {
  // Transaction ID (required)
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

  // Store transaction data (from list or loaded)
  TransactionEntity? _currentTransaction;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserRole();

      // Load transaction detail from API (không dùng transactionData)
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
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ref
          .read(transactionViewModelProvider.notifier)
          .fetchTransactionDetail(widget.transactionId);

      if (!mounted) return;

      final state = ref.read(transactionViewModelProvider);

      if (state.detailData != null) {
        setState(() {
          _currentTransaction = state.detailData;
          _isLoading = false;
        });
      } else {
        if (!mounted) return;
        final s = S.of(context)!;
        setState(() {
          _isLoading = false;
          _errorMessage = state.errorMessage ?? s.operation_failed;
        });
      }
    } catch (e) {
      if (!mounted) return;
      final s = S.of(context)!;
      setState(() {
        _isLoading = false;
        _errorMessage = '${s.error_occurred}: ${e.toString()}';
      });
    }
  }

  Future<void> _onRefresh() async {
    await _loadTransactionDetail();
  }

  void _onActionCompleted() {
    setState(() => _hasChanges = true);
    
    // Check current status before reload to detect status changes
    final currentStatus = _currentTransaction?.statusEnum;
    
    // Reload transaction detail after action
    _loadTransactionDetail().then((_) {
      if (!mounted) return;
      
      // Check transaction status after reload
      if (_currentTransaction != null) {
        final status = _currentTransaction!.statusEnum;
        
        // Only navigate back to list if status changed to a final state
        // Don't navigate if status is still inProgress (e.g., after input details)
        // Navigate for:
        // - completed: after approve
        // - canceledByUser: after reject or toggle cancel
        // - canceledBySystem: system canceled
        // - status changed from inProgress to something else
        final statusChanged = currentStatus != null && currentStatus != status;
        final isFinalState = status == TransactionStatus.completed ||
            status == TransactionStatus.canceledByUser ||
            status == TransactionStatus.canceledBySystem;
        
        if (isFinalState || (statusChanged && currentStatus == TransactionStatus.inProgress)) {
          // Navigate back to transaction list page
          if (context.canPop()) {
            context.pop(true); // Return with changes flag
          } else {
            // Determine the correct list page based on user role
            if (_userRole == Role.household) {
              context.go('/household-list-transactions');
            } else if (_userRole == Role.individualCollector ||
                _userRole == Role.businessCollector) {
              context.go('/collector-list-transactions');
            }
          }
        }
        // If status is still inProgress, stay on detail page (e.g., after input details)
      }
    });
  }

  void _onBack() {
    context.pop(_hasChanges);
  }

  void _navigateToTransactionList() {
    if (!mounted) return;

    // Determine the correct list page based on user role
    String targetRoute;
    if (_userRole == Role.household) {
      targetRoute = '/household-list-transactions';
    } else if (_userRole == Role.individualCollector ||
        _userRole == Role.businessCollector) {
      targetRoute = '/collector-list-transactions';
    } else {
      // Fallback: if role is not set, default to collector list
      // (since checkin is typically done by collector)
      debugPrint(
          '⚠️ WARNING: User role not set, defaulting to collector list');
      targetRoute = '/collector-list-transactions';
    }

    // For checkin success, always navigate to list page (don't try to pop)
    // This ensures collector always goes back to transaction list after checkin
    if (mounted && context.mounted) {
      context.go(targetRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final s = S.of(context)!;

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
          child: _buildBody(theme, spacing, s),
        ),
      ),
    );
  }

  Widget _buildBody(ThemeData theme, AppSpacing spacing, S s) {
    if (_isLoading) {
      return const _LoadingState(
        key:  ValueKey('loading'),
      );
    }

    if (_errorMessage != null || _currentTransaction == null) {
      final errorMsg = _errorMessage ?? s.not_found;
      return _TransactionErrorState(
        key: const ValueKey('error'),
        errorMessage: errorMsg,
        onRetry: _loadTransactionDetail,
        onBack: _onBack,
      );
    }

    return _TransactionDetailContent(
      key: const ValueKey('content'),
      transaction: _currentTransaction!,
      userRole: _userRole,
      onRefresh: _onRefresh,
      onActionCompleted: _onActionCompleted,
      onBack: _onBack,
      onCheckInSuccess: _navigateToTransactionList,
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
  final VoidCallback? onCheckInSuccess;

  const _TransactionDetailContent({
    super.key,
    required this.transaction,
    required this.userRole,
    required this.onRefresh,
    required this.onActionCompleted,
    required this.onBack,
    this.onCheckInSuccess,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!.screenPadding;

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
                TransactionDetailAppBar(onBack: onBack, onRefresh: onRefresh),

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
                        spacing * 12, // Increased to allow scrolling above floating chat button
                      ),
                      child: _SingleTransactionContentBody(
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
            amountDifference:
                0.0, // No amount difference for single transaction
            onActionCompleted: onActionCompleted,
            transactionsData: null, // No related transactions
            onCheckInSuccess: onCheckInSuccess, // Pass callback for checkin success
          ),
        ),

        // Floating chat button
        Positioned(
          right: spacing,
          bottom: spacing * 6.5,
          child: _ChatFloatingButton(
            transaction: transaction,
            userRole: userRole,
          ),
        ),
      ],
    );
  }
}

/// Content body for single transaction (no related transactions)
class _SingleTransactionContentBody extends StatelessWidget {
  final TransactionEntity transaction;
  final Role userRole;

  const _SingleTransactionContentBody({
    required this.transaction,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!.screenPadding;
    final s = S.of(context)!;

    return Column(
      children: [
        // Header with status and ID
        TransactionHeaderInfo(
          transaction: transaction,
          amountDifference: null,
          isLoadingTransactions: false,
        ),
        SizedBox(height: spacing * 1.5),

        // Summary card
        TransactionSummaryCard(
          transaction: transaction,
          amountDifference: null,
          isLoadingTransactions: false,
        ),
        SizedBox(height: spacing * 1.5),

        // Time slot card
        TransactionTimeSlotCard(transaction: transaction),
        SizedBox(height: spacing * 1.5),

        // Pickup address
        TransactionAddressInfo(
          address: transaction.offer?.scrapPost?.address,
          theme: theme,
          space: spacing,
        ),
        SizedBox(height: spacing),

        // Party info
        TransactionPartyInfo(
          transaction: transaction,
          userRole: userRole,
          theme: theme,
          space: spacing,
          s: s,
        ),
        SizedBox(height: spacing * 1.5),

        // Transaction items
        if (transaction.transactionDetails.isNotEmpty)
          TransactionItemsSection(
            transactionDetails: transaction.transactionDetails,
            transaction: transaction,
            theme: theme,
            space: spacing,
            s: s,
          ),
      ],
    );
  }
}

/// Floating chat button
class _ChatFloatingButton extends ConsumerWidget {
  final TransactionEntity transaction;
  final Role userRole;

  const _ChatFloatingButton({
    required this.transaction,
    required this.userRole,
  });

  Future<void> _openChat(BuildContext context, WidgetRef ref) async {
    try {
      final otherUserName = userRole == Role.household
          ? transaction.scrapCollector.fullName
          : transaction.household.fullName;

      if (!context.mounted) return;

      final s = S.of(context)!;

      // Show loading toast
      CustomToast.show(
        context,
        '${s.opening_chat_with} $otherUserName...',
        type: ToastType.info,
      );

      // Step 1: Try to fetch existing chat rooms
      await ref
          .read(messageViewModelProvider.notifier)
          .fetchChatRooms(page: 1, size: 100);

      if (!context.mounted) return;

      final messageState = ref.read(messageViewModelProvider);
      final chatRooms = messageState.chatRooms?.chatRooms ?? [];

      // Step 2: Check if chat room exists for this transaction
      final existingRoom = chatRooms
          .where((room) => room.transactionId == transaction.transactionId)
          .firstOrNull;

      if (existingRoom != null) {
        // Chat room exists - Navigate directly
        if (context.mounted) {
          context.push(
            '/chat-detail',
            extra: {
              'transactionId': transaction.transactionId,
              'chatRoomId': existingRoom.chatRoomId,
              'partnerName': existingRoom.partnerName,
              'partnerAvatar': existingRoom.partnerAvatar,
            },
          );
        }
      } else {
        // Chat room doesn't exist - Create by sending first message
        if (!context.mounted) return;

        // Show creating chat room toast
        CustomToast.show(
          context,
          s.chat_creating_room,
          type: ToastType.info,
        );

        // Send initial greeting message to create chat room
        final greetingMessage = s.chat_room_created_success.isNotEmpty
            ? s.chat_room_created_success
            : 'Hello! 👋';
        final success = await ref
            .read(messageViewModelProvider.notifier)
            .sendMessageWithTransaction(
              transactionId: transaction.transactionId,
              content: greetingMessage,
            );

        if (!success) {
          if (context.mounted) {
            CustomToast.show(
              context,
              s.chat_failed_create_room,
              type: ToastType.error,
            );
          }
          return;
        }

        // Step 3: Fetch chat rooms again to get the newly created room
        await ref
            .read(messageViewModelProvider.notifier)
            .fetchChatRooms(page: 1, size: 100);

        if (!context.mounted) return;

        final updatedState = ref.read(messageViewModelProvider);
        final updatedRooms = updatedState.chatRooms?.chatRooms ?? [];

        // Find the newly created chat room
        final newRoom = updatedRooms
            .where((room) => room.transactionId == transaction.transactionId)
            .firstOrNull;

        if (newRoom == null) {
          if (context.mounted) {
            CustomToast.show(
              context,
              s.chat_failed_load_room,
              type: ToastType.error,
            );
          }
          return;
        }

        // Navigate to the newly created chat room
        if (context.mounted) {
          CustomToast.show(
            context,
            s.chat_room_created_success,
            type: ToastType.success,
          );

          context.push(
            '/chat-detail',
            extra: {
              'transactionId': transaction.transactionId,
              'chatRoomId': newRoom.chatRoomId,
              'partnerName': newRoom.partnerName,
              'partnerAvatar': newRoom.partnerAvatar,
            },
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        final s = S.of(context)!;
        CustomToast.show(
          context,
          '${s.error_occurred}: ${e.toString()}',
          type: ToastType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final s = S.of(context)!;
    final space = theme.extension<AppSpacing>()!.screenPadding;
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(space),
      color: theme.primaryColor,
      child: InkWell(
        onTap: () => _openChat(context, ref),
        borderRadius: BorderRadius.circular(space),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: space,
            vertical: space * 0.75,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(space),
            gradient: LinearGradient(
              colors: [
                theme.primaryColor,
                theme.primaryColor.withValues(alpha: 0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.chat_bubble_rounded,
                color: theme.scaffoldBackgroundColor,
                size: 20,
              ),
              SizedBox(width: space * 0.5),
              Text(
                s.message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.scaffoldBackgroundColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
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
        return theme.primaryColor;
      case TransactionStatus.canceledBySystem:
      case TransactionStatus.canceledByUser:
        return AppColors.danger;
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!.screenPadding;
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: spacing * 24, // 280 / 16 = 17.5
      child: Container(
        decoration: BoxDecoration(
          color: _getStatusColor(context).withValues(alpha: 0.8),
        ),
      ),
    );
  }
}

/// Loading state widget
class _LoadingState extends StatelessWidget {
  const _LoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!.screenPadding;
    final s = S.of(context)!;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
            ),
            SizedBox(height: spacing),
            Text(
              s.loading,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Error state widget
class _TransactionErrorState extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;
  final VoidCallback onBack;

  const _TransactionErrorState({
    super.key,
    required this.errorMessage,
    required this.onRetry,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!.screenPadding;
    final s = S.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
        title: Text(s.transaction_detail),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(spacing * 1.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.danger,
              ),
              SizedBox(height: spacing),
              Text(
                errorMessage,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.hintColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacing * 1.5),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(s.retry),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: theme.scaffoldBackgroundColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
