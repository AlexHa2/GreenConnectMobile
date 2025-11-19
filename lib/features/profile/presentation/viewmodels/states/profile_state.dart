import 'package:GreenConnectMobile/features/profile/domain/entities/profile_entity.dart';

class ProfileState {
  final bool isLoading;
  final ProfileEntity? user;
  final String? errorMessage;
  final bool verified;

  ProfileState({
    this.isLoading = false,
    this.user,
    this.errorMessage,
    this.verified = false,
  });

  ProfileState copyWith({
    bool? isLoading,
    ProfileEntity? user,
    String? errorMessage,
    bool? verified,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      errorMessage: errorMessage,
      verified: verified ?? this.verified,
    );
  }
}
