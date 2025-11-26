import 'package:firebase_auth/firebase_auth.dart';

class AuthState {
  final bool isLoading;
  final String? verificationId;
  final String? errorMessage;
  final int? errorCode;
  final UserCredential? userCredential;
  final String? phone;
  final String? fullName;
  final List<String>? userRoles;

  AuthState({
    this.isLoading = false,
    this.verificationId,
    this.errorMessage,
    this.userCredential,
    this.phone,
    this.fullName,
    this.userRoles,
    this.errorCode,
  });

  AuthState copyWith({
    bool? isLoading,
    String? verificationId,
    String? errorMessage,
    int? errorCode,
    UserCredential? userCredential,
    String? phone,
    String? fullName,
    List<String>? userRoles,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      verificationId: verificationId ?? this.verificationId,
      errorMessage: errorMessage,
      errorCode: errorCode ?? this.errorCode,
      userCredential: userCredential ?? this.userCredential,
      phone: phone ?? this.phone,
      fullName: fullName ?? this.fullName,
      userRoles: userRoles ?? this.userRoles,
    );
  }
}
