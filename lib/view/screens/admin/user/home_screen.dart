import 'package:flutter/material.dart';
import 'package:septeo_transport/model/bus.dart';
import 'package:septeo_transport/view/components/app_colors.dart';

import '../../../../model/planning.dart';
import '../../../../model/station.dart';
import '../../../../viewmodel/station_services.dart';
import '../../../../viewmodel/user_services.dart';
import '../../../components/search_bar.dart';
import '../../../components/station_card.dart';
import '../../../components/today_card.dart';

class HomePage extends StatefulWidget {
  
  const HomePage({super.key , });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Station>? _stations;
  String _searchText = '';
  UserViewModel userViewModel = UserViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      height: 30,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Transport',
                      style: TextStyle(fontSize: 30),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Search_bar(onChanged: (value) {
                  setState(() {
                    _searchText = value;
                  });
                }),
                const SizedBox(height: 40),
                const Text("Today", style: TextStyle(fontSize: 20)),
                const SizedBox(height: 20),
                FutureBuilder<Planning?>(
                  future: userViewModel.getTodayPlanning(),
                  builder: (BuildContext context,
                      AsyncSnapshot<Planning?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('No planning for today'));
                    } else if (snapshot.hasData) {
                      if (snapshot.data == null) {
                        return const Center(
                            child: Text('No planning for today'));
                      } else {
                        return PlanningCard(planning: snapshot.data!);
                      }
                    } else {
                      return const Center(
                          child: Text(
                        'No planning for today yet',
                        style: TextStyle(color: AppColors.auxiliaryGrey),
                      ));
                    }
                  },
                ),
                const SizedBox(height: 30),
                const Text("Available stations",
                    style: TextStyle(fontSize: 20)),
                const SizedBox(height: 20),
                FutureBuilder<List<Station>>(
                  future: StationService.getStations(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Station>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      _stations = snapshot.data!;
                      var stationsToShow = _searchText.isEmpty
                          ? _stations
                          : _stations!
                              .where((station) => station.name
                                  .toLowerCase()
                                  .contains(_searchText.toLowerCase()))
                              .toList();

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1 / 1,
                        ),
                        itemCount: stationsToShow!.length,
                        itemBuilder: (BuildContext ctx, index) {
                          return StationItem(station: stationsToShow[index]);
                        },
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
