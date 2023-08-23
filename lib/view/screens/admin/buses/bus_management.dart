import 'package:flutter/material.dart';
import 'package:septeo_transport/session_manager.dart';
import 'package:septeo_transport/view/components/app_colors.dart';
import 'package:septeo_transport/view/screens/admin/buses/add_bus_sheet.dart';

import '../../../../model/bus.dart';
import '../../../../viewmodel/bus_services.dart';
import '../../../../viewmodel/station_services.dart';
import '../../../../viewmodel/user_services.dart';
import '../../../components/bus_item.dart';
import '../../../components/search_bar.dart';

class BusManagement extends StatefulWidget {
  final BusService busService;
  final UserViewModel userService;
  final SessionManager sessionManager;
  final StationService stationService;

  const BusManagement({
    Key? key,
    required this.busService,
    required this.userService,
    required this.sessionManager,
    required this.stationService,
  }) : super(key: key);

  @override
  _BusManagementState createState() => _BusManagementState();
}

class _BusManagementState extends State<BusManagement> {
  bool? isDriver;

  @override
  void initState() {
    super.initState();
    _initializeRole();
  }

  Future<void> _initializeRole() async {
    String? role = await widget.sessionManager.getRole();
    setState(() {
      isDriver = role == "Driver";
    });
    print("isDriver $isDriver");
  }

  @override
  Widget build(BuildContext context) {
    if (isDriver == null) {
      return const CircularProgressIndicator();
    }
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<List<Bus>>(
          future: widget.busService.getBus(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return const Center(child: Text('Error loading data'));
            } else {
              return _buildBusList(snapshot.data!);
            }
          },
        ),
        floatingActionButton: !isDriver!
            ? FloatingActionButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return AddBusSheet(
                        busService: widget.busService,
                        userViewModel: widget.userService,
                      );
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

  Widget _buildBusList(List<Bus> buses) {
    return Padding(
      padding: EdgeInsets.only(
          top: isDriver! ? 30 : 120, left: 10.0, right: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDriver!)
            const Text(" buses list",
                style: TextStyle(
                    fontSize: 25, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Search_bar(onChanged: (value) {}),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: buses.length,
              itemBuilder: (context, index) {
                var bus = buses[index];
                return BusCard(
                  bus: bus,
                  busService: widget.busService,
                  userService: widget.userService,
                  sessionManager: widget.sessionManager,
                  stationService: widget.stationService,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}