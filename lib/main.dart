// import 'package:flutter/material.dart';
// import 'screens/login_screen.dart';
// import 'screens/create_acc.dart';
// import 'screens/fixit_appbar.dart'; //to import the outer layouts

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
//               //After login go to the outer shell instead of Homescreen uuuuuuuuuuuuuuuuu
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (_) => const FixItShell()),
//               );
//             },
//             onCreateAccount: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => CreateAccountScreen(
//                     onAccountCreated: () {
//                       //After account creation also go to the outer layout
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(builder: (_) => const FixItShell()),
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
import 'screens/fixit_appbar.dart'; // contains FixItShell

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
      // 👇 Skip login, go straight to shell
      home: const FixItShell(),
    );
  }
}


