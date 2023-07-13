import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import '../../../../model/bus.dart';
import '../../../../model/station.dart';
import '../../../../viewmodel/station_services.dart';
import '../../../components/app_colors.dart';
import '../../../components/stations_bus.dart';

class StationDetailsScreen extends StatefulWidget {
  final Station station;

  const StationDetailsScreen({super.key, required this.station});

  @override
  State<StationDetailsScreen> createState() => _StationDetailsScreenState();
}

class _StationDetailsScreenState extends State<StationDetailsScreen> {
  final Set<Marker> _markers = <Marker>{};
  final Set<Polygon> _polygons = <Polygon>{};
  final Set<Polyline> _polylines = <Polyline>{};
  List<LatLng> polygonLatLngs = <LatLng>[];

  int _polygonIdCounter = 1;
  int _polylineIdCounter = 1;

  final StationService stationService = StationService();

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
void _getAndSetDirections() async {
  List<LatLng> directions = await stationService.getOpenRouteCoordinates(
    LatLng(widget.station.location.lat, widget.station.location.lng),
    LatLng(36.84790,10.26857),
    
  );

  print('Directions: $directions');

  setState(() {
    _setPolyline(directions);
  });
}

  void _setPolygon() {
    final String polygonIdVal = 'polygon_$_polygonIdCounter';
    _polygonIdCounter++;

    _polygons.add(
      Polygon(
        polygonId: PolygonId(polygonIdVal),
        points: polygonLatLngs,
        strokeWidth: 2,
        fillColor: const Color.fromARGB(255, 230, 11, 3),
      ),
    );
  }

  void _setPolyline(List<LatLng> points) {
  final String polylineIdVal = 'polyline_$_polylineIdCounter';
  _polylineIdCounter++;

  _polylines.add(
    Polyline(
      polylineId: PolylineId(polylineIdVal),
      width: 2,
      color: Colors.blue,
      points: points,
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    widget.station.location.lat, widget.station.location.lng),
                zoom: 17.7746,
              ),
              markers: {
                Marker(
                  markerId: MarkerId(widget.station.id),
                  position: LatLng(
                      widget.station.location.lat, widget.station.location.lng),
                      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
                ),
                Marker(
                  markerId: const MarkerId("septeo"),
                  position: const LatLng(36.84790, 10.26857),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueBlue),
                ),
              },
              polylines: _polylines,
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
                    color: Color.fromARGB(0, 255, 255, 255) ,
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
                      ArrivalTime arrivalTime = widget.station.arrivalTimes[index];
                      Bus bus = arrivalTime
                          .bus!; 
                      return BusItemCard(
                        arrivalTime: arrivalTime,
                        bus: bus,
                        calculateTimeRemaining: calculateTimeRemaining,
                      );
                    },
                    separatorBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0), 
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
