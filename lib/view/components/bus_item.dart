import 'package:flutter/material.dart';
import 'package:septeo_transport/view/components/app_colors.dart';

import '../../model/bus.dart';
import '../../viewmodel/bus_services.dart';
import '../../viewmodel/user_services.dart';
import '../screens/admin/buses/bus_details.dart';

class BusCard extends StatelessWidget {
  final Bus bus;
  final bool isdriver;

  const BusCard({super.key, required this.bus, required this.isdriver});

  @override
  Widget build(BuildContext context) {
    return isdriver ? buildCard(context) : buildDismissibleCard(context);
  }

  Widget buildDismissibleCard(BuildContext context) {
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
        color: AppColors.secondaryLightOrange,
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
      child: buildCard(context),
    );
  }

  Widget buildCard(BuildContext context) {
    return Card(
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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isdriver)
              IconButton(
                icon: const Icon(Icons.message),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      final TextEditingController _controller =
                          TextEditingController();
                      return AlertDialog(
                        title: const Text('Send Message'),
                        content: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                              hintText: "Enter your message here"),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('SEND'),
                            onPressed: () {
                              UserViewModel.sendMessage(bus.id, _controller.text);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BusDetailsScreen(
                      bus: bus,
                      isdriver: isdriver,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
