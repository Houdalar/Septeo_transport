import 'package:flutter/material.dart';
import 'package:septeo_transport/view/components/app_colors.dart';
import 'package:septeo_transport/view/screens/admin/stations/station_management.dart';
import '../buses/bus_management.dart';

class AdminSpace extends StatefulWidget {


  const AdminSpace({
    Key? key,
  }) : super(key: key);

  @override
  _AdminSpaceState createState() => _AdminSpaceState();
}

class _AdminSpaceState extends State<AdminSpace> {
  int _selectedIndex = 0;

  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = [
      const StationManagement(),
      const BusManagement(
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
            icon:
                const Icon(Icons.arrow_back, color: AppColors.primaryDarkBlue),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Stack(
          children: [
            _tabs[_selectedIndex],
            Positioned(
              top: 10.0,
              left: 30,
              right: 30,
              child: TabSwitcher(
                selectedIndex: _selectedIndex,
                onTabSelected: (index) =>
                    setState(() => _selectedIndex = index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TabSwitcher extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const TabSwitcher({
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SizedBox(
          height: 50.0,
          child: Row(
            children: List.generate(2, (index) {
              final isSelected = selectedIndex == index;
              final titles = ["Stations", "Buses"];
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTabSelected(index),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryOrange : null,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      titles[index],
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppColors.primaryDarkBlue,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
