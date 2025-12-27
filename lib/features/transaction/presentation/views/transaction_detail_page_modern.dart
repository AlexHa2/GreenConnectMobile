import 'package:GreenConnectMobile/core/di/profile_injector.dart';
import 'package:GreenConnectMobile/core/enum/role.dart';
import 'package:GreenConnectMobile/core/enum/transaction_status.dart';
import 'package:GreenConnectMobile/core/network/token_storage.dart';
import 'package:GreenConnectMobile/features/message/presentation/providers/message_providers.dart';
import 'package:GreenConnectMobile/features/offer/domain/entities/collection_offer_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/household_entity.dart'
    as post_entity;
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_category_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/transaction_entity.dart'
    as post_entity;
import 'package:GreenConnectMobile/features/post/presentation/providers/scrap_post_providers.dart';
import 'package:GreenConnectMobile/features/profile/domain/entities/user_entity.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_detail_entity.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/providers/transaction_providers.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_detail/transaction_detail_app_bar.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_detail/transaction_detail_bottom_actions.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_detail/transaction_detail_content.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TransactionDetailPageModern extends ConsumerStatefulWidget {
  // Transaction ID (optional - để tìm transaction trong list)
  final String? transactionId;

  // Required params for post transactions (luôn có khi navigate đến route này)
  final String? postId;
  final String? collectorId;
  final String? slotId;

  const TransactionDetailPageModern({
    super.key,
    this.transactionId,
    this.postId,
    this.collectorId,
    this.slotId,
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

  // State for post transactions
  post_entity.PostTransactionsResponseEntity? _transactionsData;
  double _amountDifference = 0.0;
  bool _isLoadingTransactions = false;

  // Store transaction data (from list or loaded)
  TransactionEntity? _currentTransaction;

  // Index of current transaction in the list (for switching)
  int _currentTransactionIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserRole();

      // LUÔN gọi fetchPostTransactions() vì params postId, collectorId, slotId luôn có
      // Data sẽ được load từ API, không dùng transactionData
      if (widget.postId != null &&
          widget.postId!.isNotEmpty &&
          widget.collectorId != null &&
          widget.collectorId!.isNotEmpty &&
          widget.slotId != null &&
          widget.slotId!.isNotEmpty) {
        _loadPostTransactions(
          postId: widget.postId!,
          collectorId: widget.collectorId!,
          slotId: widget.slotId!,
        );
      }
    });
  }

  /// Convert post_entity.TransactionEntity to transaction_entity.TransactionEntity
  TransactionEntity _convertPostTransactionToTransaction(
    post_entity.TransactionEntity postTransaction,
  ) {
    // Convert HouseholdEntity to UserEntity
    UserEntity convertHouseholdToUser(post_entity.HouseholdEntity? household) {
      if (household == null) {
        return UserEntity(
          userId: '',
          fullName: '',
          phoneNumber: '',
          pointBalance: 0,
          rank: '',
          roles: [],
        );
      }
      return UserEntity(
        userId: household.id,
        fullName: household.fullName,
        phoneNumber: household.phoneNumber,
        pointBalance: household.pointBalance,
        creditBalance: household.creditBalance,
        rank: household.rank,
        roles: household.roles,
        avatarUrl: household.avatarUrl,
      );
    }

    // Convert TransactionDetailEntity
    List<TransactionDetailEntity> convertDetails(
      List<post_entity.TransactionDetailEntity> details,
    ) {
      // Note: This method doesn't have access to context, so we use a default value
      // The category name will be localized when displayed in UI
      return details.map((detail) {
        // Create default ScrapCategoryEntity if null
        // Note: transaction domain uses different ScrapCategoryEntity structure
        final category = detail.scrapCategory != null
            ? ScrapCategoryEntity(
                scrapCategoryId: detail.scrapCategory!.id,
                categoryName: detail.scrapCategory!.name,
                description: null,
              )
            : ScrapCategoryEntity(
                scrapCategoryId: detail.scrapCategoryId,
                categoryName: '', // Will be localized when displayed
                description: null,
              );

        return TransactionDetailEntity(
          transactionId: detail.transactionId,
          scrapCategoryId: detail.scrapCategoryId,
          scrapCategory: category,
          pricePerUnit: detail.pricePerUnit,
          unit: detail.unit,
          quantity: detail.quantity,
          finalPrice: detail.finalPrice,
        );
      }).toList();
    }

    return TransactionEntity(
      transactionId: postTransaction.transactionId,
      householdId: postTransaction.householdId,
      household: convertHouseholdToUser(postTransaction.household),
      scrapCollectorId: postTransaction.scrapCollectorId,
      scrapCollector: convertHouseholdToUser(postTransaction.scrapCollector),
      offerId: postTransaction.offerId,
      offer: postTransaction.offer != null
          ? CollectionOfferEntity(
              collectionOfferId: postTransaction.offer!.collectionOfferId,
              scrapPostId: postTransaction.offer!.scrapPostId,
              scrapPost: postTransaction.offer!.scrapPost,
              status: postTransaction.offer!.status,
              createdAt: postTransaction.offer!.createdAt,
              offerDetails: postTransaction.offer!.offerDetails,
              scheduleProposals: const [], // Not available in post entity
              timeSlotId: postTransaction.offer!.timeSlotId,
              timeSlot: postTransaction.offer!.timeSlot,
            )
          : null,
      status: postTransaction.status,
      scheduledTime: postTransaction.scheduledTime,
      checkInTime: postTransaction.checkInTime,
      createdAt: postTransaction.createdAt,
      updatedAt: postTransaction.updatedAt,
      transactionDetails: convertDetails(postTransaction.transactionDetails),
      totalPrice: postTransaction.totalPrice,
      timeSlotId: postTransaction.timeSlotId,
      timeSlot: postTransaction.timeSlot,
    );
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

  Future<void> _loadPostTransactions({
    required String postId,
    required String collectorId,
    required String slotId,
  }) async {
    if (mounted) {
      setState(() {
        _isLoadingTransactions = true;
      });
    }

    try {
      await ref.read(scrapPostViewModelProvider.notifier).fetchPostTransactions(
            postId: postId,
            collectorId: collectorId,
            slotId: slotId,
          );

      if (mounted) {
        final state = ref.read(scrapPostViewModelProvider);
        setState(() {
          _transactionsData = state.transactionsData;
          _amountDifference = state.transactionsData?.amountDifference ?? 0.0;
          _isLoadingTransactions = false;

          // ALWAYS update current transaction from _loadPostTransactions data
          // This ensures UI always shows data from API, not from passed transactionData
          if (state.transactionsData != null &&
              state.transactionsData!.transactions.isNotEmpty) {
            final currentTransactionId =
                widget.transactionId ?? _currentTransaction?.transactionId;

            int? selectedIndex;

            if (currentTransactionId != null) {
              // Find current transaction in the list
              final foundIndex = state.transactionsData!.transactions
                  .indexWhere((t) => t.transactionId == currentTransactionId);

              if (foundIndex >= 0) {
                selectedIndex = foundIndex;
              }
            }

            // If no specific transaction found or no transactionId provided,
            // try to find the best transaction to display:
            // Priority 1: Transaction WITHOUT transactionDetails (needs data input) - for collector
            // Priority 2: Transaction with transactionDetails (has data entered)
            // Priority 3: First transaction
            if (selectedIndex == null) {
              // Find transaction WITHOUT transactionDetails first (needs input)
              final transactionWithoutDetailsIndex = state
                  .transactionsData!.transactions
                  .indexWhere((t) => t.transactionDetails.isEmpty);

              if (transactionWithoutDetailsIndex >= 0) {
                selectedIndex = transactionWithoutDetailsIndex;
              } else {
                // If all transactions have details, find one with details
                final transactionWithDetailsIndex = state
                    .transactionsData!.transactions
                    .indexWhere((t) => t.transactionDetails.isNotEmpty);

                if (transactionWithDetailsIndex >= 0) {
                  selectedIndex = transactionWithDetailsIndex;
                } else {
                  // Fallback: use first one
                  selectedIndex = 0;
                }
              }
            }

            // ALWAYS use data from _loadPostTransactions (API)
            if (selectedIndex >= 0 &&
                selectedIndex < state.transactionsData!.transactions.length) {
              _currentTransaction = _convertPostTransactionToTransaction(
                state.transactionsData!.transactions[selectedIndex],
              );
              _currentTransactionIndex = selectedIndex;
            }
          }
        });
      }
    } catch (e) {
      debugPrint('❌ ERROR LOAD POST TRANSACTIONS: $e');
      if (mounted) {
        setState(() {
          _isLoadingTransactions = false;
          // Fallback: use totalPrice if cannot load
          _amountDifference = 0.0;
        });
      }
    }
  }

  Future<void> _onRefresh() async {
    // Reload post transactions (params luôn có)
    if (widget.postId != null &&
        widget.postId!.isNotEmpty &&
        widget.collectorId != null &&
        widget.collectorId!.isNotEmpty &&
        widget.slotId != null &&
        widget.slotId!.isNotEmpty) {
      await _loadPostTransactions(
        postId: widget.postId!,
        collectorId: widget.collectorId!,
        slotId: widget.slotId!,
      );
    }
  }

  void _onActionCompleted() {
    setState(() => _hasChanges = true);

    // Check current status before reload to detect status changes
    final currentStatus = _currentTransaction?.statusEnum;

    // Reload post transactions to get updated status (params luôn có)
    if (widget.postId != null &&
        widget.postId!.isNotEmpty &&
        widget.collectorId != null &&
        widget.collectorId!.isNotEmpty &&
        widget.slotId != null &&
        widget.slotId!.isNotEmpty) {
      _loadPostTransactions(
        postId: widget.postId!,
        collectorId: widget.collectorId!,
        slotId: widget.slotId!,
      ).then((_) {
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
          final statusChanged =
              currentStatus != null && currentStatus != status;
          final isFinalState = status == TransactionStatus.completed ||
              status == TransactionStatus.canceledByUser ||
              status == TransactionStatus.canceledBySystem;

          if (isFinalState ||
              (statusChanged &&
                  currentStatus == TransactionStatus.inProgress)) {
            // Navigate back to transaction list page
            _navigateToTransactionList();
          }
          // If status is still inProgress, stay on detail page (e.g., after input details)
        }
      });
    }
  }

  void _navigateToTransactionList() {
    if (!mounted) return;

    // Try to pop first (if we came from list page)
    if (context.canPop()) {
      context.pop(true); // Return with changes flag
    } else {
      // If can't pop, navigate to the correct list page based on user role
      String targetRoute;
      if (_userRole == Role.household) {
        targetRoute = '/household-list-transactions';
      } else if (_userRole == Role.individualCollector ||
          _userRole == Role.businessCollector) {
        targetRoute = '/collector-list-transactions';
      } else {
        // Fallback: if role is not set, don't navigate
        debugPrint(
            '⚠️ WARNING: User role not set, cannot navigate to transaction list');
        return;
      }

      // Use pushReplacement or go to ensure we navigate correctly
      if (mounted) {
        context.go(targetRoute);
      }
    }
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
    // Use transaction from list if available, otherwise show error
    if (_currentTransaction == null) {
      return _TransactionErrorState(
        key: const ValueKey('error'),
        onRetry: () {
          // If transaction is null, we can't retry without transactionId
          // This should not happen if called from list
          _onBack();
        },
        onBack: _onBack,
      );
    }

    return _TransactionDetailContent(
      key: const ValueKey('content'),
      transaction: _currentTransaction!,
      userRole: _userRole,
      amountDifference: _amountDifference,
      isLoadingTransactions: _isLoadingTransactions,
      transactionsData: _transactionsData,
      currentTransactionIndex: _currentTransactionIndex,
      onTransactionChanged: (index) {
        if (_transactionsData != null &&
            index >= 0 &&
            index < _transactionsData!.transactions.length) {
          setState(() {
            _currentTransaction = _convertPostTransactionToTransaction(
              _transactionsData!.transactions[index],
            );
            _currentTransactionIndex = index;
          });
        }
      },
      convertPostTransactionToTransaction:
          _transactionsData != null && _transactionsData!.transactions.isNotEmpty
              ? (post_entity.TransactionEntity postTransaction) =>
                  _convertPostTransactionToTransaction(postTransaction)
              : null,
      onRefresh: _onRefresh,
      onActionCompleted: _onActionCompleted,
      onBack: _onBack,
    );
  }
}

/// Main content widget for transaction detail
class _TransactionDetailContent extends StatefulWidget {
  final TransactionEntity transaction;
  final Role userRole;
  final double amountDifference;
  final bool isLoadingTransactions;
  final post_entity.PostTransactionsResponseEntity? transactionsData;
  final int currentTransactionIndex;
  final ValueChanged<int>? onTransactionChanged;
  final TransactionEntity Function(post_entity.TransactionEntity)? convertPostTransactionToTransaction;
  final VoidCallback onRefresh;
  final VoidCallback onActionCompleted;
  final VoidCallback onBack;

  const _TransactionDetailContent({
    super.key,
    required this.transaction,
    required this.userRole,
    required this.amountDifference,
    required this.isLoadingTransactions,
    this.transactionsData,
    this.currentTransactionIndex = 0,
    this.onTransactionChanged,
    this.convertPostTransactionToTransaction,
    required this.onRefresh,
    required this.onActionCompleted,
    required this.onBack,
  });

  @override
  State<_TransactionDetailContent> createState() => _TransactionDetailContentState();
}

class _TransactionDetailContentState extends State<_TransactionDetailContent> {
  late TransactionEntity _currentTransaction;

  @override
  void initState() {
    super.initState();
    _currentTransaction = widget.transaction;
  }

  @override
  void didUpdateWidget(_TransactionDetailContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.transaction.transactionId != widget.transaction.transactionId ||
        oldWidget.currentTransactionIndex != widget.currentTransactionIndex) {
      _currentTransaction = widget.transaction;
    }
  }

  void _handleTransactionChanged(int index) {
    widget.onTransactionChanged?.call(index);
    // Update local state immediately for smooth UI update
    if (widget.transactionsData != null &&
        index >= 0 &&
        index < widget.transactionsData!.transactions.length &&
        widget.convertPostTransactionToTransaction != null) {
      setState(() {
        _currentTransaction = widget.convertPostTransactionToTransaction!(
          widget.transactionsData!.transactions[index],
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!.screenPadding;
    // final s = S.of(context)!;

    return Stack(
      children: [
        // Background gradient - use current transaction status
        _TransactionBackgroundGradient(status: _currentTransaction.statusEnum),

        // Main content
        Positioned.fill(
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Top app bar
                TransactionDetailAppBar(onBack: widget.onBack, onRefresh: widget.onRefresh),

                // Scrollable content
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async => widget.onRefresh(),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        spacing,
                        0,
                        spacing,
                        spacing *
                            12, // Increased to allow scrolling above floating chat button
                      ),
                      child: TransactionDetailContentBody(
                        transaction: _currentTransaction,
                        userRole: widget.userRole,
                        transactionsData: widget.transactionsData,
                        isLoadingTransactions: widget.isLoadingTransactions,
                        currentTransactionIndex: widget.currentTransactionIndex,
                        onTransactionChanged: _handleTransactionChanged,
                        convertPostTransactionToTransaction:
                            widget.convertPostTransactionToTransaction,
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
            transaction: _currentTransaction,
            userRole: widget.userRole,
            amountDifference: widget.amountDifference,
            onActionCompleted: widget.onActionCompleted,
            transactionsData: widget.transactionsData,
          ),
        ),

        // Floating chat button
        Positioned(
          right: spacing,
          bottom: spacing * 6.5,
          child: _ChatFloatingButton(
            transaction: _currentTransaction,
            userRole: widget.userRole,
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
