import 'package:flutter/material.dart';
import 'package:septeo_transport/view/components/app_colors.dart';

import '../../../../model/station.dart';
import '../../../../viewmodel/station_services.dart';
import '../../../components/station_item.dart';
import 'add_station_sheet.dart';


class StationManagement extends StatefulWidget {
  const StationManagement({super.key});

  @override
  _StationManagementState createState() => _StationManagementState();
}

class _StationManagementState extends State<StationManagement> {
  late List<Station> _stationList;

  @override
  void initState() {
    super.initState();
   //  _getStationList();
  }
// get the list of stations from the server
_getStationList() async {
    var stations = await StationService().getStations();
    setState(() {
      _stationList = stations;
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<List<Station>>(
          future: StationService().getStations(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return const Center(child: Text('Error loading data'));
            } else {
              return Padding(
                padding: const EdgeInsets.only(top: 120.0 , left: 10.0 , right: 10.0),
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var station = snapshot.data![index];
                    return StationCard(station: station);
                  },
                ),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                
                return const AddStationSheet();
              },
            );
          },
          backgroundColor: AppColors.secondaryLightOrange,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

