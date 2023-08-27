import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:septeo_transport/viewmodel/station_services.dart';

import '../../../../model/station.dart';

class StationSelectionScreen extends StatefulWidget {
  const StationSelectionScreen({
    Key? key,
  }) : super(key: key);

  @override
  _StationSelectionScreenState createState() => _StationSelectionScreenState();
}

class _StationSelectionScreenState extends State<StationSelectionScreen> {
  List<String> selectedStationIds = [];
  List<Station> allStations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getStationList();
  }

  _getStationList() async {
    try {
      var stations = await context.read<StationService>().getStations();
      setState(() {
        allStations = stations;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      // Handle error, for example, show a snackbar or a dialog.
    }
  }

  _toggleStationSelection(String stationId) {
    setState(() {
      if (selectedStationIds.contains(stationId)) {
        selectedStationIds.remove(stationId);
      } else {
        selectedStationIds.add(stationId);
      }
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
      body: isLoading
          ? CircularProgressIndicator()
          : ListView.builder(
              itemCount: allStations.length,
              itemBuilder: (context, index) {
                final station = allStations[index];
                return CheckboxListTile(
                  title: Text(station.name),
                  value: selectedStationIds.contains(station.id),
                  onChanged: (newValue) {
                    _toggleStationSelection(station.id);
                  },
                );
              },
            ),
    );
  }
}
