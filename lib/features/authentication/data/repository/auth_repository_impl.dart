import 'package:GreenConnectMobile/core/error/exception_mapper.dart';
import 'package:GreenConnectMobile/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:GreenConnectMobile/features/authentication/domain/entities/login_entity.dart';
import 'package:GreenConnectMobile/features/authentication/domain/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource authDatasource;

  AuthRepositoryImpl({required this.authDatasource});

  @override
  Future<void> sendPhoneNumberOtp({
    required String phoneNumber,
    required Function(String verificationId, int? resendToken) onCodeSent,
    required Function(FirebaseAuthException exception) onVerificationFailed,
    required Function(PhoneAuthCredential credential) onVerificationCompleted,
  }) async {
    await authDatasource.sendPhoneNumberOtp(
      phoneNumber: phoneNumber,
      onCodeSent: onCodeSent,
      onVerificationFailed: onVerificationFailed,
      onVerificationCompleted: onVerificationCompleted,
    );
  }

  @override
  Future<UserCredential> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    return await authDatasource.verifyOtp(
      verificationId: verificationId,
      smsCode: smsCode,
    );
  }

  @override
  Future<void> logout() async {
    await authDatasource.logout();
  }

  @override
  String getToken() {
    return 'hello my friend';
  }

  @override
  Future<LoginEntity> loginSystem({required String tokenId}) async {
    return guard(() async {
      return await authDatasource.loginSystem(tokenId: tokenId);
    });
  }
}
