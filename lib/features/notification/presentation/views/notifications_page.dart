import 'package:GreenConnectMobile/core/di/injector.dart';
import 'package:GreenConnectMobile/core/enum/role.dart';
import 'package:GreenConnectMobile/core/network/token_storage.dart';
import 'package:GreenConnectMobile/features/notification/presentation/providers/notification_providers.dart';
import 'package:GreenConnectMobile/features/notification/presentation/viewmodels/states/notification_state.dart';
import 'package:GreenConnectMobile/features/notification/presentation/views/widgets/notification_item.dart';
import 'package:GreenConnectMobile/features/profile/data/models/user_model.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  final ScrollController _scrollController = ScrollController();
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    // Load user and notifications when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUser();
      ref.read(notificationViewModelProvider.notifier).fetchNotifications();
    });

    // Setup infinite scroll
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadUser() async {
    final tokenStorage = sl<TokenStorageService>();
    final user = await tokenStorage.getUserData();
    if (mounted) {
      setState(() {
        _currentUser = user;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      final viewModel = ref.read(notificationViewModelProvider.notifier);
      final state = ref.read(notificationViewModelProvider);
      if (state.hasNextPage && !state.isLoading) {
        viewModel.loadNextPage();
      }
    }
  }

  Future<void> _onRefresh() async {
    final viewModel = ref.read(notificationViewModelProvider.notifier);
    await viewModel.refreshNotifications();

    if (mounted) {
      final state = ref.read(notificationViewModelProvider);
      if (state.errorMessage == null) {
        CustomToast.show(
          context,
          S.of(context)!.notifications_error,
          type: ToastType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(notificationViewModelProvider);
    final viewModel = ref.read(notificationViewModelProvider.notifier);

    // Listen to error messages and show snackbar
    ref.listen<NotificationState>(notificationViewModelProvider, (
      previous,
      next,
    ) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: theme.colorScheme.error,
            action: SnackBarAction(
              label: 'Dismiss',
              textColor: theme.colorScheme.onError,
              onPressed: () {
                viewModel.clearError();
              },
            ),
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.notifications),
        actions: [
          if (state.unreadCount > 0)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${state.unreadCount} ${S.of(context)!.unread}',
                    style: TextStyle(
                      color: theme.colorScheme.onError,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: state.isLoading
                ? null
                : () => viewModel.refreshNotifications(),
            tooltip: 'Refresh notifications',
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildBody(state, viewModel, theme),
          if (state.isMarkingRead)
            Container(
              color: Colors.black12,
              child: Center(
                child: CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBody(dynamic state, dynamic viewModel, ThemeData theme) {
    if (state.isLoading && !state.hasNotifications) {
      return Center(
        child: CircularProgressIndicator(color: theme.colorScheme.primary),
      );
    }

    if (state.errorMessage != null && !state.hasNotifications) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: theme.colorScheme.error.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'Oops! Something went wrong',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                state.errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => viewModel.fetchNotifications(),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (!state.hasNotifications) {
      return RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 80,
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No notifications yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You\'ll receive notifications here',
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        controller: _scrollController,
        itemCount:
            state.notifications!.notifications.length +
            (state.hasNextPage ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.notifications!.notifications.length) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                ),
              ),
            );
          }

          final notification = state.notifications!.notifications[index];
          return NotificationItem(
            notification: notification,
            onTap: () async {
              // Mark as read if unread
              if (!notification.isRead) {
                final success = await viewModel.markNotificationAsRead(
                  notification.notificationId,
                );
                if (!success && context.mounted) {
                  CustomToast.show(
                    context,
                    S.of(context)!.notifications_mark_read_error,
                    type: ToastType.error,
                  );
                  return;
                }
              }

              // Navigate based on entity type
              if (notification.entityType != null) {
                final entityType = notification.entityType?.toLowerCase();
                // Chat/Message don't need entityId
                if (entityType == 'chat' || entityType == 'message') {
                  _handleNotificationTap(notification);
                } else if (notification.entityId != null) {
                  _handleNotificationTap(notification);
                }
              }
            },
          );
        },
      ),
    );
  }

  void _handleNotificationTap(dynamic notification) {
    final entityType = notification.entityType?.toLowerCase();
    final entityId = notification.entityId;

    if (entityType == null) return;
    
    // Xác định role của user
    final isHousehold = _currentUser != null && 
        Role.hasRole(_currentUser!.roles, Role.household);
    final isCollector = _currentUser != null && 
        (Role.hasRole(_currentUser!.roles, Role.individualCollector) ||
         Role.hasRole(_currentUser!.roles, Role.businessCollector));
    
    switch (entityType) {
      case 'message':
      case 'chat':
        // Check user role to navigate to correct message page
        if (_currentUser != null) {
          if (isHousehold) {
            context.push('/household-list-message');
          } else if (isCollector) {
            context.push('/collector-list-message');
          }
        }
        break;
      case 'post':
        if (entityId == null) return;
        context.push('/detail-post', extra: {
          'postId': entityId,
          'isCollectorView': isCollector,
        });
        break;
      case 'transaction':
        if (entityId == null) return;
        context.push('/transaction-detail', extra: {
          'transactionId': entityId,
        });
        break;
      case 'offer':
        if (entityId == null) return;
        context.push('/offer-detail', extra: {
          'offerId': entityId,
          'isCollectorView': isCollector,
        });
        break;
      case 'feedback':
        if (entityId == null) return;
        context.push('/feedback-detail', extra: {
          'feedbackId': entityId,
        });
        break;
      case 'complaint':
        if (entityId == null) return;
        context.push('/complaint-detail', extra: {
          'complaintId': entityId,
        });
        break;
    }
  }
}
