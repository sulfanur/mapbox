import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/map_bloc.dart';
import '../blocs/map_event.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'Search for a place...',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            context.read<MapBloc>().add(SearchPlaceEvent(value)); // Kirim event untuk pencarian
          }
        },
      ),
    );
  }
}