import 'package:flutter/material.dart';

import '../../../model/station.dart';
import '../../components/search_bar.dart';
import '../../components/station_card.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Station> availableStations = [
    Station(
  name: 'Station 1',
  address: 'Address 1',
  location: Location(lat: 40.7128, lng: -74.0060),
  image: 'http://10.0.2.2:8080/media/map.png',
),
    Station(
  name: 'Station 2',
  address: 'Address 2',
  location: Location(lat: 40.7128, lng: -74.0060),
  image: 'http://10.0.2.2:8080/media/map.png',
),
   Station(
  name: 'Station 3',
  address: 'Address 3',
  location: Location(lat: 40.7128, lng: -74.0060),
  image: 'http://10.0.2.2:8080/media/map.png',
),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Welcome admin ',
                style: TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 16),
           Search_bar(),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text("Availble Pickup Stations", style: TextStyle(fontSize: 20)),
            ),
            SizedBox(
              height: 150,
              child: ListView.builder(
                itemCount: availableStations.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return StationCard(station: availableStations[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}




