import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class MapEvent {}

class AddMarkerEvent extends MapEvent {
  final LatLng location;
  AddMarkerEvent(this.location);
}

class DrawPolylineEvent extends MapEvent {
  final List<LatLng> points;
  DrawPolylineEvent(this.points);
}

class MapState {
  final LatLng center;
  final List<LatLng> markers;
  final List<LatLng> polylinePoints;

  MapState({
    required this.center,
    required this.markers,
    required this.polylinePoints,
  });

  MapState copyWith({
    LatLng? center,
    List<LatLng>? markers,
    List<LatLng>? polylinePoints,
  }) {
    return MapState(
      center: center ?? this.center,
      markers: markers ?? this.markers,
      polylinePoints: polylinePoints ?? this.polylinePoints,
    );
  }
}

class MapBloc extends Bloc<MapEvent, MapState> {
  MapboxMapController? mapController;

  MapBloc()
      : super(MapState(
          center: const LatLng(-6.2088, 106.8456),  // Jakarta
          markers: [],
          polylinePoints: [],
        ));

  Stream<MapState> mapEventToState(MapEvent event) async* {
    if (event is AddMarkerEvent) {
      final newMarkers = List<LatLng>.from(state.markers)..add(event.location);
      yield state.copyWith(markers: newMarkers);
      mapController?.addSymbol(SymbolOptions(
        geometry: event.location,
        iconImage: "marker-15",
      ));
    } else if (event is DrawPolylineEvent) {
      yield state.copyWith(polylinePoints: event.points);
      mapController?.addLine(LineOptions(
        geometry: event.points,
        lineColor: "#FF0000",
        lineWidth: 5.0,
      ));
    }
  }
}
