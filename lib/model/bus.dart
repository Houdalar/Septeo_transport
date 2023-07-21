class Bus {
  String id;
  int capacity;

  String busNumber ;

  Bus({required this.id, 
    required this.capacity , required this.busNumber});

  factory Bus.fromJson(Map<String, dynamic> json) {

    return Bus(
      id: json['_id'],
     
      capacity: json['capacity'],
      
      busNumber: json['busNumber'],
    );
  }
}