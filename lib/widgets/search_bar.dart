import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../services/mapbox_service.dart';
import '../blocs/map_bloc.dart';
import '../models/location.dart';

const String mapboxAccessToken = "pk.eyJ1Ijoia2FybG9kZXYiLCJhIjoiY2xocTN1ZnVjMjB1NDNtcHNoMmI2N2dhcCJ9.5Y8fh8aPfM6f5zDKA_bDiw";  // Gantilah dengan token Mapbox Anda

class SearchBarr extends StatefulWidget {
  const SearchBarr({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBarr> {
  final TextEditingController _controller = TextEditingController();
  List<Location> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: "Search for a place",
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () async {
                  final query = _controller.text;
                  if (query.isNotEmpty) {
                    try {
                      final results = await MapboxService().searchPlace(query);
                      setState(() {
                        _searchResults = results;
                      });
                    } catch (e) {
                      // ignore: use_build_context_synchronously
                      _showSnackbar(context, "Error: $e");
                    }
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final location = _searchResults[index];
                return ListTile(
                  title: Text(location.name),
                  onTap: () {
                    // Memusatkan peta pada lokasi yang dipilih
                    context.read<MapBloc>().add(AddMarkerEvent(
                        LatLng(location.latitude, location.longitude)));
                    _showSnackbar(context, 'Selected: ${location.name}');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
