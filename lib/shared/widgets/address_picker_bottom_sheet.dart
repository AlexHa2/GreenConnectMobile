import 'package:GreenConnectMobile/core/helper/get_location_from_address.dart';
import 'package:GreenConnectMobile/features/post/data/services/saved_location_service.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/saved_location_entity.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';

/// Bottom sheet for selecting or adding an address
/// Features:
/// - GPS auto-location button
/// - List of saved locations
/// - Manual address input
/// - Save new locations with custom names
class AddressPickerBottomSheet extends StatefulWidget {
  final String? initialAddress;
  final Function(String address, double? latitude, double? longitude)
  onAddressSelected;

  const AddressPickerBottomSheet({
    super.key,
    this.initialAddress,
    required this.onAddressSelected,
  });

  @override
  State<AddressPickerBottomSheet> createState() =>
      _AddressPickerBottomSheetState();
}

class _AddressPickerBottomSheetState extends State<AddressPickerBottomSheet> {
  final SavedLocationService _savedLocationService = SavedLocationService();
  final TextEditingController _manualAddressController =
      TextEditingController();

  List<SavedLocation> _savedLocations = [];
  bool _isLoadingLocations = true;
  bool _isGettingCurrentLocation = false;
  double? _pendingLatitude;
  double? _pendingLongitude;

  // Manual address validation
  bool _isValidatingAddress = false;
  bool _addressValidated = false;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    if (widget.initialAddress != null) {
      _manualAddressController.text = widget.initialAddress!;
    }
    _loadSavedLocations();
  }

  @override
  void dispose() {
    _manualAddressController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedLocations() async {
    setState(() => _isLoadingLocations = true);
    try {
      final locations = await _savedLocationService.getSavedLocations();
      if (mounted) {
        setState(() {
          _savedLocations = locations;
          _isLoadingLocations = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingLocations = false);
        CustomToast.show(
          context,
          S.of(context)!.error_occurred,
          type: ToastType.error,
        );
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isGettingCurrentLocation = true);

    try {
      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            CustomToast.show(
              context,
              S.of(context)!.location_permission_denied,
              type: ToastType.error,
            );
          }
          setState(() => _isGettingCurrentLocation = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          CustomToast.show(
            context,
            S.of(context)!.location_permission_denied_forever,
            type: ToastType.error,
          );
        }
        setState(() => _isGettingCurrentLocation = false);
        return;
      }

      // Get position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Reverse geocode
      final placemarks = await geocoding.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty && mounted) {
        final placemark = placemarks.first;
        final address = _buildAddressFromPlacemark(placemark);

        setState(() {
          _pendingLatitude = position.latitude;
          _pendingLongitude = position.longitude;
          _manualAddressController.text = address;
          _addressValidated = true; // GPS address is pre-validated
          _isGettingCurrentLocation = false;
        });

        CustomToast.show(
          context,
          S.of(context)!.location_fetched_successfully,
          type: ToastType.success,
        );
      }
    } catch (e) {
      if (mounted) {
        CustomToast.show(
          context,
          S.of(context)!.error_getting_location,
          type: ToastType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGettingCurrentLocation = false);
      }
    }
  }

  String _buildAddressFromPlacemark(geocoding.Placemark placemark) {
    final parts = <String>[];
    if (placemark.street?.isNotEmpty == true) parts.add(placemark.street!);
    if (placemark.subLocality?.isNotEmpty == true) {
      parts.add(placemark.subLocality!);
    }
    if (placemark.locality?.isNotEmpty == true) parts.add(placemark.locality!);
    if (placemark.administrativeArea?.isNotEmpty == true) {
      parts.add(placemark.administrativeArea!);
    }
    if (placemark.country?.isNotEmpty == true) parts.add(placemark.country!);
    return parts.join(', ');
  }

  void _selectLocation(SavedLocation location) {
    widget.onAddressSelected(
      location.address,
      location.latitude,
      location.longitude,
    );
    Navigator.of(context).pop();
  }

  Future<void> _validateAndConfirmAddress() async {
    final address = _manualAddressController.text.trim();
    if (address.isEmpty) {
      CustomToast.show(
        context,
        S.of(context)!.please_enter_address,
        type: ToastType.warning,
      );
      return;
    }

    // Check if we already have coordinates from GPS
    if (_pendingLatitude != null && _pendingLongitude != null) {
      _showSaveDialog(address, _pendingLatitude!, _pendingLongitude!);
      return;
    }

    // Validate address by geocoding
    setState(() {
      _isValidatingAddress = true;
      _validationError = null;
    });

    try {
      final location = await getLocationFromAddress(address);

      if (location != null && mounted) {
        setState(() {
          _pendingLatitude = location.latitude;
          _pendingLongitude = location.longitude;
          _addressValidated = true;
          _isValidatingAddress = false;
        });

        CustomToast.show(
          context,
          S.of(context)!.address_validated_successfully,
          type: ToastType.success,
        );

        // Show save dialog
        _showSaveDialog(address, location.latitude, location.longitude);
      } else {
        if (mounted) {
          setState(() {
            _isValidatingAddress = false;
            _validationError = S.of(context)!.address_not_found;
          });

          CustomToast.show(
            context,
            S.of(context)!.address_validation_failed,
            type: ToastType.error,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isValidatingAddress = false;
          _validationError = S.of(context)!.error_getting_location;
        });

        CustomToast.show(
          context,
          S.of(context)!.address_validation_failed,
          type: ToastType.error,
        );
      }
    }
  }

  void _showSaveDialog(String address, double latitude, double longitude) {
    final nameController = TextEditingController();
    bool setAsDefault = false;
    final space = Theme.of(context).extension<AppSpacing>()!;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(S.of(context)!.save_this_location),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(space.screenPadding / 2),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                address,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              SizedBox(height: space.screenPadding),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: S.of(context)!.location_name,
                  hintText: S.of(context)!.location_name_hint,
                  border: const OutlineInputBorder(),
                ),
              ),
              SizedBox(height: space.screenPadding),
              Row(
                children: [
                  Checkbox(
                    value: setAsDefault,
                    onChanged: (value) {
                      setDialogState(() => setAsDefault = value ?? false);
                    },
                  ),
                  Expanded(child: Text(S.of(context)!.set_as_default)),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Skip saving, just use the address
                Navigator.of(context).pop();
                widget.onAddressSelected(address, latitude, longitude);
                Navigator.of(context).pop();
              },
              child: Text(S.of(context)!.skip),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isEmpty) {
                  CustomToast.show(
                    context,
                    S.of(context)!.please_enter_location_name,
                    type: ToastType.warning,
                  );
                  return;
                }

                try {
                  final newLocation = SavedLocation(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: name,
                    address: address,
                    latitude: latitude,
                    longitude: longitude,
                    isDefault: setAsDefault,
                    createdAt: DateTime.now(),
                  );

                  await _savedLocationService.saveLocation(newLocation);

                  if (setAsDefault) {
                    await _savedLocationService.setDefaultLocation(
                      newLocation.id,
                    );
                  }

                  if (context.mounted) {
                    CustomToast.show(
                      context,
                      S.of(context)!.location_saved_successfully,
                      type: ToastType.success,
                    );
                    Navigator.of(context).pop(); // Close dialog
                    widget.onAddressSelected(address, latitude, longitude);
                    Navigator.of(context).pop(); // Close bottom sheet
                  }
                } catch (e) {
                  if (context.mounted) {
                    CustomToast.show(
                      context,
                      S.of(context)!.error_occurred,
                      type: ToastType.error,
                    );
                  }
                }
              },
              child: Text(S.of(context)!.save),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteLocation(SavedLocation location) async {
    final space = Theme.of(context).extension<AppSpacing>()!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context)!.delete_location),
        content: Text(S.of(context)!.confirm_delete_location),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(space.screenPadding / 2),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(S.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(S.of(context)!.delete),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _savedLocationService.deleteLocation(location.id);
        if (mounted) {
          CustomToast.show(
            context,
            S.of(context)!.location_deleted_successfully,
            type: ToastType.success,
          );
          _loadSavedLocations();
        }
      } catch (e) {
        if (mounted) {
          CustomToast.show(
            context,
            S.of(context)!.error_occurred,
            type: ToastType.error,
          );
        }
      }
    }
  }

  Future<void> _toggleDefault(SavedLocation location) async {
    try {
      if (location.isDefault) {
        // Unset as default (set to empty string to clear)
        await _savedLocationService.setDefaultLocation('');
      } else {
        // Set as default
        await _savedLocationService.setDefaultLocation(location.id);
      }
      if (mounted) {
        _loadSavedLocations();
      }
    } catch (e) {
      if (mounted) {
        CustomToast.show(
          context,
          S.of(context)!.error_occurred,
          type: ToastType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final space = Theme.of(context).extension<AppSpacing>()!; //12
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(space.screenPadding),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(space.screenPadding),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(space.screenPadding),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, color: theme.primaryColor),
                SizedBox(width: space.screenPadding / 1.5),
                Text(
                  S.of(context)!.select_address,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(space.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // GPS Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isGettingCurrentLocation
                          ? null
                          : _getCurrentLocation,
                      icon: _isGettingCurrentLocation
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.my_location),
                      label: Text(
                        _isGettingCurrentLocation
                            ? S.of(context)!.getting_current_location
                            : S.of(context)!.use_current_location,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        foregroundColor: theme.scaffoldBackgroundColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),

                  SizedBox(height: space.screenPadding * 2),

                  // Saved Locations Section
                  Row(
                    children: [
                      Icon(Icons.bookmark, color: theme.primaryColor, size: 20),
                      SizedBox(width: space.screenPadding / 1.5),
                      Text(
                        S.of(context)!.saved_locations,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: space.screenPadding),

                  if (_isLoadingLocations)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (_savedLocations.isEmpty)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(space.screenPadding * 2),
                        child: Column(
                          children: [
                            Icon(
                              Icons.location_off,
                              size: 48,
                              color: theme.disabledColor,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              S.of(context)!.no_saved_locations,
                              style: TextStyle(color: theme.disabledColor),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _savedLocations.length,
                      separatorBuilder: (_, _) => const Divider(),
                      itemBuilder: (context, index) {
                        final location = _savedLocations[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: theme.primaryColor.withValues(
                              alpha: 0.1,
                            ),
                            child: Icon(
                              location.isDefault
                                  ? Icons.star
                                  : Icons.location_on,
                              color: theme.primaryColor,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            location.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            location.address,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: Row(
                                  children: [
                                    Icon(
                                      location.isDefault
                                          ? Icons.star_border
                                          : Icons.star,
                                      size: 20,
                                    ),
                                    SizedBox(width: space.screenPadding / 1.5),
                                    Text(
                                      location.isDefault
                                          ? S.of(context)!.unset_default
                                          : S.of(context)!.set_as_default,
                                    ),
                                  ],
                                ),
                                onTap: () => _toggleDefault(location),
                              ),
                              PopupMenuItem(
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.delete,
                                      size: 20,
                                      color: AppColors.danger,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(S.of(context)!.delete_location),
                                  ],
                                ),
                                onTap: () => _deleteLocation(location),
                              ),
                            ],
                          ),
                          onTap: () => _selectLocation(location),
                        );
                      },
                    ),

                  SizedBox(height: space.screenPadding * 2),

                  // Divider with OR text
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          S.of(context)!.or_divider,
                          style: TextStyle(
                            color: theme.disabledColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),

                  SizedBox(height: space.screenPadding * 2),

                  // Manual Address Input
                  Text(
                    S.of(context)!.manual_address,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: space.screenPadding),
                  TextField(
                    controller: _manualAddressController,
                    maxLines: 3,
                    onChanged: (value) {
                      // Reset validation state when user types
                      if (_validationError != null || _addressValidated) {
                        setState(() {
                          _validationError = null;
                          _addressValidated = false;
                          _pendingLatitude = null;
                          _pendingLongitude = null;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      hintText: S.of(context)!.enter_full_address,
                      border: const OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(space.screenPadding),
                      errorText: _validationError,
                      errorMaxLines: 2,
                      suffixIcon: _addressValidated
                          ? Icon(Icons.check_circle, color: theme.primaryColor)
                          : null,
                    ),
                  ),
                  SizedBox(height: space.screenPadding),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isValidatingAddress
                          ? null
                          : _validateAndConfirmAddress,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        foregroundColor: theme.scaffoldBackgroundColor,
                        padding: EdgeInsets.symmetric(
                          vertical: space.screenPadding,
                        ),
                      ),
                      child: _isValidatingAddress
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: theme.scaffoldBackgroundColor,
                                  ),
                                ),
                                SizedBox(width: space.screenPadding / 1.5),
                                Text(S.of(context)!.validating_address),
                              ],
                            )
                          : Text(S.of(context)!.confirm),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
