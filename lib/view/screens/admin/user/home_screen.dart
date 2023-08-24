import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:septeo_transport/viewmodel/station_services.dart';
import 'package:septeo_transport/viewmodel/user_services.dart';
import '../../../../model/planning.dart';
import '../../../../model/station.dart';
import '../../../components/station_card.dart';
import '../../../components/today_card.dart';

class HomePage extends StatefulWidget {

  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Station>? _stations;
  String _searchText = '';

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
                _buildHeader(),
                const SizedBox(height: 20),
                SearchBar(onChanged: (value) {
                  setState(() {
                    _searchText = value;
                  });
                }),
                const SizedBox(height: 40),
                _buildTodayPlanning(),
                const SizedBox(height: 30),
                const Text("Available stations", style: TextStyle(fontSize: 20)),
                const SizedBox(height: 20),
                _buildAvailableStations(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
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
    );
  }

  Widget _buildTodayPlanning() {
    return FutureBuilder<Planning?>(
      future: context.read<UserViewModel>().getTodayPlanning(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || snapshot.data == null) {
          return const Center(child: Text('No planning for today'));
        } else {
          return PlanningCard(planning: snapshot.data!);
        }
      },
    );
  }

  Widget _buildAvailableStations() {
    return FutureBuilder<List<Station>>(
      future: context.read<StationService>().getStations(),
      builder: (context, snapshot) {
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
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1 / 1,
            ),
            itemCount: stationsToShow!.length,
            itemBuilder: (context, index) {
              return StationItem(station: stationsToShow[index]);
            },
          );
        }
      },
    );
  }
}