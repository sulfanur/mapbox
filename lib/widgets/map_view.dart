import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../blocs/map_bloc.dart';

const String mapboxAccessToken = "pk.eyJ1Ijoia2FybG9kZXYiLCJhIjoiY2xocTN1ZnVjMjB1NDNtcHNoMmI2N2dhcCJ9.5Y8fh8aPfM6f5zDKA_bDiwen";  // Gantilah dengan token Mapbox Anda

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        return MapboxMap(
          accessToken: mapboxAccessToken,
          styleString: "mapbox://styles/mapbox/streets-v11",  // Gaya peta
          initialCameraPosition: CameraPosition(
            target: state.center,
            zoom: 10,
          ),
          onMapCreated: (controller) {
            context.read<MapBloc>().mapController = controller;
            // Menambahkan marker jika ada
            for (var marker in state.markers) {
              controller.addSymbol(SymbolOptions(
                geometry: marker,
                iconImage: "marker-15",
              ));
            }
            // Menggambar polyline jika ada
            if (state.polylinePoints.isNotEmpty) {
              controller.addLine(LineOptions(
                geometry: state.polylinePoints,
                lineColor: "#FF0000",
                lineWidth: 5.0,
              ));
            }
          },
        );
      },
    );
  }
}
