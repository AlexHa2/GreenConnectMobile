import 'package:GreenConnectMobile/features/post/domain/entities/household_report_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/repository/scrap_post_repository.dart';

class GetHouseholdReportUsecase {
  final ScrapPostRepository repository;

  GetHouseholdReportUsecase(this.repository);

  Future<HouseholdReportEntity> call({
    required String start,
    required String end,
  }) {
    return repository.getHouseholdReport(
      start: start,
      end: end,
    );
  }
}
