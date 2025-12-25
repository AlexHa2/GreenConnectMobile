import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/repository/scrap_post_repository.dart';

class CreateTimeSlotUsecase {
  final ScrapPostRepository repository;
  CreateTimeSlotUsecase(this.repository);

  Future<ScrapPostTimeSlotEntity> call({
    required String postId,
    required String specificDate,
    required String startTime,
    required String endTime,
  }) {
    return repository.createTimeSlot(
      postId: postId,
      specificDate: specificDate,
      startTime: startTime,
      endTime: endTime,
    );
  }
}

