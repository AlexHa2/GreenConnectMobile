import 'package:GreenConnectMobile/features/post/domain/repository/scrap_post_repository.dart';

class DeleteTimeSlotUsecase {
  final ScrapPostRepository repository;
  DeleteTimeSlotUsecase(this.repository);

  Future<bool> call({
    required String postId,
    required String timeSlotId,
  }) {
    return repository.deleteTimeSlot(
      postId: postId,
      timeSlotId: timeSlotId,
    );
  }
}

