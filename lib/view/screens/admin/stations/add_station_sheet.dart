import 'package:flutter/material.dart';
import 'package:septeo_transport/viewmodel/station_services.dart';

import '../../../../model/station.dart';
import '../../../components/app_colors.dart';
import 'package:place_picker/place_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddStationSheet extends StatefulWidget {
  const AddStationSheet({super.key});

  @override
  _AddStationSheetState createState() => _AddStationSheetState();
}

class _AddStationSheetState extends State<AddStationSheet> {
  final _formKey = GlobalKey<FormState>();
  final _stationNameController = TextEditingController();
  final _stationAddressController = TextEditingController();
  final _stationLocationController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();
  final StationService stationService = StationService();
  double? pickedLatitude;
  double? pickedLongitude;

  @override
  void dispose() {
    _stationNameController.dispose();
    _stationAddressController.dispose();
    _stationLocationController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  Future<void> requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      showPlacePicker();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> showPlacePicker() async {
    try {
      LocationResult? result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PlacePicker(
            "2922eb17-0b68-43d8-bd67-36046c2fa94e",
            displayLocation: const LatLng(36.84790, 10.26857),
            defaultLocation: const LatLng(36.84790, 10.26857),
          ),
        ),
      );

      if (result != null) {
        _stationLocationController.text = result.formattedAddress ?? '';
        pickedLatitude = result.latLng?.latitude;
        pickedLongitude = result.latLng?.longitude;
      } else {
        throw Exception('Error picking location');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

//pick a location from the maps

  Future<void> createNewStation() async {
    var station = Station(
      id: "",
      name: _stationNameController.text,
      address: _stationAddressController.text,
      location: Location(
        lat: pickedLatitude!,
        lng: pickedLongitude!,
        //lat: double.parse(_latController.text),
        //lng: double.parse(_lngController.text),
      ),
      arrivalTimes: [],
    );
    await stationService.createStation(station, context);
  }

  @override
  Widget build(BuildContext context) {
    final stationNameField = TextFormField(
      controller: _stationNameController,
      decoration: InputDecoration(
        hintText: 'Station Name',
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primaryOrange),
          borderRadius: BorderRadius.circular(32.0),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(32.0),
        ),
        filled: true,
        fillColor: AppColors.auxiliaryOffWhite,
        prefixIcon: const Icon(
          Icons.train,
          color: AppColors.auxiliaryGrey,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter station name';
        }
        return null;
      },
    );

    final stationAddressField = TextFormField(
      controller: _stationAddressController,
      decoration: InputDecoration(
        hintText: 'Station Address',
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primaryOrange),
          borderRadius: BorderRadius.circular(32.0),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(32.0),
        ),
        filled: true,
        fillColor: AppColors.auxiliaryOffWhite,
        prefixIcon: const Icon(
          Icons.location_on,
          color: AppColors.auxiliaryGrey,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter station address';
        }
        return null;
      },
    );

    final locationField = TextFormField(
      controller: _stationLocationController,
      decoration: InputDecoration(
        hintText: ' location : lat, lng',
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primaryOrange),
          borderRadius: BorderRadius.circular(32.0),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(32.0),
        ),
        filled: true,
        fillColor: AppColors.auxiliaryOffWhite,
        prefixIcon: const Icon(
          Icons.location_on,
          color: AppColors.auxiliaryGrey,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please pick a location from the map';
        }
        return null;
      },
    );
    final latField = TextFormField(
      controller: _latController,
      decoration: InputDecoration(
        hintText: 'lat',
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primaryOrange),
          borderRadius: BorderRadius.circular(32.0),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(32.0),
        ),
        filled: true,
        fillColor: AppColors.auxiliaryOffWhite,
        prefixIcon: const Icon(
          Icons.location_on,
          color: AppColors.auxiliaryGrey,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please pick enter lat';
        }
        return null;
      },
    );
    final lngField = TextFormField(
      controller: _lngController,
      decoration: InputDecoration(
        hintText: 'lng',
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primaryOrange),
          borderRadius: BorderRadius.circular(32.0),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(32.0),
        ),
        filled: true,
        fillColor: AppColors.auxiliaryOffWhite,
        prefixIcon: const Icon(
          Icons.location_on,
          color: AppColors.auxiliaryGrey,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please pick enter lng';
        }
        return null;
      },
    );

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            stationNameField,
            const SizedBox(height: 30),
            stationAddressField,
            const SizedBox(height: 20),
            locationField,
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: latField),
                const SizedBox(width: 10),
                Expanded(child: lngField),
              ],
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () async {
                await requestLocationPermission();
                // Update the coordinates state after user picks a location
              },
              child: const Text(
                'Pick location from map',
                style: TextStyle(color: AppColors.primaryOrange, fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 50.0,
              width: double.infinity * 0.8,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    createNewStation();
                  }
                },
                child: const Text(
                  'add station',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }
}
