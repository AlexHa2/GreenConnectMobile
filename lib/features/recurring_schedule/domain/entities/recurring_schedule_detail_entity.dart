import 'package:GreenConnectMobile/features/post/domain/entities/scrap_category_entity.dart';

class RecurringScheduleDetailEntity {
  final String id;
  final String recurringScheduleId;
  final String scrapCategoryId;
  final ScrapCategoryEntity? scrapCategory;
  final num? quantity;
  final String? unit;
  final String? amountDescription;
  final String? type;

  const RecurringScheduleDetailEntity({
    required this.id,
    required this.recurringScheduleId,
    required this.scrapCategoryId,
    this.scrapCategory,
    this.quantity,
    this.unit,
    this.amountDescription,
    this.type,
  });
}

