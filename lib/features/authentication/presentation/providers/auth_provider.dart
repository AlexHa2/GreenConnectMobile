import 'package:GreenConnectMobile/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:GreenConnectMobile/features/authentication/data/repository/auth_repository_impl.dart';
import 'package:GreenConnectMobile/features/authentication/domain/usecases/login_system_usecase.dart';
import 'package:GreenConnectMobile/features/authentication/domain/usecases/send_otp_usecase.dart';
import 'package:GreenConnectMobile/features/authentication/domain/usecases/verify_otp_usecase.dart';
import 'package:GreenConnectMobile/features/authentication/presentation/viewmodels/auth_viewmodel.dart';
import 'package:GreenConnectMobile/features/authentication/presentation/viewmodels/states/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  final firebaseAuth = FirebaseAuth.instance;
  return AuthRemoteDatasource(firebaseAuth: firebaseAuth);
});

final authRepositoryProvider = Provider<AuthRepositoryImpl>((ref) {
  final authDatasource = ref.read(authRemoteDatasourceProvider);
  return AuthRepositoryImpl(authDatasource: authDatasource);
});

final loginSystemUsecaseProvider = Provider<LoginSystemUsecase>((ref) {
  return LoginSystemUsecase(repository: ref.read(authRepositoryProvider));
});

final sendOtpUsecaseProvider = Provider<SendOtpUsecase>((ref) {
  return SendOtpUsecase(repository: ref.read(authRepositoryProvider));
});

final verifyOtpUsecaseProvider = Provider<VerifyOtpUsecase>((ref) {
  return VerifyOtpUsecase(repository: ref.read(authRepositoryProvider));
});

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  () => AuthViewModel(),
);
