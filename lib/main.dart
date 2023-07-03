import 'package:flutter/material.dart';
import 'package:septeo_transport/view/screens/user/login_screen.dart';

import 'view/screens/user/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: ThemeData(
        primaryColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',  
      routes: {
        '/': (context) =>  Home(), 
        '/home':(context) =>  Home(),
      },
    );
  }
}
