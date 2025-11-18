import 'package:firebase_auth/firebase_auth.dart';

class AuthState {
  final bool isLoading;
  final String? verificationId;
  final String? errorMessage;
  final UserCredential? userCredential;

  AuthState({
    this.isLoading = false,
    this.verificationId,
    this.errorMessage,
    this.userCredential,
  });

  AuthState copyWith({
    bool? isLoading,
    String? verificationId,
    String? errorMessage,
    UserCredential? userCredential,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      verificationId: verificationId ?? this.verificationId,
      errorMessage: errorMessage,
      userCredential: userCredential ?? this.userCredential,
    );
  }
}
