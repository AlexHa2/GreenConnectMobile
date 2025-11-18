import 'package:GreenConnectMobile/features/authentication/domain/usecases/login_system_usecase.dart';
import 'package:GreenConnectMobile/features/authentication/domain/usecases/send_otp_usecase.dart';
import 'package:GreenConnectMobile/features/authentication/domain/usecases/verify_otp_usecase.dart';
import 'package:GreenConnectMobile/features/authentication/presentation/providers/auth_provider.dart';
import 'package:GreenConnectMobile/features/authentication/presentation/viewmodels/states/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class AuthViewModel extends Notifier<AuthState> {
  late LoginSystemUsecase _loginSystemUsecase;
  late SendOtpUsecase _sendOtpUsecase;
  late VerifyOtpUsecase _verifyOtpUsecase;

  @override
  AuthState build() {
    _loginSystemUsecase = ref.read(loginSystemUsecaseProvider);
    _sendOtpUsecase = ref.read(sendOtpUsecaseProvider);
    _verifyOtpUsecase = ref.read(verifyOtpUsecaseProvider);

    return AuthState();
  }

  // -------------------------------------------------------------------------

  Future<void> sendOtp(String phoneNumber) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    await _sendOtpUsecase.call(
      phoneNumber: phoneNumber,
      onCodeSent: (verificationId, resendToken) {
        state = state.copyWith(
          isLoading: false,
          verificationId: verificationId,
        );
      },
      onVerificationFailed: (e) {
        state = state.copyWith(isLoading: false, errorMessage: e.message);
      },
      onVerificationCompleted: (credential) async {
        // OTP auto-verified
        try {
          final userCred = await FirebaseAuth.instance.signInWithCredential(
            credential,
          );
          state = state.copyWith(isLoading: false, userCredential: userCred);
        } catch (e) {
          state = state.copyWith(isLoading: false, errorMessage: e.toString());
        }
      },
    );
  }

  // -------------------------------------------------------------------------

  Future<void> verifyOtp({required String smsCode}) async {
    if (state.verificationId == null) {
      state = state.copyWith(errorMessage: "Missing verificationId");
      return;
    }

    state = state.copyWith(isLoading: true);

    try {
      final userCred = await _verifyOtpUsecase.call(
        verificationId: state.verificationId!,
        smsCode: smsCode,
      );

      state = state.copyWith(isLoading: false, userCredential: userCred);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  // -------------------------------------------------------------------------

  Future<void> loginSystem(String tokenId) async {
    state = state.copyWith(isLoading: true);

    try {
      await _loginSystemUsecase.call(tokenId: tokenId);

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}
