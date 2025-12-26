enum ScrapPostDetailType {
  sale,
  donation,
  service;

  String toJson() => name;

  String get label {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1);
  }

  static ScrapPostDetailType fromJson(String json) => values.firstWhere(
    (e) => e.name.toLowerCase() == json.toLowerCase(),
    orElse: () => ScrapPostDetailType.sale,
  );

  static ScrapPostDetailType parseType(String type) {
    switch (type.toLowerCase()) {
      case 'sale':
        return ScrapPostDetailType.sale;
      case 'donation':
        return ScrapPostDetailType.donation;
      case 'service':
        return ScrapPostDetailType.service;
      default:
        return ScrapPostDetailType.sale;
    }
  }
}
