import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:septeo_transport/view/components/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:septeo_transport/viewmodel/user_services.dart';
import 'session_manager.dart';
import 'view/screens/admin/user/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'view/screens/admin/user/login_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uni_links/uni_links.dart';

import 'view/screens/splash_screen.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request notification permissions for iOS
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await FlutterLocalNotificationsPlugin().initialize(initializationSettings);
  final UserViewModel userViewModel = UserViewModel();

  runApp(
    ChangeNotifierProvider<UserViewModel>.value(
      value: userViewModel,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

      bool hasUnreadNotification = false; 
        String? userId;

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id', 'your channel name',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: '/AppHome');
  }

  String? _deepLink;
  @override
  void initState() {
    super.initState();
     _initializeUserId();
    initUniLinks();

    _firebaseMessaging.getToken().then((String? token) {
      assert(token != null);
      //print("FCM Token: $token");
    });
    

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        _showNotification(
            notification.title ?? "new message for your bus driver",
            notification.body ??
                ""); 
                setState(() {
      hasUnreadNotification = true; 
    });
      }
    });
    Future.delayed(Duration.zero, () {
      if (_deepLink != null) {
        Navigator.of(context).pushNamed(_deepLink!);
      }
    });
  }
Future<void> _initializeUserId() async {
    String userId = await SessionManager.getUserId();
    setState(() {
        userId = userId;
    });
}
 

  Future<void> initUniLinks() async {
    // Get the initial deep link if the app was launched with one
    try {
      _deepLink = await getInitialLink();
      if (_deepLink != null) {
        Navigator.of(context).pushNamed(_deepLink!);
      }
    } catch (e) {
      // Handle error
    }

    // Listen for deep links while the app is running
    getLinksStream().listen((String? link) {
      print('Link: $link'); // Add this line
      if (link != null) {
        Future.delayed(Duration.zero, () {
          Navigator.of(context).pushNamed(link);
        });
      }
    }, onError: (err) {
      // Handle error
    });
  }

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
      initialRoute: '/splash',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => const LoginPage());
          case '/home':
            return MaterialPageRoute(builder: (context) => const Home());
          case '/splash':
            return MaterialPageRoute(
                builder: (context) => SplashScreen(
                      nextRoute: userId == ""
                          ? '/'
                          : '/home',
                    ));
          default:
            return null;
        }
      },
    );
  }
}
