class CollectorEntity {
  final String id;
  final String? fullName;
  final String? phoneNumber;
  final int pointBalance;
  final String rank;
  final List<String> roles;
  final String? avatarUrl;

  CollectorEntity({
    required this.id,
    this.fullName,
    this.phoneNumber,
    required this.pointBalance,
    required this.rank,
    required this.roles,
    this.avatarUrl,
  });
}
