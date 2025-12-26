import 'package:GreenConnectMobile/features/post/data/models/scrap_post/analyzed_scrap_item_model.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/analyze_scrap_entity.dart';

class AnalyzeScrapResultModel {
  final String suggestedTitle;
  final String suggestedDescription;
  final String? savedImageUrl;
  final String? savedImageFilePath;
  final List<AnalyzedScrapItemModel> identifiedItems;

  AnalyzeScrapResultModel({
    required this.suggestedTitle,
    required this.suggestedDescription,
    this.savedImageUrl,
    this.savedImageFilePath,
    this.identifiedItems = const [],
  });

  factory AnalyzeScrapResultModel.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['identifiedItems'] as List<dynamic>? ?? [];
    final items = itemsJson
        .map((item) => AnalyzedScrapItemModel.fromJson(item))
        .toList();

    return AnalyzeScrapResultModel(
      suggestedTitle: json['suggestedTitle'] ?? '',
      suggestedDescription: json['suggestedDescription'] ?? '',
      savedImageUrl: json['savedImageUrl'],
      savedImageFilePath: json['savedImageFilePath'],
      identifiedItems: items,
    );
  }

  AnalyzeScrapResultEntity toEntity() {
    return AnalyzeScrapResultEntity(
      suggestedTitle: suggestedTitle,
      suggestedDescription: suggestedDescription,
      savedImageUrl: savedImageUrl,
      savedImageFilePath: savedImageFilePath,
      identifiedItems: identifiedItems.map((e) => e.toEntity()).toList(),
    );
  }
}

