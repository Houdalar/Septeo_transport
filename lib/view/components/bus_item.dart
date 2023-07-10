import 'package:flutter/material.dart';
import 'package:septeo_transport/view/components/app_colors.dart';

import '../../model/bus.dart';
import '../../viewmodel/bus_services.dart';
import '../screens/buses/bus_details.dart';

class BusCard extends StatelessWidget {
  final Bus bus;

  BusCard({required this.bus});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(bus.id),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirm"),
              content: const Text("Are you sure you wish to delete this bus?"),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("DELETE")),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("CANCEL"),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Bus ${bus.busNumber} deleted"),
          ),
        );

        BusService().deleteBus(bus.id, context);
      },
      background: Container(
        color:AppColors.secondaryLightOrange,
        child: const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
      ),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(15.0),
          title: Text(
            bus.busNumber,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: () {
               Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BusDetailsScreen(bus:bus),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
