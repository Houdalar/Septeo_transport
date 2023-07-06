import 'package:flutter/material.dart';

import '../../model/station.dart';
import '../screens/stations/station_detail_screen.dart';

class StationCard extends StatelessWidget {
  final Station station;

  const StationCard({Key? key, required this.station}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15.0),
        title: Text(
          station.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        subtitle: Text(
          station.address,
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => StationDetailsScreen(station:station),
              ),
            );
          },
        ),
      ),
    );
  }
}