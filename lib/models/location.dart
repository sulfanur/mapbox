class Location {
  final String name;
  final double latitude;
  final double longitude;

  Location({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    final coordinates = json['geometry']['coordinates'];
    return Location(
      name: json['place_name'],
      latitude: coordinates[1],
      longitude: coordinates[0],
    );
  }

  @override
  String toString() {
    return "$name ($latitude, $longitude)";
  }
}
