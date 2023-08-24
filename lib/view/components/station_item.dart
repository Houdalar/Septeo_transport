import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/station.dart';
import '../screens/admin/stations/station_detail_screen.dart';
import '../../viewmodel/station_services.dart';
import 'app_colors.dart';

class StationCard extends StatelessWidget {
  final Station station;

  const StationCard({
    Key? key,
    required this.station,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(station.id),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirm"),
              content: const Text("Are you sure you wish to delete this station?"),
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
            content: Text("Station ${station.name} deleted"),
          ),
        );
        context.read<StationService>().deleteStation(station.id,);
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
            station.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          subtitle: Text(
            station.address,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => StationDetailsScreen(station: station ,),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
