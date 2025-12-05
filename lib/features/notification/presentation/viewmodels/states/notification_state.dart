import 'package:GreenConnectMobile/features/notification/domain/entities/paginated_notification_entity.dart';

class NotificationState {
  final bool isLoading;
  final bool isRegistering;
  final bool isMarkingRead;
  final String? errorMessage;
  final PaginatedNotificationEntity? notifications;
  final int currentPage;
  final int pageSize;

  NotificationState({
    this.isLoading = false,
    this.isRegistering = false,
    this.isMarkingRead = false,
    this.errorMessage,
    this.notifications,
    this.currentPage = 1,
    this.pageSize = 20,
  });

  NotificationState copyWith({
    bool? isLoading,
    bool? isRegistering,
    bool? isMarkingRead,
    String? errorMessage,
    PaginatedNotificationEntity? notifications,
    int? currentPage,
    int? pageSize,
  }) {
    return NotificationState(
      isLoading: isLoading ?? this.isLoading,
      isRegistering: isRegistering ?? this.isRegistering,
      isMarkingRead: isMarkingRead ?? this.isMarkingRead,
      errorMessage: errorMessage,
      notifications: notifications ?? this.notifications,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  bool get hasNotifications =>
      notifications != null && notifications!.notifications.isNotEmpty;
  bool get hasNextPage => notifications?.hasNextPage ?? false;
  bool get hasPrevPage => notifications?.hasPrevPage ?? false;
  int get unreadCount =>
      notifications?.notifications.where((n) => !n.isRead).length ?? 0;
}
