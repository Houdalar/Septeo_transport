class Bus {
  String id;
  List<String> stations;
  String driver;
  int capacity;
  //DateTime startDate;
  String busNumber ;

  Bus({required this.id, required this.stations,
   required this.driver, required this.capacity , required this.busNumber});

  factory Bus.fromJson(Map<String, dynamic> json) {
    var list = json['stations'] as List;
    List<String> stationsList = list.map((i) => i.toString()).toList();

    return Bus(
      id: json['_id'],
      stations: stationsList,
      driver: json['driver'],
      capacity: json['capacity'],
      //startDate: DateTime.parse(json['startDate']),
      busNumber: json['busNumber'],
    );
  }
}