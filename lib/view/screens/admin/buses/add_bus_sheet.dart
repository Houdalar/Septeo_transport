import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../model/user.dart';
import '../../../../viewmodel/bus_services.dart';
import '../../../../viewmodel/user_services.dart';
import '../../../components/app_colors.dart';

class AddBusSheet extends StatefulWidget {
  const AddBusSheet({
    Key? key,
  }) : super(key: key);

  @override
  _AddBusSheetState createState() => _AddBusSheetState();
}

class _AddBusSheetState extends State<AddBusSheet> {
  final _formKey = GlobalKey<FormState>();
  final _CapacityController = TextEditingController();
  final _busNumberController = TextEditingController();

  List<User> _drivers = []; // List of drivers
  String? _selectedDriver; // Selected driver

  @override
  void dispose() {
    _CapacityController.dispose();
    _busNumberController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchDrivers();
  }

  Future<void> fetchDrivers() async {
    _drivers = await context.read<UserViewModel>().getDrivers();
    if (_drivers.isNotEmpty) {
      _selectedDriver = _drivers[0].id;
    }
  }

  Future<void> createNewBus() async {
    context.read<BusService>().createNewBus(
      int.tryParse(_CapacityController.text) ?? 0,
      _busNumberController.text,
      context,
    );
  }
  @override
  Widget build(BuildContext context) {
    final CapacityField = TextFormField(
      controller: _CapacityController,
      decoration: InputDecoration(
        hintText: 'Bus Capacity',
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
          return 'Please enter bus capacity';
        }
        return null;
      },
    );

    final busNumberField = TextFormField(
      controller: _busNumberController,
      decoration: InputDecoration(
        hintText: 'Bus Number',
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
          Icons.numbers_outlined,
          color: AppColors.auxiliaryGrey,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter bus number';
        }
        return null;
      },
    );
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CapacityField,
              const SizedBox(height: 30),
              busNumberField,
              const SizedBox(height: 20),
             // driverField,
              const SizedBox(height: 30),
             /* TextButton(
                onPressed: () async {
                  // Navigate to the StationSelectionScreen and wait for the result, which should be a list of selected station ids.
                  final List<String>? result =
                      await Navigator.push<List<String>>(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const StationSelectionScreen()), // replace with your actual StationSelectionScreen
                  );

                  // If the result is not null, update the selectedStationIds state.
                  if (result != null) {
                    setState(() {
                      selectedStationIds = result;
                    });
                  }
                },
                child: const Text(
                  'choose stations',
                  style:
                      TextStyle(color: AppColors.primaryOrange, fontSize: 18),
                ),
              ),*/
              //const SizedBox(height: 20),
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
                      createNewBus();
                    }
                  },
                  child: const Text(
                    'add Bus',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
