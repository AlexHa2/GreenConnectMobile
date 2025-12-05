import 'package:GreenConnectMobile/core/error/failure.dart';
import 'package:GreenConnectMobile/features/notification/domain/usecases/get_notifications_usecase.dart';
import 'package:GreenConnectMobile/features/notification/domain/usecases/mark_notification_as_read_usecase.dart';
import 'package:GreenConnectMobile/features/notification/domain/usecases/register_device_token_usecase.dart';
import 'package:GreenConnectMobile/features/notification/presentation/providers/notification_providers.dart';
import 'package:GreenConnectMobile/features/notification/presentation/viewmodels/states/notification_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationViewModel extends Notifier<NotificationState> {
  late RegisterDeviceTokenUsecase _registerToken;
  late GetNotificationsUsecase _getNotifications;
  late MarkNotificationAsReadUsecase _markAsRead;

  @override
  NotificationState build() {
    _registerToken = ref.read(registerDeviceTokenUsecaseProvider);
    _getNotifications = ref.read(getNotificationsUsecaseProvider);
    _markAsRead = ref.read(markNotificationAsReadUsecaseProvider);
    return NotificationState();
  }

  /// Register device token for push notifications
  Future<bool> registerDeviceToken(String deviceToken) async {
    state = state.copyWith(isRegistering: true, errorMessage: null);

    try {
      final success = await _registerToken(deviceToken);
      state = state.copyWith(isRegistering: false);
      return success;
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR REGISTER TOKEN: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(isRegistering: false, errorMessage: e.toString());
      return false;
    }
  }

  /// Fetch notifications with pagination
  Future<void> fetchNotifications({
    int? page,
    int? size,
    bool loadMore = false,
  }) async {
    final targetPage = page ?? state.currentPage;
    final targetSize = size ?? state.pageSize;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final result = await _getNotifications(
        pageNumber: targetPage,
        pageSize: targetSize,
      );

      state = state.copyWith(
        isLoading: false,
        notifications: result,
        currentPage: targetPage,
        pageSize: targetSize,
      );
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR FETCH NOTIFICATIONS: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Load next page of notifications
  Future<void> loadNextPage() async {
    if (!state.hasNextPage || state.isLoading) return;
    await fetchNotifications(page: state.notifications!.nextPage!);
  }

  /// Refresh notifications (reload first page)
  Future<void> refreshNotifications() async {
    await fetchNotifications(page: 1);
  }

  /// Mark a notification as read
  Future<bool> markNotificationAsRead(String notificationId) async {
    state = state.copyWith(isMarkingRead: true, errorMessage: null);

    try {
      final success = await _markAsRead(notificationId);

      if (success && state.notifications != null) {
        await refreshNotifications();
      }

      state = state.copyWith(isMarkingRead: false);
      return success;
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR MARK AS READ: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(isMarkingRead: false, errorMessage: e.toString());
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
