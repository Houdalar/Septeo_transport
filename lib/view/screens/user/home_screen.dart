import 'package:flutter/material.dart';
import 'package:septeo_transport/model/bus.dart';
import 'package:septeo_transport/view/components/app_colors.dart';

import '../../../model/planning.dart';
import '../../../model/station.dart';
import '../../components/search_bar.dart';
import '../../components/station_card.dart';
import '../../components/today_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Station> availableStations = [
    Station(
      id: "1",
      name: "lac 2",
      address: "123 Street, City A",
      location: Location(lat: 36.84790, lng: 10.26857),
      arrivalTimes: [
        ArrivalTime(
          time: "15:00",
          bus: Bus(
            id: "1",
            stations: [],
            driver: "Driver 1",
            capacity: 50,
            // startDate: DateTime.now(),
            busNumber: "B25",
          ),
        ),
        ArrivalTime(
          time: "14:15",
          bus: Bus(
            id: "2",
            stations: [],
            driver: "Driver 2",
            capacity: 60,
            // startDate: DateTime.now(),
            busNumber: "B26",
          ),
        ),
        ArrivalTime(
          time: "14:25",
          bus: Bus(
            id: "2",
            stations: [],
            driver: "Driver 2",
            capacity: 60,
            // startDate: DateTime.now(),
            busNumber: "B26",
          ),
        ),
      ],
    ),
    Station(
      id: "1",
      name: "ariana",
      address: "123 Street, City A",
      location: Location(lat: 36.88988, lng: 10.17240),
      arrivalTimes: [
        ArrivalTime(
          time: "14:00",
          bus: Bus(
            id: "1",
            stations: [],
            driver: "Driver 1",
            capacity: 50,
            // startDate: DateTime.now(),
            busNumber: "B25",
          ),
        ),
        ArrivalTime(
          time: "14:08",
          bus: Bus(
            id: "1",
            stations: [],
            driver: "Driver 1",
            capacity: 50,
            // startDate: DateTime.now(),
            busNumber: "B25",
          ),
        ),
        ArrivalTime(
          time: "16:20",
          bus: Bus(
            id: "1",
            stations: [],
            driver: "Driver 1",
            capacity: 50,
            // startDate: DateTime.now(),
            busNumber: "B25",
          ),
        ),
        ArrivalTime(
          time: "17:15",
          bus: Bus(
            id: "2",
            stations: [],
            driver: "Driver 2",
            capacity: 60,
            // startDate: DateTime.now(),
            busNumber: "B26",
          ),
        ),
      ],
    ),
    Station(
      id: "2",
      name: "mohammedia",
      address: "456 Avenue, City B",
      location: Location(lat: 36.67933, lng: 10.15657),
      arrivalTimes: [
        ArrivalTime(
          time: "17:30:00",
          bus: Bus(
            id: "3",
            stations: [],
            driver: "Driver 3",
            capacity: 55,
            //startDate: DateTime.now(),
            busNumber: "B27",
          ),
        ),
        ArrivalTime(
          time: "18:00:00",
          bus: Bus(
            id: "4",
            stations: [],
            driver: "Driver 4",
            capacity: 65,
            // startDate: DateTime.now(),
            busNumber: "B28",
          ),
        ),
      ],
    ),
  ];

  final Planning todayPlanning = Planning(
      id: "1",
      user: "user",
      dayOfWeek: "Monday",
      isTakingBus: true,
      toStation: Station(
        id: "1",
        name: "lac 2",
        address: "123 Street, City",
        location: Location(lat: 51.5074, lng: 0.1278),
        arrivalTimes: [
          ArrivalTime(
            time: "13:30",
            bus: Bus(
              id: "3",
              stations: [],
              driver: "Driver 3",
              capacity: 55,
              // startDate: DateTime.now(),
              busNumber: "B27",
            ),
          ),
          ArrivalTime(
            time: "14:15",
            bus: Bus(
              id: "4",
              stations: [],
              driver: "Driver 4",
              capacity: 65,
//startDate: DateTime.now(),
              busNumber: "B28",
            ),
          ),
        ],
      ),
      fromStation: Station(
        id: "1",
        name: "ariana",
        address: "123 Street, City",
        location: Location(lat: 51.5074, lng: 0.1278),
        arrivalTimes: [
          ArrivalTime(
            time: "13:30:00",
            bus: Bus(
              id: "3",
              stations: [],
              driver: "Driver 3",
              capacity: 55,
              //   startDate: DateTime.now(),
              busNumber: "B27",
            ),
          ),
          ArrivalTime(
            time: "14:15:00",
            bus: Bus(
              id: "4",
              stations: [],
              driver: "Driver 4",
              capacity: 65,
              //  startDate: DateTime.now(),
              busNumber: "B28",
            ),
          ),
        ],
      ),
      bus: Bus(
        id: "",
        stations: [],
        driver: "",
        capacity: 50,
        busNumber: "B25",
      ),
      time: "06:30");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                 Row(
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      height:30,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Transport',
                      style: TextStyle(fontSize:30),
                    ),
                    
                  ],
                ),
                const SizedBox(height: 20),
                const Search_bar(),
                const SizedBox(height: 40),
                const Text("Today", style: TextStyle(fontSize: 20 )),
                const SizedBox(height: 20),
                SizedBox(
                    height: 100,
                    child: PlanningCard(todayPlanning: todayPlanning)),
                const SizedBox(height: 30),
                const Text("Available stations",
                    style: TextStyle(fontSize: 20)),
                const SizedBox(height: 20),
                SizedBox(
                  height: MediaQuery.of(context).size.height /
                      2.2, // Define your height here
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1 / 1,
                    ),
                    physics: const NeverScrollableScrollPhysics(), 
                    itemCount: availableStations.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return StationItem(station: availableStations[index]);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
