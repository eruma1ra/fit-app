import 'package:flutter/material.dart';
import 'screens/home/hello_screen.dart';
import 'screens/home/activity_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/registration_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ACTIVITY',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HelloScreen(),
      routes: {
        '/registration': (context) => RegistrationScreen(),
        '/login': (context) => LoginScreen(),
        '/activity': (context) => const ActivityScreen(),
      },
    );
  }
}
