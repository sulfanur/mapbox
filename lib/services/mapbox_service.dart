import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mapbox_integration_app/models/location.dart';

const String accessToken = "pk.eyJ1Ijoia2FybG9kZXYiLCJhIjoiY2xocTN1ZnVjMjB1NDNtcHNoMmI2N2dhcCJ9.5Y8fh8aPfM6f5zDKA_bDiw";  // Gantilah dengan token Mapbox Anda

class MapboxService {
  // Fungsi untuk mencari lokasi menggunakan Mapbox Geocoding API
  Future<List<Location>> searchPlace(String query) async {
    final url = "https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json?access_token=$accessToken";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['features'] as List)
          .map((e) => Location.fromJson(e))
          .toList();
    } else {
      throw Exception("Failed to load search results");
    }
  }

  // Fungsi untuk mendapatkan rute menggunakan Directions API
  Future<List<LatLng>> getRoute(LatLng start, LatLng end) async {
    final url = "https://api.mapbox.com/directions/v5/mapbox/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?access_token=$accessToken&geometries=geojson";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final route = data['routes'][0]['geometry']['coordinates'];
      return route.map<LatLng>((coord) => LatLng(coord[1], coord[0])).toList();
    } else {
      throw Exception("Failed to get route");
    }
  }
}
