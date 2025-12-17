import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class CheckInLocationDialog extends StatefulWidget {
  final String transactionId;

  const CheckInLocationDialog({super.key, required this.transactionId});

  @override
  State<CheckInLocationDialog> createState() => _CheckInLocationDialogState();
}

class _CheckInLocationDialogState extends State<CheckInLocationDialog> {
  bool _isLoading = false;
  String? _errorMessage;
  double? _latitude;
  double? _longitude;

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Use platform channel to get location
      // This is a simple implementation - in production, use geolocator package
      // For now, we'll use a basic approach

      // Try to get location using platform channels
      // Note: This requires location permissions in AndroidManifest.xml and Info.plist
      final location = await _getLocationFromPlatform();

      if (location != null) {
        setState(() {
          _isLoading = false;
          _latitude = location['latitude'];
          _longitude = location['longitude'];
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = S.of(context)!.location_fetch_error;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = S.of(context)!.location_fetch_error;
      });
    }
  }

  Future<Map<String, double>?> _getLocationFromPlatform() async {
    try {
      // Check location service is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high,
      );

      return {'latitude': position.latitude, 'longitude': position.longitude};
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!.screenPadding;
    final s = S.of(context)!;

    return AlertDialog(
      backgroundColor: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(spacing),
      ),
      title: Row(
        children: [
          Icon(Icons.location_on, color: theme.primaryColor),
          SizedBox(width: spacing),
          Expanded(child: Text(s.check_in)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            )
          else if (_errorMessage != null)
            Padding(
              padding: EdgeInsets.all(spacing),
              child: Column(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: AppColors.danger,
                    size: spacing * 4,
                  ),
                  SizedBox(height: spacing),
                  Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.danger,
                    ),
                  ),
                ],
              ),
            )
          else if (_latitude != null && _longitude != null)
            Column(
              children: [
                Icon(
                  Icons.check_circle,
                  color: theme.primaryColor,
                  size: spacing * 4,
                ),
                SizedBox(height: spacing),
                Text(
                  s.location_fetched_successfully_toast,
                  style: theme.textTheme.bodyMedium,
                ),
                SizedBox(height: spacing / 2),
                Text(
                  s.location_coordinates(
                    _latitude!.toStringAsFixed(6),
                    _longitude!.toStringAsFixed(6),
                  ),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ],
            ),
          SizedBox(height: spacing),
          Text(
            s.check_in_message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(s.cancel),
        ),
        ElevatedButton(
          onPressed: (_latitude != null && _longitude != null && !_isLoading)
              ? () => Navigator.of(
                  context,
                ).pop({'latitude': _latitude, 'longitude': _longitude})
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            foregroundColor: theme.scaffoldBackgroundColor,
          ),
          child: Text(s.check_in),
        ),
      ],
    );
  }
}
