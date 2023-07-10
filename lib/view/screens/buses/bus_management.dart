import 'package:flutter/material.dart';
import 'package:septeo_transport/view/components/app_colors.dart';
import 'package:septeo_transport/view/screens/buses/add_bus_sheet.dart';

import '../../../model/bus.dart';
import '../../../viewmodel/bus_services.dart';
import '../../components/bus_item.dart';


class BusManagement extends StatefulWidget {
  @override
  _BusManagementState createState() => _BusManagementState();
}

class _BusManagementState extends State<BusManagement> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<List<Bus>>(
          future: BusService().getBus(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              print( snapshot.error);
              return const Center(child: Text('Error loading data'));
            } else {
              return Padding(
                padding: const EdgeInsets.only(top: 120.0 , left: 10.0 , right: 10.0),
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var bus = snapshot.data![index];
                    return BusCard(bus: bus);  // You will need to define this BusCard widget
                  },
                ),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return AddBusSheet();  // This will need to be defined too
              },
            );
          },
          backgroundColor: AppColors.secondaryLightOrange,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}