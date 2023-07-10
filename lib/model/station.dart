

import 'package:septeo_transport/model/bus.dart';

class Station {
  final String id;
  final String name;
  final String address;
  final Location location;
  final List<ArrivalTime> arrivalTimes;

  Station({
    required this.id,
    required this.name,
    required this.address,
    required this.location,
    required this.arrivalTimes,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['_id'],
      name: json['name'],
      address: json['address'],
      location: Location.fromJson(json['location']),
      arrivalTimes: (json['arrivaltime'] as List?)
    ?.map((e) => ArrivalTime.fromJson(e))
    .toList() ?? [],
    );
  }
}

class Location {
  final double lat;
  final double lng;

  Location({required this.lat, required this.lng});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(lat: json['lat'], lng: json['lng']);
  }
}

class ArrivalTime {
  final Bus? bus;
  final String? time;

  ArrivalTime({required this.bus, required this.time});

  factory ArrivalTime.fromJson(Map<String, dynamic> json) {
    return ArrivalTime(
      bus: json['bus'] != null ? Bus.fromJson(json['bus']) : null, // add null check
      time: json['time'],
    );
  }
}

