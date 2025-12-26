import 'package:GreenConnectMobile/core/error/exception_mapper.dart';
import 'package:GreenConnectMobile/features/post/data/models/scrap_post/location_model.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/location_entity.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/data/datasources/abstract_datasources/recurring_schedule_remote_datasource.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/data/models/recurring_schedule/create_recurring_schedule_model.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/data/models/recurring_schedule/paginated_recurring_schedule_model.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/data/models/recurring_schedule/recurring_schedule_model.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/data/models/recurring_schedule/schedule_detail_model.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/data/models/recurring_schedule/update_recurring_schedule_model.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/entities/paginated_recurring_schedule_entity.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/entities/recurring_schedule_detail_entity.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/entities/recurring_schedule_entity.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/repository/recurring_schedule_repository.dart';

class RecurringScheduleRepositoryImpl implements RecurringScheduleRepository {
  final RecurringScheduleRemoteDataSource remote;
  RecurringScheduleRepositoryImpl(this.remote);

  @override
  Future<PaginatedRecurringScheduleEntity> getSchedules({
    required int pageNumber,
    required int pageSize,
    bool? sortByCreatedAt,
  }) {
    return guard(() async {
      final PaginatedRecurringScheduleModel res = await remote.getSchedules(
        pageNumber: pageNumber,
        pageSize: pageSize,
        sortByCreatedAt: sortByCreatedAt,
      );
      return PaginatedRecurringScheduleEntity(
        data: res.data.map((e) => e.toEntity()).toList(),
        pagination: res.pagination,
      );
    });
  }

  @override
  Future<RecurringScheduleEntity> getScheduleDetail(String id) {
    return guard(() async {
      final RecurringScheduleModel res = await remote.getSchedule(id);
      return res.toEntity();
    });
  }

  @override
  Future<bool> toggleSchedule(String id) {
    return guard(() => remote.toggleSchedule(id));
  }

  @override
  Future<bool> updateSchedule({
    required String id,
    required RecurringScheduleEntity schedule,
  }) {
    return guard(() async {
      final safeLocation = schedule.location ??
          LocationEntity(
            longitude: 0,
            latitude: 0,
          );
      final model = UpdateRecurringScheduleModel(
        title: schedule.title,
        description: schedule.description,
        address: schedule.address,
        location: LocationModel.fromEntity(safeLocation),
        mustTakeAll: schedule.mustTakeAll,
        dayOfWeek: schedule.dayOfWeek,
        startTime: schedule.startTime,
        endTime: schedule.endTime,
      );
      return await remote.updateSchedule(id: id, model: model);
    });
  }

  @override
  Future<RecurringScheduleEntity> createSchedule(
    RecurringScheduleEntity schedule,
  ) {
    return guard(() async {
      final model = CreateRecurringScheduleModel(
        title: schedule.title,
        description: schedule.description,
        address: schedule.address,
        location: LocationModel.fromEntity(schedule.location!),
        mustTakeAll: schedule.mustTakeAll,
        dayOfWeek: schedule.dayOfWeek,
        startTime: schedule.startTime,
        endTime: schedule.endTime,
        scheduleDetails: schedule.scheduleDetails
            .map(
              (d) => ScheduleDetailModel(
                id: d.id,
                recurringScheduleId: schedule.id,
                scrapCategoryId: d.scrapCategoryId,
                quantity: d.quantity,
                unit: d.unit,
                amountDescription: d.amountDescription,
                type: d.type,
              ),
            )
            .toList(),
      );
      final res = await remote.createSchedule(model);
      return res.toEntity();
    });
  }

  @override
  Future<RecurringScheduleDetailEntity> createScheduleDetail({
    required String scheduleId,
    required RecurringScheduleDetailEntity detail,
  }) {
    return guard(() async {
      final model = ScheduleDetailModel(
        id: detail.id,
        recurringScheduleId: scheduleId,
        scrapCategoryId: detail.scrapCategoryId,
        quantity: detail.quantity,
        unit: detail.unit,
        amountDescription: detail.amountDescription,
        type: detail.type,
      );
      final res = await remote.createScheduleDetail(
        scheduleId: scheduleId,
        model: model,
      );
      return res.toEntity();
    });
  }

  @override
  Future<RecurringScheduleDetailEntity> updateScheduleDetail({
    required String scheduleId,
    required String detailId,
    num? quantity,
    String? unit,
    String? amountDescription,
    String? type,
  }) {
    return guard(() async {
      final res = await remote.updateScheduleDetail(
        scheduleId: scheduleId,
        detailId: detailId,
        quantity: quantity,
        unit: unit,
        amountDescription: amountDescription,
        type: type,
      );
      return res.toEntity();
    });
  }

  @override
  Future<RecurringScheduleDetailEntity> getScheduleDetailItem(String detailId) {
    return guard(() async {
      final res = await remote.getScheduleDetail(detailId);
      return res.toEntity();
    });
  }

  @override
  Future<bool> deleteScheduleDetail({
    required String scheduleId,
    required String detailId,
  }) {
    return guard(() async {
      return await remote.deleteScheduleDetail(
        scheduleId: scheduleId,
        detailId: detailId,
      );
    });
  }
}

