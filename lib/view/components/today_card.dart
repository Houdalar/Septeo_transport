import 'package:flutter/material.dart';
import 'package:septeo_transport/view/components/app_colors.dart';

import '../../model/planning.dart';

class PlanningCard extends StatelessWidget {
  final Planning todayPlanning;

  const PlanningCard({super.key, required this.todayPlanning});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
         // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(todayPlanning.dayOfWeek , style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryOrange),),
              ],
            ),
            const SizedBox(width: 15),
            const SizedBox(
              height: 40,
              child: VerticalDivider(
                color: Colors.grey,
                thickness: 1,
              ),
            ),
            const SizedBox(width: 15,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(todayPlanning.toStation.name),
                const SizedBox(height: 10,),
                Text(todayPlanning.time),
              ],
            ),
            const Spacer(),
            SizedBox(
              height: 100,
              width: 60,
              child: Card(
                color: AppColors.primaryOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.directions_bus_filled, color: AppColors.auxiliaryOffWhite),
                    const SizedBox(height: 5),
                    Text(todayPlanning.bus.busNumber ,style: const TextStyle(color: AppColors.auxiliaryOffWhite), ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}