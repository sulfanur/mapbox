  import 'package:http/http.dart' as http;
  import 'dart:convert';
  import 'package:latlong2/latlong.dart';

  class MapRepository {
    final String accessToken = 'pk.eyJ1Ijoia2FybG9kZXYiLCJhIjoiY2xocTN1ZnVjMjB1NDNtcHNoMmI2N2dhcCJ9.5Y8fh8aPfM6f5zDKA_bDiw';
    final String baseUrl = 'https://api.mapbox.com';

    Future<dynamic> loadInitialMapData() async {
      return {
        "center": [37.7749, -122.4194], // San Francisco
        "zoom": 12.0
      };
    }

    Future<List<dynamic>> searchPlace(String query) async {
      final url = Uri.parse('$baseUrl/geocoding/v5/mapbox.places/$query.json?access_token=$accessToken');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['features'];
      } else {
        throw Exception('Failed to search location');
      }
    }

    Future<List<LatLng>> getRouteCoordinates(LatLng start, LatLng end) async {
      final url = Uri.parse(
        'https://api.mapbox.com/directions/v5/mapbox/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?geometries=geojson&access_token=$accessToken');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> coordinates = data['routes'][0]['geometry']['coordinates'];
        return coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
      } else {
        throw Exception('Failed to fetch route');
      }
    }
  }
