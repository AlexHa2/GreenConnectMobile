import 'package:GreenConnectMobile/features/household/domain/entities/location_entity.dart';
import 'package:geocoding/geocoding.dart';

Future<LocationEntity?> getLocationFromAddress(String address) async {
  try {
    List<Location> locations = await locationFromAddress(address);
    if (locations.isNotEmpty) {
      final loc = locations.first;
      print(
        'Location found: Latitude ${loc.latitude}, Longitude ${loc.longitude}',
      );
      return LocationEntity(latitude: loc.latitude, longitude: loc.longitude);
    }
  } catch (e) {
    print('Error occurred while fetching location: $e');
  }
  return null;
}
