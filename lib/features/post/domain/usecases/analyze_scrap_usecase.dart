import 'dart:typed_data';

import 'package:GreenConnectMobile/features/post/domain/entities/analyze_scrap_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/repository/scrap_post_repository.dart';

class AnalyzeScrapUsecase {
  final ScrapPostRepository repository;
  AnalyzeScrapUsecase(this.repository);

  Future<AnalyzeScrapResultEntity> call({
    required Uint8List imageBytes,
    required String fileName,
  }) {
    return repository.analyzeScrap(imageBytes: imageBytes, fileName: fileName);
  }
}

