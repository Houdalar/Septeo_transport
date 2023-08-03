import 'package:flutter/material.dart';
import 'package:septeo_transport/model/station.dart';
import '../../../components/timeline_station.dart';

class StationsTab extends StatelessWidget {
  final List<Station> stations;
  final ScrollController scrollController;

  StationsTab({required this.stations, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    if (stations.isEmpty) {
      return const Center(
          child: Text('No planning yet for this bus for today'));
    } else {
      // Flatten the list of stations into a list of station-arrival time pairs
      final stationArrivalPairs = stations
          .expand((station) => station.arrivalTimes.map((arrivalTime) =>
              StationArrivalPair(station: station, arrivalTime: arrivalTime)))
          .toList();

      // Sort the list based on arrival times
      stationArrivalPairs
          .sort((a, b) => a.arrivalTime.time!.compareTo(b.arrivalTime.time!));

      return ListView.builder(
        controller: scrollController,
        itemCount: stationArrivalPairs.length,
        itemBuilder: (BuildContext context, int index) {
          Station station = stationArrivalPairs[index].station;
          ArrivalTime arrivalTime = stationArrivalPairs[index].arrivalTime;
          return TimelineStation(
            stationName: station.name,
            stationAddress: station.address,
            isFirst: index == 0 ? true : false,
            isLast: index == stationArrivalPairs.length - 1 ? true : false,
            arrivalTime:
                arrivalTime, // pass a single arrival time instead of the list
          );
        },
      );
    }
  }
}

// Define a helper class to store a station-arrival time pair
class StationArrivalPair {
  final Station station;
  final ArrivalTime arrivalTime;

  StationArrivalPair({required this.station, required this.arrivalTime});
}
