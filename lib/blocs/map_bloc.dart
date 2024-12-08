import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'map_event.dart';
import 'map_state.dart';
import '../repositories/map_repository.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final MapRepository repository;
  MapBloc(this.repository) : super(MapInitial()) {
    on<LoadMapDataEvent>((event, emit) async {
      emit(MapLoading());
      try {
        // Koordinat lima titik di sekitar Monas, Jakarta
        final polylineCoordinates = [
          const LatLng(-6.1751, 106.8272), // Titik 1: Monas
          const LatLng(-6.1740, 106.8275), // Titik 2
          const LatLng(-6.1730, 106.8260), // Titik 3
          const LatLng(-6.1760, 106.8255), // Titik 4
          const LatLng(-6.1770, 106.8280), // Titik 5
        ];

        emit(PolylineDrawn(polylineCoordinates));

        // Emit data peta
        emit(MapLoaded({
          'center': [-6.1751, 106.8272],
          'zoom': 15.0,
        }));
      } catch (e) {
        emit(MapError(e.toString()));
      }
    });

    on<SearchPlaceEvent>((event, emit) async {
      try {
        final results = await repository.searchPlace(event.query);
        emit(SearchResults(results)); // Emit hasil pencarian
      } catch (e) {
        emit(MapError(e.toString()));
      }
    });

    on<SelectSearchResultEvent>((event, emit) {
      emit(MapCentered(LatLng(event.latitude,
          event.longitude)));
    });

    on<DrawPolylineEvent>((event, emit) async {
      try {
        final polyline =
            await repository.getRouteCoordinates(event.start, event.end);
        emit(PolylineDrawn(polyline)); // Emit polyline untuk peta
      } catch (e) {
        emit(MapError(e.toString()));
      }
    });
  }
}
