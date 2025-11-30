class UserEntity {
  final String userId;
  final String fullName;
  final String phoneNumber;
  final int pointBalance;
  final String rank;
  final List<String> roles;
  final String? avatarUrl;
  final String? buyerType;

  UserEntity({
    required this.userId,
    required this.fullName,
    required this.phoneNumber,
    required this.pointBalance,
    required this.rank,
    required this.roles,
    this.avatarUrl,
    this.buyerType,
  });
}