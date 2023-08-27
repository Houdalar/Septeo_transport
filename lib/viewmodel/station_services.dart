import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../constatns.dart';
import '../model/station.dart';
import 'package:permission_handler/permission_handler.dart';

void requestLocationPermission() async {
  PermissionStatus permission = await Permission.location.status;
  if (!permission.isGranted) {
    await Permission.location.request();
  }
}

class StationService extends ChangeNotifier {
  final ApiService apiService;
  final key = dotenv.env['GOOGLE_API_KEY'];
  final apiKey = dotenv.env['GRAPHHOPPER_API_KEY'];
  StationService({required this.apiService});

  Future<List<Station>> fetchStations(String busId) async {
    print('fetchStations called with busId: $busId'); // Add this

    try {
      final response = await apiService.get('station/buses/$busId');
      print(
          'API Response: $response'); // This should print the raw API response

      if (response is List) {
        List<Station> stations = response
            .map((i) => Station.fromJson(i as Map<String, dynamic>))
            .toList();
        return stations;
      } else {
        throw Exception('API response is not a list');
      }
    } catch (e) {
      print(
          'Error in fetchStations: $e'); // This will print any exception that occurs
      throw Exception('Failed to load stations');
    }
  }

  Future<void> createStation(Station station) async {
    try {
      await apiService.post('station', {
        'name': station.name,
        'address': station.address,
        'location': {
          'lat': station.location.lat,
          'lng': station.location.lng,
        },
        'arrivaltime': station.arrivalTimes
            .map((e) => {'bus': e.bus, 'time': e.time})
            .toList(),
      });
    } catch (e) {
      throw Exception('Failed to create station');
    }
  }

  Future<List<Station>> getStations() async {
    var jsonResponse = await apiService.get('stations');
    return List<Station>.from(
        jsonResponse.map((model) => Station.fromJson(model)));
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
    return json['result'] as Map<String, dynamic>;
  }

  // google api
  Future<Map<String, dynamic>> getDirections(
      String origin, String destination) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$key';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);

    return {
      'bounds_ne': json['routes'][0]['bounds']['northeast'],
      'bounds_sw': json['routes'][0]['bounds']['southwest'],
      'start_location': json['routes'][0]['legs'][0]['start_location'],
      'end_location': json['routes'][0]['legs'][0]['end_location'],
      'polyline': json['routes'][0]['overview_polyline']['points'],
      'polyline_decoded': PolylinePoints()
          .decodePolyline(json['routes'][0]['overview_polyline']['points']),
    };
  }

// graphhopper api
  Future<List<LatLng>> getOpenRouteCoordinates(
      LatLng startPoint, LatLng endPoint) async {
    final String url =
        'https://graphhopper.com/api/1/route?point=${startPoint.latitude},${startPoint.longitude}&point=${endPoint.latitude},${endPoint.longitude}&vehicle=car&locale=en&key=$key';
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    String encodedPolyline = data['paths'][0]['points'];
    return PolylinePoints()
        .decodePolyline(encodedPolyline)
        .map((p) => LatLng(p.latitude, p.longitude))
        .toList();
  }

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

  void deleteStation(String id) async {
    await apiService.delete('station/$id');
  }

  Future<List<Station>> getPlanningStations(String busId) async {
    var jsonResponse = await apiService.get('stations/todayroute/$busId');
    if (jsonResponse.isEmpty) {
      return [];
    } else {
      try {
        List<Station> stations =
            jsonResponse.map((item) => Station.fromJson(item)).toList();
        return stations;
      } catch (e) {
        throw Exception('Error while converting API response to List<Station>');
      }
    }
  }
}
