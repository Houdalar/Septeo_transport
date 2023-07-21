import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../screens/employee/add_planning.dart';
import 'app_colors.dart';

class MiniCalendar extends StatefulWidget {
  final ValueChanged<DateTime> onDaySelected;
  final ValueChanged<DateTime> onWeekChanged;
  
  MiniCalendar({required this.onDaySelected,required this.onWeekChanged});
  @override
  _MiniCalendarState createState() => _MiniCalendarState();
}

class _MiniCalendarState extends State<MiniCalendar> {
  int _selectedIndex = 0;
  List<DateTime> dates = [];
  int _weekOffset = 0; // Add this line

  @override
  void initState() {
    super.initState();
    _generateWeekDays();
  }

  // This function generates the weekdays according to the current week offset
  void _generateWeekDays() {
    // Get the current date
    DateTime now = DateTime.now();

    // Add the week offset to the current date
    DateTime current = now.add(Duration(days: _weekOffset * 7));

    // Get the previous Monday
    DateTime monday = current.subtract(Duration(days: current.weekday - 1));

    // Generate dates from Monday to Friday
    dates = List.generate(5, (index) => monday.add(Duration(days: index)));

    // Set the selected index to the current weekday - 1 (because it's zero-indexed)
    // This ensures that the current day of the week is selected by default
    _selectedIndex = current.weekday - 1;
    widget.onWeekChanged(dates.first);
  }

  @override
  Widget build(BuildContext context) {
    // Get the current date
    DateTime now = DateTime.now();

    // Add the week offset to the current date
    DateTime current = now.add(Duration(days: _weekOffset * 7));

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      color: AppColors.primaryOrange,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _weekOffset--; // Decrement the week offset
                      _generateWeekDays();
                      widget.onWeekChanged(dates[0]);
                    });
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Text(
                  DateFormat('MMMM').format(current),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _weekOffset++; // Increment the week offset
                      _generateWeekDays();
                      widget.onWeekChanged(dates[0]);
                    });
                  },
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(dates.length, (index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                      widget.onDaySelected(dates[index]);
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 90,
                        width: 60,
                        margin: const EdgeInsets.only(top: 5.0),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: _selectedIndex == index
                              ? Colors.white
                              : AppColors.primaryOrange,
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('EEE').format(dates[index]),
                              style: TextStyle(
                                color: _selectedIndex == index
                                    ? AppColors.primaryOrange
                                    : Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              DateFormat('d').format(dates[index]),
                              style: TextStyle(
                                color: _selectedIndex == index
                                    ? AppColors.primaryOrange
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
            //elevated button
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 50,
              child: TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return AddPlanningForm(selectedDate: dates[_selectedIndex]);
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppColors.primaryOrange,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  'Add Schedule',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
