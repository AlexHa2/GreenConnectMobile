import 'package:GreenConnectMobile/core/di/auth_injector.dart';
import 'package:GreenConnectMobile/core/network/token_storage.dart';
import 'package:GreenConnectMobile/features/profile/data/models/user_update_model.dart';
import 'package:GreenConnectMobile/features/profile/data/models/verification_model.dart';
import 'package:GreenConnectMobile/features/profile/domain/usecases/get_me_usecase.dart';
import 'package:GreenConnectMobile/features/profile/domain/usecases/update_me_usecase.dart';
import 'package:GreenConnectMobile/features/profile/domain/usecases/verify_user_usecase.dart';
import 'package:GreenConnectMobile/features/profile/presentation/providers/profile_providers.dart';
import 'package:GreenConnectMobile/features/profile/presentation/viewmodels/states/profile_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileViewModel extends Notifier<ProfileState> {
  late final GetMeUseCase _getMeUseCase;
  late final UpdateMeUseCase _updateMeUseCase;
  late final VerifyUserUseCase _verifyUserUseCase;
  @override
  ProfileState build() {
    _getMeUseCase = ref.read(getMeUsecaseProvider);
    _updateMeUseCase = ref.read(updateMeUsecaseProvider);
    _verifyUserUseCase = ref.read(verifyUserUsecaseProvider);

    return ProfileState();
  }

  // GET /me
  Future<void> getMe() async {
    state = state.copyWith(isLoading: true);

    try {
      final user = await _getMeUseCase();
      state = state.copyWith(isLoading: false, user: user);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  // PUT /me
  Future<void> updateMe(UserUpdateModel update) async {
    state = state.copyWith(isLoading: true);
    TokenStorageService tokenStorage = sl<TokenStorageService>();
    try {
      final updated = await _updateMeUseCase(update);
      await tokenStorage.updateFullName(updated.fullName);
      state = state.copyWith(isLoading: false, user: updated);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  // POST /verification
  Future<void> verifyUser(VerificationModel verify) async {
    state = state.copyWith(isLoading: true);

    try {
      await _verifyUserUseCase(verify);
      state = state.copyWith(isLoading: false, verified: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}
