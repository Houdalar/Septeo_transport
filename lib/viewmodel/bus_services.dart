import 'package:flutter/material.dart';
import 'package:septeo_transport/model/bus.dart';

import 'package:permission_handler/permission_handler.dart';

import '../constatns.dart';

void requestLocationPermission() async {
  PermissionStatus permission = await Permission.location.status;
  if (!permission.isGranted) {
    await Permission.location.request();
  }
}

class BusService extends ChangeNotifier {
  final ApiService apiService;

  final List<Bus> _bus = [];
  List<Bus> get bus => [..._bus];
  BusService({required this.apiService});

  Future<List<Bus>> getBus() async {
    try {
      final jsonResponse = await apiService.get('/buses');

      if (jsonResponse is List) {
        return jsonResponse
            .map((model) => Bus.fromJson(model as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('API response is not a list');
      }
    } catch (e) {
      throw Exception('Failed to load buses');
    }
  }

  Future<void> createNewBus(
      int capacity, String busNumber, BuildContext context) async {
    try {
      await apiService.post('/bus', {
        'capacity': capacity,
        'busNumber': busNumber,
      });
      apiService.showdialog(context, 'Success', 'Bus created successfully.');
    } catch (e) {
      apiService.showdialog(context, 'Error', 'Failed to create bus');
    }
  }

  Future<void> deleteBus(String id, BuildContext context) async {
    try {
      await apiService.delete('/bus/$id');
    } catch (e) {
      apiService.showdialog(context, 'Error', 'Failed to delete bus');
    }
  }

  Future<bool> updateBus(String busId, int capacity, String busNumber) async {
    try {
      await apiService.put('/bus/$busId', {
        'capacity': capacity,
        'busNumber': busNumber,
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
