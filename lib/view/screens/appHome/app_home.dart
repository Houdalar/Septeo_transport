import 'package:flutter/material.dart';
import 'package:septeo_transport/view/components/app_colors.dart';
import 'package:septeo_transport/view/screens/admin/buses/bus_management.dart';
import 'package:septeo_transport/view/screens/appHome/quick_access.dart';

import '../admin/user/home_page.dart';
import '../admin/user/user_managment_screen.dart';
// Import other pages here...

class AppHome extends StatefulWidget {
  final String userType;

  AppHome({required this.userType});

  @override
  _AppHomeState createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  int _currentIndex = 0; // By default, our first screen will be shown

  // This is a getter method that creates and returns a new list of widgets
  List<Widget> get _children {
    return [
      QuickAccess(),
      const BusManagement(isdriver: false),
      const BusManagement(isdriver: false),
      const BusManagement(isdriver: false),
      // VacationPage(),  // Define this widget
      // PaydayAdvancePage(),  // Define this widget
      // UsersManagementPage(),  // Define this widget
      // Add more pages for navigation if necessary
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePage' , style: TextStyle(color: Colors.white),),
      ),
      body: _children[_currentIndex], // Switch between different pages
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.primaryOrange,
              ),
              child: Text('Septeo Transport'),
            ),
            ListTile(
              title: const Text('transport'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>Home(role: widget.userType)), // Navigate to the transport homepage
                );
              },
            ),
            ListTile(
              title: const Text('Vacation Management'),
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Payday Advance Management'),
              onTap: () {
                setState(() {
                  _currentIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
            if (widget.userType != 'driver') ...[
              ListTile(
                title: const Text('User Management'),
                onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>UserManagement()), // Navigate to the transport homepage
                );
              },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
