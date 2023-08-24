import 'package:flutter/material.dart';
import 'package:septeo_transport/view/components/app_colors.dart';
import 'package:provider/provider.dart';
import '../../../../model/station.dart';
import '../../../../viewmodel/station_services.dart';
import '../../../components/station_item.dart';
import 'add_station_sheet.dart';

class StationManagement extends StatefulWidget {
  const StationManagement({Key? key}) : super(key: key);

  @override
  _StationManagementState createState() => _StationManagementState();
}

class _StationManagementState extends State<StationManagement> {
  late Future<List<Station>> _stationsFuture;

  @override
  void initState() {
    super.initState();
    _stationsFuture = context.read<StationService>().getStations();
  }

  @override
  Widget build(BuildContext context) {
    final stationService = context.read<StationService>();
    return SafeArea(
      child: Scaffold(
        body: StationsList(future: _stationsFuture),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) =>
                  AddStationSheet(stationService: stationService),
            );
          },
          backgroundColor: AppColors.secondaryLightOrange,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class StationsList extends StatelessWidget {
  final Future<List<Station>> future;

  const StationsList({required this.future});

  @override
  Widget build(BuildContext context) {
    final stationService = context.read<StationService>();
    return FutureBuilder<List<Station>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return const Center(child: Text('Error loading data'));
        } else {
          return Padding(
            padding: const EdgeInsets.only(top: 120.0, left: 10.0, right: 10.0),
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var station = snapshot.data![index];
                return StationCard(
                  station: station,
                );
              },
            ),
          );
        }
      },
    );
  }
}
