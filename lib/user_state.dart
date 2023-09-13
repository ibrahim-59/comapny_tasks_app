import 'package:ecommerce/screens/auth/login.dart';
import 'package:ecommerce/screens/tasks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, userSnapshot) {
        if (userSnapshot.data == null) {
          print('User didn\'t login yet');
          return LoginIn();
        } else if (userSnapshot.hasData) {
          print('User login');
          return tasksScreen();
        } else if (userSnapshot.hasError) {
          return const Center(
              child: Text(
            "App has error",
            style: TextStyle(
                fontSize: 50, fontWeight: FontWeight.bold, color: Colors.red),
          ));
        }
        return const Scaffold(
          body: Center(
              child: Text(
            "something went wrong",
            style: TextStyle(
                fontSize: 50, fontWeight: FontWeight.bold, color: Colors.red),
          )),
        );
      },
    );
  }
}
