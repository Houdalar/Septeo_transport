import 'package:flutter/material.dart';
import 'package:septeo_transport/view/components/app_colors.dart';

import '../../model/station.dart';

class StationCard extends StatelessWidget {
  final Station station;

  StationCard({required this.station});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Image.network(station.image),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  station.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryDarkBlue),
                ),
                const SizedBox(height: 4),
            Text(
              station.address,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement navigation to details screen
              },
              child: const Text('See Details'),
            ),
              ],
            ),
            
          ],
        ),
      ),
    );
  }
}