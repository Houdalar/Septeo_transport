import 'package:flutter/material.dart';

import '../../../../model/station.dart';
import '../../../../viewmodel/station_services.dart';

class StationSelectionScreen extends StatefulWidget {
  final StationService stationService;

  const StationSelectionScreen({
    Key? key,
    required this.stationService,
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
      var stations = await widget.stationService.getStations();
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