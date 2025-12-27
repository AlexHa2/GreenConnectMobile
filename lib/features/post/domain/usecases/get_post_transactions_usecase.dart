import 'package:GreenConnectMobile/features/post/domain/entities/transaction_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/repository/scrap_post_repository.dart';

class GetPostTransactionsUsecase {
  final ScrapPostRepository repository;
  GetPostTransactionsUsecase(this.repository);

  Future<PostTransactionsResponseEntity> call({
    required String postId,
    required String collectorId,
    required String slotId,
  }) {
    return repository.getPostTransactions(
      postId: postId,
      collectorId: collectorId,
      slotId: slotId,
    );
  }
}

