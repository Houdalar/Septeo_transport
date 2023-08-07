import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:septeo_transport/model/bus.dart';


import 'package:permission_handler/permission_handler.dart';

void requestLocationPermission() async {
  PermissionStatus permission = await Permission.location.status;
  if (!permission.isGranted) {
    await Permission.location.request();
  }
}

class BusService extends ChangeNotifier {
  //static String baseUrl = "10.0.2.2:8080";
  static String baseUrl = "10.0.2.2:62668";
 // static String baseUrl = "192.168.250.165:8080"; // for real device
  final List<Bus> _bus = [];
  List<Bus> get bus {
    return [..._bus];
  }

  BusService();



  Future<List<Bus>> getBus() async {
    final String url = 'http://$baseUrl/buses';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Iterable jsonResponse = jsonDecode(response.body);
      print('Decoded response: $jsonResponse');
      List<Bus> bus = List<Bus>.from(jsonResponse.map((model) => Bus.fromJson(model)));
      return bus;
    } else {
      throw Exception('Failed to load buses');
    }
  }

  Future<void> createNewBus(int capacity, String busNumber,BuildContext context) async {
    final response = await http.post(
      Uri.parse('http://$baseUrl/bus'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'capacity': capacity,
        'busNumber': busNumber,
      }),
    );

    if (response.statusCode == 201) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Bus created successfully.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Failed to create bus'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            );
          });
    }
  }

   Future<void> deleteBus(String id, BuildContext context) async {
    final response = await http.delete(
      Uri.parse('http://$baseUrl/bus/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    // print(response.statusCode);

    if (response.statusCode != 200) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Failed to create bus'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            );
          });
    }
  }

   static Future<bool> updateBus(String busId , int capacity , String busNumber)async {
    final response = await http.put(
      Uri.parse('http://$baseUrl/bus/$busId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'capacity': capacity,
        'busNumber': busNumber,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    }
    
    return false;
  }

}
