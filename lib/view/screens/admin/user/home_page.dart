import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../session_manager.dart';
import '../../../components/app_colors.dart';
import '../../appHome/quick_access.dart';
import '../buses/bus_management.dart';
import 'home_screen.dart';
import 'settings_page.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  var currentIndex = 0;
  String? role;
  List<IconData> listOfIcons = [];

  List<String> listOfStrings = [];
  @override
  void initState() {
    super.initState();
    _initializeRole().then((fetchedRole) {
      setState(() {
        role = fetchedRole;
        if (role == "Driver") {
          listOfIcons = [
          Icons.directions_bus,
          Icons.settings_rounded,
        ];
        listOfStrings = [
          'driver',
          'Settings',
        ];
      } else {
        listOfIcons = [
          Icons.home_rounded,
          Icons.directions_bus,
          Icons.settings_rounded,
        ];
        listOfStrings = [
          'Home',
          'transport',
          'Settings',
        ];
        }
      });
    });
   
  }

Future<String> _initializeRole() async {
    String fetchedRole = await SessionManager.getRole();
    return fetchedRole;
}

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            IndexedStack(
                index: currentIndex,
                children: role == "Driver"
                    ? [const BusManagement(), const SettingsPage()]
                    : [const QuickAccess(), const HomePage(), const SettingsPage()]),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                margin: EdgeInsets.all(displayWidth * .05),
                height: displayWidth * .155,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.15),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(50),
                ),
                child: ListView.builder(
                  itemCount: listOfIcons.length,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: displayWidth * .02),
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      setState(() {
                        currentIndex = index;
                        HapticFeedback.lightImpact();
                      });
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Padding(
                      padding: role == "Driver"
                          ? EdgeInsets.symmetric(horizontal: displayWidth * .1)
                          : EdgeInsets.symmetric(
                              horizontal: displayWidth * .03),
                      child: Stack(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastLinearToSlowEaseIn,
                            width: index == currentIndex
                                ? displayWidth * .32
                                : displayWidth * .18,
                            alignment: Alignment.center,
                            child: AnimatedContainer(
                              duration: const Duration(seconds: 1),
                              curve: Curves.fastLinearToSlowEaseIn,
                              height: index == currentIndex
                                  ? displayWidth * .12
                                  : 0,
                              width: index == currentIndex
                                  ? displayWidth * .32
                                  : 0,
                              decoration: BoxDecoration(
                                color: index == currentIndex
                                    ? AppColors.primaryOrange
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastLinearToSlowEaseIn,
                            width: index == currentIndex
                                ? displayWidth * .31
                                : displayWidth * .18,
                            alignment: Alignment.center,
                            child: Stack(
                              children: [
                                Row(
                                  children: [
                                    AnimatedContainer(
                                      duration: const Duration(seconds: 1),
                                      curve: Curves.fastLinearToSlowEaseIn,
                                      width: index == currentIndex
                                          ? displayWidth * .13
                                          : 0,
                                    ),
                                    AnimatedOpacity(
                                      opacity: index == currentIndex ? 1 : 0,
                                      duration: const Duration(seconds: 1),
                                      curve: Curves.fastLinearToSlowEaseIn,
                                      child: Text(
                                        index == currentIndex
                                            ? listOfStrings[index]
                                            : '',
                                        style: const TextStyle(
                                          color: AppColors.auxiliaryOffWhite,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    AnimatedContainer(
                                      duration: const Duration(seconds: 1),
                                      curve: Curves.fastLinearToSlowEaseIn,
                                      width: index == currentIndex
                                          ? displayWidth * .03
                                          : 20,
                                    ),
                                    Icon(
                                      listOfIcons[index],
                                      size: displayWidth * .076,
                                      color: index == currentIndex
                                          ? AppColors.auxiliaryOffWhite
                                          : Colors.black26,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
