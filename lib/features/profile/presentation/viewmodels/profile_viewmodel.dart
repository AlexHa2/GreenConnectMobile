import 'package:GreenConnectMobile/core/di/auth_injector.dart';
import 'package:GreenConnectMobile/core/error/failure.dart';
import 'package:GreenConnectMobile/core/network/token_storage.dart';
import 'package:GreenConnectMobile/features/profile/data/models/user_update_model.dart';
import 'package:GreenConnectMobile/features/profile/data/models/verification_model.dart';
import 'package:GreenConnectMobile/features/profile/domain/usecases/get_me_usecase.dart';
import 'package:GreenConnectMobile/features/profile/domain/usecases/update_me_usecase.dart';
// import 'package:GreenConnectMobile/features/profile/domain/usecases/update_verification_usecase.dart';
import 'package:GreenConnectMobile/features/profile/domain/usecases/upload_user_avatar.dart';
import 'package:GreenConnectMobile/features/profile/domain/usecases/verify_user_usecase.dart';
import 'package:GreenConnectMobile/features/profile/presentation/providers/profile_providers.dart';
import 'package:GreenConnectMobile/features/profile/presentation/viewmodels/states/profile_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileViewModel extends Notifier<ProfileState> {
  late final GetMeUseCase _getMeUseCase;
  late final UpdateMeUseCase _updateMeUseCase;
  late final VerifyUserUseCase _verifyUserUseCase;
  late final UpdateMeAvatarUseCase _updateMeAvatarUseCase;
  // late final UpdateVerificationUsecase _updateVerificationUseCase;
  @override
  ProfileState build() {
    _getMeUseCase = ref.read(getMeUsecaseProvider);
    _updateMeUseCase = ref.read(updateMeUsecaseProvider);
    _verifyUserUseCase = ref.read(verifyUserUsecaseProvider);
    _updateMeAvatarUseCase = ref.read(updateMeAvatarUsecaseProvider);
    // _updateVerificationUseCase = ref.read(updateVerificationUsecaseProvider);

    return ProfileState();
  }

  // GET /me
  Future<void> getMe() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _getMeUseCase();
      state = state.copyWith(isLoading: false, user: user, errorMessage: null);
    } catch (e) {
      final errorMessage = e is AppException ? (e.message ?? e.toString()) : e.toString();
      state = state.copyWith(isLoading: false, errorMessage: errorMessage);
    }
  }

  // PUT /me
  Future<void> updateMe(UserUpdateModel update) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    TokenStorageService tokenStorage = sl<TokenStorageService>();
    try {
      final updated = await _updateMeUseCase(update);
      await tokenStorage.updateFullName(updated.fullName);
      state = state.copyWith(isLoading: false, user: updated, errorMessage: null);
    } catch (e) {
      final errorMessage = e is AppException ? (e.message ?? e.toString()) : e.toString();
      state = state.copyWith(isLoading: false, errorMessage: errorMessage);
    }
  }

  // POST /verification
  Future<void> verifyUser(VerificationModel verify) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _verifyUserUseCase(verify);
      state = state.copyWith(isLoading: false, verified: true, errorMessage: null);
    } catch (e) {
      String errorMessage;
      
      if (e is BusinessException) {
        // Extract meaningful error message from BusinessException
        final message = e.message ?? '';
        
        // Check if it's AI_ERROR or contains specific error codes
        if (message.contains('AI_ERROR') || message.contains('FPT.AI')) {
          errorMessage = 'AI_VERIFICATION_ERROR'; // Special code for UI to handle
        } else if (message.contains('DATABASE_CONFLICT') || e.statusCode == 409) {
          errorMessage = 'VERIFICATION_CONFLICT'; // Special code for duplicate verification
        } else {
          errorMessage = message;
        }
      } else if (e is AppException) {
        errorMessage = e.message ?? 'Unknown error occurred';
      } else {
        errorMessage = e.toString();
      }
      
      state = state.copyWith(isLoading: false, errorMessage: errorMessage);
    }
  }

  // PUT /me/avatar
  Future<void> updateAvatar(String avatarUrl) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _updateMeAvatarUseCase(avatarUrl);
      state = state.copyWith(isLoading: false, errorMessage: null);
    } catch (e) {
      final errorMessage = e is AppException ? (e.message ?? e.toString()) : e.toString();
      state = state.copyWith(isLoading: false, errorMessage: errorMessage);
    }
  }

  // PATCH /admin/verifications/update-verification
  // Future<void> updateVerification(VerificationModel verify) async {
  //   state = state.copyWith(isLoading: true, errorMessage: null);
  //   try {
  //     await _updateVerificationUseCase(verify);
  //     state = state.copyWith(isLoading: false, verified: true, errorMessage: null);
  //   } catch (e) {
  //     final errorMessage = e is AppException ? (e.message ?? e.toString()) : e.toString();
  //     state = state.copyWith(isLoading: false, errorMessage: errorMessage);
  //   }
  // }
}
