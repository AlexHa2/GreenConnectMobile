import 'dart:typed_data';

import 'package:GreenConnectMobile/features/upload/domain/entities/recognize_scrap_response_entity.dart';
import 'package:GreenConnectMobile/features/upload/domain/repository/file_repository.dart';

class RecognizeScrapUseCase {
  final FileRepository repository;

  RecognizeScrapUseCase(this.repository);

  Future<RecognizeScrapResponse> call(Uint8List imageBytes, String fileName) {
    return repository.recognizeScrap(imageBytes, fileName);
  }
}
