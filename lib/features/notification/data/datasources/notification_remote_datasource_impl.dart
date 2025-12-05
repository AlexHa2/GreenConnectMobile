import 'package:GreenConnectMobile/core/di/auth_injector.dart';
import 'package:GreenConnectMobile/core/network/api_client.dart';
import 'package:GreenConnectMobile/features/notification/data/datasources/abstract_datasources/notification_remote_datasource.dart';
import 'package:GreenConnectMobile/features/notification/data/models/paginated_notification_model.dart';

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiClient _apiClient = sl<ApiClient>();
  final String _baseUrl = '/v1/notifications';

  @override
  Future<bool> registerDeviceToken(String deviceToken) async {
    final res = await _apiClient.post(
      '$_baseUrl/device-token',
      data: {'deviceToken': deviceToken},
    );
    if (res.statusCode == 200) {
      return true;
    }
    return false;
  }

  @override
  Future<PaginatedNotificationModel> getNotifications({
    required int pageNumber,
    required int pageSize,
  }) async {
    final res = await _apiClient.get(
      _baseUrl,
      queryParameters: {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      },
    );
    return PaginatedNotificationModel.fromJson(res.data);
  }

  @override
  Future<bool> markNotificationAsRead(String notificationId) async {
    final res = await _apiClient.patch('$_baseUrl/$notificationId/read');
    if (res.statusCode == 204 || res.statusCode == 200) {
      return true;
    }
    return false;
  }
}
