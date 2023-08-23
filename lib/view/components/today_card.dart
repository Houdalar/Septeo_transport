import 'package:flutter/material.dart';
import 'package:septeo_transport/view/components/app_colors.dart';

import '../../model/planning.dart';
import '../../viewmodel/user_services.dart';
import '../screens/employee/add_planning.dart';

class PlanningCard extends StatelessWidget {
  final Planning planning;
  final UserViewModel userViewModel;

  const PlanningCard({
    Key? key,
    required this.planning,
    required this.userViewModel,
  }) : super(key: key);

  String getFirstArrivalTime() {
    for (var arrival in planning.fromStation.arrivalTimes) {
      if (arrival.bus?.id == planning.startbus.id) {
        return arrival.time ?? 'No Arrival Time';
      }
    }
    return 'No Arrival Time';
  }

  String getSecondArrivalTime() {
    for (var arrival in planning.toStation.arrivalTimes) {
      if (arrival.bus?.id == planning.finishbus.id) {
        if (arrival.time != null &&
            int.parse(arrival.time!.split(':')[0]) >= 17) {
          return arrival.time!;
        }
      }
    }
    return 'empty';
  }

  @override
  Widget build(BuildContext context) {
    String firstarrivalTime = getFirstArrivalTime();
    String secondarrivalTime = getSecondArrivalTime();

    return Material(
      child: InkWell(
        onLongPress: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('manage planning'),
                content:
                    const Text('Do you want to delete or update this planning?'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Delete'),
                    onPressed: () async {
                      await userViewModel.deletePlanning(planning.id);
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Update'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return AddPlanningForm(planning: planning);
                        },
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: AppColors.primaryOrange,
                      child: Icon(Icons.location_on, color: Colors.white),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(planning.fromStation.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 5),
                        Text(firstarrivalTime,
                            style: const TextStyle(
                                color: AppColors.auxiliaryGrey, fontSize: 15)),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 55,
                      height: 55,
                      child: Card(
                        color: AppColors.primaryOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0,
                        child: Center(
                          child: Text(
                            planning.startbus.busNumber,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Row(
                  children: [
                    SizedBox(
                      width: 12,
                    ),
                    SizedBox(
                      height: 20,
                      child: VerticalDivider(
                        color: Color.fromARGB(255, 211, 211, 211),
                        thickness: 2,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: AppColors.primaryOrange,
                      child: Icon(Icons.location_on, color: Colors.white),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(planning.toStation.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 5),
                        Text(secondarrivalTime,
                            style: const TextStyle(
                                color: AppColors.auxiliaryGrey, fontSize: 15)),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 55,
                      height: 55,
                      child: Card(
                        color: AppColors.primaryOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0,
                        child: Center(
                          child: Text(
                            planning.finishbus.busNumber,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
