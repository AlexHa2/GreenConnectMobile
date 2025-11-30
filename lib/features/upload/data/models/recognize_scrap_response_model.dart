class RecognizeScrapResponseModel {
  final String itemName;
  final String category;
  final String material;
  final bool isRecyclable;
  final String estimatedAmount;
  final String advice;
  final double confidence;
  final String savedImageFilePath;
  final String savedImageUrl;

  const RecognizeScrapResponseModel({
    required this.itemName,
    required this.category,
    required this.material,
    required this.isRecyclable,
    required this.estimatedAmount,
    required this.advice,
    required this.confidence,
    required this.savedImageFilePath,
    required this.savedImageUrl,
  });

  factory RecognizeScrapResponseModel.fromJson(Map<String, dynamic> json) {
    return RecognizeScrapResponseModel(
      itemName: json['itemName'] as String? ?? '',
      category: json['category'] as String? ?? '',
      material: json['material'] as String? ?? '',
      isRecyclable: json['isRecyclable'] as bool? ?? false,
      estimatedAmount: json['estimatedAmount'] as String? ?? '0',
      advice: json['advice'] as String? ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      savedImageFilePath: json['savedImageFilePath'] as String? ?? '',
      savedImageUrl: json['savedImageUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'category': category,
      'material': material,
      'isRecyclable': isRecyclable,
      'estimatedAmount': estimatedAmount,
      'advice': advice,
      'confidence': confidence,
      'savedImageFilePath': savedImageFilePath,
      'savedImageUrl': savedImageUrl,
    };
  }
}
