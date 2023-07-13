import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:septeo_transport/view/components/app_colors.dart';

import 'view/screens/admin/user/home_page.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: ThemeData(appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryOrange,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.primaryDarkBlue,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
        textTheme: GoogleFonts.josefinSansTextTheme(
          Theme.of(context).textTheme,
        ).apply(
          bodyColor: AppColors.primaryDarkBlue,
          displayColor: AppColors.primaryDarkBlue,
        ), 
       /* colorScheme: const ColorScheme.light(
          primary: AppColors.primaryOrange,
          primaryVariant: AppColors.primaryDarkBlue,
          secondary: AppColors.secondaryDarkOrange,
          secondaryVariant: AppColors.secondaryDarkBlue,
          surface: AppColors.primaryDarkBlue,
          background: AppColors.primaryDarkBlue,
          error: AppColors.primaryDarkBlue,
          onPrimary: AppColors.primaryDarkBlue,
          onSecondary: AppColors.primaryDarkBlue,
          onSurface: AppColors.primaryDarkBlue,
          onBackground: AppColors.primaryDarkBlue,
          onError: AppColors.primaryDarkBlue,
          brightness: Brightness.light,
        ),*/
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/home': (context) => const Home(),
      },
    );
  }
}
