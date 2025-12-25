import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/repository/scrap_post_repository.dart';

class UpdateTimeSlotUsecase {
  final ScrapPostRepository repository;
  UpdateTimeSlotUsecase(this.repository);

  Future<ScrapPostTimeSlotEntity> call({
    required String postId,
    required String timeSlotId,
    required String specificDate,
    required String startTime,
    required String endTime,
  }) {
    return repository.updateTimeSlot(
      postId: postId,
      timeSlotId: timeSlotId,
      specificDate: specificDate,
      startTime: startTime,
      endTime: endTime,
    );
  }
}

