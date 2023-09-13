import 'package:ecommerce/screens/auth/login.dart';
import 'package:ecommerce/screens/auth/signin.dart';
import 'package:ecommerce/screens/tasks.dart';
import 'package:ecommerce/user_state.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _appInitilaization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _appInitilaization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                    child: Text(
                  "App is Loading",
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                )),
              ));
        } else if (snapshot.hasError) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                    child: Text(
                  "App has error",
                  style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                )),
              ));
        }
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter workos',
            theme: ThemeData(
              scaffoldBackgroundColor: Color(0xFFEDE7DC),
              primarySwatch: Colors.blue,
            ),
            home: UserState());
      },
    );
  }
}
