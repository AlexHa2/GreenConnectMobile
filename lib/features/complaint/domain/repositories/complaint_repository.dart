import 'package:GreenConnectMobile/features/complaint/domain/entities/complaint_entity.dart';
import 'package:GreenConnectMobile/features/complaint/domain/entities/complaint_list_response.dart';
import 'package:GreenConnectMobile/features/complaint/domain/entities/create_complaint_request.dart';
import 'package:GreenConnectMobile/features/complaint/domain/entities/update_complaint_request.dart';

abstract class ComplaintRepository {
  Future<ComplaintListResponse> getAllComplaints({
    int? pageNumber,
    int? pageSize,
    bool? sortByCreatedAt,
    String? sortByStatus,
  });

  Future<ComplaintEntity> getComplaintDetail(String complaintId);

  Future<ComplaintEntity> createComplaint(CreateComplaintRequest request);

  Future<ComplaintEntity> updateComplaint({
    required String complaintId,
    required UpdateComplaintRequest request,
  });

  Future<bool> processComplaint({
    required String complaintId,
    required bool isAccept,
  });

  Future<ComplaintEntity> reopenComplaint(String complaintId);
}
