// ignore_for_file: deprecated_member_use, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapView extends StatelessWidget {
  final dynamic data;
  final LatLng? center;
  final List<LatLng>? polylineCoordinates;

  const MapView({super.key, this.data, this.center, this.polylineCoordinates});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: center ?? const LatLng(-6.1751, 106.8272),
        zoom: data?['zoom'] ?? 12.0,
      ),
      children: [
        TileLayer(
          urlTemplate:
              "https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}",
          additionalOptions: {
            'accessToken':
                'pk.eyJ1Ijoia2FybG9kZXYiLCJhIjoiY2xocTN1ZnVjMjB1NDNtcHNoMmI2N2dhcCJ9.5Y8fh8aPfM6f5zDKA_bDiw',
            'id': 'mapbox/streets-v11',
          },
        ),
        if (polylineCoordinates != null && polylineCoordinates!.isNotEmpty)
          PolylineLayer(
            polylines: [
              Polyline(
                points: polylineCoordinates!,
                strokeWidth: 4.0,
                color: Colors.blue,
              ),
            ],
          ),
        if (center != null)
          MarkerLayer(
            markers: [
              Marker(
                point: center!,
                width: 80.0,
                height: 80.0,
                child: const Icon(Icons.location_on, color: Colors.red),
              ),
            ],
          ),
      ],
    );
  }
}
