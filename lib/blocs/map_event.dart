import 'package:latlong2/latlong.dart';

abstract class MapEvent {}

class LoadMapDataEvent extends MapEvent {}

class SearchPlaceEvent extends MapEvent {
  final String query;
  SearchPlaceEvent(this.query);
}

class SelectSearchResultEvent extends MapEvent {
  final double latitude;
  final double longitude;
  SelectSearchResultEvent(this.latitude, this.longitude);
}

class DrawPolylineEvent extends MapEvent {
  final LatLng start;
  final LatLng end;
  DrawPolylineEvent(this.start, this.end);
}
