import 'package:GreenConnectMobile/features/complaint/domain/repositories/complaint_repository.dart';

class ProcessComplaintUsecase {
  final ComplaintRepository _repository;

  ProcessComplaintUsecase(this._repository);

  Future<bool> call({
    required String complaintId,
    required bool isAccept,
  }) async {
    return await _repository.processComplaint(
      complaintId: complaintId,
      isAccept: isAccept,
    );
  }
}
