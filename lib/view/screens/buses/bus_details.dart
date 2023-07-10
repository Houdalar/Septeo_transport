import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:septeo_transport/model/bus.dart';
import 'package:septeo_transport/model/station.dart';

import '../../../viewmodel/bus_services.dart';
import '../../../viewmodel/station_services.dart';
import '../../components/station_item.dart';
//import 'package:septeo_transport/view/screens/bus/edit_bus_screen.dart';

class BusDetailsScreen extends StatefulWidget {
  final Bus bus;

  BusDetailsScreen({required this.bus});

  @override
  _BusDetailsScreenState createState() => _BusDetailsScreenState();
}

class _BusDetailsScreenState extends State<BusDetailsScreen> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(36.84790, 10.26857);
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<List<Station>> fetchStations() async {
    // Call the API to fetch the stations
    List<Station> stations =
        await StationService.fetchStations(widget.bus.stations);
    return stations;
  }

  Future<Set<Polyline>> fetchPolylines() async {
    // Call the API to fetch the stations
    List<Station> stations = await StationService.fetchStations(widget.bus.stations);
    
    // Create a PolylineId
    PolylineId id = PolylineId('poly');
    
    // Create LatLng list
    List<LatLng> polylineCoordinates = [];
    stations.forEach((station) {
      polylineCoordinates.add(LatLng(station.location.lat, station.location.lng));
    });
    
    // Create a Polyline instance
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
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
                if (snapshot.hasData) {
                  Set<Marker> markers = snapshot.data!.map((station) {
                    return Marker(
                      markerId: MarkerId(station.id),
                      position:
                          LatLng(station.location.lat, station.location.lng),
                      infoWindow: InfoWindow(
                        title: station.name,
                        snippet: station.address,
                      ),
                    );
                  }).toSet();

                  return FutureBuilder<Set<Polyline>>(
                    future: fetchPolylines(),
                    builder: (BuildContext context, AsyncSnapshot<Set<Polyline>> polylineSnapshot) {
                      if(polylineSnapshot.hasData) {
                   return GoogleMap(
                    cameraTargetBounds: CameraTargetBounds.unbounded,
                    mapType: MapType.normal,
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 8.0,
                    ),
                    markers: markers,
                    polylines: polylineSnapshot.data!,
                    
                  );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  );
                } else {
                  // You can return a placeholder here
                  return CircularProgressIndicator();
                }
              },
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.5,
              minChildSize: 0.4,
              maxChildSize: 0.8,
              builder:
                  (BuildContext context, ScrollController scrollController) {
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
                        const TabBar(
                          tabs: [
                            Tab(text: 'Stations'),
                            Tab(text: 'Details'),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              ListView.builder(
                                controller: scrollController,
                                itemCount: widget.bus.stations
                                    .length, // replace with your station count
                                itemBuilder:
                                    (BuildContext context, int index) {},
                              ),
                              SingleChildScrollView(
                                controller: scrollController,
                                child: Column(
                                  children: [
                                    // Here, add the rest of your bus details and an edit button
                                    TextButton(
                                      onPressed: () {
                                        /*  Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => EditBusScreen(bus: widget.bus)),
                                        );*/
                                      },
                                      child: const Text("Edit"),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
