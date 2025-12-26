import 'package:GreenConnectMobile/features/recurring_schedule/domain/entities/paginated_recurring_schedule_entity.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/repository/recurring_schedule_repository.dart';

class GetRecurringSchedulesUsecase {
  final RecurringScheduleRepository repository;
  GetRecurringSchedulesUsecase(this.repository);

  Future<PaginatedRecurringScheduleEntity> call({
    required int pageNumber,
    required int pageSize,
    bool? sortByCreatedAt,
  }) {
    return repository.getSchedules(
      pageNumber: pageNumber,
      pageSize: pageSize,
      sortByCreatedAt: sortByCreatedAt,
    );
  }
}

