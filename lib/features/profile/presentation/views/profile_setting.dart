import 'package:GreenConnectMobile/features/profile/presentation/views/widgets/card_infor_profile_setting.dart';
import 'package:GreenConnectMobile/features/profile/presentation/views/widgets/card_profile_setting.dart';
import 'package:GreenConnectMobile/features/profile/presentation/views/widgets/header_profile_setting.dart';
import 'package:GreenConnectMobile/features/setting/domain/entities/app_settings.dart';
import 'package:GreenConnectMobile/features/setting/presentation/providers/settings_provider.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_button_danger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileSetting extends ConsumerWidget {
  final Map<String, dynamic> initialData;
  const ProfileSetting({super.key, required this.initialData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final s = S.of(context)!;

    final settingsAsync = ref.watch(settingsProvider);
    final settings =
        settingsAsync.value ??
        const AppSettings(theme: AppTheme.light, languageCode: 'vi');
    final settingsNotifier = ref.read(settingsProvider.notifier);

    // final postId = initialData['postId'];
    final title = initialData['title'];
    final imageUrl = initialData['imageUrl'];
    final fullname = initialData['fullname'];
    final address = initialData['address'];
    final phonenumber = initialData['phonenumber'];
    final role = initialData['role'];

    return Scaffold(
      appBar: AppBar(
        title: Text("${s.profile} - $title"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.screenPadding * 1.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            HeaderProfileSetting(
              fullname: fullname,
              role: role,
              title: title,
              imageUrl: imageUrl,
            ),
            SizedBox(height: spacing.screenPadding * 2),
            CardProfileSetting(
              title: "${s.profile} ${s.information}",
              icon: Icons.info_outline,
              onEdit: () {},
              children: [
                CardInforProfileSetting(
                  icon: Icons.person_outline,
                  label: "${s.fullname}:",
                  value: fullname,
                ),
                CardInforProfileSetting(
                  icon: Icons.phone,
                  label: "${s.phone_number}:",
                  value: phonenumber,
                ),
                CardInforProfileSetting(
                  icon: Icons.location_on_outlined,
                  label: "${s.street_address}:",
                  value: address,
                ),
              ],
            ),
            SizedBox(height: spacing.screenPadding * 2),
            CardProfileSetting(
              title: s.settings,
              icon: Icons.settings_outlined,
              children: [
                CardInforProfileSetting(
                  icon: Icons.security_outlined,
                  label: s.security,
                  value: s.change_your_phone,
                ),
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
              ],
            ),
            SizedBox(height: spacing.screenPadding * 2.5),
            CustomButtonDanger(
              label: s.logout,
              onPressed: () {},
              icon: const Icon(Icons.logout),
            ),
            SizedBox(height: spacing.screenPadding * 3),
          ],
        ),
      ),
    );
  }
}
