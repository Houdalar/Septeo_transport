import 'package:flutter/material.dart';

import '../../model/station.dart';
import '../screens/admin/stations/station_detail_screen.dart';

class StationItem extends StatelessWidget {
  final Station station;

  const StationItem({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StationDetailsScreen(station: station),
          ),
        );
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/icon_map_marker.png',
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            Text(station.name , style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
           
          ],
        ),
      ),
    );
  }
}