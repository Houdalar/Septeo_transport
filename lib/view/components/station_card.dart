import 'package:flutter/material.dart';
import '../../model/station.dart';
import '../screens/admin/stations/station_detail_screen.dart';

class StationItem extends StatelessWidget {
  final Station station;

  const StationItem({Key? key, required this.station,  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _navigateToDetails(context),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildStationImage(),
              const SizedBox(height: 20),
              _buildStationName(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStationImage() {
    return  Image.asset(
      'assets/icon_map_marker.png',
      height: 80,
      width: 80,
      fit: BoxFit.cover,
    );
  }

  Widget _buildStationName() {
    return Text(
      station.name,
      style: const TextStyle(fontSize: 20),
    );
  }

  void _navigateToDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StationDetailsScreen(station: station ,),
      ),
    );
  }
}