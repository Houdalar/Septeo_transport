import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:septeo_transport/model/planning.dart';

import '../../../constatns.dart';
import '../../../model/bus.dart';
import '../../../model/station.dart';
import '../../../viewmodel/station_services.dart';
import '../../../viewmodel/user_services.dart';
import '../../components/app_colors.dart';

class AddPlanningForm extends StatefulWidget {
  final DateTime? selectedDate;
  final Planning? planning;
  AddPlanningForm({this.selectedDate, this.planning});
  @override
  _AddPlanningFormState createState() => _AddPlanningFormState();
}

class _AddPlanningFormState extends State<AddPlanningForm> {
  Station? _selectedFromStation;
  Station? _selectedToStation;
  ArrivalTime? _selectedFromBus;
  ArrivalTime? _selectedToBus;
  List<Station> _stations = [];
  bool _isUpdateMode = false;
  

  @override
  void initState() {
    super.initState();
    _fetchStations();
  }

  Future<void> _fetchStations() async {
    List<Station> stations = await StationService.getStations();

   if (widget.planning != null) {
  _selectedFromStation = stations.firstWhere((s) => s.id == widget.planning!.fromStation.id);
  _selectedToStation = stations.firstWhere((s) => s.id == widget.planning!.toStation.id);

  var afterFifteen = (ArrivalTime b) => DateTime.parse("1970-01-01 ${b.time}:00Z").hour > 15;
  var beforeFifteen = (ArrivalTime b) => DateTime.parse("1970-01-01 ${b.time}:00Z").hour < 15;

  _selectedFromBus = _selectedFromStation?.arrivalTimes.firstWhere((b) => b.bus?.id == widget.planning!.startbus?.id && beforeFifteen(b));
  _selectedToBus = _selectedToStation?.arrivalTimes.firstWhere((b) => b.bus?.id == widget.planning!.finishbus?.id && afterFifteen(b));
}

    setState(() {
      _stations = stations;
    });
  }

  void _selectFromStation(Station? station) {
    if (station == null) {
      return;
    }
    setState(() {
      _selectedFromStation = station;
      _selectedFromBus = null;
    });
  }

  void _selectToStation(Station? station) {
    if (station == null) {
      return;
    }
    setState(() {
      _selectedToStation = station;
      _selectedToBus = null;
    });
  }

  void _selectFromBus(ArrivalTime? bus) {
    if (bus == null) {
      return;
    }
    setState(() {
      _selectedFromBus = bus;
    });
  }

  void _selectToBus(ArrivalTime? bus) {
    if (bus == null) {
      return;
    }
    setState(() {
      _selectedToBus = bus;
    });
  }

 void _submit() async {
  final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    if (_selectedFromStation == null ||
        _selectedToStation == null ||
        _selectedFromBus == null ||
        _selectedToBus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                "Please select both stations and the corresponding buses.")),
      );
      return;
    }
    String id = "64abf65cc2ce4294ccd8ae28"; // Replace with the actual userId

    if (widget.planning == null) {
      // In add mode, add the planning
      
      await userViewModel.addPlanning(
          id,
          widget.selectedDate!.toIso8601String(),
          _selectedFromStation!.id,
          _selectedToStation!.id,
          _selectedFromBus!.bus!.id,
          _selectedToBus!.bus!.id,
          context);
    } else {
      // In update mode, update the planning
     _isUpdateMode = await userViewModel.updatePlanning(
          widget.planning!.id,
          DateTime.now().toIso8601String(),
          _selectedFromStation!.id,
          _selectedToStation!.id,
          _selectedFromBus!.bus!.id,
          _selectedToBus!.bus!.id,
          );
          Navigator.of(context).pop();
     if (_isUpdateMode) {
       
       SnackBar snackBar = const SnackBar(content: Text("Planning updated successfully"));
       ScaffoldMessenger.of(context).showSnackBar(snackBar);
     } else {
       SnackBar snackBar = const SnackBar(content: Text("Error updating planning"));
       ScaffoldMessenger.of(context).showSnackBar(snackBar);
     }    
  }
}

  DropdownButtonFormField<Station> _buildDropdown(List<Station> items,
      Station? selectedValue, Function onChanged, String hint) {
    return DropdownButtonFormField<Station>(
      value: selectedValue,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintText: hint,
        hintStyle: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: const BorderSide(
            color: Colors.orange,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: const BorderSide(
            color: Colors.orange,
            width: 1,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: const BorderSide(
            color: Colors.orange,
            width: 1,
          ),
        ),
      ),
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      icon: const Icon(Icons.arrow_drop_down, color: Colors.orange),
      iconSize: 24,
      isExpanded: true,
      items: items
          .map((station) => DropdownMenuItem<Station>(
                value: station,
                child: Text(station.name),
              ))
          .toList(),
      onChanged: (Station? station) {
        onChanged(station);
      },
    );
  }

  DropdownButtonFormField<ArrivalTime> _buildBusDropdown(
      Station? station,
      ArrivalTime? selectedValue,
      Function onChanged,
      String hint,
      bool afterFifteen) {
    var filteredArrivalTimes = station?.arrivalTimes.where((arrivalTime) {
      var time = DateTime.parse("1970-01-01 ${arrivalTime.time}:00Z");
      if (afterFifteen) {
        return time.hour > 15;
      } else {
        return time.hour < 15;
      }
    }).toList();

    if (filteredArrivalTimes != null &&
        !filteredArrivalTimes.contains(selectedValue)) {
      // set selectedValue as null or the first item in the list
      selectedValue = null;
      // selectedValue = filteredArrivalTimes.isNotEmpty ? filteredArrivalTimes.first : null;
    }

    return DropdownButtonFormField<ArrivalTime>(
      value: selectedValue,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 16, color: Colors.black),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: const BorderSide(color: Colors.orange, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: const BorderSide(color: Colors.orange, width: 1),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: const BorderSide(color: Colors.orange, width: 1),
        ),
      ),
      items: filteredArrivalTimes
              ?.map((arrivalTime) => DropdownMenuItem<ArrivalTime>(
                    value: arrivalTime,
                    child: Row(
                      children: [
                        Text(arrivalTime.bus?.busNumber ?? ""),
                        SizedBox(width: 16),
                        Text(arrivalTime.time!),
                      ],
                    ),
                  ))
              .toList() ??
          [],
      onChanged: (ArrivalTime? arrivalTime) {
        onChanged(arrivalTime);
        setState(() {
          selectedValue = arrivalTime;
        });
      },
    );
  }

 @override
Widget build(BuildContext context) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: ConstrainedBox(
      constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text("Add Planning", style: TextStyle(fontSize: 25)),
           const SizedBox(height: 50),
          _buildDropdown(_stations, _selectedFromStation, _selectFromStation, 'First Station'),
          const SizedBox(height: 16),
          _buildBusDropdown(_selectedFromStation, _selectedFromBus, _selectFromBus, 'Bus', false),
          const SizedBox(height: 40),
          _buildDropdown(_stations, _selectedToStation, _selectToStation, 'Second Station'),
          const SizedBox(height: 16),
          _buildBusDropdown(_selectedToStation, _selectedToBus, _selectToBus, 'Bus', true),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
                padding: const EdgeInsets.all(16.0),
              ),
              child:Text(widget.planning == null ? 'Add' : 'Update'),
            ),
          ),
        ],
      ),
    ),
  );
}
}
