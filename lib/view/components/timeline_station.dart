import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../model/station.dart';
import 'app_colors.dart';
import 'package:intl/intl.dart';

class TimelineStation extends StatelessWidget {
  final String stationName;
  final String stationAddress;
  final bool isFirst;
  final bool isLast;
  final List<ArrivalTime>? arrivalTimes;

  TimelineStation(
      {required this.stationName,
      required this.stationAddress,
      required this.isFirst,
      required this.isLast,
      this.arrivalTimes});

  @override
  Widget build(BuildContext context) {
    // Calculate firstArrivalTime
    String firstArrivalTime = "";
    bool isDone = false; // Initiate isDone variable

    if (arrivalTimes != null && arrivalTimes!.isNotEmpty) {
      final now = DateTime.now();
      final format = DateFormat("HH:mm"); // Define the time format

      for (var arrivalTime in arrivalTimes!) {
        try {
          DateTime arrivalDateTime = format.parse(arrivalTime.time!);
          arrivalDateTime = DateTime(now.year, now.month, now.day,
              arrivalDateTime.hour, arrivalDateTime.minute);

          // If the firstArrivalTime is before or at current time, it's done
          if (now.compareTo(arrivalDateTime) < 0) {
            firstArrivalTime = arrivalTime.time!;
            break;
          } else {
             firstArrivalTime = arrivalTime.time!;
            isDone = true;
          }
        } catch (e) {
          print("Error parsing time: $e");
        }
      }
    }

    // Color for indicator and line
    Color lineColor = isDone
        ? AppColors.primaryOrange
        : const Color.fromARGB(255, 202, 202, 202);

    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0.25,
      isFirst: isFirst,
      isLast: isLast,
      
      indicatorStyle: IndicatorStyle(
        width: 35,
        height: 35,
        color: lineColor,
        padding: const EdgeInsets.all(5),
        indicator: Container(
          decoration: BoxDecoration(
            color: lineColor,
            borderRadius: const BorderRadius.all(Radius.circular(50)),
          ),
          child: const Center(
            child: Icon(
              Icons.location_on,
              color: Colors.white,
              size: 18.0,
            ),
          ),
        ),
      ),
     
      beforeLineStyle: LineStyle(
        color: lineColor,
        thickness: 2,
      ),
      afterLineStyle: LineStyle(
        color: lineColor,
        thickness: 2,
      ),
      startChild: Container(
        padding: const EdgeInsets.only(right: 15),
        alignment: Alignment.centerRight,
        child: Text(
          firstArrivalTime,
          style: TextStyle(
            color: isDone ? AppColors.primaryOrange : Colors.grey,
            fontSize: 18,
          ),
        ),
      ),
      endChild: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              Text(
                stationName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                stationAddress,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
