// scrap_post_detail_model.dart
import 'package:GreenConnectMobile/features/post/data/models/scrap_category/scrap_category_model.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_detail_entity.dart';

class ScrapPostDetailModel {
  final String scrapCategoryId;
  final ScrapCategoryModel? scrapCategory;
  final String amountDescription;
  final String? imageUrl;
  final String? status;
  final String type;

  ScrapPostDetailModel({
    required this.scrapCategoryId,
    this.scrapCategory,
    required this.amountDescription,
    this.imageUrl,
    this.status,
    required this.type,
  });

  factory ScrapPostDetailModel.fromJson(Map<String, dynamic> json) {
    final dynamic idRaw = json['scrapCategoryId'];
    return ScrapPostDetailModel(
      scrapCategoryId: idRaw?.toString() ?? '',
      scrapCategory: json['scrapCategory'] != null
          ? ScrapCategoryModel.fromJson(json['scrapCategory'])
          : null,
      amountDescription: json['amountDescription'] ?? '',
      imageUrl: json['imageUrl'],
      status: json['status'],
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scrapCategoryId': scrapCategoryId,
      'scrapCategory': scrapCategory?.toJson(),
      'amountDescription': amountDescription,
      'imageUrl': imageUrl,
      'status': status,
      'type': type,
    };
  }

  ScrapPostDetailEntity toEntity() {
    return ScrapPostDetailEntity(
      scrapCategoryId: scrapCategoryId,
      scrapCategory: scrapCategory?.toEntity(),
      amountDescription: amountDescription,
      imageUrl: imageUrl,
      status: status,
      type: type,
    );
  }
}
