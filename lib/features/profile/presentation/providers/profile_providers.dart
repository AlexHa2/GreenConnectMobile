import 'package:GreenConnectMobile/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:GreenConnectMobile/features/profile/data/repository/profile_repository_impl.dart';
import 'package:GreenConnectMobile/features/profile/domain/repository/profile_repository.dart';
import 'package:GreenConnectMobile/features/profile/domain/usecases/get_me_usecase.dart';
import 'package:GreenConnectMobile/features/profile/domain/usecases/update_me_usecase.dart';
import 'package:GreenConnectMobile/features/profile/domain/usecases/upload_user_avatar.dart';
import 'package:GreenConnectMobile/features/profile/domain/usecases/verify_user_usecase.dart';
import 'package:GreenConnectMobile/features/profile/presentation/viewmodels/profile_viewmodel.dart';
import 'package:GreenConnectMobile/features/profile/presentation/viewmodels/states/profile_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileRemoteDatasourceProvider = Provider<ProfileRemoteDatasource>((
  ref,
) {
  return ProfileRemoteDatasource();
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(ref.read(profileRemoteDatasourceProvider));
});

final getMeUsecaseProvider = Provider<GetMeUseCase>((ref) {
  return GetMeUseCase(ref.read(profileRepositoryProvider));
});

final updateMeUsecaseProvider = Provider<UpdateMeUseCase>((ref) {
  return UpdateMeUseCase(ref.read(profileRepositoryProvider));
});

final verifyUserUsecaseProvider = Provider<VerifyUserUseCase>((ref) {
  return VerifyUserUseCase(ref.read(profileRepositoryProvider));
});

final updateMeAvatarUsecaseProvider = Provider<UpdateMeAvatarUseCase>((ref) {
  return UpdateMeAvatarUseCase(ref.read(profileRepositoryProvider));
});
final profileViewModelProvider =
    NotifierProvider<ProfileViewModel, ProfileState>(() => ProfileViewModel());
