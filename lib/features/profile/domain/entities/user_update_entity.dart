class UserUpdateEntity {
  final String fullName;
  final String address;
  final String gender;
  final String dateOfBirth;
  final String? bankCode;
  final String? bankAccountNumber;
  final String? bankAccountName;

  UserUpdateEntity({
    required this.fullName,
    required this.address,
    required this.gender,
    required this.dateOfBirth,
    this.bankCode,
    this.bankAccountNumber,
    this.bankAccountName,
  });
}
