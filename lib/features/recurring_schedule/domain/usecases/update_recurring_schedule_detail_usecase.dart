import 'package:GreenConnectMobile/features/recurring_schedule/domain/entities/recurring_schedule_detail_entity.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/repository/recurring_schedule_repository.dart';

class UpdateRecurringScheduleDetailUsecase {
  final RecurringScheduleRepository repository;
  UpdateRecurringScheduleDetailUsecase(this.repository);

  Future<RecurringScheduleDetailEntity> call({
    required String scheduleId,
    required String detailId,
    num? quantity,
    String? unit,
    String? amountDescription,
    String? type,
  }) {
    return repository.updateScheduleDetail(
      scheduleId: scheduleId,
      detailId: detailId,
      quantity: quantity,
      unit: unit,
      amountDescription: amountDescription,
      type: type,
    );
  }
}

