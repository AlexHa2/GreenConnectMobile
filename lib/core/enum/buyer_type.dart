
enum BuyerTypeStatus {
  individual,
  business;

  String toJson() => name;

  String get label {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1);
  }

  static BuyerTypeStatus fromJson(String json) => values.firstWhere(
    (e) => e.name.toLowerCase() == json.toLowerCase(),
    orElse: () => BuyerTypeStatus.individual,
  );

  static BuyerTypeStatus parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'individual':
        return BuyerTypeStatus.individual;
      case 'business':
        return BuyerTypeStatus.business;
      default:
        return BuyerTypeStatus.individual;
    }
  }
}
