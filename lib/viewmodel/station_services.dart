import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../model/station.dart';

import 'package:permission_handler/permission_handler.dart';

void requestLocationPermission() async {
  PermissionStatus permission = await Permission.location.status;
  if (!permission.isGranted) {
    await Permission.location.request();
  }
}

class StationService extends ChangeNotifier {
  static String baseUrl = "10.0.2.2:808";

  final String key = 'AIzaSyADG1lENsRv14KlWdZgXOuMfcl_lf0MaXA';
  static const String apiKey =
      '5b3ce3597851110001cf6248f55d7a31499e40848c6848d7de8fa624';

  final List<Station> _stations = [];
  List<Station> get stations {
    return [..._stations];
  }

  StationService();

  static Future<List<Station>> fetchStations(
    String busId,
  ) async {
    final response = await http.get(
      Uri.parse('http://$baseUrl/station/buses/$busId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var stationList = json.decode(response.body) as List;
      List<Station> stations =
          stationList.map((i) => Station.fromJson(i)).toList();
      return stations;
    } else {
      throw Exception('Failed to load stations');
    }
  }

  Future<void> createStation(Station station, BuildContext context) async {
    final response = await http.post(
      Uri.parse('http://$baseUrl/station'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': station.name,
        'address': station.address,
        'location': {
          'lat': station.location.lat,
          'lng': station.location.lng,
        },
        'arrivaltime': station.arrivalTimes
            .map((e) => {'bus': e.bus, 'time': e.time})
            .toList(),
      }),
    );

    if (response.statusCode == 200) {
      // return Station.fromJson(jsonDecode(response.body));
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Station created successfully.'),
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
              content: Text(
                  'Failed to create station. ${jsonDecode(response.body)['message']}'),
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

  static Future<List<Station>> getStations() async {
    final String url = 'http://$baseUrl/stations';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Iterable jsonResponse = jsonDecode(response.body);
      List<Station> stations = List<Station>.from(
          jsonResponse.map((model) => Station.fromJson(model)));
      return stations;
    } else {
      throw Exception('Failed to load stations');
    }
  }

  Future<String> getPlaceId(String input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var placeId = json['candidates'][0]['place_id'] as String;

    return placeId;
  }

  Future<Map<String, dynamic>> getPlace(String input) async {
    final placeId = await getPlaceId(input);

    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var results = json['result'] as Map<String, dynamic>;

    print(results);
    return results;
  }

  Future<Map<String, dynamic>> getDirections(
      String origin, String destination) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=AIzaSyB7tqa4d4erBKHaZ_fNzBjjN4BRVKrU_iI';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);

    if (json['status'] != 'OK') {
      print(json);
      throw Exception('Error fetching directions: ${json['status']}');
    }

    if (json['routes'].isEmpty) {
      throw Exception('No routes found for given origin and destination');
    }

    var results = {
      'bounds_ne': json['routes'][0]['bounds']['northeast'],
      'bounds_sw': json['routes'][0]['bounds']['southwest'],
      'start_location': json['routes'][0]['legs'][0]['start_location'],
      'end_location': json['routes'][0]['legs'][0]['end_location'],
      'polyline': json['routes'][0]['overview_polyline']['points'],
      'polyline_decoded': PolylinePoints()
          .decodePolyline(json['routes'][0]['overview_polyline']['points']),
    };

    // Temporarily return static data
    /* return Future.delayed(const Duration(seconds: 1), () {
      List<PointLatLng> points = createStaticPolylinePoints();
      return {
        'bounds_ne': {
          'lat': 36.85297,
          'lng': 10.19201,
        },
        'bounds_sw': {
          'lat': 36.84790,
          'lng': 10.26857,
        },
        'start_location': {
          'lat': 36.85297,
          'lng': 10.19201,
        },
        'end_location': {
          'lat': 36.84790,
          'lng': 10.26857,
        },
        'polyline': 'encodedPolylineString',
        'polyline_decoded': points,
      };
    });*/
    return results;
  }

  List<PointLatLng> createStaticPolylinePoints() {
    // Generate some static polyline points
    // Assuming a straight path from the origin to the destination
    return [
      const PointLatLng(36.85297, 10.19201),
      const PointLatLng(36.84790, 10.26857),
    ];
  }
//return results ;

  Future<List<LatLng>> getOpenRouteCoordinates(
      LatLng startPoint, LatLng endPoint) async {
    var response = await http.get(getGraphHopperRouteUrl(startPoint, endPoint));

    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String encodedPolyline = data['paths'][0]['points'];
      List<LatLng> points = decodePolyline(encodedPolyline);
      return points;
    } else {
      throw Exception('Failed to load coordinates');
    }
  }

/*Uri getRouteUrl(LatLng startPoint, LatLng endPoint) {
  return Uri.parse('https://www.openstreetmap.org/directions?api_key=$apiKey&start=${startPoint.latitude},${startPoint.longitude}&end=${endPoint.latitude},${endPoint.longitude}');
}*/
  Uri getGraphHopperRouteUrl(LatLng startPoint, LatLng endPoint) {
    return Uri.parse(
        'https://graphhopper.com/api/1/route?point=${startPoint.latitude},${startPoint.longitude}&point=${endPoint.latitude},${endPoint.longitude}&vehicle=car&locale=en&key=2922eb17-0b68-43d8-bd67-36046c2fa94e');
  }

  List<LatLng> decodePolyline(String encoded) {
    var decodedPoints = PolylinePoints().decodePolyline(encoded);
    List<LatLng> points =
        decodedPoints.map((p) => LatLng(p.latitude, p.longitude)).toList();
    return points;
  }

  void deleteStation(String id, BuildContext context) async {
    final response = await http.delete(
      Uri.parse('http://$baseUrl/station/$id'),
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

  static Future<List<Station>> getPlanningStations(String busId) async {
    final response =
        await http.get(Uri.parse('http://$baseUrl/stations/todayroute/$busId'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      if (jsonResponse.isEmpty) {
        // Return an empty list if the jsonResponse is empty
        print(jsonResponse);
        return [];
      } else {
        return jsonResponse.map((item) => Station.fromJson(item)).toList();
      }
    } else {
      throw Exception('Failed to load stations');
    }
  }
}

 
 // }