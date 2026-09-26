import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/create_acc.dart';
import 'package:flutter_application_1/screens/login_screen.dart';

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
      home: Builder(
        builder: (context) => LoginScreen(
          onSignedIn: () {},
          onCreateAccount: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) => CreateAccountScreen(
                onAccountCreated: () => Navigator.of(context).pop(),
                onBackToLogin: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
