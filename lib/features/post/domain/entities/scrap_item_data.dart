import 'dart:io';


class ScrapItemData {
  final int categoryId;
  final String categoryName;
  final int quantity;
  final double weight;
  
  final File? imageFile;
  
  final String? imageUrl;
  
  final Map<String, dynamic>? aiData;

  const ScrapItemData({
    required this.categoryId,
    required this.categoryName,
    required this.quantity,
    required this.weight,
    this.imageFile,
    this.imageUrl,
    this.aiData,
  });

  bool get hasUploadedImage => imageUrl != null && imageUrl!.isNotEmpty;
  

  bool get needsUpload => !hasUploadedImage && imageFile != null;
  
  String get displayPath => imageUrl ?? imageFile?.path ?? '';
  
  bool get hasAIData => aiData != null;

  ScrapItemData copyWith({
    int? categoryId,
    String? categoryName,
    int? quantity,
    double? weight,
    File? imageFile,
    String? imageUrl,
    Map<String, dynamic>? aiData,
  }) {
    return ScrapItemData(
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      quantity: quantity ?? this.quantity,
      weight: weight ?? this.weight,
      imageFile: imageFile ?? this.imageFile,
      imageUrl: imageUrl ?? this.imageUrl,
      aiData: aiData ?? this.aiData,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'category': categoryName,
      'quantity': quantity,
      'weight': weight,
      'image': imageUrl ?? imageFile?.path ?? '',
      'aiData': aiData,
    };
  }

  @override
  String toString() {
    return 'ScrapItemData(categoryId: $categoryId, categoryName: $categoryName, '
           'quantity: $quantity, weight: $weight, '
           'hasFile: ${imageFile != null}, hasUrl: $hasUploadedImage)';
  }
}
