// features/authentication/domain/usecases/send_otp_usecase.dart
import 'package:GreenConnectMobile/features/authentication/domain/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SendOtpUsecase {
  final AuthRepository repository;

  SendOtpUsecase({required this.repository});

  Future<void> call({
    required String phoneNumber,
    required Function(String verificationId, int? resendToken) onCodeSent,
    required Function(FirebaseAuthException exception) onVerificationFailed,
    required Function(PhoneAuthCredential credential) onVerificationCompleted,
  }) async {
    return repository.sendPhoneNumberOtp(
      phoneNumber: phoneNumber,
      onCodeSent: onCodeSent,
      onVerificationFailed: onVerificationFailed,
      onVerificationCompleted: onVerificationCompleted,
    );
  }
}