import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

@immutable
class Suggestion {
  final String placeId;
  final String description;

  const Suggestion(this.placeId, this.description);
}

class PlaceApiProvider {
  final Client client = Client();
  final String? sessionToken;
  static final String apiKey = dotenv.get('GOOGLE_MAPS_API_KEY', fallback: 'key_not_found');

  PlaceApiProvider(this.sessionToken);

  Future<List<Suggestion>> fetchSuggestions(String input, String languageCode) async {
    if (input.isEmpty) return <Suggestion>[];

    final Uri requestUri = Uri.https('places.googleapis.com', 'v1/places:autocomplete');
    final headers = {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': apiKey,
    };
    final body = jsonEncode({
      "input": input,
      "languageCode": languageCode,
      "sessionToken": sessionToken,
    });

    try{
      final response = await client.post(requestUri, headers: headers, body: body);

      if (response.statusCode == 200) {
        return _parseSuggestions(response.body);
      } else {
        throw Exception('Failed to fetch suggestions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Request failed: $e');
    }
  }

  List<Suggestion> _parseSuggestions(String responseBody) {
    final result = jsonDecode(responseBody);
    if (result['suggestions'] == null) return [];

    return result['suggestions']
      .map<Suggestion>((json) => Suggestion(
          json['placePrediction']['placeId'] as String,
          json['placePrediction']['text']['text'] as String))
      .toList();
  }

  Future<LatLng> getPlaceCoordinatesFromId(String placeId) async {
    final Uri requestUri =
      Uri.https('places.googleapis.com', 'v1/places/$placeId', {
      'key': apiKey,
      'fields': 'location',
      'sessionToken': sessionToken,
    });

    try {
      final response = await client.get(requestUri);

      if (response.statusCode == 200) {
        return _parseCoordinates(response.body);
      } else {
        throw Exception('Failed to load place coordinates: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Request failed: $e');
    }
  }

  LatLng _parseCoordinates(String responseBody) {
    final result = jsonDecode(responseBody);
    if (
      result.containsKey('location') &&
      result['location'].containsKey('latitude') &&
      result['location'].containsKey('longitude')
    ) {
      final latitude = result['location']['latitude'];
      final longitude = result['location']['longitude'];
      return LatLng(latitude, longitude);
    }

    return const LatLng(0, 0);
  }
}
