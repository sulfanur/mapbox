import 'package:flutter/material.dart';
import '../widgets/map_view.dart';
import '../widgets/search_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mapbox Integration"),
      ),
      body: const Column(
        children: [
          SearchBarr(),
          Expanded(child: MapView()),
        ],
      ),
    );
  }
}
