import 'package:GreenConnectMobile/features/authentication/domain/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyOtpUsecase {
  final AuthRepository repository;

  VerifyOtpUsecase({required this.repository});

  Future<UserCredential> call({
    required String verificationId,
    required String smsCode,
  }) async {
    return repository.verifyOtp(
      verificationId: verificationId,
      smsCode: smsCode,
    );
  }
}
