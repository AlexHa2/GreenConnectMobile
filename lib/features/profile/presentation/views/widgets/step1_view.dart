import 'package:GreenConnectMobile/features/profile/domain/entities/address_entity.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/button_gradient.dart';
import 'package:flutter/material.dart';

class ProfileSetupStep1View extends StatefulWidget {
  final Function(Address) onNext;

  const ProfileSetupStep1View({super.key, required this.onNext});

  @override
  State<ProfileSetupStep1View> createState() => _ProfileSetupStep1ViewState();
}

class _ProfileSetupStep1ViewState extends State<ProfileSetupStep1View> {
  final street = TextEditingController();
  final ward = TextEditingController();
  final stateProvince = TextEditingController();
  final zip = TextEditingController();
  final country = TextEditingController();

  String? streetError;
  String? wardError;
  String? stateProvinceError;
  String? zipError;
  String? countryError;

  bool validateFields() {
    bool isValid = true;
    setState(() {
      // Street
      if (street.text.isEmpty) {
        streetError = S.of(context)!.street_address_error;
        isValid = false;
      } else if (street.text.length > 50) {
        streetError = S.of(context)!.street_address_length_error;
        isValid = false;
      } else {
        streetError = null;
      }

      // Ward
      if (ward.text.isEmpty) {
        wardError = S.of(context)!.ward_commune_error;
        isValid = false;
      } else if (ward.text.length > 50) {
        wardError = S.of(context)!.ward_commune_length_error;
        isValid = false;
      } else {
        wardError = null;
      }

      // State/Province
      if (stateProvince.text.isEmpty) {
        stateProvinceError = S.of(context)!.state_province_error;
        isValid = false;
      } else if (stateProvince.text.length > 50) {
        stateProvinceError = S.of(context)!.state_province_length_error;
        isValid = false;
      } else {
        stateProvinceError = null;
      }

      // Zip Code
      if (zip.text.isEmpty) {
        zipError = S.of(context)!.zip_code_error;
        isValid = false;
      } else if (!RegExp(r'^\d{5,10}$').hasMatch(zip.text)) {
        zipError = S.of(context)!.zip_code_format_error;
        isValid = false;
      } else {
        zipError = null;
      }

      // Country
      if (country.text.isEmpty) {
        countryError = S.of(context)!.country_error;
        isValid = false;
      } else if (country.text.length > 50) {
        countryError = S.of(context)!.country_length_error;
        isValid = false;
      } else {
        countryError = null;
      }
    });
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = Theme.of(context).extension<AppSpacing>()!;

    Widget buildTextField({
      required TextEditingController controller,
      required String label,
      required String hint,
      String? errorText,
    }) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.bodyLarge),
          SizedBox(height: spacing.screenPadding / 2),
          TextField(
            controller: controller,
            decoration: InputDecoration(hintText: hint, errorText: errorText),
            onChanged: (_) => validateFields(),
          ),
        ],
      );
    }

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(spacing.screenPadding),
        side: BorderSide(color: theme.dividerColor),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.screenPadding * 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  S.of(context)!.location,
                  style: theme.textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 20),

            buildTextField(
              controller: street,
              label: S.of(context)!.street_address,
              hint: S.of(context)!.street_address_hint,
              errorText: streetError,
            ),
            SizedBox(height: spacing.screenPadding),

            Row(
              children: [
                Expanded(
                  child: buildTextField(
                    controller: ward,
                    label: S.of(context)!.ward_commune,
                    hint: S.of(context)!.ward_commune_hint,
                    errorText: wardError,
                  ),
                ),
                SizedBox(width: spacing.screenPadding),
                Expanded(
                  child: buildTextField(
                    controller: stateProvince,
                    label: S.of(context)!.state_province,
                    hint: S.of(context)!.state_province_hint,
                    errorText: stateProvinceError,
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing.screenPadding),

            Row(
              children: [
                Expanded(
                  child: buildTextField(
                    controller: zip,
                    label: S.of(context)!.zip_code,
                    hint: S.of(context)!.zip_code_hint,
                    errorText: zipError,
                  ),
                ),
                SizedBox(width: spacing.screenPadding),
                Expanded(
                  child: buildTextField(
                    controller: country,
                    label: S.of(context)!.country,
                    hint: S.of(context)!.country_hint,
                    errorText: countryError,
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing.screenPadding * 3),

            GradientButton(
              text: S.of(context)!.next,
              onPressed: () {
                if (validateFields()) {
                  widget.onNext(
                    Address(
                      street: street.text,
                      wardCommune: ward.text,
                      zipCode: zip.text,
                      country: country.text,
                      stateProvince: stateProvince.text,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
