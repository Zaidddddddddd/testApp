import 'package:flutter/material.dart';
import 'package:test_app/helper/constants.dart';
import 'package:test_app/ui/dashboard_screen.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Initial theme mode is light

  // Toggle theme method
  void _toggleTheme() {
    setState(() {
      Constants.IS_DARK_MODE_ON = !Constants.IS_DARK_MODE_ON;
    });
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Constants.IS_DARK_MODE_ON ? ThemeData.dark() : ThemeData.light(),
      home: DashboardScreen(toggleTheme: _toggleTheme),
    );
  }
}

