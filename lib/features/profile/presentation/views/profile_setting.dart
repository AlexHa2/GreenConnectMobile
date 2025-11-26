import 'dart:typed_data';

import 'package:GreenConnectMobile/core/di/injector.dart';
import 'package:GreenConnectMobile/core/enum/role.dart';
import 'package:GreenConnectMobile/core/helper/navigate_with_loading.dart';
import 'package:GreenConnectMobile/core/network/token_storage.dart';
import 'package:GreenConnectMobile/features/authentication/presentation/providers/auth_provider.dart';
import 'package:GreenConnectMobile/features/profile/data/models/user_update_model.dart';
import 'package:GreenConnectMobile/features/profile/presentation/providers/profile_providers.dart';
import 'package:GreenConnectMobile/features/profile/presentation/views/widgets/card_infor_profile_setting.dart';
import 'package:GreenConnectMobile/features/profile/presentation/views/widgets/card_profile_setting.dart';
import 'package:GreenConnectMobile/features/profile/presentation/views/widgets/dialog_update_profile.dart';
import 'package:GreenConnectMobile/features/profile/presentation/views/widgets/header_profile_setting.dart';
import 'package:GreenConnectMobile/features/setting/domain/entities/app_settings.dart';
import 'package:GreenConnectMobile/features/setting/presentation/providers/settings_provider.dart';
import 'package:GreenConnectMobile/features/upload/domain/entities/upload_request_entity.dart';
import 'package:GreenConnectMobile/features/upload/presentation/providers/upload_provider.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_button_danger.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_leaf_loading.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSetting extends ConsumerStatefulWidget {
  const ProfileSetting({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ProfileSettingState();
  }
}

class _ProfileSettingState extends ConsumerState<ProfileSetting> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileViewModelProvider.notifier).getMe();
    });
  }

  void logout() async {
    final tokenStorage = sl<TokenStorageService>();
    await tokenStorage.clearAuthData();
    if (mounted) {
      navigateWithLoading(context, route: '/');
    }
    ref.read(authViewModelProvider.notifier).reset();
  }

  Future<void> handleUploadAvatar() async {
    final uploadNotifier = ref.read(uploadViewModelProvider.notifier);
    final profileNotifier = ref.read(profileViewModelProvider.notifier);
    final s = S.of(context)!;
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final Uint8List bytes = await image.readAsBytes();
      final contentType = "image/${image.path.split('.').last}";

      await uploadNotifier.requestUploadUrl(
        UploadFileRequest(fileName: image.name, contentType: contentType),
      );

      final uploadState = ref.read(uploadViewModelProvider);
      if (uploadState.uploadUrl == null) {
        if (!mounted) return;
        CustomToast.show(
          context,
          s.cannot_get_uploadurl,
          type: ToastType.error,
        );
        return;
      }

      await uploadNotifier.uploadBinary(
        uploadUrl: uploadState.uploadUrl!.uploadUrl,
        fileBytes: bytes,
        contentType: contentType,
      );

      await profileNotifier.updateAvatar(uploadState.uploadUrl!.filePath);

      await profileNotifier.getMe();

      if (mounted) {
        CustomToast.show(
          context,
          s.avatar_updated_successfully,
          type: ToastType.success,
        );
      }
    } catch (e, st) {
      debugPrint("❌ ERROR UPLOAD AVATAR: $e");
      debugPrint("📌 STACK TRACE: $st");
      if (!mounted) return;
      CustomToast.show(
        context,
        s.error_occurred_while_updating_avatar,
        type: ToastType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final s = S.of(context)!;

    final settingsAsync = ref.watch(settingsProvider);
    final settings =
        settingsAsync.value ??
        const AppSettings(theme: AppTheme.light, languageCode: 'vi');
    final settingsNotifier = ref.read(settingsProvider.notifier);

    final logo = "assets/images/user_image.png";
    final uploadState = ref.watch(uploadViewModelProvider);
    final profileState = ref.watch(profileViewModelProvider);
    final user = profileState.user;
    final checkAccountIsUpgrade = Role.hasRole(user?.roles, Role.household);
    if (uploadState.isLoading) {
      return const RotatingLeafLoader();
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("${s.profile} - ${user?.fullName ?? ''}"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.screenPadding * 1.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            HeaderProfileSetting(
              fullname: '',
              roles: user?.roles ?? [],
              title: user?.rank ?? "",
              imageUrl: user?.avatarUrl ?? logo,
              onTap: () {
                handleUploadAvatar();
              },
            ),
            SizedBox(height: spacing.screenPadding * 2),
            CardProfileSetting(
              title: "${s.profile} ${s.information}",
              icon: Icons.info_outline,
              onEdit: () {
                final UserUpdateModel userUpdateModel = UserUpdateModel(
                  fullName: user?.fullName ?? '',
                  address: user?.address ?? '',
                  gender: user?.gender ?? '',
                  dateOfBirth: user?.dateOfBirth ?? '',
                );
                showDialog(
                  context: context,
                  builder: (_) => UpdateProfileDialog(
                    user: userUpdateModel,
                    onUpdated: () async {
                      final notifier = ref.read(
                        profileViewModelProvider.notifier,
                      );
                      await notifier.getMe();
                      final newState = ref.read(profileViewModelProvider);
                      if (!mounted) return;
                      if (newState.user!.fullName.isNotEmpty) {
                        if (!mounted || !context.mounted) return;
                        CustomToast.show(
                          context,
                          s.profile_updated_successfully,
                          type: ToastType.success,
                        );
                      } else {
                        if (!mounted || !context.mounted) return;
                        CustomToast.show(
                          context,
                          s.error_occurred_while_updating_profile,
                          type: ToastType.error,
                        );
                      }
                    },
                  ),
                );
              },
              children: [
                CardInforProfileSetting(
                  icon: Icons.person_outline,
                  label: "${s.fullname}:",
                  value: user?.fullName ?? "",
                ),
                CardInforProfileSetting(
                  icon: Icons.phone,
                  label: "${s.phone_number}:",
                  value: user?.phoneNumber ?? "",
                ),
                CardInforProfileSetting(
                  icon: Icons.location_on_outlined,
                  label: "${s.street_address}:",
                  value: user?.address ?? "",
                ),
                CardInforProfileSetting(
                  icon: Icons.wc_outlined,
                  label: "${s.gender}:",
                  value: user?.gender == "Male" ? s.male : s.female,
                ),
                CardInforProfileSetting(
                  icon: Icons.cake_outlined,
                  label: "${s.date_of_birth}:",
                  value: user?.dateOfBirth ?? "",
                ),
              ],
            ),
            SizedBox(height: spacing.screenPadding * 2),
            CardProfileSetting(
              title: s.settings,
              icon: Icons.settings_outlined,
              children: [
                CardInforProfileSetting(
                  icon: settings.theme == AppTheme.light
                      ? Icons.sunny
                      : Icons.nightlight,
                  label: s.theme,
                  value: settings.theme == AppTheme.light
                      ? s.theme_light
                      : s.theme_dark,
                  onPressed: () async {
                    await settingsNotifier.toggleTheme();
                  },
                  iconPress: const Icon(Icons.swap_horiz),
                ),
                CardInforProfileSetting(
                  icon: Icons.language_outlined,
                  label: s.language,
                  value: settings.languageCode == 'vi' ? s.vi : s.en,
                  onPressed: () async {
                    await settingsNotifier.changeLanguage(
                      settings.languageCode == 'vi' ? 'en' : 'vi',
                    );
                  },
                  iconPress: const Icon(Icons.swap_horiz),
                ),

                CardInforProfileSetting(
                  icon: Icons.help_outline,
                  label: s.help_center,
                  value: s.faq_and_support,
                ),
                SizedBox(height: spacing.screenPadding * 2),

                if (checkAccountIsUpgrade)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.verified_rounded),
                      label: Text(s.upgrade_to_collector),
                      onPressed: () {
                        context.push("/upgrade-verification");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        foregroundColor: theme.scaffoldBackgroundColor,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: spacing.screenPadding,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            spacing.screenPadding,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: spacing.screenPadding * 2.5),
            CustomButtonDanger(
              label: s.logout,
              onPressed: () {
                logout();
              },
              icon: const Icon(Icons.logout),
            ),
            SizedBox(height: spacing.screenPadding * 3),
          ],
        ),
      ),
    );
  }
}
