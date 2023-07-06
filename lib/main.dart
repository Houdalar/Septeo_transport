import 'package:flutter/material.dart';
import 'package:septeo_transport/view/components/app_colors.dart';

import 'view/screens/user/home_page.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: ThemeData(
        textTheme: GoogleFonts.josefinSansTextTheme(
          Theme.of(context).textTheme,
        ).apply(
          bodyColor: AppColors.primaryDarkBlue,
          displayColor: AppColors.primaryDarkBlue,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/home': (context) => const Home(),
      },
    );
  }
}
