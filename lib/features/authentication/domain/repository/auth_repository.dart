import 'package:GreenConnectMobile/features/authentication/domain/entities/login_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<void> sendPhoneNumberOtp({
    required String phoneNumber,
    required Function(String verificationId, int? resendToken) onCodeSent,
    required Function(FirebaseAuthException exception) onVerificationFailed,
    required Function(PhoneAuthCredential credential) onVerificationCompleted,
  });

  Future<UserCredential> verifyOtp({
    required String verificationId,
    required String smsCode,
  });

  Future<LoginEntity> loginSystem({required String tokenId});

  String getToken();

  Future<void> logout();
}
