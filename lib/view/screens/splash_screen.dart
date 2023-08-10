import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final String nextRoute;

  SplashScreen({required this.nextRoute});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1 ), () {
      Navigator.pushReplacementNamed(context, widget.nextRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 150.0,
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(50, 0, 50, 10),
          child: Image.asset("assets/logo_orange.png"),
        ),
      ),
    );
  }
}