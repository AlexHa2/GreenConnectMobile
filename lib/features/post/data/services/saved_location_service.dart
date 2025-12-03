import 'dart:convert';

import 'package:GreenConnectMobile/features/post/domain/entities/saved_location_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedLocationService {
  static const String _storageKey = 'saved_locations';

  Future<List<SavedLocation>> getSavedLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final String? locationsJson = prefs.getString(_storageKey);
    
    if (locationsJson == null || locationsJson.isEmpty) {
      return [];
    }

    final List<dynamic> locationsList = json.decode(locationsJson);
    return locationsList
        .map((json) => SavedLocation.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<bool> saveLocation(SavedLocation location) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final locations = await getSavedLocations();
      
      // Check if location already exists
      final existingIndex = locations.indexWhere((loc) => loc.id == location.id);
      if (existingIndex != -1) {
        locations[existingIndex] = location;
      } else {
        locations.add(location);
      }

      final locationsJson = json.encode(
        locations.map((loc) => loc.toJson()).toList(),
      );
      
      return await prefs.setString(_storageKey, locationsJson);
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteLocation(String locationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final locations = await getSavedLocations();
      
      locations.removeWhere((loc) => loc.id == locationId);
      
      final locationsJson = json.encode(
        locations.map((loc) => loc.toJson()).toList(),
      );
      
      return await prefs.setString(_storageKey, locationsJson);
    } catch (e) {
      return false;
    }
  }

  Future<bool> setDefaultLocation(String locationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final locations = await getSavedLocations();
      
      // Remove default from all locations
      final updatedLocations = locations.map((loc) {
        return loc.copyWith(isDefault: loc.id == locationId);
      }).toList();
      
      final locationsJson = json.encode(
        updatedLocations.map((loc) => loc.toJson()).toList(),
      );
      
      return await prefs.setString(_storageKey, locationsJson);
    } catch (e) {
      return false;
    }
  }

  Future<SavedLocation?> getDefaultLocation() async {
    final locations = await getSavedLocations();
    try {
      return locations.firstWhere((loc) => loc.isDefault);
    } catch (e) {
      return null;
    }
  }
}
