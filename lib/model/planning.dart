import 'package:septeo_transport/model/station.dart';

import 'bus.dart';

class Planning {
    String id;
    String user;
    String date ;
    bool isTakingBus;
    Station toStation;
    Station fromStation;
    Bus startbus;
    Bus finishbus;
    
  
    Planning({required this.id, required this.user, 
    required this.date, required this.isTakingBus, 
    required this.toStation, required this.fromStation, 
    required this.startbus, required this.finishbus
    });
  
    factory Planning.fromJson(Map<String, dynamic> json) {
      return Planning(
        id: json['_id'],
        user: json['user'],
        date: json['date'],
        isTakingBus: json['isTakingBus'],
        toStation: Station.fromJson(json['toStation']),
        fromStation: Station.fromJson(json['fromStation']),
        startbus: Bus.fromJson(json['startbus']),
        finishbus: Bus.fromJson(json['finishbus']),
      );
    }
  }
  