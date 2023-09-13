import 'package:ecommerce/constants/constant.dart';
import 'package:ecommerce/widgets/all_workers_widget.dart';
import 'package:ecommerce/widgets/drawer_widget.dart';
import 'package:ecommerce/widgets/tasks_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllWorkersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        drawer: DrawerWidget(),
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Constants.darkBlue),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: const Text(
            'All Workers',
            style: TextStyle(color: Colors.pink),
          ),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
          builder: (context, snapshots) {
            if (snapshots.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshots.connectionState == ConnectionState.active) {
              if (snapshots.data!.docs.isNotEmpty) {
                return ListView.builder(
                    itemCount: snapshots.data!.docs.length,
                    itemBuilder: (context, index) {
                      return AllWorkersWidget(
                        userEmail: snapshots.data!.docs[index]['Email'],
                        userId: snapshots.data!.docs[index]['userId'],
                        userImage: snapshots.data!.docs[index]['userImageurl'],
                        userName: snapshots.data!.docs[index]['name'],
                        userPosition: snapshots.data!.docs[index]['Position'],
                        userPhone: snapshots.data!.docs[index]['PhoneNumber'],
                      );
                    });
              } else {
                return const Center(child: Text("No tasks has been uploaded"));
              }
            }
            return const Center(child: Text("Something went wrong"));
          },
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
        ));
  }
}
