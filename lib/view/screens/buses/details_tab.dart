import 'package:flutter/material.dart';
import 'package:septeo_transport/model/bus.dart';
import '../../../model/station.dart';
import '../../../viewmodel/bus_services.dart';
import '../../components/app_colors.dart';
import 'station_sheet_selection.dart';

class BusDetailsTab extends StatefulWidget {
  final Bus bus;
  final ScrollController scrollController;

  BusDetailsTab({required this.bus, required this.scrollController});

  @override
  _BusDetailsTabState createState() => _BusDetailsTabState();
}

class _BusDetailsTabState extends State<BusDetailsTab> {
  late TextEditingController _busNumberController;
  late TextEditingController _capacityController;
  bool _isEditing = false;
  List<Station> selectedStations = [];

  @override
  void initState() {
    super.initState();
    _busNumberController =
        TextEditingController(text: '${widget.bus.busNumber}');
    _capacityController = TextEditingController(text: '${widget.bus.capacity}');
  }

  @override
  void dispose() {
    _busNumberController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.scrollController,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            if (_isEditing)
              Column(
                children: [
                  TextFormField(
                    controller: _busNumberController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: '     bus number',
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: AppColors.primaryOrange),
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      filled: true,
                      fillColor: AppColors.auxiliaryOffWhite,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              )
            else
              Column(
                children: [
                  Text(
                    ' bus number  ${widget.bus.busNumber}',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            if (_isEditing)
              Column(
                children: [
                  TextFormField(
                    controller: _capacityController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'capacity',
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: AppColors.primaryOrange),
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      filled: true,
                      fillColor: AppColors.auxiliaryOffWhite,
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              )
            else
              Column(
                children: [
                  Text('  capacity    ${widget.bus.capacity}',
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 15),
                ],
              ),
            if (_isEditing)
              TextButton(
                onPressed: () async {
                  /* List<String> selectedStationIds = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StationSelectionScreen(),
                  ),
                ) as List<String>;*/
                  setState(() {
                    _isEditing = false;
                  });
                },
                child: const Text(
                  "cancel",
                  style: TextStyle(
                    color: AppColors.primaryOrange,
                    fontSize: 18,
                  ),
                ),
              ),
            const SizedBox(height: 15),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  padding: const EdgeInsets.all(16.0),
                ),
                child: Text(
                  _isEditing ? 'Save' : 'Edit',
                  style: const TextStyle(
                    color: AppColors.auxiliaryOffWhite,
                    fontSize: 18.0,
                  ),
                ),
                onPressed: () async {
                  if (_isEditing) {
                    String updatedBusNumber = _busNumberController.text;
                    int updatedCapacity = int.parse(_capacityController.text);
                    bool isSuccess = await BusService.updateBus(
                        widget.bus.id, updatedCapacity, updatedBusNumber);
                    setState(() {
                      _isEditing = false;
                      widget.bus.busNumber = updatedBusNumber;
                      widget.bus.capacity = updatedCapacity;
                    });
                  } else {
                    setState(() {
                      _isEditing = true;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
