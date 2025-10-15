import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_connect_mb/core/di/injector.dart';
import 'package:green_connect_mb/features/auth/domain/entities/user.dart';
import 'package:green_connect_mb/features/auth/domain/usecases/get_user_usecase.dart';

class AuthNotifier extends StateNotifier<AsyncValue<List<User>>> {
  final GetUserUseCase getUserUseCase;

  AuthNotifier(this.getUserUseCase) : super(const AsyncValue.data([]));

  Future<void> getUser() async {
    state = const AsyncValue.loading();
    try {
      List<User> users = await getUserUseCase();
      state = AsyncValue.data(users);
    } catch (e, st) {
      debugPrint('❌ Exception: $e');
      debugPrintStack(stackTrace: st);
      state = AsyncValue.error(e, st);
    }
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<List<User>>>(
      (ref) => AuthNotifier(sl<GetUserUseCase>()),
    );
