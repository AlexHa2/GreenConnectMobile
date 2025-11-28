import 'package:GreenConnectMobile/features/offer/domain/entities/paginated_offer_entity.dart';
import 'package:GreenConnectMobile/features/offer/domain/repository/offer_repository.dart';

class GetAllOffersUsecase {
  final OfferRepository repository;
  GetAllOffersUsecase(this.repository);

  Future<PaginatedOfferEntity> call({
    String? status,
    bool? sortByCreateAtDesc,
    required int pageNumber,
    required int pageSize,
  }) {
    return repository.getAllOffers(
      status: status,
      sortByCreateAtDesc: sortByCreateAtDesc,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }
}
