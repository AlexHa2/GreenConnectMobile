import 'package:GreenConnectMobile/features/complaint/data/models/complaint_list_response_model.dart';
import 'package:GreenConnectMobile/features/complaint/data/models/complaint_model.dart';
import 'package:GreenConnectMobile/features/complaint/domain/entities/create_complaint_request.dart';
import 'package:GreenConnectMobile/features/complaint/domain/entities/update_complaint_request.dart';

abstract class ComplaintRemoteDatasource {
  /// GET /v1/complaints?pageNumber={page}&pageSize={size}&sortByCreatedAt={bool}&sortByStatus={status}
  Future<ComplaintListResponseModel> getAllComplaints({
    int? pageNumber,
    int? pageSize,
    bool? sortByCreatedAt,
    String? sortByStatus,
  });

  /// GET /v1/complaints/{id}
  Future<ComplaintModel> getComplaintDetail(String complaintId);

  /// POST /v1/complaints
  Future<ComplaintModel> createComplaint(CreateComplaintRequest request);

  /// PATCH /v1/complaints/{id}?reason={reason}&evidenceUrl={url}
  Future<ComplaintModel> updateComplaint({
    required String complaintId,
    required UpdateComplaintRequest request,
  });

  /// PATCH /v1/complaints/{id}/process?isAccept={bool}
  Future<bool> processComplaint({
    required String complaintId,
    required bool isAccept,
  });

  /// PATCH /v1/complaints/{id}/reopen
  Future<ComplaintModel> reopenComplaint(String complaintId);
}
