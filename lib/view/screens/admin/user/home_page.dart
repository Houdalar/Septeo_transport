import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../session_manager.dart';
import '../../../components/app_colors.dart';
import '../../appHome/quick_access.dart';
import '../buses/bus_management.dart';
import 'home_screen.dart';
import 'settings_page.dart';

class Home extends StatefulWidget {

  const Home({
    Key? key,
  }) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  int currentIndex = 0;
  String? role;
  late List<IconData> listOfIcons;
  late List<String> listOfStrings;

  @override
  void initState() {
    super.initState();
    _initializeRole();
  }

  Future<void> _initializeRole() async {
    String? fetchedRole = await context.read<SessionManager>().getRole();
    setState(() {
      role = fetchedRole;
      if (role == "Driver") {
        listOfIcons = [Icons.directions_bus, Icons.settings_rounded];
        listOfStrings = ['driver', 'Settings'];
      } else {
        listOfIcons = [Icons.home_rounded, Icons.directions_bus, Icons.settings_rounded];
        listOfStrings = ['Home', 'transport', 'Settings'];
      }
    });
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
                  ? [ const BusManagement(), const SettingsPage()]
                  : [const QuickAccess(), const HomePage(), const SettingsPage()],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: BottomNavigation(
                displayWidth: displayWidth,
                listOfIcons: listOfIcons,
                listOfStrings: listOfStrings,
                currentIndex: currentIndex,
                onTap: (index) => setState(() => currentIndex = index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavigation extends StatelessWidget {
  final double displayWidth;
  final List<IconData> listOfIcons;
  final List<String> listOfStrings;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavigation({
    required this.displayWidth,
    required this.listOfIcons,
    required this.listOfStrings,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => onTap(index),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: displayWidth * .03),
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
          );
        },
      ),
    );
  }
}