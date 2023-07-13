import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:septeo_transport/model/bus.dart';
import 'package:septeo_transport/model/station.dart';
import 'package:septeo_transport/view/components/app_colors.dart';
import '../../../../viewmodel/station_services.dart';
import '../../../components/timeline_station.dart';
import 'details_tab.dart';
import 'stations_tab.dart';

class BusDetailsScreen extends StatefulWidget {
  final Bus bus;

  const BusDetailsScreen({super.key, required this.bus});

  @override
  _BusDetailsScreenState createState() => _BusDetailsScreenState();
}

class _BusDetailsScreenState extends State<BusDetailsScreen> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(36.84790, 10.26857);
  final StationService stationService = StationService();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<List<Station>> fetchStations() async {
    // Call the API to fetch the stations
    List<Station> stations = await StationService.fetchStations(widget.bus.id);
    return stations;
  }

  Set<Marker> createMarkers(List<Station> stations) {
    return stations.map((station) {
      return Marker(
        markerId: MarkerId(station.id),
        position: LatLng(station.location.lat, station.location.lng),
        infoWindow: InfoWindow(
          title: station.name,
          snippet: station.address,
        ),
      );
    }).toSet();
  }

Future<Set<Polyline>> createPolylines(List<Station> stations) async {
  PolylineId id = const PolylineId('poly');
  
  List<LatLng> polylineCoordinates = [];

  for (var i = 0; i < stations.length - 1; i++) {
    List<LatLng> route = await stationService.getOpenRouteCoordinates(
      LatLng(stations[i].location.lat, stations[i].location.lng),
      LatLng(stations[i + 1].location.lat, stations[i + 1].location.lng)
    );
    polylineCoordinates.addAll(route);
  }

  Polyline polyline = Polyline(
    polylineId: id,
    color: Colors.blue,
    points: polylineCoordinates,
    width: 2,
  );

  return {polyline};
}
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            FutureBuilder<List<Station>>(
              future: fetchStations(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Station>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<Station> stations = snapshot.data!;
                  Set<Marker> markers = createMarkers(stations);

                  return FutureBuilder<Set<Polyline>>(
                      future: createPolylines(stations),
                      builder: (BuildContext context,
                          AsyncSnapshot<Set<Polyline>> polylineSnapshot) {
                        if (polylineSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (polylineSnapshot.hasError) {
                          return Text('Error: ${polylineSnapshot.error}');
                        } else {
                          Set<Polyline> polylines = polylineSnapshot.data!;

                          return GoogleMap(
                            cameraTargetBounds: CameraTargetBounds.unbounded,
                            mapType: MapType.normal,
                            onMapCreated: _onMapCreated,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                  stations.isNotEmpty
                                      ? stations[0].location.lat
                                      : _center.latitude,
                                  stations.isNotEmpty
                                      ? stations[0].location.lng
                                      : _center.longitude),
                              zoom: 13.0,
                            ),
                            markers: markers,
                            polylines: polylines,
                          );
                        }
                      });
                }
              },
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.5,
              minChildSize: 0.4,
              maxChildSize: 0.8,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return FutureBuilder<List<Station>>(
                  future: fetchStations(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Station>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<Station> stations = snapshot.data!;
                      return createStationList(stations,
                          scrollController); // Create station list function
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget createStationList(
      List<Station> stations, ScrollController scrollController) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const SizedBox(height: 10),
            const SizedBox(
              height: 3,
              child: Center(
                child: Icon(
                  Icons.drag_handle,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const TabBar(
              labelStyle: TextStyle(fontSize: 18),
              indicatorColor: AppColors.primaryOrange,
              labelColor: AppColors.primaryOrange,
              unselectedLabelColor: Colors.grey,
              indicatorWeight: 1,
              indicatorPadding: EdgeInsetsDirectional.symmetric(horizontal: 50),
              tabs: [
                Tab(
                  text: 'stations',
                ),
                Tab(text: 'details'),
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              child: TabBarView(
                children: [
                  StationsTab(
                      stations: stations, scrollController: scrollController),
                  BusDetailsTab(
                      scrollController: scrollController, bus: widget.bus),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
