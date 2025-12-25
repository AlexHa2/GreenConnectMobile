import 'package:GreenConnectMobile/features/post/data/models/scrap_category/scrap_category_model.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/entities/recurring_schedule_detail_entity.dart';

class ScheduleDetailModel {
  final String id;
  final String recurringScheduleId;
  final String scrapCategoryId;
  final ScrapCategoryModel? scrapCategory;
  final num? quantity;
  final String? unit;
  final String? amountDescription;
  final String? type;

  ScheduleDetailModel({
    required this.id,
    required this.recurringScheduleId,
    required this.scrapCategoryId,
    this.scrapCategory,
    this.quantity,
    this.unit,
    this.amountDescription,
    this.type,
  });

  factory ScheduleDetailModel.fromJson(Map<String, dynamic> json) {
    return ScheduleDetailModel(
      id: json['id'] ?? '',
      recurringScheduleId: json['recurringScheduleId'] ?? '',
      scrapCategoryId: json['scrapCategoryId'] ?? '',
      scrapCategory: json['scrapCategory'] != null
          ? ScrapCategoryModel.fromJson(json['scrapCategory'])
          : null,
      quantity: json['quantity'],
      unit: json['unit'],
      amountDescription: json['amountDescription'],
      type: json['type'],
    );
  }

  RecurringScheduleDetailEntity toEntity() {
    return RecurringScheduleDetailEntity(
      id: id,
      recurringScheduleId: recurringScheduleId,
      scrapCategoryId: scrapCategoryId,
      scrapCategory: scrapCategory?.toEntity(),
      quantity: quantity,
      unit: unit,
      amountDescription: amountDescription,
      type: type,
    );
  }
}

