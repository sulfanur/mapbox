// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_integration_app/blocs/map_event.dart';
import 'package:mapbox_integration_app/blocs/map_state.dart';
import '../blocs/map_bloc.dart';
import '../widgets/map_view.dart';
import '../widgets/search_bar.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MapBloc>().add(LoadMapDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapbox Integration'),
      ),
      body: Column(
        children: [
          // Letakkan Search Bar di atas map
          const Search(),

          // Hasil pencarian akan ditampilkan di bawah search bar
          Expanded(
            child: BlocBuilder<MapBloc, MapState>(
              builder: (context, state) {
                if (state is MapLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MapLoaded) {
                  return MapView(
                    data: state.mapData,
                    center: state.mapData['center'] != null
                        ? LatLng(state.mapData['center'][0],
                            state.mapData['center'][1])
                        : const LatLng(-6.1751,
                            106.8272),
                    polylineCoordinates: state.mapData['polylineCoordinates'],
                  );
                } else if (state is SearchResults) {
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.results.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(state.results[index]['place_name']),
                              onTap: () {
                                final coordinates = state.results[index]
                                    ['geometry']['coordinates'];
                                context
                                    .read<MapBloc>()
                                    .add(SelectSearchResultEvent(
                                      coordinates[1],
                                      coordinates[0],
                                    )); // Memusatkan peta pada hasil pencarian
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                } else if (state is MapCentered) {
                  return MapView(
                    center: state
                        .location,
                  );
                } else if (state is PolylineDrawn) {
                  return MapView(
                    polylineCoordinates:
                        state.polylineCoordinates,
                  );
                } else if (state is MapError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text('Load the map'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
