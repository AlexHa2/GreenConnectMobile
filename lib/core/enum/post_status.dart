
enum PostStatus {
  open,
  partiallyBooked,
  fullyBooked,
  completed,
  canceled;

  String toJson() => name; 
  
  static PostStatus fromJson(String json) => values.firstWhere(
        (e) => e.name.toLowerCase() == json.toLowerCase(),
        orElse: () => PostStatus.open,
      );
}

enum PostDetailStatus {
  available,
  booked,
  collected;

  String toJson() => name; 
  
  static PostDetailStatus fromJson(String json) => values.firstWhere(
        (e) => e.name.toLowerCase() == json.toLowerCase(),
        orElse: () => PostDetailStatus.available,
      );
}