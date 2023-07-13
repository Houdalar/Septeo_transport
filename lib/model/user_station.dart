class UserStation {
  String id;
  String user;
  String station;
  DateTime arrivalTime;

  UserStation({required this.id, required this.user, required this.station, required this.arrivalTime});

  factory UserStation.fromJson(Map<String, dynamic> json) {
    return UserStation(
      id: json['_id'],
      user: json['user'],
      station: json['station'],
      arrivalTime: DateTime.parse(json['arrivalTime']),
    );
  }
}