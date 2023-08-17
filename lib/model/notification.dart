class notification {
  String id;
  String message;
  String busNumber;
  DateTime timeSent;
  notification(
      {required this.id,
      required this.message,
      required this.busNumber,
      required this.timeSent});

  factory notification.fromJson(Map<String, dynamic> json) {
    return notification(
      id: json['id'],
      message: json['message'],
      busNumber: json['busNumber'],
      timeSent: DateTime.parse(json['timeSent']),
    );
  }
}
