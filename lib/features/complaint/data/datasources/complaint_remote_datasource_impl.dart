import 'package:GreenConnectMobile/core/di/injector.dart';
import 'package:GreenConnectMobile/core/network/api_client.dart';
import 'package:GreenConnectMobile/features/complaint/data/datasources/complaint_remote_datasource.dart';
import 'package:GreenConnectMobile/features/complaint/data/models/complaint_list_response_model.dart';
import 'package:GreenConnectMobile/features/complaint/data/models/complaint_model.dart';
import 'package:GreenConnectMobile/features/complaint/domain/entities/create_complaint_request.dart';
import 'package:GreenConnectMobile/features/complaint/domain/entities/update_complaint_request.dart';

class ComplaintRemoteDatasourceImpl implements ComplaintRemoteDatasource {
  final ApiClient _apiClient = sl<ApiClient>();
  static const String _complaintsBaseUrl = '/v1/complaints';

  @override
  Future<ComplaintListResponseModel> getAllComplaints({
    int? pageNumber,
    int? pageSize,
    bool? sortByCreatedAt,
    String? sortByStatus,
  }) async {
    final Map<String, dynamic> queryParams = {};
    if (pageNumber != null) {
      queryParams['pageNumber'] = pageNumber;
    }
    if (pageSize != null) {
      queryParams['pageSize'] = pageSize;
    }
    if (sortByCreatedAt != null) {
      queryParams['sortByCreatedAt'] = sortByCreatedAt;
    }
    if (sortByStatus != null) {
      queryParams['sortByStatus'] = sortByStatus;
    }

    final queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');

    final url = queryString.isEmpty
        ? _complaintsBaseUrl
        : '$_complaintsBaseUrl?$queryString';

    final res = await _apiClient.get(url);
    return ComplaintListResponseModel.fromJson(res.data);
  }

  @override
  Future<ComplaintModel> getComplaintDetail(String complaintId) async {
    final res = await _apiClient.get('$_complaintsBaseUrl/$complaintId');
    return ComplaintModel.fromJson(res.data);
  }

  @override
  Future<ComplaintModel> createComplaint(
      CreateComplaintRequest request) async {
    final res = await _apiClient.post(
      _complaintsBaseUrl,
      data: request.toJson(),
    );
    return ComplaintModel.fromJson(res.data);
  }

  @override
  Future<ComplaintModel> updateComplaint({
    required String complaintId,
    required UpdateComplaintRequest request,
  }) async {
    final queryParams = request.toQueryParams();
    final queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    final url = '$_complaintsBaseUrl/$complaintId?$queryString';

    final res = await _apiClient.patch(url);
    return ComplaintModel.fromJson(res.data);
  }

  @override
  Future<bool> processComplaint({
    required String complaintId,
    required bool isAccept,
  }) async {
    final res = await _apiClient.patch(
      '$_complaintsBaseUrl/$complaintId/process?isAccept=$isAccept',
    );
    return res.statusCode == 200;
  }

  @override
  Future<ComplaintModel> reopenComplaint(String complaintId) async {
    final res =
        await _apiClient.patch('$_complaintsBaseUrl/$complaintId/reopen');
    return ComplaintModel.fromJson(res.data);
  }
}
