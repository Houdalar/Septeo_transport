import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:septeo_transport/view/components/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'view/screens/admin/user/home_page.dart';
import 'package:google_fonts/google_fonts.dart';

import 'view/screens/admin/user/login_screen.dart';
import 'view/screens/appHome/app_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');

  String? token = await messaging.getToken();
  print('User registration token: $token');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      print('Message title: ${notification.title}');
      print('Message body: ${notification.body}');
    }
  });

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
        appBarTheme: const AppBarTheme(
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
      ),
      initialRoute: '/home',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => const LoginPage());
          case '/home':
            return MaterialPageRoute(
                builder: (context) => const Home(role: 'Driver'));
          case '/AppHome':
            return MaterialPageRoute(
                builder: (context) => const AppHome(userType: 'Employee'));
          default:
            return null;
        }
      },
    );
  }
}
