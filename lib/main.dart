import 'package:flutter/material.dart';
import '../screens/login_screen.dart'; // if you put LoginScreen in a separate file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(
        onSignedIn: () {
          // For now, just show a snackbar or navigate
          print("Signed in!");
        },
      ),
    );
  }
}
