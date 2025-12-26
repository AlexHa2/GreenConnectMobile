import 'package:GreenConnectMobile/core/common/paginate/paginate_entity.dart';
import 'package:GreenConnectMobile/core/common/paginate/paginate_model.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/data/models/recurring_schedule/recurring_schedule_model.dart';

class PaginatedRecurringScheduleModel
    extends PaginatedResponseModel<RecurringScheduleModel> {
  PaginatedRecurringScheduleModel({
    required super.data,
    required super.pagination,
  });

  factory PaginatedRecurringScheduleModel.fromJson(
      Map<String, dynamic> json,) {
    return PaginatedRecurringScheduleModel(
      data: (json['data'] as List)
          .map((e) => RecurringScheduleModel.fromJson(e))
          .toList(),
      pagination: PaginationEntity(
        totalRecords: json['pagination']['totalRecords'] ?? 0,
        currentPage: json['pagination']['currentPage'] ?? 1,
        totalPages: json['pagination']['totalPages'] ?? 1,
        nextPage: json['pagination']['nextPage'],
        prevPage: json['pagination']['prevPage'],
      ),
    );
  }
}

