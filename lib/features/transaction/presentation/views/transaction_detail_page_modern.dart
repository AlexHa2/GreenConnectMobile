import 'package:GreenConnectMobile/core/di/profile_injector.dart';
import 'package:GreenConnectMobile/core/enum/role.dart';
import 'package:GreenConnectMobile/core/enum/transaction_status.dart';
import 'package:GreenConnectMobile/core/network/token_storage.dart';
import 'package:GreenConnectMobile/features/message/presentation/providers/message_providers.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/providers/transaction_providers.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_detail/transaction_detail_app_bar.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_detail/transaction_detail_bottom_actions.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_detail/transaction_detail_content.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_leaf_loading.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TransactionDetailPageModern extends ConsumerStatefulWidget {
  final String transactionId;

  const TransactionDetailPageModern({super.key, required this.transactionId});

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

  Widget _buildBody(dynamic state, ThemeData theme, AppSpacing spacing, S s) {
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

        // Floating chat button
        Positioned(
          right: 16,
          bottom: 100,
          child: _ChatFloatingButton(
            transaction: transaction,
            userRole: userRole,
          ),
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

        // Send initial "Hello" message to create chat room
        final success = await ref
            .read(messageViewModelProvider.notifier)
            .sendMessageWithTransaction(
              transactionId: transaction.transactionId,
              content: 'Hello! 👋',
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
        CustomToast.show(
          context,
          'Error: ${e.toString()}',
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              const SizedBox(width: 8),
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

    return Center(child: Text(s.login_error, style: theme.textTheme.bodyLarge));
  }
}
