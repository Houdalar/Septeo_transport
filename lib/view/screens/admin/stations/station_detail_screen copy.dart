import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../model/bus.dart';
import '../../../../model/station.dart';
import '../../../components/app_colors.dart';
import '../../../components/stations_bus.dart';

class StationDetailsScreen2 extends StatefulWidget {
  final Station station;

  const StationDetailsScreen2({super.key, required this.station});

  @override
  State<StationDetailsScreen2> createState() => _StationDetailsScreenState();
}

class _StationDetailsScreenState extends State<StationDetailsScreen2> {
  List listOfPoints = [];
  List<LatLng> points = [];

  String calculateTimeRemaining(String arrivalTime) {
    final DateTime now = DateTime.now();
    final List<String> timeParts = arrivalTime.split(':');
    final DateTime arrivalDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
      timeParts.length > 2 ? int.parse(timeParts[2]) : 0,
    );

    final Duration difference = arrivalDateTime.difference(now);

    if (difference.isNegative) {
      return "Gone";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} min";
    } else {
      return "${difference.inHours} h ${difference.inMinutes.remainder(60)} min";
    }
  }

  @override
  void initState() {
    super.initState();
    _getAndSetDirections();
  }

  getRouteUrl(String startPoint, String endPoint) {
    const String baseUrl =
        'https://api.openrouteservice.org/v2/directions/driving-car';
    const String apiKey =
        '5b3ce3597851110001cf6248f55d7a31499e40848c6848d7de8fa624';
    return Uri.parse(
        '$baseUrl?api_key=$apiKey&start=$startPoint&end=$endPoint');
  }

  void _getAndSetDirections() async {
    var response = await http.get(getRouteUrl(
        "1.243344,6.145332", '1.2160116523406839,6.125231015668568'));
    setState(() {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        listOfPoints = data['features'][0]['geometry']['coordinates'];
        points = listOfPoints
            .map((p) => LatLng(p[1].toDouble(), p[0].toDouble()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            FlutterMap(
              options: MapOptions(zoom: 15, center: LatLng(6.131015, 1.223898)),
              children: [
                // Layer that adds the map
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                ),
                // Layer that adds points the map
                MarkerLayer(
                  markers: [
                    // First Marker
                    Marker(
                      point: LatLng(6.145332, 1.243342),
                      width: 80,
                      height: 80,
                      builder: (context) => IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.location_on),
                        color: Colors.green,
                        iconSize: 45,
                      ),
                    ),
                    // Second Marker
                    Marker(
                      point: LatLng(6.125231015668568, 1.2160116523406839),
                      width: 80,
                      height: 80,
                      builder: (context) => IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.location_on),
                        color: Colors.red,
                        iconSize: 45,
                      ),
                    ),
                  ],
                ),
                PolylineLayer(
                  polylineCulling: false,
                  polylines: [
                    Polyline(
                        points: points,
                        color: const Color.fromARGB(255, 0, 4, 255),
                        strokeWidth: 5),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.primaryOrange,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    "Station ${widget.station.name}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryOrange,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 90,
              left: 15,
              right: 15,
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(0, 255, 255, 255),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 15.0,
                        spreadRadius: 2.0,
                        offset: Offset(
                          5.0,
                          5.0,
                        ),
                      )
                    ],
                  ),
                  child: ListView.separated(
                    itemCount: widget.station.arrivalTimes.length,
                    itemBuilder: (context, index) {
                      ArrivalTime arrivalTime =
                          widget.station.arrivalTimes[index];
                      Bus bus = arrivalTime.bus!;
                      return BusItemCard(
                        arrivalTime: arrivalTime,
                        bus: bus,
                        calculateTimeRemaining: calculateTimeRemaining,
                      );
                    },
                    separatorBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.0),
                      child: Divider(
                        color: Colors.grey,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 15,
              right: 15,
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  onPressed: () {
                    // Your action here...
                  },
                  child: const Text(
                    'Lets go',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
