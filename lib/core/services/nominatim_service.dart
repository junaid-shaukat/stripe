import 'package:nominatim_flutter/model/request/request.dart';
import 'package:nominatim_flutter/model/response/response.dart';

import '/core/app_export.dart';

class NominatimService {
  NominatimService._();
  static NominatimService instance = NominatimService._();

  Api api = Api.instance;

  Future<List<NominatimResponse>> search({
    String? city,
    String? state,
    int limit = 5,
    String? street,
    String? county,
    String? country,
    ViewBox? viewBox,
    String? postalCode,
    required String query,
    bool extraTags = true,
    bool nameDetails = true,
    List<String>? countryCodes,
    bool addressDetails = true,
    List<String>? excludePlaceIds,
    String language = 'en-US,en;q=0.5',
  }) async {
    try {
      final searchRequest = SearchRequest(
        city: city,
        query: query,
        limit: limit,
        state: state,
        street: street,
        county: county,
        country: country,
        viewBox: viewBox,
        language: language,
        extraTags: extraTags,
        postalCode: postalCode,
        nameDetails: nameDetails,
        countryCodes: countryCodes,
        addressDetails: addressDetails,
        excludePlaceIds: excludePlaceIds,
      );

      // Perform a search
      final response = await NominatimFlutter.instance.search(
        language: language,
        searchRequest: searchRequest,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> reverse({
    required double lat,
    required double lon,
    String language = 'en-US,en;q=0.5',
  }) async {
    try {
      final reverseRequest = ReverseRequest(
        lat: lat,
        lon: lon,
        extraTags: true,
        nameDetails: true,
        addressDetails: true,
      );

      final reverseResult = await NominatimFlutter.instance.reverse(
        language: language,
        reverseRequest: reverseRequest,
      );
      return reverseResult.address;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> status([int? timestamp]) async {
    try {
      final response = await NominatimFlutter.instance.status();
      return response.status == Status.ok;
    } catch (e) {
      rethrow;
    }
  }
}
