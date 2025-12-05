import 'package:GreenConnectMobile/core/di/injector.dart';
import 'package:GreenConnectMobile/core/network/api_client.dart';
import 'package:GreenConnectMobile/features/message/data/datasources/message_remote_datasource.dart';
import 'package:GreenConnectMobile/features/message/data/models/message_model.dart';
import 'package:GreenConnectMobile/features/message/data/models/paginated_chat_room_model.dart';
import 'package:GreenConnectMobile/features/message/data/models/paginated_message_model.dart';

class MessageRemoteDataSourceImpl implements MessageRemoteDataSource {
  final ApiClient _apiClient = sl<ApiClient>();
  static const String _baseUrl = '/v1/chat';

  @override
  Future<PaginatedChatRoomModel> getChatRooms({
    String? name,
    required int pageNumber,
    required int pageSize,
  }) async {
    final queryParams = <String, dynamic>{
      'pageNumber': pageNumber,
      'pageSize': pageSize,
    };

    if (name != null && name.isNotEmpty) {
      queryParams['name'] = name;
    }

    final queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');

    final res = await _apiClient.get('$_baseUrl/rooms?$queryString');
    return PaginatedChatRoomModel.fromJson(res.data);
  }

  @override
  Future<PaginatedMessageModel> getMessages({
    required String chatRoomId,
    required int pageNumber,
    required int pageSize,
  }) async {
    final queryParams = <String, dynamic>{
      'pageNumber': pageNumber,
      'pageSize': pageSize,
    };

    final queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');

    final res = await _apiClient.get(
      '$_baseUrl/rooms/$chatRoomId?$queryString',
    );
    return PaginatedMessageModel.fromJson(res.data);
  }

  @override
  Future<MessageModel> sendMessage({
    required String transactionId,
    required String content,
  }) async {
    final res = await _apiClient.post(
      '$_baseUrl/sendMessage',
      data: {'transactionId': transactionId, 'content': content},
    );
    return MessageModel.fromJson(res.data);
  }

  @override
  Future<bool> markChatRoomAsRead(String chatRoomId) async {
    final res = await _apiClient.patch('$_baseUrl/rooms/$chatRoomId/read');
    return res.statusCode == 204 || res.statusCode == 200;
  }
}
