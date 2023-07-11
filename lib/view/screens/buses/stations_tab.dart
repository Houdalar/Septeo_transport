import 'package:flutter/material.dart';
import 'package:septeo_transport/model/station.dart';
import '../../components/timeline_station.dart';

class StationsTab extends StatelessWidget {
  final List<Station> stations;
  final ScrollController scrollController;

  StationsTab({required this.stations, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: stations.length,
      itemBuilder: (BuildContext context, int index) {
        Station station = stations[index];
        return TimelineStation(
          stationName: station.name,
          stationAddress: station.address,
          isFirst: index == 0 ? true : false,
          isLast: index == stations.length - 1 ? true : false,
          arrivalTimes: station.arrivalTimes.isEmpty ? null: station.arrivalTimes,
        );
      },
    );
  }
}
