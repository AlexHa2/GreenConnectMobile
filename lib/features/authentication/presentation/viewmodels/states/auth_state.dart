import 'package:firebase_auth/firebase_auth.dart';

class AuthState {
  final bool isLoading;
  final String? verificationId;
  final String? errorMessage;
  final UserCredential? userCredential;
  final String? phone;
  final String? fullName;

  AuthState({
    this.isLoading = false,
    this.verificationId,
    this.errorMessage,
    this.userCredential,
    this.phone,
    this.fullName,
  });

  AuthState copyWith({
    bool? isLoading,
    String? verificationId,
    String? errorMessage,
    UserCredential? userCredential,
    String? phone,
    String? fullName,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      verificationId: verificationId ?? this.verificationId,
      errorMessage: errorMessage,
      userCredential: userCredential ?? this.userCredential,
      phone: phone ?? this.phone,
      fullName: fullName ?? this.fullName,
    );
  }
}
