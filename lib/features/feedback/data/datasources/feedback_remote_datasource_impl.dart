import 'package:GreenConnectMobile/core/di/injector.dart';
import 'package:GreenConnectMobile/core/network/api_client.dart';
import 'package:GreenConnectMobile/features/feedback/data/datasources/feedback_remote_datasource.dart';
import 'package:GreenConnectMobile/features/feedback/data/models/feedback_list_response_model.dart';
import 'package:GreenConnectMobile/features/feedback/data/models/feedback_model.dart';
import 'package:GreenConnectMobile/features/feedback/domain/entities/create_feedback_request.dart';
import 'package:GreenConnectMobile/features/feedback/domain/entities/update_feedback_request.dart';

class FeedbackRemoteDataSourceImpl implements FeedbackRemoteDataSource {
  final ApiClient _apiClient = sl<ApiClient>();
  static const String _feedbacksBaseUrl = '/v1/feedbacks';

  @override
  Future<FeedbackListResponseModel> getMyFeedbacks({
    required int pageNumber,
    required int pageSize,
    bool? sortByCreatAt,
  }) async {
    final queryParams = <String, dynamic>{
      'pageNumber': pageNumber,
      'pageSize': pageSize,
    };

    if (sortByCreatAt != null) {
      queryParams['sortByCreatAt'] = sortByCreatAt;
    }

    final queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');

    final res =
        await _apiClient.get('$_feedbacksBaseUrl/my-feedbacks?$queryString');
    return FeedbackListResponseModel.fromJson(res.data);
  }

  @override
  Future<FeedbackModel> getFeedbackDetail(String feedbackId) async {
    final res = await _apiClient.get('$_feedbacksBaseUrl/$feedbackId');
    return FeedbackModel.fromJson(res.data);
  }

  @override
  Future<FeedbackModel> createFeedback(CreateFeedbackRequest request) async {
    final res = await _apiClient.post(
      _feedbacksBaseUrl,
      data: request.toJson(),
    );
    return FeedbackModel.fromJson(res.data);
  }

  @override
  Future<FeedbackModel> updateFeedback({
    required String feedbackId,
    required UpdateFeedbackRequest request,
  }) async {
    final queryParams = request.toQueryParams();
    final queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');

    final res = await _apiClient.patch(
      '$_feedbacksBaseUrl/$feedbackId?$queryString',
    );
    return FeedbackModel.fromJson(res.data);
  }

  @override
  Future<bool> deleteFeedback(String feedbackId) async {
    final res = await _apiClient.delete('$_feedbacksBaseUrl/$feedbackId');
    return res.statusCode == 200;
  }
}
