import 'package:GreenConnectMobile/features/schedule/domain/entities/schedule_list_response.dart';
import 'package:GreenConnectMobile/features/schedule/domain/repository/schedule_repository.dart';

class GetAllSchedulesUsecase {
  final ScheduleRepository _repository;

  GetAllSchedulesUsecase(this._repository);

  Future<ScheduleListResponse> call({
    String? status,
    bool? sortByCreateAtDesc,
    required int pageNumber,
    required int pageSize,
  }) async {
    return await _repository.getAllSchedules(
      status: status,
      sortByCreateAtDesc: sortByCreateAtDesc,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }
}
