import 'package:flutter/material.dart';

import '../../../../model/station.dart';
import '../../../../viewmodel/station_services.dart';

class StationSelectionScreen extends StatefulWidget {
  const StationSelectionScreen({super.key});

  @override
  _StationSelectionScreenState createState() => _StationSelectionScreenState();
}

class _StationSelectionScreenState extends State<StationSelectionScreen> {
  // This list will hold all the ids of the selected stations.
  List<String> selectedStationIds = [];

  // This is your list of all stations, you should fetch this from your backend.
  List<Station> allStations = [];

    @override
  void initState() {
    super.initState();
     _getStationList();
  }
// get the list of stations from the server
_getStationList() async {
    var stations = await StationService.getStations();
    setState(() {
      allStations = stations;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Stations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () {
              
              Navigator.of(context).pop(selectedStationIds);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: allStations.length,
        itemBuilder: (context, index) {
          final station = allStations[index];
          return CheckboxListTile(
            title: Text(station.name),
            value: selectedStationIds.contains(station.id),
            onChanged: (newValue) {
              setState(() {
                if (newValue == true) {
                  selectedStationIds.add(station.id);
                } else {
                  selectedStationIds.remove(station.id);
                }
              });
            },
          );
        },
      ),
    );
  }
}