import 'package:flutter/material.dart';

import '../admin/buses/bus_management.dart';

class QuickAccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GridView.count(
        crossAxisCount: 2,  // you can change this number based on how many items you want in a row
        childAspectRatio: 1.0,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        children: <Widget>[
          createQuickAccessCard(context, 'Transport Management', Icons.bus_alert, BusManagement(isdriver: false,)),
        //  createQuickAccessCard(context, 'Vacation Management', Icons.beach_access, VacationPage()),
        //  createQuickAccessCard(context, 'Payday Advance', Icons.payments, PaydayAdvancePage()),
        //  createQuickAccessCard(context, 'User Management', Icons.person, UsersManagementPage()),
          // Add more cards if necessary
        ],
      ),
    );
  }

  Card createQuickAccessCard(BuildContext context, String title, IconData icon, Widget destinationPage) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 4.0,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destinationPage),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 50.0, color: Theme.of(context).primaryColor,),
            SizedBox(height: 10.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
