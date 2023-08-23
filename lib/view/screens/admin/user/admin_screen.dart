import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:septeo_transport/view/components/app_colors.dart';
import 'package:septeo_transport/view/screens/admin/stations/station_management.dart';

import '../../../../session_manager.dart';
import '../../../../viewmodel/bus_services.dart';
import '../../../../viewmodel/station_services.dart';
import '../../../../viewmodel/user_services.dart';
import '../buses/bus_management.dart';

class AdminSpace extends StatefulWidget {
  const AdminSpace({Key? key}) : super(key: key);

  @override
  _AdminSpaceState createState() => _AdminSpaceState();
}

class _AdminSpaceState extends State<AdminSpace> {
  int _selectedIndex = 0;

  late final BusService busService;
  late final UserViewModel userService;
  late final SessionManager sessionManager;
  late final StationService stationService;

   late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();

    busService = Provider.of<BusService>(context, listen: false);
    userService = Provider.of<UserViewModel>(context, listen: false);
    sessionManager = Provider.of<SessionManager>(context, listen: false);
    stationService = Provider.of<StationService>(context, listen: false);
    _tabs = [
      const StationManagement(),
      BusManagement(
        busService: busService,
        userService: userService,
        sessionManager: sessionManager,
        stationService: stationService,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              "Admin Space",
              style: TextStyle(color: AppColors.primaryDarkBlue),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.primaryDarkBlue),
              onPressed: () {
                Navigator.pop(context);
              },
            )
            ),
        body: Stack(
          children: [
            _tabs[_selectedIndex],
            Positioned(
              top: 10.0,
              left: 30,
              right: 30,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: SizedBox(
                    height: 50.0,
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedIndex = 0),
                            child: Stack(
                              children: [
                                if (_selectedIndex == 0)
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryOrange,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Stations",
                                    style: TextStyle(
                                      color: _selectedIndex == 0
                                          ? Colors.white
                                          : AppColors.primaryDarkBlue,
                                      fontWeight: _selectedIndex == 1
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedIndex = 1),
                            child: Stack(
                              children: [
                                if (_selectedIndex == 1)
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryOrange,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Buses",
                                    style: TextStyle(
                                      color: _selectedIndex == 1
                                          ? Colors.white
                                          : AppColors.primaryDarkBlue,
                                      fontWeight: _selectedIndex == 0
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}