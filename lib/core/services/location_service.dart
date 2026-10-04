import 'package:nominatim_flutter/model/response/response.dart';

import '/core/app_export.dart';

class LocationService {
  LocationService._internal();
  static final LocationService instance = LocationService._internal();

  final nominatimService = NominatimService.instance;
  Preference preference = Preference.instance;

  Future<Map<String, dynamic>?> getCurrentAddress(LatLng target) async {
    try {
      return await nominatimService.reverse(
        lat: target.latitude,
        lon: target.longitude,
        language: '${preference.languageCode}',
      );
    } catch (e) {
      rethrow; // Rethrow to let caller handle the error
    }
  }

  Future<List<NominatimResponse>> search(String query) async {
    try {
      return await nominatimService.search(
        query: query,
        country: preference.countryCode,
        language: '${preference.languageCode}',
        countryCodes: [preference.countryCode ?? 'en'],
      );
    } catch (e) {
      rethrow; // Rethrow to let caller handle the error
    }
  }

  Future<Position?> getCurrentPosition() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled. Please enable them.');
      }

      // Check and request location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception(
            'Location permissions are denied. Please grant permission.',
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          'Location permissions are permanently denied. Please enable them in settings.',
        );
      }

      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          distanceFilter: 1,
          accuracy: LocationAccuracy.high,
        ),
      );

      return position;
    } catch (e) {
      rethrow; // Rethrow to let caller handle the error
    }
  }
}
