import 'package:GreenConnectMobile/features/complaint/data/datasources/complaint_remote_datasource.dart';
import 'package:GreenConnectMobile/features/complaint/domain/entities/complaint_entity.dart';
import 'package:GreenConnectMobile/features/complaint/domain/entities/complaint_list_response.dart';
import 'package:GreenConnectMobile/features/complaint/domain/entities/create_complaint_request.dart';
import 'package:GreenConnectMobile/features/complaint/domain/entities/update_complaint_request.dart';
import 'package:GreenConnectMobile/features/complaint/domain/repositories/complaint_repository.dart';

class ComplaintRepositoryImpl implements ComplaintRepository {
  final ComplaintRemoteDatasource _remoteDatasource;

  ComplaintRepositoryImpl(this._remoteDatasource);

  @override
  Future<ComplaintListResponse> getAllComplaints({
    int? pageNumber,
    int? pageSize,
    bool? sortByCreatedAt,
    String? sortByStatus,
  }) async {
    final model = await _remoteDatasource.getAllComplaints(
      pageNumber: pageNumber,
      pageSize: pageSize,
      sortByCreatedAt: sortByCreatedAt,
      sortByStatus: sortByStatus,
    );
    return model.toEntity();
  }

  @override
  Future<ComplaintEntity> getComplaintDetail(String complaintId) async {
    final model = await _remoteDatasource.getComplaintDetail(complaintId);
    return model.toEntity();
  }

  @override
  Future<ComplaintEntity> createComplaint(
      CreateComplaintRequest request,) async {
    final model = await _remoteDatasource.createComplaint(request);
    return model.toEntity();
  }

  @override
  Future<ComplaintEntity> updateComplaint({
    required String complaintId,
    required UpdateComplaintRequest request,
  }) async {
    final model = await _remoteDatasource.updateComplaint(
      complaintId: complaintId,
      request: request,
    );
    return model.toEntity();
  }

  @override
  Future<bool> processComplaint({
    required String complaintId,
    required bool isAccept,
  }) async {
    return await _remoteDatasource.processComplaint(
      complaintId: complaintId,
      isAccept: isAccept,
    );
  }

  @override
  Future<ComplaintEntity> reopenComplaint(String complaintId) async {
    final model = await _remoteDatasource.reopenComplaint(complaintId);
    return model.toEntity();
  }
}
