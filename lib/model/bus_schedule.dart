class BusSchedule {
  String id;
  String bus;
  String station;
  DateTime estimatedArrivalTime;

  BusSchedule({required this.id, required this.bus, required this.station, required this.estimatedArrivalTime});

  factory BusSchedule.fromJson(Map<String, dynamic> json) {
    return BusSchedule(
      id: json['_id'],
      bus: json['bus'],
      station: json['station'],
      estimatedArrivalTime: DateTime.parse(json['estimatedArrivalTime']),
    );
  }
}