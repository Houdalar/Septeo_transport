import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:septeo_transport/view/components/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:septeo_transport/viewmodel/user_services.dart';
import 'constatns.dart';
import 'session_manager.dart';
import 'view/screens/admin/user/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'view/screens/admin/user/login_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uni_links/uni_links.dart';
import 'view/screens/splash_screen.dart';
import 'viewmodel/bus_services.dart';
import 'viewmodel/station_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load();
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => ApiService()), // Providing ApiService
        Provider<Preferences>(
            create: (context) =>
                SharedPreferencesImpl()), // Providing SharedPreferencesImpl as Preferences
        Provider(
            create: (context) => SessionManager(
                prefs: context.read<
                    Preferences>())), // Providing SessionManager with SharedPreferencesImpl
        ChangeNotifierProvider(
          create: (context) => UserViewModel(
            apiService: context.read<ApiService>(),
            sessionManager: context.read<SessionManager>(),
          ),
        ),
         ChangeNotifierProvider(
          create: (context) => StationService(apiService: context.read<ApiService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => BusService(apiService: context.read<ApiService>()),
        ),
        Provider(create: (context) => FirebaseMessaging.instance),
        Provider(create: (context) => FlutterLocalNotificationsPlugin()),
      ],
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
  late final FirebaseMessaging _firebaseMessaging;
  late final FlutterLocalNotificationsPlugin _notificationsPlugin;
  late final UserViewModel _userViewModel;
  late final StationService _stationServices;
  //late final BusServices _busServices;

  bool hasUnreadNotification = false;
  String? userId;
  String? _deepLink;

  @override
  void initState() {
    super.initState();
    _firebaseMessaging = context.read<FirebaseMessaging>();
    _notificationsPlugin = context.read<FlutterLocalNotificationsPlugin>();
    _userViewModel = context.read<UserViewModel>();
     _stationServices = context.read<StationService>();
    // _busServices = context.read<BusServices>();

    _initializeUserId();
    initUniLinks();
    _firebaseMessaging.getToken().then((String? token) {
      assert(token != null);
    });
  }

  Future<void> _initializeUserId() async {
    userId = await context.read<SessionManager>().getUserId();
  }

  Future<void> initUniLinks() async {
    // Get the initial deep link if the app was launched with one
    try {
      _deepLink = await getInitialLink();
      if (_deepLink != null) {
        Navigator.of(context).pushNamed(_deepLink!);
      }
    } catch (e) {
      throw e;
    }

    // Listen for deep links while the app is running
    // ignore: deprecated_member_use
    getLinksStream().listen((String? link) {
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
            return MaterialPageRoute(
                builder: (context) => const LoginPage(
                    ));
          case '/home':
            return MaterialPageRoute(builder: (context) => const Home());
          case '/splash':
            return MaterialPageRoute(
                builder: (context) => SplashScreen(
                      nextRoute: userId == "" ? '/' : '/home',
                    ));
          default:
            return null;
        }
      },
    );
  }
}
