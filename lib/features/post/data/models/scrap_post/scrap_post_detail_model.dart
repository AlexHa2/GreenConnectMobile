// scrap_post_detail_model.dart
import 'package:GreenConnectMobile/features/post/data/models/scrap_category/scrap_category_model.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_detail_entity.dart';

class ScrapPostDetailModel {
  final int scrapCategoryId;
  final ScrapCategoryModel? scrapCategory;
  final String amountDescription;
  final String imageUrl;
  final String? status;

  ScrapPostDetailModel({
    required this.scrapCategoryId,
    this.scrapCategory,
    required this.amountDescription,
    required this.imageUrl,
    this.status,
  });

  factory ScrapPostDetailModel.fromJson(Map<String, dynamic> json) {
    return ScrapPostDetailModel(
      scrapCategoryId: json['scrapCategoryId'],
      scrapCategory: json['scrapCategory'] != null
          ? ScrapCategoryModel.fromJson(json['scrapCategory'])
          : null,
      amountDescription: json['amountDescription'],
      imageUrl: json['imageUrl'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scrapCategoryId': scrapCategoryId,
      'scrapCategory': scrapCategory?.toJson(),
      'amountDescription': amountDescription,
      'imageUrl': imageUrl,
      'status': status,
    };
  }

  ScrapPostDetailEntity toEntity() {
    return ScrapPostDetailEntity(
      scrapCategoryId: scrapCategoryId,
      scrapCategory: scrapCategory?.toEntity(),
      amountDescription: amountDescription,
      imageUrl: imageUrl,
      status: status,
    );
  }
}
