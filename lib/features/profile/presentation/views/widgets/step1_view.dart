import 'package:GreenConnectMobile/features/profile/domain/entities/address_entity.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/button_gradient.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

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

  bool isLoadingLocation = false;
  bool isValidatingAddress = false;
  bool isAddressValidated = false;

    double? _latitude;
    double? _longitude;

  Future<void> _getCurrentLocation() async {
    setState(() {
      isLoadingLocation = true;
    });

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!mounted) return;
        if (mounted) {
          CustomToast.show(context, S.of(context)!.location_service_disabled);
          setState(() {
            isLoadingLocation = false;
          });
        }
        return;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (!mounted) return;
          if (mounted) {
            CustomToast.show(
              context,
              S.of(context)!.location_permission_denied,
            );
            setState(() {
              isLoadingLocation = false;
            });
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        if (mounted) {
          CustomToast.show(context, S.of(context)!.location_permission_denied);
          setState(() {
            isLoadingLocation = false;
          });
        }
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get address from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // Save lat/lng
      _latitude = position.latitude;
      _longitude = position.longitude;

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          street.text = place.street ?? '';
          ward.text = place.subLocality ?? '';
          stateProvince.text = place.administrativeArea ?? '';
          zip.text = place.postalCode ?? '';
          country.text = place.country ?? '';
          isLoadingLocation = false;
        });

        // Auto-validate after filling
        await _validateAddressWithGeocode();
      } else {
        if (!mounted) return;
        if (mounted) {
          CustomToast.show(
            context,
            S.of(context)!.failed_to_get_address,
            type: ToastType.error,
          );
          setState(() {
            isLoadingLocation = false;
          });
        }
      }
    } catch (e) {
      if (!mounted) return;
      if (mounted) {
        CustomToast.show(
          context,
          S.of(context)!.failed_to_get_address,
          type: ToastType.error,
        );
        setState(() {
          isLoadingLocation = false;
        });
      }
    }
  }

  Future<void> _validateAddressWithGeocode() async {
    if (street.text.isEmpty || country.text.isEmpty) {
      setState(() {
        isAddressValidated = false;
      });
      return;
    }

    setState(() {
      isValidatingAddress = true;
    });

    try {
      // Construct full address - only add parts that are not empty
      List<String> addressParts = [];
      if (street.text.isNotEmpty) addressParts.add(street.text);
      if (ward.text.isNotEmpty) addressParts.add(ward.text);
      if (stateProvince.text.isNotEmpty) addressParts.add(stateProvince.text);
      if (country.text.isNotEmpty) addressParts.add(country.text);
      
      String fullAddress = addressParts.join(', ');

      // Try to geocode the address
      List<Location> locations = await locationFromAddress(fullAddress);

      if (locations.isNotEmpty) {
        if (!mounted) return;
        if (mounted) {
          setState(() {
            isAddressValidated = true;
            isValidatingAddress = false;
            _latitude = locations[0].latitude;
            _longitude = locations[0].longitude;
          });
          CustomToast.show(
            context,
            S.of(context)!.address_validated_successfully,
            type: ToastType.success,
          );
        }
      } else {
        if (!mounted) return;
        if (mounted) {
          setState(() {
            isAddressValidated = false;
            isValidatingAddress = false;
          });
          CustomToast.show(
            context,
            S.of(context)!.address_validation_failed,
            type: ToastType.error,
          );
        }
      }
    } catch (e) {
      // Address validation failed, but allow user to proceed if fields are filled
      setState(() {
        isAddressValidated = false;
        isValidatingAddress = false;
      });
      // Don't show error if basic validation passes
      if (validateFields()) {
        setState(() {
          isAddressValidated = true;
        });
      }
    }
  }

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

      // Ward - optional field, only check length if provided
      if (ward.text.isNotEmpty && ward.text.length > 50) {
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

      // Zip Code - optional field, only check format if provided
      if (zip.text.isNotEmpty && !RegExp(r'^\d{5,10}$').hasMatch(zip.text)) {
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
            onChanged: (_) {
              validateFields();
              // Reset validation status when user changes address
              setState(() {
                isAddressValidated = false;
              });
            },
            onEditingComplete: () {
              // Auto-validate when user finishes editing
              if (validateFields()) {
                _validateAddressWithGeocode();
              }
            },
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
                Icon(Icons.location_on, color: theme.primaryColor),
                SizedBox(width: spacing.screenPadding / 1.5),
                Text(
                  S.of(context)!.location,
                  style: theme.textTheme.titleLarge,
                ),
              ],
            ),
            SizedBox(height: spacing.screenPadding),

            // Modern GPS auto-fill button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: isLoadingLocation ? null : _getCurrentLocation,
                icon: isLoadingLocation
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.my_location),
                label: Text(
                  isLoadingLocation
                      ? S.of(context)!.getting_location
                      : S.of(context)!.use_current_location,
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: spacing.screenPadding,
                    horizontal: spacing.screenPadding * 1.5,
                  ),
                  side: BorderSide(
                    color: theme.primaryColor.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                  foregroundColor: theme.primaryColor,
                ),
              ),
            ),
            SizedBox(height: spacing.screenPadding * 1.5),

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
            SizedBox(height: spacing.screenPadding * 2),

            // Validation status indicator
            if (isValidatingAddress)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    S.of(context)!.validating_address,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              )
            else if (isAddressValidated && street.text.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: theme.primaryColor, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    S.of(context)!.address_validated_successfully,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ),

            SizedBox(height: spacing.screenPadding),

            // Validate Address Button
            if (!isAddressValidated &&
                street.text.isNotEmpty &&
                !isValidatingAddress)
              OutlinedButton.icon(
                onPressed: _validateAddressWithGeocode,
                icon: const Icon(Icons.verified_user),
                label: Text(S.of(context)!.validating_address),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),

            SizedBox(height: spacing.screenPadding),

            GradientButton(
              text: S.of(context)!.next,
              onPressed: () async {
                if (validateFields()) {
                  // Validate address before proceeding if not already validated
                  if (!isAddressValidated) {
                    await _validateAddressWithGeocode();
                  }

                  // Only proceed if address is validated or user manually entered valid data
                  if (isAddressValidated || validateFields()) {
                    widget.onNext(
                      Address(
                        street: street.text,
                        wardCommune: ward.text,
                        zipCode: zip.text,
                        country: country.text,
                        stateProvince: stateProvince.text,
                        latitude: _latitude ?? 0.0,
                        longitude: _longitude ?? 0.0,
                      ),
                    );
                  } else {
                    if (context.mounted) {
                      CustomToast.show(
                        context,
                        S.of(context)!.address_validation_failed,
                        type: ToastType.error,
                      );
                    }
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
