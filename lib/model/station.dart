class Station {
  final String name;
  final String address;
  final Location location;
  final String image;

  Station({
    required this.name,
    required this.address,
    required this.location,
    required this.image,
  });
}

class Location {
  final double lat;
  final double lng;

  Location({required this.lat, required this.lng});
}