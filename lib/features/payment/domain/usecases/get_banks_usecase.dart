import 'package:GreenConnectMobile/features/payment/domain/entities/bank_entity.dart';
import 'package:GreenConnectMobile/features/payment/domain/repository/bank_repository.dart';

class GetBanksUsecase {
  final BankRepository repository;

  GetBanksUsecase(this.repository);

  Future<List<BankEntity>> call() {
    return repository.getBanks();
  }
}
