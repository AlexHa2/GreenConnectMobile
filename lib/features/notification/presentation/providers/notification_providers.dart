import 'package:GreenConnectMobile/features/notification/data/datasources/abstract_datasources/notification_remote_datasource.dart';
import 'package:GreenConnectMobile/features/notification/data/datasources/notification_remote_datasource_impl.dart';
import 'package:GreenConnectMobile/features/notification/data/repository/notification_repository_impl.dart';
import 'package:GreenConnectMobile/features/notification/domain/repository/notification_repository.dart';
import 'package:GreenConnectMobile/features/notification/domain/usecases/get_notifications_usecase.dart';
import 'package:GreenConnectMobile/features/notification/domain/usecases/mark_notification_as_read_usecase.dart';
import 'package:GreenConnectMobile/features/notification/domain/usecases/register_device_token_usecase.dart';
import 'package:GreenConnectMobile/features/notification/presentation/viewmodels/notification_view_model.dart';
import 'package:GreenConnectMobile/features/notification/presentation/viewmodels/states/notification_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ==================
///  Remote DataSource
/// ==================
final notificationRemoteDsProvider = Provider<NotificationRemoteDataSource>((
  ref,
) {
  return NotificationRemoteDataSourceImpl();
});

/// =============
///  Repository
/// =============
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final ds = ref.read(notificationRemoteDsProvider);
  return NotificationRepositoryImpl(ds);
});

/// =============
///  UseCases
/// =============

// Register device token
final registerDeviceTokenUsecaseProvider = Provider<RegisterDeviceTokenUsecase>(
  (ref) {
    return RegisterDeviceTokenUsecase(ref.read(notificationRepositoryProvider));
  },
);

// Get notifications
final getNotificationsUsecaseProvider = Provider<GetNotificationsUsecase>((
  ref,
) {
  return GetNotificationsUsecase(ref.read(notificationRepositoryProvider));
});

// Mark notification as read
final markNotificationAsReadUsecaseProvider =
    Provider<MarkNotificationAsReadUsecase>((ref) {
      return MarkNotificationAsReadUsecase(
        ref.read(notificationRepositoryProvider),
      );
    });

/// =============
///  ViewModel
/// =============
final notificationViewModelProvider =
    NotifierProvider<NotificationViewModel, NotificationState>(
      () => NotificationViewModel(),
    );
