import 'package:flutter/material.dart';
import 'package:septeo_transport/session_manager.dart';
import 'package:septeo_transport/view/components/app_colors.dart';
import 'package:septeo_transport/view/screens/admin/buses/add_bus_sheet.dart';

import '../../../../model/bus.dart';
import '../../../../viewmodel/bus_services.dart';
import '../../../components/bus_item.dart';
import '../../../components/search_bar.dart';

class BusManagement extends StatefulWidget {
  const BusManagement({super.key,});

  @override
  _BusManagementState createState() => _BusManagementState();
}

class _BusManagementState extends State<BusManagement>  {
 bool? isdriver;
@override
  void initState() {
    super.initState();
    _initializeRole();
  }
  Future<void> _initializeRole() async {
    String role = await SessionManager.getRole();
    setState(() {
        isdriver = role == "Driver";
    });
    print("isdriver $isdriver");
}
  @override
  Widget build(BuildContext context) {
    if (isdriver == null) {
    return const CircularProgressIndicator(); 
  }
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<List<Bus>>(
          future: BusService().getBus(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return const Center(child: Text('Error loading data'));
            } else {
              return Padding(
                padding: EdgeInsets.only(
                    top: isdriver! ? 30 : 120, left: 10.0, right: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isdriver!)
                      const Text(" buses list",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Search_bar(
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var bus = snapshot.data![index];
                          return BusCard(bus: bus );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
        floatingActionButton: !isdriver!
            ? FloatingActionButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return const AddBusSheet(); // This will need to be defined too
                    },
                  );
                },
                backgroundColor: AppColors.secondaryLightOrange,
                child: const Icon(Icons.add),
              )
            : null,
      ),
    );
  }
}
