import 'package:flutter/material.dart';
import 'package:septeo_transport/view/components/app_colors.dart';
import 'package:septeo_transport/view/screens/admin/buses/bus_management.dart';
import 'package:septeo_transport/view/screens/appHome/quick_access.dart';

import '../admin/user/home_page.dart';
import '../admin/user/user_managment_screen.dart';
// Import other pages here...

class AppHome extends StatefulWidget {
  final String userType;

  const AppHome({super.key, required this.userType});

  @override
  _AppHomeState createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  int _currentIndex = 0;
  int _currentDrawerIndex = 0;

  List<Widget> get _children {
    return [
      QuickAccess(),
      const BusManagement(isdriver: false),
      const BusManagement(isdriver: false),
      const BusManagement(isdriver: false),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('HomePage', style: TextStyle(fontSize: 20)),
          backgroundColor: Colors.transparent,
        ),
        body: _children[_currentIndex],
      ),
    );
  }

  Widget buildListTile(
      {required String title, required int index, required Function onTap}) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        decoration: BoxDecoration(
          color: _currentDrawerIndex == index ? AppColors.primaryOrange : null,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(
              color: _currentDrawerIndex == index ? Colors.white : null,
            ),
          ),
        ),
      ),
    );
  }
}
