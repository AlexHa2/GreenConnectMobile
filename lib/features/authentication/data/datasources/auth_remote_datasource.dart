import 'package:GreenConnectMobile/core/di/auth_injector.dart';
import 'package:GreenConnectMobile/core/network/api_client.dart';
import 'package:GreenConnectMobile/core/network/token_storage.dart';
import 'package:GreenConnectMobile/features/authentication/data/models/login_model.dart';
import 'package:GreenConnectMobile/features/profile/data/models/user_model.dart';
import 'package:GreenConnectMobile/features/authentication/domain/entities/login_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRemoteDatasource {
  final FirebaseAuth _firebaseAuth;
  final ApiClient _apiClient = sl<ApiClient>();
  final TokenStorageService _tokenStorage = sl<TokenStorageService>();
  final String _baseUrlAuthSystem = '/v1/auth/login-or-register';
  AuthRemoteDatasource({required FirebaseAuth firebaseAuth})
    : _firebaseAuth = firebaseAuth;

  Future<void> sendPhoneNumberOtp({
    required String phoneNumber,
    required Function(String verificationId, int? resendToken) onCodeSent,
    required Function(FirebaseAuthException exception) onVerificationFailed,
    required Function(PhoneAuthCredential credential) onVerificationCompleted,
  }) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: onVerificationCompleted,
      verificationFailed: onVerificationFailed,
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<UserCredential> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return await _firebaseAuth.signInWithCredential(credential);
  }

  Future<LoginEntity> loginSystem({required String tokenId}) async {
    try {
      final response = await _apiClient.post(
        _baseUrlAuthSystem,
        data: {'firebaseToken': tokenId},
      );

      final loginModel = LoginModel.fromJson(response.data);
      await _tokenStorage.saveAuthData(
        accessToken: loginModel.accessToken,
        user: loginModel.user as UserModel,
      );
      return loginModel;
    } catch (e) {
      throw Exception("Login to system failed: $e");
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
