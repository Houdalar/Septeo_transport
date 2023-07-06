import 'package:flutter/material.dart';
import 'package:septeo_transport/view/components/app_colors.dart';

import '../../model/bus.dart';
import '../../model/station.dart';

class BusItemCard extends StatelessWidget {
  final ArrivalTime arrivalTime;
  final Bus bus;
  final Function calculateTimeRemaining;

  BusItemCard({
    required this.arrivalTime,
    required this.bus,
    required this.calculateTimeRemaining,
  });

  @override
  Widget build(BuildContext context) {
    String remainingTime = calculateTimeRemaining(arrivalTime.time);

    return SizedBox(
      height: 90,
      child: Card(
        color: const Color.fromARGB(232, 255, 255, 255),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
          child: Row(
            children: <Widget>[
              const SizedBox(
                width: 30,
              ),
              Image.asset(
                'assets/bus.png',
                height: 50,
              ),
              const SizedBox(
                width: 40,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    bus.busNumber,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(arrivalTime.time,
                      style: const TextStyle(fontSize: 13, color: Colors.grey)),
                ],
              ),
              const Spacer(),
              Center(
                child: Text(
                  remainingTime,
                  style: const TextStyle(color: AppColors.primaryOrange ,fontSize: 15 ,fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
