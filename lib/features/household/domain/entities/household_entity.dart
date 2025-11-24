// household_entity.dart
class HouseholdEntity {
  final String id;
  final String fullName;
  final String phoneNumber;
  final int pointBalance;
  final String rank;
  final List<String> roles;
  final String avatarUrl;

  HouseholdEntity({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.pointBalance,
    required this.rank,
    required this.roles,
    required this.avatarUrl,
  });
}
