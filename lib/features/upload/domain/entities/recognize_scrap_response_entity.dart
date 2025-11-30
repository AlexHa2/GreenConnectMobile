class RecognizeScrapResponse {
  final String itemName;
  final String category;
  final String material;
  final bool isRecyclable;
  final String estimatedAmount;
  final String advice;
  final double confidence;
  final String savedImageFilePath;
  final String savedImageUrl;

  const RecognizeScrapResponse({
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
}
