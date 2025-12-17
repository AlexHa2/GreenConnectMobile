import 'package:GreenConnectMobile/features/profile/domain/entities/location_entity.dart';

class UserUpdateEntity {
  final String fullName;
  final String address;
  final String gender;
  final String dateOfBirth;
  final LocationEntity? location;
  final String? bankCode;
  final String? bankAccountNumber;
  final String? bankAccountName;

  UserUpdateEntity({
    required this.fullName,
    required this.address,
    required this.gender,
    required this.dateOfBirth,
    this.location,
    this.bankCode,
    this.bankAccountNumber,
    this.bankAccountName,
  });
}
