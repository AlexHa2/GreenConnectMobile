import 'package:GreenConnectMobile/features/profile/domain/entities/address_entity.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/button_gradient.dart';
import 'package:flutter/material.dart';

class ProfileSetupStep3View extends StatelessWidget {
  final Address addressData;
  final String fullName;
  final String gender;
  final DateTime dob;

  final VoidCallback onBack;
  final VoidCallback onComplete;

  const ProfileSetupStep3View({
    super.key,
    required this.addressData,
    required this.fullName,
    required this.gender,
    required this.dob,
    required this.onBack,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(spacing.screenPadding),
        side: BorderSide(color: theme.dividerColor),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.screenPadding * 2),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Text(
              S.of(context)!.all_set,
              style: theme.textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              S.of(context)!.all_set_message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),

            // Info Box
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.inputDecorationTheme.fillColor,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Column(
                children: [
                  _infoRow("${S.of(context)!.fullName}:", fullName, theme),
                  _infoRow("${S.of(context)!.gender}:", gender, theme),
                  _infoRow(
                    "${S.of(context)!.date_of_birth}:",
                    "${dob.year}-${dob.month}-${dob.day}",
                    theme,
                  ),
                  _infoRow(
                    "${S.of(context)!.street_address}:",
                    addressData.street,
                    theme,
                  ),
                  _infoRow(
                    "${S.of(context)!.ward_commune}:",
                    addressData.wardCommune,
                    theme,
                  ),
                  _infoRow(
                    "${S.of(context)!.state_province}:",
                    addressData.stateProvince,
                    theme,
                  ),
                  _infoRow(
                    "${S.of(context)!.country}:",
                    addressData.country,
                    theme,
                  ),

                  _infoRow(
                    "${S.of(context)!.zip_code}:",
                    addressData.zipCode,
                    theme,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onBack,
                    child: Text(S.of(context)!.back),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GradientButton(
                    text: S.of(context)!.completed,
                    onPressed: onComplete,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium!.copyWith(
              color: theme.textTheme.bodyMedium!.color!,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
