import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../model/planning.dart';
import '../../../session_manager.dart';
import '../../../viewmodel/user_services.dart';
import '../../components/app_colors.dart';
import '../../components/mini_calendar.dart';
import '../../components/today_card.dart';

class EmployeeSpace extends StatefulWidget {
  const EmployeeSpace({Key? key}) : super(key: key);

  @override
  State<EmployeeSpace> createState() => _EmployeeSpaceState();
}

class _EmployeeSpaceState extends State<EmployeeSpace> {
  // List of schedules
  final List<String> schedules = List<String>.generate(2, (i) => "Schedule $i");

  DateTime _selectedDate = DateTime.now();
  List<Planning> weekPlannings = [];
  List<Planning> filteredPlannings = [];
  DateTime _selectedWeek = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchWeekPlanning();
  }

  Future<void> fetchWeekPlanning() async {
    try {
      final userId = await  Provider.of<SessionManager>(context).getUserId();
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      var planning = await userViewModel.fetchPlannings(userId!, _selectedWeek);
      setState(() {
        weekPlannings = planning;
        filterPlannings(_selectedDate);
      });
    } catch (e) {
      print(e);
    }
  }

  void filterPlannings(DateTime selectedDay) {
    setState(() {
      filteredPlannings = weekPlannings
          .where((item) =>
              DateFormat('yyyy-MM-dd').format(DateTime.parse(item.date)) ==
              DateFormat('yyyy-MM-dd').format(selectedDay))
          .toList();
    });
  }

  Future<void> fetchNewWeek(DateTime newWeek) async {
    _selectedWeek = newWeek;
    fetchWeekPlanning();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'bus schedule',
              style: TextStyle(
                color: AppColors.primaryDarkBlue,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: AppColors.primaryDarkBlue),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                SizedBox(
                  height: 270,
                  child: MiniCalendar(
                    onDaySelected: (date) {
                      setState(() {
                        _selectedDate = date;
                      });
                      filterPlannings(_selectedDate);
                    },
                    onWeekChanged: fetchNewWeek,
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    DateFormat('EEEE, d MMMM ').format(_selectedDate),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: filteredPlannings.isNotEmpty
                      ? ListView.builder(
                          itemCount: filteredPlannings.length,
                          itemBuilder: (context, index) {
                            return PlanningCard(
                                planning: filteredPlannings[index]);
                          },
                        )
                      : const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text('No plans for this date.'),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
