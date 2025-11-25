enum PostStatus {
  open,
  partiallyBooked,
  fullyBooked,
  completed,
  canceled;

  String toJson() => name;
  
  String get label {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1);
  }

  static PostStatus fromJson(String json) => values.firstWhere(
    (e) => e.name.toLowerCase() == json.toLowerCase(),
    orElse: () => PostStatus.open,
  );

  static PostStatus parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return PostStatus.open;
      case 'partiallybooked':
        return PostStatus.partiallyBooked;
      case 'fullybooked':
        return PostStatus.fullyBooked;
      case 'completed':
        return PostStatus.completed;
      case 'canceled':
        return PostStatus.canceled;
      default:
        return PostStatus.open;
    }
  }
}

enum PostDetailStatus {
  available,
  booked,
  collected;

  String toJson() => name;

  String get label {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1);
  }

  static PostDetailStatus fromJson(String json) => values.firstWhere(
    (e) => e.name.toLowerCase() == json.toLowerCase(),
    orElse: () => PostDetailStatus.available,
  );

  static PostDetailStatus parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return PostDetailStatus.available;
      case 'booked':
        return PostDetailStatus.booked;
      case 'collected':
        return PostDetailStatus.collected;
      default:
        return PostDetailStatus.available;
    }
  }
}
