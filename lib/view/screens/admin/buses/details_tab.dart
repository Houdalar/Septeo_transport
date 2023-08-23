import 'package:flutter/material.dart';
import 'package:septeo_transport/model/bus.dart';
import '../../../../model/station.dart';
import '../../../../viewmodel/bus_services.dart';
import '../../../components/app_colors.dart';
import 'station_sheet_selection.dart';

enum EditState { viewing, editing }

class BusDetailsTab extends StatefulWidget {
  final Bus bus;
  final ScrollController scrollController;
  final bool isDriver;
  final BusService busService;

  BusDetailsTab({
    required this.bus,
    required this.scrollController,
    required this.isDriver,
    required this.busService,
  });

  @override
  _BusDetailsTabState createState() => _BusDetailsTabState();
}

class _BusDetailsTabState extends State<BusDetailsTab> {
  late TextEditingController _busNumberController;
  late TextEditingController _capacityController;
  EditState _editState = EditState.viewing;

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
            _buildBusNumberField(),
            const SizedBox(height: 20),
            _buildCapacityField(),
            const SizedBox(height: 15),
            if (_editState == EditState.editing) _buildCancelButton(),
            const SizedBox(height: 15),
            if (!widget.isDriver) _buildEditSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBusNumberField() {
    return _editState == EditState.editing
        ? _buildTextField(_busNumberController, 'bus number')
        : _buildText('bus number ${widget.bus.busNumber}');
  }

  Widget _buildCapacityField() {
    return _editState == EditState.editing
        ? _buildTextField(_capacityController, 'capacity')
        : _buildText('capacity ${widget.bus.capacity}');
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextFormField(
      controller: controller,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: hint,
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
      ),
    );
  }

  Widget _buildText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 20),
    );
  }

  Widget _buildCancelButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          _editState = EditState.viewing;
        });
      },
      child: const Text(
        "cancel",
        style: TextStyle(
          color: AppColors.primaryOrange,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildEditSaveButton() {
    return SizedBox(
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
          _editState == EditState.viewing ? 'Edit' : 'Save',
          style: const TextStyle(
            color: AppColors.auxiliaryOffWhite,
            fontSize: 18.0,
          ),
        ),
        onPressed: _onEditSavePressed,
      ),
    );
  }

  void _onEditSavePressed() async {
    if (_editState == EditState.editing) {
      String updatedBusNumber = _busNumberController.text;
      int updatedCapacity = int.parse(_capacityController.text);
      bool isSuccess = await widget.busService.updateBus(
          widget.bus.id, updatedCapacity, updatedBusNumber);
      if (isSuccess) {
        setState(() {
          _editState = EditState.viewing;
          widget.bus.busNumber = updatedBusNumber;
          widget.bus.capacity = updatedCapacity;
        });
      } else {
        // Handle the error, maybe show a snackbar
      }
    } else {
      setState(() {
        _editState = EditState.editing;
      });
    }
  }
}