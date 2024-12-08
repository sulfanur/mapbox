import 'package:latlong2/latlong.dart';

abstract class MapState {}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapLoaded extends MapState {
  final dynamic mapData;
  MapLoaded(this.mapData);
}

class SearchResults extends MapState {
  final List<dynamic> results;
  SearchResults(this.results);
}

class MapCentered extends MapState {
  final LatLng location;
  MapCentered(this.location);
}

class PolylineDrawn extends MapState {
  final List<LatLng> polylineCoordinates;
  PolylineDrawn(this.polylineCoordinates);
}

class MapError extends MapState {
  final String message;
  MapError(this.message);
}
