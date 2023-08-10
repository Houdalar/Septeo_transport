import 'package:flutter/material.dart';
import 'package:septeo_transport/view/components/app_colors.dart';

import '../../../session_manager.dart';
import '../../components/search_bar.dart';
import '../admin/buses/bus_management.dart';
import '../admin/user/admin_screen.dart';
import '../admin/user/user_managment_screen.dart';
import '../employee/employee_space.dart';

class QuickAccess extends StatefulWidget {
  @override
  State<QuickAccess> createState() => _QuickAccessState();
}

class _QuickAccessState extends State<QuickAccess>   {
  String? role;
  @override
  void initState() {
    super.initState();
    //setUserRole();
    role = SessionManager.Role;
  }

  @override
  Widget build(BuildContext context) {
    if (role == null) {
      return const CircularProgressIndicator();
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Row(
              children: [
                Text('Hi, john doe !',
                    style: Theme.of(context).textTheme.headlineMedium),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BusManagement()),
                    );
                  },
                  icon: const Icon(Icons.notifications),
                  color: AppColors.primaryOrange,
                  iconSize: 30.0,
                ),
              ],
            ),
            //const SizedBox(height: 10.0),
            Text('Good Morning',
                style: TextStyle(fontSize: 17.0, color: Colors.grey[400])),
            const SizedBox(height: 20.0),
            Search_bar(onChanged: (value) {}),
            const SizedBox(height: 20.0),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: const BorderSide(
                      color: AppColors.primaryOrange, width: 1.5)),
              elevation: 0,
              borderOnForeground: true,
              child: Row(
                children: [
                  const SizedBox(width: 30.0),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome !',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'let\'s get started',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Flexible(
                    child: SizedBox(
                      height: 120.0,
                      width: 120.0,
                      child: Image.asset(
                        "assets/forming team leadership-pana.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 30.0),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Text('Services', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 10.0),
            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                if (role == "Admin")
                  createQuickAccessCard(context, 'Transport Management',
                      'Bus driver-pana.png', const AdminSpace()),
                if (role == "Admin")
                  createQuickAccessCard(context, 'user Management',
                      'Office management-cuate.png', UserManagement()),
                createQuickAccessCard(context, 'payment Management',
                    'Investment data-cuate.png', const BusManagement()),
                createQuickAccessCard(context, 'bus Schedule',
                    'Schedule-rafiki.png', const EmployeeSpace()),
                createQuickAccessCard(context, 'About us',
                    'About us page-pana.png', const BusManagement()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Card createQuickAccessCard(
      BuildContext context, String title, String icon, Widget destinationPage) {
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
        child: Padding(
          padding: const EdgeInsets.all(10.0), // Adding padding inside the card
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/$icon",
                //fit: BoxFit.contain,
                height: 100,
              ),
              const SizedBox(height: 10.0),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
