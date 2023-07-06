import 'package:septeo_transport/model/station.dart';

import 'bus.dart';

class Planning {
    String id;
    String user;
    String dayOfWeek;
    bool isTakingBus;
    Station toStation;
    Station fromStation;
    Bus bus;
    String time ;
    
  
    Planning({required this.id, required this.user, 
    required this.dayOfWeek, required this.isTakingBus, 
    required this.toStation, required this.fromStation, 
    required this.bus, required this.time});
  
    factory Planning.fromJson(Map<String, dynamic> json) {
      return Planning(
        id: json['_id'],
        user: json['user'],
        dayOfWeek: json['dayOfWeek'],
        isTakingBus: json['isTakingBus'],
        toStation: json['toStation'],
        fromStation: json['fromStation'],
        bus: Bus.fromJson(json['bus']),
        time:json['fromStation'],
      );
    }
  }
  