import 'dart:io';

import 'package:GreenConnectMobile/core/enum/scrap_post_detail_type.dart';


class ScrapItemData {
  final String categoryId;
  final String categoryName;
  final String amountDescription;
  final ScrapPostDetailType type;

  final File? imageFile;

  final String? imageUrl;

  final Map<String, dynamic>? aiData;

  const ScrapItemData({
    required this.categoryId,
    required this.categoryName,
    required this.amountDescription,
    this.type = ScrapPostDetailType.sale,
    this.imageFile,
    this.imageUrl,
    this.aiData,
  });

  bool get hasUploadedImage => imageUrl != null && imageUrl!.isNotEmpty;
  

  bool get needsUpload => !hasUploadedImage && imageFile != null;
  
  String get displayPath => imageUrl ?? imageFile?.path ?? '';
  
  bool get hasAIData => aiData != null;

  ScrapItemData copyWith({
    String? categoryId,
    String? categoryName,
    String? amountDescription,
    ScrapPostDetailType? type,
    File? imageFile,
    String? imageUrl,
    Map<String, dynamic>? aiData,
  }) {
    return ScrapItemData(
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      amountDescription: amountDescription ?? this.amountDescription,
      type: type ?? this.type,
      imageFile: imageFile ?? this.imageFile,
      imageUrl: imageUrl ?? this.imageUrl,
      aiData: aiData ?? this.aiData,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'category': categoryName,
      'amountDescription': amountDescription,
      'type': type.toJson(),
      'image': imageUrl ?? imageFile?.path ?? '',
      'aiData': aiData,
    };
  }

  @override
  String toString() {
    return 'ScrapItemData(categoryId: $categoryId, categoryName: $categoryName, '
           'amountDescription: $amountDescription, type: ${type.name}, '
           'hasFile: ${imageFile != null}, hasUrl: $hasUploadedImage)';
  }
}
