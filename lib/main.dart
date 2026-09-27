// import 'package:flutter/material.dart';
// import 'screens/login_screen.dart';
// import 'screens/homescreen.dart';
// import 'screens/create_acc.dart';


// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'FixIt',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: Builder(
//         builder: (context) {
//           return LoginScreen(
//             onSignedIn: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const Homescreen()),
//               );
//             },
//             onCreateAccount: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => CreateAccountScreen(
//                     onAccountCreated: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(builder: (context) => const Homescreen()),
//                       );
//                     },
//                     onBackToLogin: () {
//                       Navigator.pop(context);
//                     },
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/create_acc.dart';
import 'screens/fixit_appbar.dart'; // 👈 import your shell

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FixIt',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Builder(
        builder: (context) {
          return LoginScreen(
            onSignedIn: () {
              // 👇 After login, go to FixItShell instead of Homescreen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const FixItShell()),
              );
            },
            onCreateAccount: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CreateAccountScreen(
                    onAccountCreated: () {
                      // 👇 After account creation, also go to FixItShell
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const FixItShell()),
                      );
                    },
                    onBackToLogin: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
