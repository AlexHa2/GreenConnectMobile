class UserEntity {
  final String? profileId;
  final String userId;
  final String fullName;
  final String phoneNumber;
  final String? dateOfBirth;
  final String? address;
  final String? gender;
  final int pointBalance;
  final int? creditBalance;
  final String rank;
  final List<String> roles;
  final String? avatarUrl;
  final String? buyerType;
  final String? bankCode;
  final String? bankAccountNumber;
  final String? bankAccountName;

  UserEntity({
    this.profileId,
    required this.userId,
    required this.fullName,
    required this.phoneNumber,
    this.dateOfBirth,
    this.address,
    this.gender,
    required this.pointBalance,
    this.creditBalance,
    required this.rank,
    required this.roles,
    this.avatarUrl,
    this.buyerType,
    this.bankCode,
    this.bankAccountNumber,
    this.bankAccountName,
  });
}