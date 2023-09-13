// ignore_for_file: sort_child_properties_last

import 'package:ecommerce/constants/constant.dart';
import 'package:ecommerce/screens/all_workers.dart';
import 'package:ecommerce/screens/inner%20screen/add_task_screen.dart';
import 'package:ecommerce/screens/inner%20screen/profile_screen.dart';
import 'package:ecommerce/screens/tasks.dart';
import 'package:ecommerce/user_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              children: [
                const Flexible(
                  child: Icon(
                    Icons.task_outlined,
                    size: 50,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Work Os',
                  style: TextStyle(
                      color: Constants.darkBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
              ],
            ),
            decoration: const BoxDecoration(color: Colors.cyan),
          ),
          const SizedBox(
            height: 30,
          ),
          _listTiles(
              label: 'All Tasks',
              ftc: () {
                NavigateToTaskScreen(context);
              },
              icon: Icons.task_outlined),
          _listTiles(
              label: 'My account',
              ftc: () {
                NavigateToProfileScreen(context);
              },
              icon: Icons.settings_outlined),
          _listTiles(
              label: 'Registerd workers',
              ftc: () {
                NavigateToAllWorkersScreen(context);
              },
              icon: Icons.workspaces_outlined),
          _listTiles(
              label: 'Add Task',
              ftc: () {
                NavigateToAddTaskScreen(context);
              },
              icon: Icons.add_task_outlined),
          const Divider(
            thickness: 1,
          ),
          _listTiles(
              label: 'Logout',
              ftc: () {
                Logout(context);
              },
              icon: Icons.logout_outlined),
        ],
      ),
    );
  }

  void NavigateToProfileScreen(context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    String _Uid = user!.uid;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfileScreen(
                  UserId: _Uid,
                )));
  }

  void NavigateToAllWorkersScreen(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AllWorkersScreen()));
  }

  void NavigateToTaskScreen(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => tasksScreen()));
  }

  void NavigateToAddTaskScreen(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddTaskScreen()));
  }

  void Logout(context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.logout_outlined),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Logout'),
              )
            ]),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Do you want Log out ?',
                style: TextStyle(
                    fontSize: 20,
                    color: Constants.darkBlue,
                    fontStyle: FontStyle.italic),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: Text("Cancel")),
              TextButton(
                  onPressed: () async {
                    await _auth.signOut();
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => UserState()));
                  },
                  child: const Text(
                    'Ok',
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          );
        });
  }

  Widget _listTiles(
      {required label, required Function ftc, required IconData icon}) {
    return ListTile(
      onTap: () {
        ftc();
      },
      leading: Icon(
        icon,
        color: Constants.darkBlue,
      ),
      title: Text(
        label,
        style: TextStyle(
            fontSize: 20,
            color: Constants.darkBlue,
            fontStyle: FontStyle.italic),
      ),
    );
  }
}
